// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CountedSet",
    products: [
        .library(
            name: "CountedSet",
            targets: ["CountedSet"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "CountedSet",
            dependencies: []
        ),
        .testTarget(
            name: "CountedSetTests",
            dependencies: ["CountedSet"]
        )
    ]
)
