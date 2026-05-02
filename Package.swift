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
            checksum: "6a806a9a43dba1b6f34866672c56c6dad6a06284a2bd309acc6d18dc8b5460c0"
        ),
    ]
)
