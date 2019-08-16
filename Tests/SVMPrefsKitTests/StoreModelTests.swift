// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

private let someFilePath = "example.swift"
private let someOptions = ParsingOptions(inputFilePath: someFilePath, debug: false, indent: 0)

final class StoreModelTests: XCTestCase {

    func testJustName() {
        let someOffset = 42
        let someName = "foo"
        let tokens: [String] = [someName]
        do {
            let cut = try StoreModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.identifier, someName)
        } catch {
            XCTFail("unexpected exception")
        }
    }

    func testNameAndSuite() {
        let someOffset = 42
        let someName = "foo"
        let someSuite = "bar"
        let tokens: [String] = [someName, someSuite]
        do {
            let cut = try StoreModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.suiteName, someSuite)
            XCTAssertEqual(cut.identifier, someName)
        } catch {
            XCTFail("unexpected exception")
        }
    }

    func testNameSuiteAndOption() {
        let someOffset = 42
        let someName = "foo"
        let someSuite = "bar"
        let someOptions = "RALL"
        let tokens: [String] = [someName, someSuite, someOptions]
        do {
            let cut = try StoreModel(offset: someOffset, withTokens: tokens)
            XCTAssertEqual(cut.sourceLineOffset, someOffset)
            XCTAssertEqual(cut.suiteName, someSuite)
            XCTAssertEqual(cut.identifier, someName)
            XCTAssertEqual(cut.options.count, 1)
            XCTAssertTrue(cut.options.contains(.generateRemoveAllMethod))
        } catch {
            XCTFail("unexpected exception")
        }
    }

    func testNameSuiteAndBadOption() {
        let someOffset = 42
        let someName = "foo"
        let someSuite = "bar"
        let someOptions = "RALL,BAD"
        let tokens: [String] = [someName, someSuite, someOptions]
        XCTAssertThrowsError(try StoreModel(offset: someOffset, withTokens: tokens),
                "No exception was thrown") { error in
            if let error = error as? SVMError {
                XCTAssertEqual(error.message, "Unknown option: BAD")
                XCTAssertEqual(error.line, someOffset + 1)
            } else {
                XCTFail("Not the expected exception")
            }
        }

    }




}
