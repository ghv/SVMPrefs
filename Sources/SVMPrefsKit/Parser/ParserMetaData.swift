// Copyright The SVMPrefs Authors. All rights reserved.

import Regex

struct DataOffsets {
    var begin: Int = -1
    var end: Int = -1
}

struct CodeOffsets {
    var parsedOffset: Int
    var clearedOffset: Int

    init(_ line: Int = -1) {
        (parsedOffset, clearedOffset) = (line, line)
    }

    mutating func parsed(_ line: Int) {
        (parsedOffset, clearedOffset) = (line, line)
    }
}

class CodeMark {
    var begin: CodeOffsets
    var end = CodeOffsets()

    init(begin parsedLine: Int = -1) {
        begin = CodeOffsets(parsedLine)
    }
}

class ParserMetaData {
    var options: ParsingOptions
    var inputHash: String
    var lines: [String]

    var dataOffsets = DataOffsets()
    var namedCodeMarks: [String: CodeMark] = [:]

    var stores: [String: StoreModel] = [:]

    internal var phase = ParserPhase.parsing

    enum ParserPhase {
        case parsing, codegen
    }

    init(contents: String, options: ParsingOptions) {
        // Normalize CR LF to LF
        let normalizedContents = contents.replacingOccurrences(of: "\r\n", with: "\n")

        self.options = options
        self.inputHash = normalizedContents.md5
        self.lines = normalizedContents.components(separatedBy: "\n")
    }

    // swiftlint:disable:next cyclomatic_complexity
    func validateDataAndCodeMarksOffsets() throws {
        if dataOffsets.begin == -1 {
            throw SVMError("Missing SVMPREFS start")
        }

        if dataOffsets.end == -1 {
            throw SVMError(at: dataOffsets.begin, "Missing SVMPREFS end")
        }

        if dataOffsets.end < dataOffsets.begin {
            throw SVMError(at: dataOffsets.end, "SVMPREFS ends before SVMPREFS starts")
        }

        if namedCodeMarks.count == 0 {
            throw SVMError("Missing code blocks")
        }

        let sortedCodeMarkNames = codeMarkNamesSortedByOffset()

        // Make sure each named code mark is defined just once
        var codeMarkSet = Set<String>()
        for key in sortedCodeMarkNames {
            for name in key.split(at: ",") {
                if codeMarkSet.contains(name) {
                    if let codeMark = namedCodeMarks[key] {
                        throw SVMError(at: codeMark.begin.parsedOffset, "Redundant BEGIN \(name)")
                    } else {
                        throw SVMError("Redundant BEGIN \(name)")
                    }
                } else {
                    codeMarkSet.insert(name)
                }
            }
        }

        var lastCodeMarkOffset = -1
        for name in sortedCodeMarkNames {
            if let codeMark = namedCodeMarks[name] {
                if codeMark.begin.parsedOffset < lastCodeMarkOffset {
                    throw SVMError(at: codeMark.begin.parsedOffset, "\(name) BEGIN before prior block's END")
                }
                if codeMark.end.parsedOffset == -1 {
                    throw SVMError(at: codeMark.begin.parsedOffset, "Missing END for \(name)")
                }
                lastCodeMarkOffset = codeMark.end.parsedOffset
            } else {
                fatalError("Accessing namedCodeMarks[\(name)]")
            }
        }

        if let firstCodeMarkBeginOffset = namedCodeMarks[sortedCodeMarkNames[0]]?.begin.parsedOffset,
                dataOffsets.end >= firstCodeMarkBeginOffset {
            throw SVMError(at: dataOffsets.begin, "SVMPREFS must be before all code marks")
        }
    }

    func findCodeMark(named: String) -> CodeMark? {
        for key in namedCodeMarks.keys {
            let names = key.split(at: ",")
            if names.contains(named) {
                return namedCodeMarks[key]
            }
        }
        return nil
    }

