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
        // --- Firebase 전체 SDK (SPM 공식 저장소) ---
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.5.0"),

        // --- 기존 의존성들 ---
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
                .product(name: "AmplitudeSwift", package: "Amplitude-Swift"),
                // --- ✅ Firebase Core & Remote Config 추가 ---
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ],
            path: "Sources/Presentation",
            resources: [
                .process("Common/Resources/Font"),
                .process("Common/Resources/Lottie")
            ]
        )
    ]
)
