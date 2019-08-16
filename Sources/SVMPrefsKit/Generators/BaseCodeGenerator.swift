// Copyright The SVMPrefs Authors. All rights reserved.

import Stencil

protocol CodeGenerator {
    func run() throws
}

class BaseCodeGenerator {

    var metaData: ParserMetaData

    // Stencil environment
    let environment = Environment()

    init(_ metaData: ParserMetaData) {
        self.metaData = metaData
    }

    func render(_ template: String, _ context: [String: Any?]) throws -> String {
        // We are using optional Any values but Stencil expects Any.
        let flattenedContext = context.reduce(into: [String: Any]()) { flattened, element in
            element.value.flatMap {
                flattened[element.key] = $0
            }
        }

        var result: String
        result = try environment.renderTemplate(string: template, context: flattenedContext)
        return result.witEmptyLinesRemoved.withTrimmedTrailingWhitespace
    }

    func reindent(_ input: [String], indent: Int) -> [String] {
        var fixed: [String] = []

        for line in input {
            var fix = line
            let currentLeadingSpaces = line.countLeadingSpaces

            // Templates are 4-space based; This is here to ensure that assumtion holds.
            assert(currentLeadingSpaces % 4 == 0)

            let indentLevel = currentLeadingSpaces / 4
            if indentLevel > 0 {
                let fixLeadingSpaces = indentLevel * indent
                let spacesToRemove = currentLeadingSpaces - fixLeadingSpaces
                if spacesToRemove > 0 {
                    fix.removeSubrange(fix.startIndex..<fix.index(fix.startIndex, offsetBy: spacesToRemove))
                } else if spacesToRemove < 0 {
                    // negative spaces to remove means we need to add instead
                    fix.insert(contentsOf: " ".repeated(count: -spacesToRemove), at: fix.startIndex)
                }
            }
            fixed.append(fix)
        }
        return fixed
    }
}
