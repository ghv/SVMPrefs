// Copyright The SVMPrefs Authors. All rights reserved.

public class Processor {
    private let metaData: ParserMetaData

    public init(with contents: String, using options: ParsingOptions) {
        metaData = ParserMetaData(contents: contents, options: options)
    }

    @discardableResult public func run() throws -> String? {
        try parse()
        try generate()

        let output = metaData.lines.joined(separator: "\n")

        let outputHash = output.md5
        metaData.log("MD5 input:  \(metaData.inputHash)")
        metaData.log("MD5 output: \(outputHash)")

        metaData.log("OUTPUT:")
        metaData.log(output)

        if metaData.inputHash != outputHash {
            metaData.log("Generated code changed")
            return output
        } else {
            metaData.log("No changes in generated code")
        }
        return nil
    }

    internal func parse() throws {
        let parser = Parser(metaData)
        try parser.run()
    }

    internal func generate() throws {
        var generator: CodeGenerator?
        switch metaData.options.language {
        case .swift:
            generator = SwiftCodeGenerator(metaData)
        default:
            ()
        }

        if let generator = generator {
            try generator.run()
        } else {
            throw SVMError("Generator for \(metaData.options.language) is not available.")
        }
    }
}
