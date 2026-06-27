// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HilingualNetwork",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HilingualNetwork",
            targets: ["HilingualNetwork"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(name: "HilingualCore", path: "../HilingualCore")
    ],
    targets: [
        .target(
            name: "HilingualNetwork",
            dependencies: [
                .product(name: "Moya", package: "Moya"),
                .product(name: "HilingualCore", package: "HilingualCore")
            ]
        )
    ]
)
