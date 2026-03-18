// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// swift-tools-version: 6.3;(experimentalCGen)

import Foundation
import PackageDescription

let supportedNativePlatforms: [Platform] = [.macOS, .windows]
let wasmPlatforms: [Platform] = [.wasi]

let swanLocalDawn: Bool = ProcessInfo.processInfo.environment["SWAN_LOCAL_DAWN"] != nil
let isWasmBuild: Bool = ProcessInfo.processInfo.environment["SWAN_WASM"] != nil
// When set, lowers the macOS deployment target to 14 for compatibility with PS CI machines.
let buildMacOS14: Bool = ProcessInfo.processInfo.environment["BUILD_MACOS14"] == "1"

#if os(Windows)
let useAddressSanitizer: Bool = false
let usePDBDebugInfo: Bool = ProcessInfo.processInfo.environment["USE_PDB_DEBUG_INFO"] == "true"
#else
let useAddressSanitizer: Bool = ProcessInfo.processInfo.environment["USE_ADDRESS_SANITIZER"] == "true"
let usePDBDebugInfo: Bool = false
#endif

let dawnArtifactURL: String? = ProcessInfo.processInfo.environment["DAWN_ARTIFACT_URL"]

let dawnTarget: Target = {
	if swanLocalDawn {
		return .binaryTarget(
			name: "DawnLib",
			path: "Dawn/dist/dawn_webgpu.artifactbundle"
		)
	} else if let dawnArtifactURL {
		return .binaryTarget(
			name: "DawnLib",
			url: dawnArtifactURL,
			checksum: ProcessInfo.processInfo.environment["DAWN_ARTIFACT_CHECKSUM"] ?? ""
		)
	} else {
		return .binaryTarget(
			name: "DawnLib",
			url:
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-147.0.7712.0/dawn-chromium-canary-147.0.7712.0-release.artifactbundleindex",
			checksum: "ec22871c1022f5fa526cfa4a1872caf2dfda3fad705207903154330878e46430"
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
		.macOS(buildMacOS14 ? .v14 : .v15),
		.iOS(.v18),
	],
	products: [
		.library(
			name: "WebGPU",
			targets: ["WebGPU"]
		),
	] + (isWasmBuild ? [] : [
		.plugin(
			name: "GenerateDawnBindingsPlugin",
			targets: ["GenerateDawnBindingsPlugin"]
		),
		.plugin(
			name: "GenerateDawnAPINotesPlugin",
			targets: ["GenerateDawnAPINotesPlugin"]
		),
	]),
	dependencies: isWasmBuild ? [
		.package(url: "https://github.com/swiftwasm/JavaScriptKit.git", branch: "cf7a4f31f1f191f4eea84bb79c6aeffbccb7140e"),
	] : [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
		.package(url: "https://github.com/swiftlang/swift-format.git", from: "602.0.0"),
	] + (buildMacOS14 ? [] : [
		.package(
			url: "https://github.com/swiftlang/swift-testing.git",
			from: "6.2.4"
		),
	]),
	targets: isWasmBuild ? [
		.target(
			name: "WebGPUWasm",
			dependencies: [
				.product(name: "JavaScriptKit", package: "JavaScriptKit")
			],
			path: "Sources/WebGPU/Wasm",
			exclude: [
				"Generated/README.md",
				"Generated/JavaScript",
				"bridge-js.config.json",
			],
			swiftSettings: swiftSettings + [
				.enableExperimentalFeature("Extern"),
				.treatWarning("EmbeddedRestrictions", as: .warning),
			],
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "WebGPU",
			dependencies: [
				.target(name: "WebGPUWasm", condition: .when(platforms: wasmPlatforms)),
			],
			exclude: [
				"Dawn",
				"Wasm",
			],
			swiftSettings: swiftSettings + [.treatWarning("EmbeddedRestrictions", as: .warning)],
			linkerSettings: asanLinkerSettings
		),
		.executableTarget(
			name: "BitonicSort",
			dependencies: [
				.target(name: "WebGPU"),
				.target(name: "WebGPUWasm"),
			],
			path: "Demos/BitonicSort",
			exclude: ["index.html"],
			swiftSettings: swiftSettings + [.enableExperimentalFeature("Extern")],
			plugins: [.plugin(name: "BridgeJS", package: "JavaScriptKit")]
		),
	] : [
		dawnTarget,
		.executableTarget(
			name: "GenerateDawnBindings",
			dependencies: [
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
			capability: .command(
				intent: .custom(
					verb: "generate-dawn-bindings-swift",
					description: "Generate Swift Dawn bindings from dawn.json"
				),
				permissions: [
					.writeToPackageDirectory(reason: "Generate Swift binding files into Sources/Dawn/Generated/")
				]
			),
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
			name: "WebGPU",
			dependencies: [
				.target(name: "WebGPUDawn", condition: .when(platforms: supportedNativePlatforms)),
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
			name: "BitonicSort",
			dependencies: [
				.target(name: "DemoUtils")
			],
			path: "Demos/BitonicSort",
			exclude: ["index.html"],
			swiftSettings: swiftSettings,
			linkerSettings: asanLinkerSettings + [
				.linkedFramework("Cocoa", .when(platforms: [.macOS])),
				.linkedFramework("IOKit", .when(platforms: [.macOS])),
				.linkedFramework("Metal", .when(platforms: [.macOS])),
				.linkedLibrary("c++", .when(platforms: [.macOS])),
			]
		),
	] + (buildMacOS14 ? [] : [
		// swift-testing uses unsafe build flags which SPM rejects when targeting macOS 14.
		// Test targets are excluded under BUILD_MACOS14 to avoid this.
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
	])
)
