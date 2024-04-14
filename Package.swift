// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "LoremSwiftify",
    platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LoremSwiftify",
            targets: ["LoremSwiftify"]
        ),
        .executable(
            name: "LoremSwiftifyClient",
            targets: ["LoremSwiftifyClient"]
        ),
    ],
    dependencies: [
        // Depend on the Swift 5.9 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.4.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "LoremSwiftifyMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "LoremSwiftify",
            dependencies: [
                "LoremSwiftifyMacros",
                "Fakery",
            ]
        ),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "LoremSwiftifyClient", dependencies: ["LoremSwiftify"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "LoremSwiftifyTests",
            dependencies: [
                "LoremSwiftifyMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ]
)
