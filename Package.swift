// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tripwire",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Tripwire",
            targets: ["Tripwire"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "Tripwire",
            url: "https://github.com/abxy-labs/tripwire-ios/releases/download/1.0.0/Tripwire-1.0.0.xcframework.zip",
            checksum: "db5d36752a5348584fdcaf4bd759738559153dee627a4670dbe9df92f7bd511d"
        ),
    ]
)
