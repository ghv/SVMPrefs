// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit
import SnapshotTesting

extension Snapshotting where Value == String, Format == String {
    static func svmPrefs(indent: Int = 4) -> Snapshotting {
        var snapshotting: Snapshotting = Snapshotting<String, String>.lines.pullback { code in
            do {
                let someFilePath = "example.swift"
                let someOptions = ParsingOptions(inputFilePath: someFilePath, debug: false, indent: indent)
                let firstProcessor = Processor(with: code, using: someOptions)
                if let result = try firstProcessor.run() {
                    let secondProcessor = Processor(with: result, using: someOptions)
                    let secondResult = try secondProcessor.run()
                    XCTAssertNil(secondResult)
                    return result
                } else {
                    return "// Empty first result"
                }
            } catch let error as SVMError {
                print("Exception: \(error)")
                let msg = error.error(forFile: "SVMError")
                return "// \(msg)"
            } catch {
                return "// Some other exception"
            }
        }
        snapshotting.pathExtension = "swift"
        return snapshotting
    }
}

final class SwiftCodeGeneratorTests: XCTestCase {

    // swiftlint:disable:next function_body_length
    func testAllTypes() {
        //record = true
        let code = """
            import Foundation
            import AppKit

            // swiftlint:disable file_length

            /*SVMPREFS [svmprefs version 2.0.0]
            # Demo Store
            S demo | | RALL

            V Bool      | isBoolVar     | boolVar       | OBJC,REM,ISSET |
            V Bool      | invBoolVar    | invBoolVar    | INV,OBJC,REM,ISSET,IS |

            V Bool      | showEnabled2  | showEnabled2  | OBJC,REM,ISSET,IS |
            V Bool      | showEnabled   | showEnabled   | OBJC,REM,ISSET,IS |
            V Bool      | hasShownAlert | hasShownAlert | OBJC,REM,ISSET |
            V Bool      | didShowAlert  | didShowAlert  | OBJC,REM,ISSET |
            V Bool      | firstLaunch   | firstLaunch   | INV,IS,rem,ISSET |

            V Double    | doubleVar    | doubleVar     | OBJC,REM,ISSET |
            V Float     | floatVar     | floatVar      | OBJC,REM,ISSET |
            V Int       | intVar       | intVar        | OBJC,REM,ISSET |

            V String?   | optStringVar | optStringVar | OBJC,REM,ISSET |
            V String    | stringVar    | stringVar    | OBJC,REM,ISSET |

            V Any?      | optAny       | optAny       | OBJC,REM,ISSET |

            V Data?     | optDataVar   | optDataVar   | OBJC,REM,ISSET |
            V Data      | dataVar      | dataVar      | OBJC,REM,ISSET |

            V Date?     | optDateVar   | optDateVar   | OBJC,REM,ISSET |
            V Date      | dateVar      | dateVar      | OBJC,REM,ISSET |

            V [Any]     | anyArray     | anyArray     | OBJC,REM,ISSET |
            V [Bool]    | boolArray    | boolArray    | OBJC,REM,ISSET |
            V [Date]    | dateArray    | dateArray    | OBJC,REM,ISSET |
            V [Double]  | doubleArray  | doubleArray  | OBJC,REM,ISSET |
            V [Float]   | floatArray   | floatArray   | OBJC,REM,ISSET |
            V [Int]     | intArray     | intArray     | OBJC,REM,ISSET |
            V [String]  | stringArray  | stringArray  | OBJC,REM,ISSET |

            V [Bool]?   | optBoolArray    | optBoolArray   | OBJC,REM,ISSET |
            V [Date]?   | optDateArray    | optDateArray   | OBJC,REM,ISSET |
            V [Double]? | optDoubleArray  | optDoubleArray | OBJC,REM,ISSET |
            V [Float ]? | optFloatArray   | optFloatArray  | OBJC,REM,ISSET |
            V [Int]?    | optIntArray     | optIntArray    | OBJC,REM,ISSET |
            V [String]? | optStringArray  | optStringArray | OBJC,REM,ISSET |

            V [[String: Any]]  | arrayOfStringToAnyDictionary    | arrayOfStringToAnyDictionary    | OBJC,REM,ISSET |
            V [[String: Any]]? | optArrayOfStringToAnyDictionary | optArrayOfStringToAnyDictionary | OBJC,REM,ISSET |

            V [String: Any]    | stringToAnyDictionary    | stringToAnyDictionary    | OBJC,REM,ISSET |
            V [String: Any]?   | optStringToAnyDictionary | optStringToAnyDictionary | OBJC,REM,ISSET |

            V URL?| optUrlVar | optUrlVar | OBJC,REM,ISSET |

            SVMPREFS*/

            // swiftlint:disable:next type_body_length
            class MyAllTypesTests {
                // ANYTHING HERE IS LEFT UNTOUCHED
                // MARK: BEGIN demo
                // ANYTHING HERE WILL BE REPLACED
                // BY THE GENERATED CODE
                // MARK: END demo
                // ANYTHING HERE IS LEFT UNTOUCHED
            }

            """

        assertSnapshot(matching: code, as: .svmPrefs())
    }

