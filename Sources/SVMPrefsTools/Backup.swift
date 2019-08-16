// Copyright The SVMPrefs Authors. All rights reserved.

import PathKit

// Adds support to move source file to a backup file.
extension Path {
    public var dotExtension: String {
        if let ext = self.extension {
            return ".\(ext)"
        }
        return ""
    }

    public func backupPath() -> Path {
        parent() + "\(lastComponentWithoutExtension).backup\(dotExtension)"
    }

    public func backup() throws {
        let targetPath = backupPath()
        if targetPath.exists {
            try targetPath.delete()
        }
        try move(targetPath)
    }
}
