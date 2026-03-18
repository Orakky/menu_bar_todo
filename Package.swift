// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "menu_bar_todo",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "menu_bar_todo",
            targets: ["menu_bar_todo"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "menu_bar_todo",
            dependencies: [],
            path: "menu_bar_todo"
        ),
    ]
)
