// Copyright The SVMPrefs Authors. All rights reserved.

import Regex

class Parser {
    var metaData: ParserMetaData

    init(_ metaData: ParserMetaData) {
        self.metaData = metaData
    }

    func findDataAndCodeMarks() throws {
        guard let regex = try? Regex(string: #"// MARK: (BEGIN|END) ([\w,]+)"#) else {
            fatalError("Could not create regular expression for begin|end matching")
        }

        for (index, line) in metaData.lines.enumerated() {
            if line.contains("/*SVMPREFS") {
                metaData.dataOffsets.begin = index
            } else if line.contains("SVMPREFS*/") {
                metaData.dataOffsets.end = index
            } else if let match = regex.firstMatch(in: line) {
                if let name = match.captures[1] {
                    if match.captures[0] == "BEGIN" {
                        if metaData.namedCodeMarks[name] == nil {
                            metaData.namedCodeMarks[name] = CodeMark(begin: index)
                        } else {
                            throw SVMError(at: index, "Redundant BEGIN \(name)")
                        }
                    } else {
                        if let codeMark = metaData.namedCodeMarks[name] {
                            codeMark.end.parsed(index)
                        } else {
                            throw SVMError(at: index, "END before BEGIN \(name)")
                        }
                    }
                }
            }
        }
    }

    func parseSVMData() throws {
        guard let regex = try? Regex(string: #"^(\w)\s+(.+)$"#) else {
            fatalError("Could not create regular expression for SVM data matching")
        }

        var currentStore: StoreModel?
        var currentOffset = metaData.dataOffsets.begin + 1
        let dataLines = metaData.lines[currentOffset..<metaData.dataOffsets.end]

        for line in dataLines {
            let line = line.trimmed
            if line.count > 0 && !line.starts(with: "#") {
                if let match = regex.firstMatch(in: line), match.captures.count == 2,
                        let record = match.captures[0], let tokens = match.captures[1] {
                    metaData.log("\(record): \(tokens)")
                    let tokens = tokens.split(at: "|")
                    switch record {
                    case "S":
                        let store = try StoreModel(offset: currentOffset, withTokens: tokens)
                        metaData.stores[store.identifier] = store
                        currentStore = store
                    case "V":
                        if let currentStore = currentStore {
                            let variable = try VariableModel(offset: currentOffset, withTokens: tokens)
                            try currentStore.add(variable: variable)
                        } else {
                            throw SVMError(at: currentOffset, "A store must be defined before any variables")
                        }
                    case "M":
                        let migrate = try MigrateModel(offset: currentOffset, withTokens: tokens)
                        let source = tokens[0]
                        if let store = metaData.stores[source] {
                            try store.add(migrate: migrate)
                        } else {
                            throw SVMError(at: currentOffset, "Unknown source store: \(source)")
                        }
                    default:
                        throw SVMError(at: currentOffset, "Unknown record type: \(record)")
                    }
                } else {
                    throw SVMError(at: currentOffset, "Invalid SVMPrefs format")
                }
            }
            currentOffset += 1
        }
    }

    func run() throws {
        try findDataAndCodeMarks()
        try metaData.validateDataAndCodeMarksOffsets()

        try parseSVMData()
        try metaData.validateSVMData()

        metaData.dumpNamedCodeMarks(true)
        try metaData.removeGeneratedLines()
        metaData.dumpNamedCodeMarks(false)
        metaData.updateBeginEndTailComments()
        metaData.updateCodeGeneratorVersion()

        metaData.dumpDataLines()
    }

}
