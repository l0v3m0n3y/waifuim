// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "waifuim",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "waifuim", targets: ["waifuim"]),
    ],
    targets: [
        .target(
            name: "waifuim",
            path: "src"
        ),
    ]
)
