// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// swift-tools-version: 6.2

import Foundation
import PackageDescription

let supportedNativePlatforms: [Platform] = [.macOS, .windows]
let wasmPlatforms: [Platform] = [.wasi]

let swanLocalDawn: Bool = ProcessInfo.processInfo.environment["SWAN_LOCAL_DAWN"] != nil

#if os(Windows)
let useAddressSanitizer: Bool = false
let usePDBDebugInfo: Bool = ProcessInfo.processInfo.environment["USE_PDB_DEBUG_INFO"] == "true"
#else
let useAddressSanitizer: Bool = ProcessInfo.processInfo.environment["USE_ADDRESS_SANITIZER"] == "true"
let usePDBDebugInfo: Bool = false
#endif

let dawnTarget: Target = {
	if swanLocalDawn {
		return .binaryTarget(
			name: "DawnLib",
			path: "Dawn/dist/dawn_webgpu.artifactbundle"
		)
	} else {
		return .binaryTarget(
			name: "DawnLib",
			url:
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-146.0.7666.0/dawn-chromium-canary-146.0.7666.0-release.zip",
			checksum: "eff4297d456101289f2105b7da4686d1963cf15ad0aa5000fe9447dcfcb30c1a"
		)
	}
}()

var swiftSettings: [SwiftSetting] = [
	.unsafeFlags(["-warnings-as-errors"])
]

// Generate PDB debug info on Windows for Visual Studio debugging compatibility
if usePDBDebugInfo {
	swiftSettings.append(contentsOf: [
		.unsafeFlags(["-g", "-debug-info-format=codeview"])
	])
}

// Add address sanitizer settings if enabled
if useAddressSanitizer {
	swiftSettings.append(contentsOf: [
		.unsafeFlags(["-sanitize=address"])
	])
}

let asanLinkerSettings: [LinkerSetting] =
	useAddressSanitizer
	? [
		.unsafeFlags(["-sanitize=address"])
	] : []

let package = Package(
	name: "Swan",
	platforms: [
		.macOS(.v15),  // macOS 15
		.iOS(.v18),  // iOS 18 (or adjust the version as needed)
	],
	products: [
		.library(
			name: "WebGPU",
			targets: ["WebGPU"]
		),
		.plugin(
			name: "GenerateDawnBindingsPlugin",
			targets: ["GenerateDawnBindingsPlugin"],
		),
		.plugin(
			name: "GenerateDawnAPINotesPlugin",
			targets: ["GenerateDawnAPINotesPlugin"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/swiftlang/swift-testing.git",
			from: "6.2.3"
		),
		.package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.43.0"),
		.package(url: "https://github.com/apple/swift-log", from: "1.9.1"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.7.0"),
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
		.package(url: "https://github.com/swiftlang/swift-format.git", from: "602.0.0"),
	],
	targets: [
		dawnTarget,
		.executableTarget(
			name: "GenerateDawnBindings",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "SwiftSyntax", package: "swift-syntax"),
				.product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
				.product(name: "SwiftBasicFormat", package: "swift-syntax"),
				.product(name: "SwiftFormat", package: "swift-format"),
				"DawnData",
			],
			exclude: [
				"README.md"
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.executableTarget(
			name: "GenerateDawnAPINotes",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnData",
			],
			exclude: [
				"README.md"
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.plugin(
			name: "GenerateDawnBindingsPlugin",
			capability: .buildTool(),
			dependencies: [
				"GenerateDawnBindings"
			]
		),
		.plugin(
			name: "GenerateDawnAPINotesPlugin",
			capability: .command(
				intent: .custom(
					verb: "generate-dawn-apinotes",
					description: "Generate Dawn APINotes from dawn.json"
				),
				permissions: [
					.writeToPackageDirectory(reason: "Generate APINotes file")
				]
			),
			dependencies: [
				"GenerateDawnAPINotes"
			]
		),
		.target(
			name: "CDawn",
			dependencies: [
				"DawnLib"
			],
			cxxSettings: [
				.unsafeFlags(["-std=c++23"])
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "DawnData",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnLib",
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "Dawn",
			dependencies: [
				"CDawn",
				"DawnLib",
				"GenerateDawnBindingsPlugin",
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "WebGPUDawn",
			dependencies: [
				// WebGPUCore or similar core library for shared protocols and types ?
				"Dawn"
			],
			path: "Sources/WebGPU/Dawn",
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "WebGPUWasm",
			dependencies: [
				.product(name: "JavaScriptKit", package: "JavaScriptKit")
			],
			path: "Sources/WebGPU/Wasm",
			exclude: ["README.md"],
			swiftSettings: swiftSettings + [.treatWarning("EmbeddedRestrictions", as: .warning)],
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "WebGPU",
			dependencies: [
				.target(name: "WebGPUDawn", condition: .when(platforms: supportedNativePlatforms)),
				.target(name: "WebGPUWasm", condition: .when(platforms: wasmPlatforms)),
			],
			exclude: [
				"Dawn",
				"Wasm",
			],
			swiftSettings: swiftSettings + [.treatWarning("EmbeddedRestrictions", as: .warning)],
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "RGFW",
			path: "Demos/RGFW",
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "DemoUtils",
			dependencies: [
				"RGFW",
				"WebGPU",
			],
			path: "Demos/DemoUtils",
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings + [
				.linkedLibrary("dxgi", .when(platforms: [.windows])),
				.linkedLibrary("d3d12", .when(platforms: [.windows])),
				.linkedLibrary("dxguid", .when(platforms: [.windows])),
			]
		),
		.executableTarget(
			name: "GameOfLife",
			dependencies: [
				"DemoUtils"
			],
			path: "Demos/GameOfLife",
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings + [
				.linkedFramework("Cocoa", .when(platforms: [.macOS])),
				.linkedFramework("IOKit", .when(platforms: [.macOS])),
				.linkedFramework("Metal", .when(platforms: [.macOS])),
				.linkedLibrary("c++", .when(platforms: [.macOS])),
			]
		),
		.executableTarget(
			name: "WebGPUMinimalWasm",
			dependencies: [
				.target(name: "WebGPU", condition: .when(platforms: wasmPlatforms))
			],
			path: "Demos/WebGPUMinimalWasm",
			exclude: ["README.md", "index.html"],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.testTarget(
			name: "CodeGenerationTests",
			dependencies: [
				"GenerateDawnBindings",
				"GenerateDawnAPINotes",
				.product(name: "Testing", package: "swift-testing"),
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.testTarget(
			name: "DawnTests",
			dependencies: [
				"WebGPU",
				.product(name: "Testing", package: "swift-testing"),
			],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings + [
				.linkedFramework("IOSurface", .when(platforms: [.macOS])),
				.linkedFramework("Metal", .when(platforms: [.macOS])),
				.linkedFramework("QuartzCore", .when(platforms: [.macOS])),
				.linkedLibrary("dxgi", .when(platforms: [.windows])),
				.linkedLibrary("d3d12", .when(platforms: [.windows])),
				.linkedLibrary("dxguid", .when(platforms: [.windows])),
			]
		),
	]
)
