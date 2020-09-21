// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CTXTutorialEngine",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "CTXTutorialEngine", targets: ["CTXTutorialEngine"]),
    ],
    targets: [
        .target(name: "CTXTutorialEngine", dependencies: [], path: "Sources"),
    ]
)
