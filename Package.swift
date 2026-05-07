// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Monty",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "MontyCore",
            targets: ["MontyCore"]
        ),
        .library(
            name: "MontyAppUI",
            targets: ["MontyAppUI"]
        ),
        .executable(
            name: "MontyApp",
            targets: ["MontyApp"]
        ),
    ],
    dependencies: [
        .package(path: "guderian/dzw"),
    ],
    targets: [
        .target(
            name: "MontyCore",
            dependencies: [
                .product(name: "DerZweiteWeltkriegHistorical", package: "dzw"),
            ],
            path: "Sources/MontyCore"
        ),
        .target(
            name: "MontyAppUI",
            dependencies: ["MontyCore"],
            path: "Sources/MontyApp",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("AppKit"),
            ]
        ),
        .executableTarget(
            name: "MontyApp",
            dependencies: ["MontyAppUI"],
            path: "Sources/MontyAppHost",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("AppKit"),
            ]
        ),
        .testTarget(
            name: "MontyTests",
            dependencies: ["MontyCore"],
            path: "Tests/MontyTests"
        ),
    ]
)
