// Copyright The SVMPrefs Authors. All rights reserved.

import PathKit

public enum CodeGenLanguage: String {
    case text = "txt"
    case java = "java"
    case kotlin = "kt"
    case objc = "m"
    case swift = "swift"
}

public class ParsingOptions {
    public var debug: Bool
    public var indent: Int
    public var inputFilePath: String
    public var language: CodeGenLanguage

    public init(inputFilePath: String, debug: Bool, indent: Int) {
        let path = Path(inputFilePath)

        self.inputFilePath = path.absolute().string
        self.debug = debug
        self.indent = indent
        if let ext = path.extension {
            self.language = CodeGenLanguage(rawValue: ext) ?? .text
        } else {
            self.language = .text
        }
    }
}
