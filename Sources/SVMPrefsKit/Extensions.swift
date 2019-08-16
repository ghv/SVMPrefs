// Copyright The SVMPrefs Authors. All rights reserved.

import Foundation
import CommonCrypto
import Regex

extension Regex {
    public static func escape(_ str: String) -> String {
        NSRegularExpression.escapedPattern(for: str)
    }
}

extension String {
    mutating func appendLFLF() {
        self.append("\n\n")
    }

    var isNotEmpty: Bool {
        !isEmpty
    }

    var stringOrNilIfEmpty: String? {
        isEmpty ? nil : self
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var withSpacesRemoved: String {
        self.replacingOccurrences(of: " ", with: "")
    }

    var witEmptyLinesRemoved: String {
        if let regex = try? Regex(string: "\n+") {
            return self.replacingAll(matching: regex, with: "\n")
        }
        return self
    }

    var withTrimmedTrailingWhitespace: String {
        if let whiteSpaceRange = self.range(of: #"\s+$"#, options: .regularExpression) {
            return self.replacingCharacters(in: whiteSpaceRange, with: "")
        } else {
            return self
        }
    }

    var withFirstLetterCapitlized: String {
        prefix(1).uppercased() + dropFirst()
    }

    var countLeadingSpaces: Int {
        if let regex = try? Regex(string: #"^(\s*)"#), let match = regex.firstMatch(in: self) {
            return match.captures[0]?.count ?? 0
        }
        return 0
    }

    var md5: String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        let hexString = digest.map({ String(format: "%02x", $0) }).joined()
        return hexString
    }

    func repeated(count: Int) -> String {
        String(repeating: self, count: count)
    }

    func split(at delimiter: String) -> [String] {
        let escapedDelimiter = Regex.escape(delimiter)
        let expression = #"\s*\#(escapedDelimiter)\s*"#
        if let regex = try? Regex(string: expression) {
            let compacted = self.trimmed.replacingAll(matching: regex, with: delimiter)
            return compacted.components(separatedBy: delimiter)
        }
        fatalError("Could not create the regular expression for split")
    }
}

extension Collection where Element == String {
    // Get a token or nil if it is out of bounds or empty
    func getToken(at index: Index) -> String? {
        self.indices.contains(index) ? self[index].stringOrNilIfEmpty : nil
    }
}
