// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "BKMoneyKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "BKMoneyKit",
            targets: ["BKMoneyKit"]),
    ],
    targets: [
        .target(
            name: "BKMoneyKit",
            resources: [
                .process("BKMoneyKit.bundle")
            ]
        )
    ]
)
