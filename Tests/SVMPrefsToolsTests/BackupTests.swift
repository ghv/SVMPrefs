// Copyright The SVMPrefs Authors. All rights reserved.

import XCTest
import PathKit
@testable import SVMPrefsTools

final class SVMPrefsTests: XCTestCase {

    func testFullPathWithExtension() {
        let somePath = "/foo/bar/file.beer"
        let expectedPath = "/foo/bar/file.backup.beer"

        let cut = Path(somePath)
        let resultPath = cut.backupPath()

        XCTAssertEqual(expectedPath, resultPath.description)
    }

    func testWithNoExtension() {
        let somePath = "/foo/bar/file"
        let expectedPath = "/foo/bar/file.backup"

        let cut = Path(somePath)
        let resultPath = cut.backupPath()

        XCTAssertEqual(expectedPath, resultPath.description)
    }

    func testWithNoParentPath() {
        let somePath = "file"
        let expectedPath = "file.backup"

        let cut = Path(somePath)
        let resultPath = cut.backupPath()

        XCTAssertEqual(expectedPath, resultPath.description)
    }

    func testWithRelativePathAndNoExtension() {
        let somePath = "../file"
        let expectedPath = "../file.backup"

        let cut = Path(somePath)
        let resultPath = cut.backupPath()

        XCTAssertEqual(expectedPath, resultPath.description)
    }

    func testWithRelativePathAndExtension() {
        let somePath = "./file.swift"
        let expectedPath = "file.backup.swift"

        let cut = Path(somePath)
        let resultPath = cut.backupPath()

        XCTAssertEqual(expectedPath, resultPath.description)
    }

    func testBackup() {
        let testPath = "./file.swift"
        let someContent = "File Foo Contents"

        let cut = Path(testPath)

        XCTAssertFalse(cut.exists)
        XCTAssertNoThrow(try cut.write(someContent))

        let backupPath = cut.backupPath()

        XCTAssertFalse(backupPath.exists)
        XCTAssertNoThrow(try cut.backup())
        XCTAssertTrue(backupPath.exists)
        XCTAssertFalse(cut.exists)
        let contents = (try? backupPath.read()) ?? "failed"
        XCTAssertEqual(contents, someContent)
        XCTAssertNoThrow(try backupPath.delete())
        XCTAssertFalse(backupPath.exists)
    }

    func testSourceFileDoesNotExist() {
        let testPath = "./willNeverExist.swift"

        let cut = Path(testPath)
        XCTAssertFalse(cut.exists)
        let backupPath = cut.backupPath()
        XCTAssertFalse(backupPath.exists)

        XCTAssertThrowsError(try cut.backup())
        XCTAssertFalse(cut.exists)
        XCTAssertFalse(backupPath.exists)
    }

    func testBackupFileDoesExist() {
        let testPath = "./file.swift"
        let someContent = "File Foo Contents"
        let someOldContent = "Old Foo Contents"

        let cut = Path(testPath)

        XCTAssertFalse(cut.exists)
        XCTAssertNoThrow(try cut.write(someContent))

        let backupPath = cut.backupPath()
        XCTAssertNoThrow(try backupPath.write(someOldContent))

        XCTAssertTrue(backupPath.exists)
        XCTAssertNoThrow(try cut.backup())
        XCTAssertTrue(backupPath.exists)
        XCTAssertFalse(cut.exists)
        let contents = (try? backupPath.read()) ?? "failed"
        XCTAssertEqual(contents, someContent)
        XCTAssertNoThrow(try backupPath.delete())
        XCTAssertFalse(backupPath.exists)
    }

}
