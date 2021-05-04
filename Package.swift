// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VDKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
			.library(name: "VDKit", targets: ["VDKit"]),
    ],
    dependencies: [],
    targets: [
			.target(name: "VDKitRuntime", dependencies: []),
			.target(name: "VDKit", dependencies: ["VDKitRuntime"]),
			.testTarget(name: "VDTests", dependencies: ["VDKit"]),
    ]
)
