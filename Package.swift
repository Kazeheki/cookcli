// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CookCLI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "cook", targets: ["CookCLI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/cooklang/CookInSwift", from: "1.2.4"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/envoy/Embassy.git", from: "4.0.0"),
        .package(url: "https://github.com/envoy/Ambassador.git", from: "4.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6"),
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: [.product(name: "Embassy", package: "Embassy"),
                           .product(name: "Ambassador", package: "Ambassador"),
                           .target(name: "Catalog")],
            exclude: ["Frontend", "inject_frontend.sh"],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(
            name: "ShoppingList",
            dependencies: ["CookInSwift"]
        ),
        .target(
            name: "Catalog",
            dependencies: ["CookInSwift"]
        ),
        .target(
            name: "CookCLI",
            dependencies: ["CookInSwift",
                           "Yams",
                           .target(name: "Server"),
                           .target(name: "ShoppingList"),
                           .target(name: "Catalog"),
                           .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "CookCLITests",
            dependencies: ["CookCLI"]),
    ]
)
