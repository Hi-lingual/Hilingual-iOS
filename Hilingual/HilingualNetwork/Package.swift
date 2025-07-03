// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "HilingualNetwork",
    platforms: [
        .iOS(.v16) 
    ],
    products: [
        .library(
            name: "HilingualNetwork",
            targets: ["HilingualNetwork"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3")
    ],
    targets: [
        .target(
            name: "HilingualNetwork", 
            dependencies: [
                .product(name: "Moya", package: "Moya")
            ]
        )
    ]
)
