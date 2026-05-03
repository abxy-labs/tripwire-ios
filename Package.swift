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
            url: "https://github.com/abxy-labs/tripwire-ios/releases/download/1.2.1/Tripwire-1.2.1.xcframework.zip",
            checksum: "b023e2e85b21235118f801915946c44c87596da4b634083a3e659f86608238ee"
        ),
    ]
)
