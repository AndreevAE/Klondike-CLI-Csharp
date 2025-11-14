// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KlondikeSwift",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "KlondikeSwift",
            dependencies: [],
            path: "Sources/KlondikeSwift"
        )
    ]
)
