// Copyright The SVMPrefs Authors. All rights reserved.

public class SVMError: Error {
    public var line: Int
    public var message: String

    init(at line: Int, _ message: String) {
        self.line = line + 1
        self.message = message
    }

    init(_ message: String) {
        self.line = 0
        self.message = message
    }

    public func error(forFile file: String) -> String {
        if line > 0 {
            return "\(file):\(line): error: \(message)"
        }
        return "\(file): error: \(message)"
    }
}
