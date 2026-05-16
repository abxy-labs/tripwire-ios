// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Foil",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Foil",
            targets: ["Foil"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "Foil",
            url: "https://github.com/abxy-labs/foil-ios/releases/download/1.2.2/Foil-1.2.2.xcframework.zip",
            checksum: "84d3071c46ff0e3653e874c9c2a22bf4b9b56bc0ea0768cf6f4e18b388f621d1"
        ),
    ]
)