    func testMigration() {
        let code = """
            import Foundation
            import AppKit

            /*SVMPREFS
            S main | | RALL

            V Bool | boolVar1    | boolVar2 | IS |
            V Bool | hasBoolVar2 | boolVar2 | |
            V Bool | boolVar3    | boolVar3 | |
            V Bool | boolVar4    | boolVar4 | |

            S copy | | RALL

            V Bool | boolVar3 | boolVar3 | |
            V Bool | boolVar4 | boolVar4 | |

            M main | copy   | boolVar3 | boolVar3
            M main | copy   | boolVar4 | boolVar4
            M main | delete | hasBoolVar2

            SVMPREFS*/

            class MyMigrationTests {
                // MARK: BEGIN main
                // this will be deleted
                // MARK: END main

                // MARK: BEGIN copy
                // this will be deleted
                // MARK: END copy

                // MARK: BEGIN migrate
                // MARK: END migrate
            }

            """

        assertSnapshot(matching: code, as: .svmPrefs())
    }

    func testMigrationWithCodeThatFollows() {
        let code = """
            import Foundation
            import AppKit

            /*SVMPREFS
            S main | | RALL

            V Bool | boolVar1    | boolVar2 | IS |
            V Bool | hasBoolVar2 | boolVar2 | |
            V Bool | boolVar3    | boolVar3 | |
            V Bool | boolVar4    | boolVar4 | |

            S copy | | RALL

            V Bool | boolVar3 | boolVar3 | |
            V Bool | boolVar4 | boolVar4 | |

            M main | copy   | boolVar3 | boolVar3
            M main | copy   | boolVar4 | boolVar4
            M main | delete | hasBoolVar2

            SVMPREFS*/

            class MyMigrationTests2 {
                // MARK: BEGIN main
                // this will be deleted
                // MARK: END main

                // MARK: BEGIN copy
                // this will be deleted
                // MARK: END copy

                // MARK: BEGIN migrate
                // MARK: END migrate
            }
            // These lines here attempt to creat the scenario
            // where there are enough extra lines (3) than being
            // removed (2) to prepare for the generated code to be inserted

            """

        assertSnapshot(matching: code, as: .svmPrefs())
    }


    func testDate() {
        let code = """
            import Foundation
            import AppKit

            /*SVMPREFS
            S main | none | RALL

            V Date           | dateVal         | dateVal         | |
            V Date as Double | dateAsDoubleVal | dateAsDoubleVal | |

            SVMPREFS*/

            class MyDateTests {
                  var main = UserDefaults.standard

                  // MARK: BEGIN main
                  // MARK: END main
            }

            """

        assertSnapshot(matching: code, as: .svmPrefs(indent: 6))
    }

