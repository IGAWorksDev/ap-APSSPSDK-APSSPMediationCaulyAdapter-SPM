// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "APSSPMediationCauly",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "APSSPMediationCauly", targets: ["APSSPMediationCauly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IGAWorksDev/ap-APSSPSDK-SPM.git", from: "3.4.0"),
        .package(url: "https://github.com/cauly/CaulySPM.git", exact: "3.1.23"),
    ],
    targets: [
        .target(name: "APSSPMediationCauly",
                dependencies: [
                    .product(name: "APSSPSDK", package: "ap-APSSPSDK-SPM"),
                    .product(name: "CaulySDK", package: "CaulySPM"),
                ],
                path: "Sources/MediationCauly"),
    ]
)
