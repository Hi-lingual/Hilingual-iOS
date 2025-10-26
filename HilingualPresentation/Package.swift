// swift-tools-version: 6.1
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
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.4.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.15.2"),
        .package(name: "HilingualDomain", path: "../HilingualDomain")
    ],
    targets: [
        .target(
            name: "HilingualPresentation",
            dependencies: [
                "HilingualDomain",
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "AmplitudeSwift", package: "Amplitude-Swift")
            ],
            path: "Sources/Presentation",
            resources: [
                .process("Common/Resources/Font"),
                .process("Common/Resources/Lottie")
            ]
        )
    ]
)
