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
            url: "https://github.com/abxy-labs/tripwire-ios/releases/download/1.2.0/Tripwire-1.2.0.xcframework.zip",
            checksum: "d364dfa9f8fe70b2c31e6fada315d06784ad018d72b2d224610d0940b2a3b018"
        ),
    ]
)
