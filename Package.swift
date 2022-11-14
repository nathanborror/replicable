// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Replicable",
    products: [
        .library(name: "Replicable", targets: ["Replicable"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Replicable", dependencies: []),
        .testTarget(name: "ReplicableTests", dependencies: ["Replicable"]),
    ]
)
