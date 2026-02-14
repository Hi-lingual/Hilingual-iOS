// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HilingualCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HilingualCore",
            targets: ["HilingualCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.15.2")
    ],
    targets: [
        .target(
            name: "HilingualCore",
            dependencies: [
                .product(name: "AmplitudeSwift", package: "Amplitude-Swift")
            ]
        )
    ]
)
