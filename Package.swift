// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DropMad",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "DropMad",
            targets: ["DropMad"]
        )
    ],
    targets: [
        .executableTarget(
            name: "DropMad",
            path: "Sources/DropMad"
        )
    ]
)
