// Copyright The SVMPrefs Authors. All rights reserved.

import Foundation

// MARK: Store Model

class StoreModel {

    var sourceLineOffset = 0
    var identifier: String
    var suiteName: String?
    var options: Set<Options> = []

    var variables: [VariableModel] = []
    var variableNameToIndexMap: [String: Int] = [:]

    var migrations: [MigrateModel] = []

    enum Options: String {
        case autoAddRemoveAllToEachVariable = "RALL" // Use NRALL to omit specific variables
    }

    init(offset: Int, withTokens tokens: [String]) throws {
        sourceLineOffset = offset
        identifier = tokens[0]
        suiteName = tokens.getToken(at: 1)
        if let optionTokens = tokens.getToken(at: 2) {
            let optionsList = optionTokens.split(at: ",")
            try optionsList.forEach { option in
                if let flag = Options(rawValue: option.uppercased()) {
                    options.insert(flag)
                } else {
                    throw SVMError(at: offset, "Unknown option: \(option)")
                }
            }
        }
    }

    func variable(named name: String) -> VariableModel? {
        if let index = variableNameToIndexMap[name] {
            return variables[index]
        }
        return nil
    }

    func add(variable: VariableModel) throws {
        if variableNameToIndexMap[variable.name] != nil {
            throw SVMError(at: variable.sourceLineOffset, "Variable already exists")
        }

        variableNameToIndexMap[variable.name] = variables.count
        variables.append(variable)

        if options.contains(.autoAddRemoveAllToEachVariable) {
            if !variable.options.contains(.omitFromRemoveAllMethod) {
                variable.options.insert(.addToRemoveAllMethod)
            }
        }
    }

    func add(migrate: MigrateModel) throws {
        if let variable = variable(named: migrate.fromVar) {
            variable.options.insert(.omitGeneratingGetterAndSetter)
        } else {
            throw SVMError(at: migrate.sourceLineOffset, "Missing source variable definition")
        }
        migrations.append(migrate)
    }
}

// MARK: Vairable Model

class VariableModel {
    var sourceLineOffset = 0
    var type: String
    var name: String
    var key: String
    var defaultValue: String?
    var options: Set<Options> = []

    enum Options: String {
        case generateInvertedLogic = "INV"
        case decorateWithObjC = "OBJC"

        // Defining a Bool named 'firstLaunch' with this option will
        // generate code for it as 'isFirstLaunch' in some places.
        case decorateNameWithIsPrefix = "IS"

        case omitGeneratingGetterAndSetter = "NVAR"
        case omitGeneratingSetter = "NSET"

        case addToRemoveAllMethod = "RALL"
        // Use this to omit when RALL is set at the store level:
        case omitFromRemoveAllMethod = "NRALL"

        case generateRemovePrefMethod = "REM"
        case generateIsSetMethod = "ISSET"
    }

    init(offset: Int, withTokens tokens: [String]) throws {
        if tokens.count < 5 {
            throw SVMError(at: offset, "Missing parameters")
        }

        sourceLineOffset = offset
        type = tokens[0]
        name = tokens[1]
        key = tokens[2]

        if tokens[3].isNotEmpty {
            let optionsList = tokens[3].split(at: ",")
            for option in optionsList {
                if let flag = Options(rawValue: option.uppercased()) {
                    options.insert(flag)
                } else {
                    throw SVMError(at: offset, "Unknown option: \(option)")
                }
            }
        }

        defaultValue = tokens[4].stringOrNilIfEmpty
    }
}

// MARK: Migrate Model

class MigrateModel {
    var sourceLineOffset = 0
    var source: String
    var target: String
    var fromVar: String
    var toVar: String

    init(offset: Int, withTokens tokens: [String]) throws {
        if tokens.count < 3 {
            throw SVMError(at: offset, "Missing parameters")
        }

        sourceLineOffset = offset
        source = tokens[0]
        target = tokens[1]
        fromVar = tokens[2]

        if target == "delete" {
            toVar = ""
        } else if tokens.count < 4 {
            throw SVMError(at: offset, "Missing destination var parameter")
        } else {
            toVar = tokens[3]
        }
   }
}

// MARK: Swift Extensions

extension VariableModel {
    var swiftDefaultValue: String? {
        if let defaultValue = defaultValue {
            return defaultValue
        }

        switch type.withSpacesRemoved {
        case "String":
            return "\"\""
        case "Date":
            return "Date.distantPast"
        case "[Any]", "[Bool]", "Data", "[Date]", "[Double]", "[Float]", "[Int]", "[[String:Any]]", "[String:Any]", "[String]":
            return "\(type)()"
        default:
            return nil
        }
    }

    var swiftIsBoolean: Bool {
        type.lowercased().starts(with: "bool")
    }

    var swiftVarName: String {
        options.contains(.decorateNameWithIsPrefix) ? swiftIsName : name
    }

    var swiftIsName: String {
        if name.starts(with: "is") {
            return name
        }
        return "is" + name.withFirstLetterCapitlized
    }

    var swiftCastType: String {
        type.replacingOccurrences(of: "?", with: "")
    }

    func swiftKeyConstant(for storeName: String) -> String {
        "\(storeName.withFirstLetterCapitlized)Keys.\(swiftVarName)"
    }

    var swiftContext: [String: Any?] {
        return [
            "type": type,
            "key": key,
            "varName": swiftVarName,
            "isName": swiftIsName,
            "varTitle": name.withFirstLetterCapitlized
        ]
    }
}

extension MigrateModel {
    // Stencil can't handle computed properties so we build context out of dictionaries
    func swiftContext(from: VariableModel?, to: VariableModel?) -> [String: Any?] {
        return [
            "source": source,
            "target": target,
            "sourceKey": from?.swiftKeyConstant(for: source),
            "targetKey": to?.swiftKeyConstant(for: target)
        ]
    }
}
