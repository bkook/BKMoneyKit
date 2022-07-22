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
                .copy("BKMoneyKit.bundle/CardLogo/amex@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/default@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/dinersclubintl@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/discover@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/jcb@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/laser@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/maestro@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/mastercard@2x.png"),
                .copy("BKMoneyKit.bundle/CardLogo/visa@2x.png"),
            ]
        )
    ]
)