    func validateSVMData() throws {
        if stores.count == 0 {
            throw SVMError("Missing stores")
        }

        for (_, store) in stores where store.variables.count == 0 {
            throw SVMError(at: store.sourceLineOffset, "Missing variables")
        }

        for (name, store) in stores where findCodeMark(named: name) == nil {
            throw SVMError(at: store.sourceLineOffset, "Missing code mark")
        }

        if findCodeMark(named: "migrate") == nil {
            for (_, store) in stores where store.migrations.count > 0 {
                throw SVMError(at: store.migrations[0].sourceLineOffset, "Missing code mark")
            }
        }

        for (_, store) in stores {
            for migrate in store.migrations {
                let targetName = migrate.target
                if targetName != "delete" {
                    if let targetStore = stores[targetName] {
                        if targetStore.variableNameToIndexMap[migrate.toVar] == nil {
                            throw SVMError(at: migrate.sourceLineOffset, "Missing target variable definition")
                        }
                    } else {
                        throw SVMError(at: migrate.sourceLineOffset, "Missing target store definition")
                    }
                }
            }
        }
    }

    func log(_ message: String) {
        if options.debug {
            print(message)
        }
    }

    func dumpDataLines() {
        if options.debug {
            print("Data offsets (begin,end) = (\(dataOffsets.begin),\(dataOffsets.end))")
            for (row, line) in lines.enumerated() {
                print("\(row): \(line)")
            }
        }
    }

    func dumpNamedCodeMarks(_ parsed: Bool) {
        if options.debug {
            print(parsed ? "Parsed:" : "Cleared:")
            let sortedCodeMarkNames = codeMarkNamesSortedByOffset()
            for name in sortedCodeMarkNames {
                if let codeMark = namedCodeMarks[name] {
                    let begin = parsed ? codeMark.begin.parsedOffset : codeMark.begin.clearedOffset
                    print(" \(begin): \(lines[begin])")
                    let end = parsed ? codeMark.end.parsedOffset : codeMark.end.clearedOffset
                    print(" \(end): \(lines[end])")
                } else {
                    fatalError("Accessing namedCodeMarks[\(name)]")
                }
            }
        }
    }

    func removeGeneratedLines() throws {
        let sortedCodeMarkNames = codeMarkNamesSortedByOffset()

        var totalLinesDeleted = 0
        for index in 0 ..< sortedCodeMarkNames.count {
            if let codeMark = namedCodeMarks[sortedCodeMarkNames[index]] {
                let start = (codeMark.begin.clearedOffset - totalLinesDeleted) + 1
                let end = codeMark.end.clearedOffset - totalLinesDeleted
                log("will delete \(start) - \(end)")
                let linesToDelete = end - start
                if linesToDelete > 0 {
                    lines.removeSubrange(start..<end)
                    totalLinesDeleted += linesToDelete
                }
                codeMark.begin.clearedOffset = start - 1
                codeMark.end.clearedOffset = start
            }
        }

        phase = .codegen
    }

    func codeMarkNamesSortedByOffset() -> [String] {
        namedCodeMarks.keys.sorted { left, right in
            guard let left = self.namedCodeMarks[left], let right = self.namedCodeMarks[right] else {
                fatalError("Sorting namedCodeMarks")
            }
            return left.begin.parsedOffset < right.begin.parsedOffset
        }
    }

    func updateBeginEndTailComments() {
        guard phase == .codegen else {
            fatalError("Can't update comments until code generation phase")
        }

        guard let regex = try? Regex(string: #"^\s*// MARK: (BEGIN|END) ([\w,]+)\s*$"#) else {
            fatalError("Could not create regular expression for begin|end comment update")
        }

        func update(_ offset: Int, _ tail: String) {
            let line = lines[offset]
            if regex.matches(line) {
                lines[offset] = "\(line.withTrimmedTrailingWhitespace) \(tail)"
            }
        }

        let beginTail = "⬇⬇⬇ AUTO-GENERATED CODE - DO NOT EDIT ⬇⬇⬇"
        let endTail = "⬆⬆⬆ AUTO-GENERATED CODE - DO NOT EDIT ⬆⬆⬆"

        for (_, codeMark) in namedCodeMarks {
            update(codeMark.begin.clearedOffset, beginTail)
            update(codeMark.end.clearedOffset, endTail)
        }
    }

    func updateCodeGeneratorVersion() {
        guard phase == .codegen else {
            fatalError("Can't update version until code generation phase")
        }

        if lines[dataOffsets.begin].starts(with: "/*SVMPREFS") {
            lines[dataOffsets.begin] = "/*SVMPREFS [code generated using svmprefs version \(Version.text)]"
        }
    }
}
