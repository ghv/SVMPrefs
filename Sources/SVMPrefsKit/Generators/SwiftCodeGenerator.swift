// Copyright The SVMPrefs Authors. All rights reserved.

import Foundation
import Stencil

class SwiftCodeGenerator: BaseCodeGenerator, CodeGenerator {

    let varTypesNotSupportedInObjectiveC = [
        "Bool?",
        "Double?",
        "Float?",
        "Int?"
    ]

    let varTypeToUserDefaultMethodMap = [
        "Bool": "bool",
        "Double": "double",
        "Float": "float",
        "Int": "integer",
        "String": "string",
        "Data": "data",
        "Date": "object",

        "Bool?": "object",
        "Double?": "object",
        "Float?": "object",
        "Int?": "object",
        "String?": "string",
        "Any?": "object",
        "Data?": "data",
        "Date?": "object",

        "[Bool]": "array",
        "[Double]": "array",
        "[Float]": "array",
        "[Int]": "array",
        "[String]": "stringArray",
        "[Any]": "array",
        "[Date]": "array",

        "[Bool]?": "array",
        "[Double]?": "array",
        "[Float]?": "array",
        "[Int]?": "array",
        "[String]?": "stringArray",
        "[Any]?": "array",
        "[Date]?": "array",

        "[[String:Any]]": "array",
        "[[String:Any]]?": "array",

        "[String:Any]": "dictionary",
        "[String:Any]?": "dictionary",

        "URL?": "url"
    ]

    func generate(store: StoreModel) throws -> String {
        var result = ""
        let suiteName = store.suiteName ?? "standard"
        if suiteName == "standard" {
            result = "    var \(store.identifier) = UserDefaults.standard\n\n"
        } else if suiteName != "none" {
            result = "    var \(store.identifier) = UserDefaults(suiteName: \(suiteName))!\n\n"
        }
        return result
    }

    func generate(keys store: StoreModel) throws -> String {
        let context: [String: Any] = [
            "source": store.identifier.withFirstLetterCapitlized,
            "vars": store.variables.map { $0.swiftContext }
        ]

        let template = """
                enum {{ source }}Keys {
            {% for var in vars %}
                    static let {{ var.varName }} = "{{ var.key }}"
            {% endfor %}
                }
            """

        var result = try render(template, context)
        result.appendLFLF()
        return result
    }

    func objcDecoration(for variable: VariableModel) -> String {
        guard !varTypesNotSupportedInObjectiveC.contains(variable.type) else {
            return ""
        }
        return variable.options.contains(.decorateWithObjC) ? "@objc " : ""
    }

    // swiftlint:disable:next function_body_length
    func generate(properties store: StoreModel) throws -> String {
        var result = ""

        for variable in store.variables {
            guard !variable.options.contains(.omitGeneratingGetterAndSetter) else {
                continue
            }

            var context: [String: Any?] = [
                "var": variable.swiftContext,
                "varDecorate": objcDecoration(for: variable),
                "decorate": variable.options.contains(.decorateWithObjC) ? "@objc " : "",

                "invert": variable.swiftIsBoolean && variable.options.contains(.generateInvertedLogic) ? "!" : "",
                "source": store.identifier,
                "key": variable.swiftKeyConstant(for: store.identifier),

                "gensetter": !variable.options.contains(.omitGeneratingSetter),
                "optional": variable.type.last == "?"
            ]

            if result.count > 0 {
                result.appendLFLF()
            }

            if let defaultValue = variable.defaultValue ?? variable.swiftDefaultValue, defaultValue.isNotEmpty {
                context["defaultValue"] = " ?? \(defaultValue)"
            }

            let customTemplates: [String: String] = [
                "Date as Double": """
                    {{ varDecorate }}var {{ var.varName }}: Date {
                        get {
                            let interval: TimeInterval = {{ source }}.double(forKey: {{ key }})
                            return Date(timeIntervalSince1970: interval)
                        }
                        set {
                            let interval = newValue.timeIntervalSince1970
                            {{ source }}.set(interval, forKey: {{ key }})
                        }
                    }
                """
            ]

            if let template = customTemplates[variable.type] {
                result.append(try render(template, context))
            } else if let method = varTypeToUserDefaultMethodMap[variable.type.withSpacesRemoved] {
                let template = """
                        {{ varDecorate }}var {{ var.varName }}: {{ var.type }} {
                            get {
                                return {{invert}}{{ source }}.{{ method }}(forKey: {{ key }}){{ cast }}{{ defaultValue }}
                            }
                    {% if gensetter %}
                            set {
                    {% if optional %}
                                if let newValue = newValue {
                                    {{ source }}.set(newValue, forKey: {{ key }})
                                } else {
                                    {{ source }}.removeObject(forKey: {{ key }})
                                }
                    {% else %}
                                {{ source }}.set({{invert}}newValue, forKey: {{ key }})
                    {% endif %}
                            }
                    {% endif %}
                        }
                    """

                context["method"] = method
                if method == "array" || method == "object" {
                    if !["[Any]", "Any?"].contains(variable.type.withSpacesRemoved) {
                        context["cast"] = " as? \(variable.swiftCastType)"
                    }
                }
                result.append(try render(template, context))
            } else {
                throw SVMError(at: variable.sourceLineOffset, "Could not render template for type \(variable.type)")
            }

            if variable.options.contains(.generateIsSetMethod) {
                let varSetTemplate = """
                        {{ decorate }}var {{ var.isName }}Set: Bool {
                            return {{ source }}.object(forKey: {{ key }}) != nil
                        }
                    """

                result.appendLFLF()
                result.append(try render(varSetTemplate, context))
            }

            if variable.options.contains(.generateRemovePrefMethod) {
                let varRemoveTemplate = """
                        {{ decorate }}func remove{{ var.varTitle }}Pref() {
                            {{ source }}.removeObject(forKey: {{ key }})
                        }
                    """

                result.appendLFLF()
                result.append(try render(varRemoveTemplate, context))
            }
        }

        result.appendLFLF()
        return result
    }

