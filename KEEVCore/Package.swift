// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KEEVCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KEEVCore",
            targets: ["KEEVCore"]),
    ],
    dependencies: [
        .package(path: "../Foundation/Network"),
        .package(path: "../Foundation/KeyValueStorage"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KEEVCore",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .product(name: "KeyValueStorage", package: "KeyValueStorage"),
            ]
        ),
        .testTarget(
            name: "KEEVCoreTests",
            dependencies: ["KEEVCore"]
        ),
    ]
)
