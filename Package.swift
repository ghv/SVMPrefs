// swift-tools-version:5.1

import PackageDescription

// https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescription.md

let package = Package(
    name: "SVMPrefs",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "svmprefs", targets: ["svmprefs"]),
        .library(name: "SVMPrefsKit", targets: ["SVMPrefsKit"]),
        .library(name: "SVMPrefsTools", targets: ["SVMPrefsTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", from: "6.0.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.5.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", .branch("master"))
    ],
    targets: [
        .target(name: "SVMPrefsTools", dependencies: ["PathKit"]),
        .target(name: "SVMPrefsKit", dependencies: ["PathKit", "Regex", "Stencil"]),
        .target(name: "svmprefs", dependencies: ["SwiftCLI", "SVMPrefsKit", "SVMPrefsTools", "PathKit"]),
        .testTarget(name: "SVMPrefsToolsTests", dependencies: ["SVMPrefsTools", "PathKit"]),
        .testTarget(name: "SVMPrefsKitTests", dependencies: ["SVMPrefsKit", "SnapshotTesting"])
    ]
)
