// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

private let someFilePath = "example.swift"
private let someOptions = ParsingOptions(inputFilePath: someFilePath, debug: false, indent: 0)

final class VariableModelTests: XCTestCase {

    func testEverythingRequiredIsThereAndNoOptions() {
        let someOffset = 42
        let someType = "MyType"
        let someName = "foo"
        let someKey = "my.key.name"
        let someOptions = ""
        let someDefault = ""
        let tokens: [String] = [someType, someName, someKey, someOptions, someDefault]
        do {
            let cut = try VariableModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.type, someType)
            XCTAssertEqual(cut.name, someName)
            XCTAssertEqual(cut.key, someKey)
            XCTAssertNil(cut.defaultValue)
        } catch {
            XCTFail("unexpected exception")
        }
    }

    func testThrowsOnInsufficientNumberOfParameters() {
        let someOffset = 42
        let tokens: [String] = []
        XCTAssertThrowsError(try VariableModel(offset: someOffset, withTokens: tokens),
                "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing parameters")
                XCTAssertEqual(error.line, 43)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testThrowsOnUnknownOption() {
        let someOffset = 42
        let someType = "MyType"
        let someName = "foo"
        let someKey = "my.key.name"
        let someOptions = "BAD"
        let someDefault = ""
        let tokens: [String] = [someType, someName, someKey, someOptions, someDefault]
        XCTAssertThrowsError(try VariableModel(offset: someOffset, withTokens: tokens),
                "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Unknown option: BAD")
                XCTAssertEqual(error.line, 43)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testEverythingRequiredIsThereWithAllOptions() {
        let someOffset = 42
        let someType = "MyType"
        let someName = "foo"
        let someKey = "my.key.name"
        let someOptions = " IS,INV,OBJC,NVAR,NSET,RALL,NRALL ,REM, ISSET "
        let someDefault = ""
        let tokens: [String] = [someType, someName, someKey, someOptions, someDefault]
        do {
            let cut = try VariableModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.type, someType)
            XCTAssertEqual(cut.name, someName)
            XCTAssertEqual(cut.key, someKey)
            XCTAssertEqual(cut.options.count, 9)
            XCTAssertNil(cut.defaultValue)
        } catch {
            XCTFail("unexpected exception")
        }
    }
}
