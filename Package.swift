// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "VDKit",
	platforms: [
		.iOS(.v11), .macOS(.v10_11), .watchOS(.v5)
	],
	products: [
		.library(name: "VDKit", targets: ["VDKit"]),
		.library(name: "VDSwiftUI", targets: ["VDSwiftUI"]),
		
		.library(name: "VDBuilders", targets: ["VDBuilders"]),
		.library(name: "VDChain", targets: ["VDChain"]),
		.library(name: "UIKitEnvironment", targets: ["UIKitEnvironment"]),
		.library(name: "VDCommon", targets: ["VDCommon"]),
		.library(name: "VDDates", targets: ["VDDates"]),
		.library(name: "WrappedDefaults", targets: ["WrappedDefaults"]),
		.library(name: "UIKitIntegration", targets: ["UIKitIntegration"]),
		.library(name: "VDLayout", targets: ["VDLayout"]),
		.library(name: "VDSwiftUICommon", targets: ["VDSwiftUICommon"]),
		.library(name: "BindGeometry", targets: ["BindGeometry"]),
		.library(name: "DragNDrop", targets: ["DragNDrop"]),
		.library(name: "EnvironmentStateObject", targets: ["EnvironmentStateObject"]),
		.library(name: "Field", targets: ["Field"]),
		.library(name: "IterableView", targets: ["IterableView"]),
		.library(name: "Pages", targets: ["Pages"]),
		.library(name: "Scroll", targets: ["Scroll"]),
		.library(name: "VDUIKit", targets: ["VDUIKit"]),
		.library(name: "VDOptional", targets: ["VDOptional"]),
		.library(name: "VDMirror", targets: ["VDMirror"]),
		.library(name: "LinesStack", targets: ["LinesStack"]),
		.library(name: "VDCoreGraphics", targets: ["VDCoreGraphics"]),
		.library(name: "VDKitRuntime", targets: ["VDKitRuntime"])
	],
	dependencies: [],
	targets: [
		.target(name: "VDKitRuntimeObjc", dependencies: []),
		.target(name: "VDKitRuntime", dependencies: ["VDKitRuntimeObjc"]),
		
		.target(name: "VDChain", dependencies: ["VDOptional"]),
		.target(name: "UIKitEnvironment", dependencies: ["VDKitRuntime", "VDChain"]),
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
		.target(name: "DragNDrop", dependencies: ["EnvironmentStateObject", "VDSwiftUICommon", "BindGeometry"], path: "Sources/SwiftUI/DragNDrop"),
		.target(name: "EnvironmentStateObject", dependencies: [], path: "Sources/SwiftUI/EnvironmentStateObject"),
		.target(name: "Field", dependencies: ["VDSwiftUICommon"], path: "Sources/SwiftUI/Field"),
		.target(name: "IterableView", dependencies: ["VDCommon"], path: "Sources/SwiftUI/Iterable"),
		.target(name: "Pages", dependencies: ["VDSwiftUICommon"], path: "Sources/SwiftUI/Pages"),
		.target(name: "Scroll", dependencies: ["VDCommon", "VDSwiftUICommon", "VDCoreGraphics"], path: "Sources/SwiftUI/Scroll"),
		.target(name: "VDSwiftUI", dependencies: ["UIKitIntegration", "VDSwiftUICommon", "BindGeometry", "DragNDrop", "EnvironmentStateObject", "Field", "IterableView", "Pages", "Scroll", "LinesStack", "VDCoreGraphics"]),
		
		.target(name: "UIKitIntegration", dependencies: ["VDLayout"]),
		
		.target(name: "VDUIKit", dependencies: ["VDBuilders", "VDCoreGraphics"]),
		.target(name: "VDLayout", dependencies: ["VDKitRuntime", "VDBuilders", "VDChain"]),
		
		.target(name: "VDKit", dependencies: ["VDKitRuntime", "VDBuilders", "VDChain", "UIKitEnvironment", "VDCommon", "VDDates", "WrappedDefaults", "UIKitIntegration", "VDLayout", "VDSwiftUICommon", "BindGeometry", "DragNDrop", "EnvironmentStateObject", "Field", "IterableView", "Pages", "Scroll", "VDUIKit", "VDOptional", "VDMirror", "LinesStack", "VDCoreGraphics"]),
		
//		.testTarget(name: "VDKitTests", dependencies: ["VDKit"]),
	]
)
