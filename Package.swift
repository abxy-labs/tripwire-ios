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
            checksum: "8d984e7b76935763c1905ca57e01d24faf90b9053e56468b74485c67ca3d38d1"
        ),
    ]
)
