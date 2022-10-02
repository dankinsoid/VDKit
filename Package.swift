// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "VDKit",
	platforms: [
		.iOS(.v11), .macOS(.v10_11)
	],
	products: [
		.library(name: "VDKit", targets: ["VDKit"]),
		.library(name: "VDSwiftUI", targets: ["VDSwiftUI"]),
		
		.library(name: "VDBuilders", targets: ["VDBuilders"]),
		.library(name: "UIKitEnvironment", targets: ["UIKitEnvironment"]),
		.library(name: "VDCommon", targets: ["VDCommon"]),
		.library(name: "VDDates", targets: ["VDDates"]),
		.library(name: "WrappedDefaults", targets: ["WrappedDefaults"]),
		.library(name: "UIKitComposable", targets: ["UIKitComposable"]),
		.library(name: "VDSwiftUICommon", targets: ["VDSwiftUICommon"]),
		.library(name: "BindGeometry", targets: ["BindGeometry"]),
		.library(name: "DragNDrop", targets: ["DragNDrop"]),
		.library(name: "EnvironmentStateObject", targets: ["EnvironmentStateObject"]),
		.library(name: "Field", targets: ["Field"]),
		.library(name: "DateField", targets: ["DateField"]),
		.library(name: "Pages", targets: ["Pages"]),
		.library(name: "Scroll", targets: ["Scroll"]),
		.library(name: "VDUIKit", targets: ["VDUIKit"]),
		.library(name: "VDOptional", targets: ["VDOptional"]),
		.library(name: "VDMirror", targets: ["VDMirror"]),
		.library(name: "LinesStack", targets: ["LinesStack"]),
		.library(name: "LoadingPlaceholder", targets: ["LoadingPlaceholder"]),
		.library(name: "VDCoreGraphics", targets: ["VDCoreGraphics"]),
		.library(name: "VDKitRuntime", targets: ["VDKitRuntime"])
	],
	dependencies: [
    ],
	targets: [
		.target(name: "VDKitRuntimeObjc", dependencies: []),
		.target(name: "VDKitRuntime", dependencies: ["VDKitRuntimeObjc"]),
		
		.target(name: "UIKitEnvironment", dependencies: ["VDKitRuntime"]),
		.target(name: "VDBuilders", dependencies: []),
		.target(name: "VDCommon", dependencies: ["VDBuilders"]),
		.target(name: "VDDates", dependencies: []),
		.target(name: "WrappedDefaults", dependencies: ["VDOptional"]),
		.target(name: "VDOptional", dependencies: []),
		.target(name: "VDMirror", dependencies: []),
		.target(name: "VDCoreGraphics", dependencies: []),
		
		.target(name: "VDSwiftUICommon", dependencies: ["VDMirror", "VDOptional", "VDBuilders"], path: "Sources/SwiftUI/VDSwiftUICommon"),
		.target(name: "BindGeometry", dependencies: [], path: "Sources/SwiftUI/BindGeometry"),
		.target(name: "LinesStack", dependencies: ["BindGeometry"], path: "Sources/SwiftUI/LinesStack"),
		.target(name: "LoadingPlaceholder", dependencies: ["BindGeometry"], path: "Sources/SwiftUI/LoadingPlaceholder"),
		.target(name: "DragNDrop", dependencies: ["EnvironmentStateObject", "VDSwiftUICommon", "BindGeometry"], path: "Sources/SwiftUI/DragNDrop"),
		.target(name: "EnvironmentStateObject", dependencies: [], path: "Sources/SwiftUI/EnvironmentStateObject"),
		.target(name: "Field", dependencies: ["VDSwiftUICommon"], path: "Sources/SwiftUI/Field"),
		.target(name: "DateField", dependencies: ["VDSwiftUICommon", "VDDates", "VDCommon", "VDUIKit"], path: "Sources/DateField"),
		.target(name: "Pages", dependencies: ["VDSwiftUICommon"], path: "Sources/SwiftUI/Pages"),
		.target(name: "Scroll", dependencies: ["VDCommon", "VDSwiftUICommon", "VDCoreGraphics"], path: "Sources/SwiftUI/Scroll"),
		.target(name: "VDSwiftUI", dependencies: ["VDSwiftUICommon", "BindGeometry", "DragNDrop", "EnvironmentStateObject", "Field", "Pages", "Scroll", "LinesStack", "VDCoreGraphics", "LoadingPlaceholder"]),
		
		.target(name: "VDUIKit", dependencies: ["VDBuilders", "VDCoreGraphics"]),
		.target(name: "UIKitComposable", dependencies: ["VDKitRuntime", "VDBuilders"]),
		
		.target(name: "VDKit", dependencies: ["VDKitRuntime", "VDBuilders", "UIKitEnvironment", "VDCommon", "VDDates", "WrappedDefaults", "UIKitComposable", "VDSwiftUICommon", "BindGeometry", "DragNDrop", "EnvironmentStateObject", "Field", "Pages", "Scroll", "VDUIKit", "VDOptional", "VDMirror", "LinesStack", "VDCoreGraphics", "LoadingPlaceholder", "DateField"]),
		
//		.testTarget(name: "VDKitTests", dependencies: ["VDKit"]),
	]
)
