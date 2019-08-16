// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

private let someFilePath = "example.swift"
private let someOptions = ParsingOptions(inputFilePath: someFilePath, debug: false, indent: 0)

final class ExceptionTests: XCTestCase {

    func testNoData() {
        let someCode = """
            no data
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing SVMPREFS start")
                XCTAssertEqual(error.line, 0)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoEnd() {
        let someCode = """
            /*SVMPREFS
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing SVMPREFS end")
                XCTAssertEqual(error.line, 1)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testEndBeforeBegin() {
        let someCode = """
            SVMPREFS*/
            /*SVMPREFS
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "SVMPREFS ends before SVMPREFS starts")
                XCTAssertEqual(error.line, 1)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoCodeMarks() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing code blocks")
                XCTAssertEqual(error.line, 0)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoFooEndMark() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing END for foo")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoFooBeginMark() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "END before BEGIN foo")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testFooBeginTwice() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: BEGIN foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Redundant BEGIN foo")
                XCTAssertEqual(error.line, 4)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testBarBeginBeforeFooEnd() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: BEGIN bar
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "bar BEGIN before prior block's END")
                XCTAssertEqual(error.line, 4)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testRedundantBeginFooAfterCompoundMark() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo,bar
            // MARK: END foo,bar
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Redundant BEGIN foo")
                XCTAssertEqual(error.line, 5)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testRedundantCompoundMarkAfterFoo() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            // MARK: BEGIN foo,bar
            // MARK: END foo,bar
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Redundant BEGIN foo")
                XCTAssertEqual(error.line, 5)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }


    func testMarkBeforeData() {
        let someCode = """
            // MARK: BEGIN foo
            // MARK: END foo
            /*SVMPREFS
            SVMPREFS*/
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message    , "SVMPREFS must be before all code marks")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testUnknownRecordType() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            X foo | |
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Unknown record type: X")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testInvalidData() {
        let someCode = """
            /*SVMPREFS
            This is some invalid text
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Invalid SVMPrefs format")
                XCTAssertEqual(error.line, 2)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testVariableBeforeStore() {
        let someCode = """
            /*SVMPREFS
            V something
            S foo | |
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "A store must be defined before any variables")
                XCTAssertEqual(error.line, 2)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testVariableMissingParameters() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing parameters")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testVariableUnkownOption() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey | BAD | someDefault
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Unknown option: BAD")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testVariableDuplicated() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey ||
            V someType | someName | someKey ||
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Variable already exists")
                XCTAssertEqual(error.line, 4)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMigrateBeforeStore() {
        let someCode = """
            /*SVMPREFS
            M someSourceStore | someTargetStore | someSourceVar | someTargetVar
            S foo | |
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Unknown source store: someSourceStore")
                XCTAssertEqual(error.line, 2)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMigrateMissingParameters() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            M someSourceStore
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing parameters")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMigrateMissingDestinationTarget() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            M someSourceStore | someTargetStore | someSourceVar
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing destination var parameter")
                XCTAssertEqual(error.line, 3)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoStores() {
        let someCode = """
            /*SVMPREFS
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing stores")
                XCTAssertEqual(error.line, 0)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoVariablesForStore() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing variables")
                XCTAssertEqual(error.line, 2)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testNoCodeMarkForStore() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey |  | someDefault
            SVMPREFS*/
            // MARK: BEGIN foos
            // MARK: END foos
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing code mark")
                XCTAssertEqual(error.line, 2)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMissingMigrateCodeMark() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey |  | someDefault
            M foo | delete | someName
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing code mark")
                XCTAssertEqual(error.line, 4)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMissingTargetStoreDefinition() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey |  | someDefault
            M foo | someTargetName | someName | someOtherName
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            // MARK: BEGIN migrate
            // MARK: END migrate
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing target store definition")
                XCTAssertEqual(error.line, 4)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMissingTargetVariableDefinition() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey |  | someDefault
            S bar
            V someType | someExtraName | someExtraKey |  | someExtraDefault
            M foo | bar | someName | someOtherName
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            // MARK: BEGIN bar
            // MARK: END bar
            // MARK: BEGIN migrate
            // MARK: END migrate
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing target variable definition")
                XCTAssertEqual(error.line, 6)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testMissingSourceVariableDefinition() {
        let someCode = """
            /*SVMPREFS
            S foo | |
            V someType | someName | someKey |  | someDefault
            S bar
            V someType | someExtraName | someExtraKey |  | someExtraDefault
            M foo | bar | someMissingName | someExtraName
            SVMPREFS*/
            // MARK: BEGIN foo
            // MARK: END foo
            // MARK: BEGIN bar
            // MARK: END bar
            // MARK: BEGIN migrate
            // MARK: END migrate
            """
        let processor = Processor(with: someCode, using: someOptions)
        XCTAssertThrowsError(try processor.run(), "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing source variable definition")
                XCTAssertEqual(error.line, 6)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }
}
