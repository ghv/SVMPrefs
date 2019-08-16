// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
@testable import SVMPrefsKit

final class StringExtensionTests: XCTestCase {
    func testStringOrNilIfEmpty() {
        let someString = "foo"
        let someEmpty = ""
        let someNil: String? = nil

        XCTAssertEqual(someString.stringOrNilIfEmpty, someString)
        XCTAssertNil(someEmpty.stringOrNilIfEmpty)
        XCTAssertNil(someNil?.stringOrNilIfEmpty)
    }

    func testTrimmed() {
        let trimmedFoo = "foo"
        let someLeadingOnlyString = "    foo"
        let someTrailingOnlyString = "foo   "
        let someLeadingAndTrailingString = "    foo     "

        XCTAssertEqual(someLeadingOnlyString.trimmed, trimmedFoo)
        XCTAssertEqual(someTrailingOnlyString.trimmed, trimmedFoo)
        XCTAssertEqual(someLeadingAndTrailingString.trimmed, trimmedFoo)
    }

    func testWithTrimmedTrailingWhitespace() {
        let trimmedFoo = "   foo"
        let someTrailingSpacesAndTabs = "   foo  \t\n\n\n "
        XCTAssertEqual(someTrailingSpacesAndTabs.withTrimmedTrailingWhitespace, trimmedFoo)
    }

    func testSplit() {
        let split123 = ["1", "2", "3"]
        let someSplit = "   1     |    2|3  "
        let someNothingToSplit = "1|2|3"
        let someCommasToSplit = "   1 ,   2,   3     "
        XCTAssertEqual(someSplit.split(at: "|"), split123)
        XCTAssertEqual(someNothingToSplit.split(at: "|"), split123)
        XCTAssertEqual(someCommasToSplit.split(at: ","), split123)
    }

    func testWithEmptyLinesRemoved() {
        let expectedAllEmptyLines = "\n"
        let someAllEmptyLines = """


"""

        let someLines = """

This
is

A
Sample

of

some

lines

being

removed


"""

        let expectedLines = """
\nThis
is
A
Sample
of
some
lines
being
removed\n
"""

        XCTAssertEqual(someAllEmptyLines.witEmptyLinesRemoved, expectedAllEmptyLines)
        XCTAssertEqual(someLines.witEmptyLinesRemoved, expectedLines)
    }

    func testWithFirstLetterCapitlized() {
        let expectedString = "Foo"
        let someString = "foo"

        XCTAssertEqual(someString.withFirstLetterCapitlized, expectedString)
        XCTAssertEqual(expectedString.withFirstLetterCapitlized, expectedString)
    }

    func testCountLeadingSpaces() {
        let some4SpaceString = "    4 spaces"
        let some0SpaceString = "0 spaces"
        let some1SpaceString = " 1 spaces"
        let someEmptyString = ""

        XCTAssertEqual(some0SpaceString.countLeadingSpaces, 0)
        XCTAssertEqual(some1SpaceString.countLeadingSpaces, 1)
        XCTAssertEqual(some4SpaceString.countLeadingSpaces, 4)
        XCTAssertEqual(someEmptyString.countLeadingSpaces, 0)
    }

    func testMD5() {
        let someText = "foo"
        let expectedHash = "acbd18db4cc2f85cedef654fccc4a4d8"
        XCTAssertEqual(someText.md5, expectedHash)
    }
}

final class ArrayExtensionTests: XCTestCase {
    func testGetToken() {
        let aut = ["one", "", "three"]
        XCTAssertEqual(aut.getToken(at: 0), "one")
        XCTAssertEqual(aut.getToken(at: 2), "three")
        XCTAssertNil(aut.getToken(at: 1))
        XCTAssertNil(aut.getToken(at: 3))
    }
}
