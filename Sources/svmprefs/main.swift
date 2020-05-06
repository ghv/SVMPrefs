// Copyright The SVMPrefs Authors. All rights reserved.

import Foundation
import SVMPrefsTools
import SVMPrefsKit
import SwiftCLI
import PathKit

class Gen: Command {
    let name = "gen"
    let shortDescription = "Processes the given file and generates the code for the contained SVM data"
    let input = Param<String>()

    let backup = Flag("-b", "--backup", description: "Create a backup copy of the source file (foo.m -> foo.backup.m)")
    let debug = Flag("-d", "--debug", description: "Print debug output")
    let indent = Key<Int>("-i", "--indent", description: "Set indent width. (Default: 4)")

    func execute() throws {
        let options = SVMPrefsKit.ParsingOptions(inputFilePath: input.value,
                debug: debug.value, indent: indent.value ?? 4)
        let inputPath = Path(options.inputFilePath)
        if let contents: String = try? inputPath.read() {
            do {
                let processor = SVMPrefsKit.Processor(with: contents, using: options)
                if let output = try processor.run() {
                    if backup.value {
                        try inputPath.backup()
                    }
                    try inputPath.write(output)
                }
            } catch let error as SVMError {
                throw(CLI.Error(message: error.error(forFile: options.inputFilePath), exitStatus: EXIT_FAILURE))
            } catch {
                throw(CLI.Error(message: "Fatal Error \(error.localizedDescription)", exitStatus: EXIT_FAILURE))
            }
        } else {
            throw(CLI.Error(message: "Could not read \(options.inputFilePath)", exitStatus: EXIT_FAILURE))
        }
    }
}

let appName = "svmprefs"
let appVersion = SVMPrefsKit.Version.text
let appDescription = """
Generates code to read, write, and migrate preferences using the SVM data embedded in the source.
Copyright 2019 The SVMPrefs Authors. All rights reserved.
"""

let cli = CLI(name: appName, version: appVersion, description: appDescription,
              commands: [Gen()])
exit(cli.go())
