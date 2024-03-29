// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesynticLibrary",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DesynticLibrary",
            type: .dynamic,
            targets: ["DesynticLibrary"]),
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.33.0")),
            .package(url: "https://github.com/apple/swift-nio-ssl.git", .upToNextMajor(from: "2.14.1")),
            .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.4.2")),
            .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.4")),
            .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.2.0")),
            .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", .upToNextMajor(from: "2.0.0"))

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DesynticLibrary",
            dependencies: [],
            swiftSettings: [.define("SWIFT_PACKAGE")],
            linkerSettings: [
                        .linkedFramework("UIKit"),
                        .linkedFramework("SwiftUI")
                    ]),
        .testTarget(
            name: "DesynticLibraryTests",
            dependencies: ["DesynticLibrary"]),
    ],
    swiftLanguageVersions: [.v5]
)