    func testSuiteName() {
        let code = #"""
            import Foundation
            import AppKit

            /*SVMPREFS
            S main  | "someSuiteName"    | RALL
            V Bool  | boolVar            | boolVar  | OBJC,REM,ISSET |
            S main1 | getSuiteName()     | RALL
            V Bool  | boolVar2           | boolVar2 | OBJC,REM,ISSET |
            S main2 | "\(someSuiteName)" | RALL
            V Bool  | boolVar3           | boolVar3 | OBJC,REM,ISSET |
            SVMPREFS*/

            class MySuiteNameTests {
              static let someSuiteName = "someSuiteName"

              static func getSuiteName() -> String {
                "someSuiteName"
              }

              // MARK: BEGIN main
              // this will be deleted
              // MARK: END main

              // MARK: BEGIN main1
              // this will be deleted
              // MARK: END main1

              // MARK: BEGIN main2
              // this will be deleted
              // MARK: END main2
            }

            """#

        assertSnapshot(matching: code, as: .svmPrefs(indent: 2))
    }

    func testCompoundCodeMark() {
        let code = #"""
            import Foundation
            import AppKit

            /*SVMPREFS
            S main  | |
            V Bool  | boolVar  | boolVar  | OBJC,REM,ISSET |
            S main1 | |
            V Bool  | boolVar2 | boolVar2 | OBJC,REM,ISSET |
            S main2 | | RALL
            V Bool  | boolVar3 | boolVar3 | OBJC,REM,ISSET |
            SVMPREFS*/

            class MyCompoundCodeMarakTests {
              // MARK: BEGIN main,main1,main2
              // this will be deleted
              // MARK: END main,main1,main2
            }

            """#

        assertSnapshot(matching: code, as: .svmPrefs(indent: 2))
    }

    func testNoRemoveAll() {
        let code = #"""
            import Foundation
            import AppKit

            /*SVMPREFS
            S main
            V Bool  | boolVar1 | boolVar1 | RALL |
            V Bool  | boolVar2 | boolVar2 |      |
            SVMPREFS*/

            class MyNoRemoveAllTests {
              // MARK: BEGIN main
              // this will be deleted
              // MARK: END main
            }

            """#

        assertSnapshot(matching: code, as: .svmPrefs(indent: 2))
    }

    func testMinimalDemo() {
        let code = #"""
            import Foundation
            import AppKit

            /*SVMPREFS
            S demo
            V Bool | isDemo | demo_key_name | |
            SVMPREFS*/

            class MyDemoPreferences {

                // ANYTHING HERE IS LEFT UNTOUCHED

                // MARK: BEGIN demo
                // ANYTHING HERE WILL BE REPLACED
                // BY THE GENERATED CODE
                // MARK: END demo

                // ANYTHING HERE IS LEFT UNTOUCHED
            }

            """#

        assertSnapshot(matching: code, as: .svmPrefs())
    }

    func testKeyPathExample() {
        let code = #"""
            import Foundation
            import AppKit

            /*SVMPREFS
            S keypath
            V [String] | primaryList   | app.primaryList   | |
            V [String] | secondaryList | app.secondaryList | |
            SVMPREFS*/

            class KeyPathPrefs {
                // MARK: BEGIN keypath
                // MARK: END keypath
            }

            // Somewhere in your app...
            func demo() {
                // A function that needs to use one of several preferences
                func processList(keyPath: KeyPath<KeyPathPrefs, [String]>) {
                    let prefs = KeyPathPrefs()
                    let list = prefs[keyPath: keyPath]
                    // Do something with this list...
                }

                // How you call it:
                processList(keyPath: \.primaryList)
                processList(keyPath: \.secondaryList)
            }

            """#

        assertSnapshot(matching: code, as: .svmPrefs())
    }

}