    func generate(removeAll store: StoreModel) throws -> String {
        let keys: [String] = store.variables.compactMap { variable in
            if variable.options.contains(.addToRemoveAllMethod) {
                return variable.swiftKeyConstant(for: store.identifier)
            }
            return nil
        }

        guard !keys.isEmpty else {
            return ""
        }

        let context: [String: Any] = [
            "source": store.identifier,
            "keys": keys
        ]

        let template = """
                func {{ source }}RemoveAll() {
            {% for key in keys %}
                    {{ source }}.removeObject(forKey: {{ key }})
            {% endfor %}
                }
            """

        var result = try render(template, context)
        result.appendLFLF()
        return result
    }

    func generateMigrator() throws -> String {
        let migrateTemplate = """
                func migrate() {
            {% for migration in migrations %}
            {% if migration.target != "delete" %}
                    if let value = {{ migration.source }}.object(forKey: {{ migration.sourceKey }}) {
                        {{ migration.target }}.set(value, forKey: {{ migration.targetKey }})
            {% else %}
                    if {{ migration.source }}.object(forKey: {{ migration.sourceKey }}) != nil {
            {% endif %}
                        {{ migration.source }}.removeObject(forKey: {{ migration.sourceKey }})
                    }
            {% endfor %}
                }
            """

        let migrations: [[String: Any?]] = metaData.stores.values.flatMap { store in
            store.migrations.map { migrate in
                let fromVar = store.variable(named: migrate.fromVar)
                var toVar: VariableModel?
                if migrate.toVar.isNotEmpty, let toStore = metaData.stores[migrate.target] {
                    toVar = toStore.variable(named: migrate.toVar)
                }
                return migrate.swiftContext(from: fromVar, to: toVar)
            }
        }

        let result = try render(migrateTemplate, ["migrations": migrations])
        return result
    }

    func run() throws {
        let reverseSortedCodeMarkNames = metaData.codeMarkNamesSortedByOffset().reversed()

        for codeMarkName in reverseSortedCodeMarkNames {
            var code = ""
            let names = codeMarkName.split(separator: ",")
            for name in names {
                if names.count > 1 {
                    code.append("    // \(name):\n")
                }
                if name == "migrate" {
                    code.append(try generateMigrator())
                } else if let store = metaData.stores["\(name)"] {
                    code.append(try generate(store: store))
                    code.append(try generate(keys: store))
                    code.append(try generate(properties: store))
                    code.append(try generate(removeAll: store))
                }
            }

            var codeLines = code.withTrimmedTrailingWhitespace.components(separatedBy: "\n")

            if metaData.options.indent != 4 {
                codeLines = reindent(codeLines, indent: metaData.options.indent)
            }

            if let codeMark = metaData.namedCodeMarks[codeMarkName] {
                metaData.lines.insert(contentsOf: codeLines, at: codeMark.begin.clearedOffset + 1)
            }
        }
    }
}
