// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

private let someFilePath = "example.swift"
private let someOptions = ParsingOptions(inputFilePath: someFilePath, debug: false, indent: 0)

final class MigrateModelTests: XCTestCase {

    func testEverythingRequiredIsThereAndNoOptions() {
        let someOffset = 42
        let someSourceName = "source"
        let someTargetName = "target"
        let someFromName = "foo"
        let someToName = "bar"
        let tokens: [String] = [someSourceName, someTargetName, someFromName, someToName]
        do {
            let cut = try MigrateModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.target, someTargetName)
            XCTAssertEqual(cut.fromVar, someFromName)
            XCTAssertEqual(cut.toVar, someToName)
        } catch {
            XCTFail("unexpected exception")
        }
    }

    func testThrowsOnInsufficientNumberOfParameters() {
        let someOffset = 42
        let someSourceName = "source"
        let someTargetName = "target"
        let tokens: [String] = [someSourceName, someTargetName]
        XCTAssertThrowsError(try MigrateModel(offset: someOffset, withTokens: tokens),
                "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing parameters")
                XCTAssertEqual(error.line, 43)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testThrowsOnMissingToVar() {
        let someOffset = 42
        let someSourceName = "source"
        let someTargetName = "target"
        let someFromName = "foo"
        let tokens: [String] = [someSourceName, someTargetName, someFromName]
        XCTAssertThrowsError(try MigrateModel(offset: someOffset, withTokens: tokens),
                "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Missing destination var parameter")
                XCTAssertEqual(error.line, 43)
            } else {
                XCTFail("Not the expected exception")
            }
        }
    }

    func testDeleteScenario() {
        let someOffset = 42
        let someSourceName = "source"
        let someTargetName = "delete"
        let someFromName = "foo"
        let tokens: [String] = [someSourceName, someTargetName, someFromName]
        do {
            let cut = try MigrateModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.target, someTargetName)
            XCTAssertEqual(cut.fromVar, someFromName)
        } catch {
            XCTFail("unexpected exception")
        }
    }


}
