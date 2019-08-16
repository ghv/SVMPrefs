// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

final class ErrorTests: XCTestCase {

    func testErrorWithNoLineFormat() {
        let someError = "An Error is being tested"
        let someFile = "error.swift"

        let cut = SVMError(someError)

        XCTAssertEqual(cut.message, someError)
        XCTAssertEqual(cut.line, 0)
        XCTAssertEqual(cut.error(forFile: someFile), "\(someFile): error: \(someError)")
    }

    func testErrorWithLineFormat() {
        let someError = "An Error is being tested"
        let someFile = "error.swift"
        let someOffset = 41
        let expectedLine = someOffset + 1

        let cut = SVMError(at: someOffset, someError)

        XCTAssertEqual(cut.message, someError)
        XCTAssertEqual(cut.line, expectedLine)
        XCTAssertEqual(cut.error(forFile: someFile), "\(someFile):\(expectedLine): error: \(someError)")
    }

}
