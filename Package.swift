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
            url: "https://github.com/abxy-labs/tripwire-ios/releases/download/1.1.0/Tripwire-1.1.0.xcframework.zip",
            checksum: "ed9a804181f858c33323755afb94212cbb1e8900c8e95b5981a940b061aa6cee"
        ),
    ]
)
