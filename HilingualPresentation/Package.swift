// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "HilingualPresentation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HilingualPresentation",
            targets: ["HilingualPresentation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(name: "HilingualDomain", path: "../HilingualDomain")
    ],
    targets: [
        .target(
            name: "HilingualPresentation",
            dependencies: [
                "HilingualDomain", 
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "Sources/Presentation",
            resources: [
                .process("Common/Resources/Font")
            ]
        )
    ]
)
