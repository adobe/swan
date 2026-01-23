// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// swift-tools-version: 6.1

import Foundation
import PackageDescription

let swanLocalDawn: Bool = ProcessInfo.processInfo.environment["SWAN_LOCAL_DAWN"] != nil
let useAddressSanitizer: Bool = ProcessInfo.processInfo.environment["CI"] == "true"

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
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-146.0.7647.0/dawn-chromium-canary-146.0.7647.0-release.zip",
			checksum: "4f2c20051e08bd60101e8c8079d658ea9f0fa6c8421c54ba0a425d2174634985"
		)
	}
}()

let strictSwiftSettings: [SwiftSetting] = [
	.unsafeFlags(["-warnings-as-errors"])
]

let asanSwiftSettings: [SwiftSetting] =
	useAddressSanitizer
	? [
		.unsafeFlags(["-sanitize=address"])
	] : []

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
		.package(url: "https://github.com/apple/swift-log", from: "1.9.1"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.7.0"),
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
		.package(url: "https://github.com/swiftlang/swift-format.git", from: "602.0.0-latest"),
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
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
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
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
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
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "DawnData",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnLib",
			],
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "Dawn",
			dependencies: [
				"CDawn",
				"DawnLib",
				"GenerateDawnBindingsPlugin",
			],
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "WebGPU",
			dependencies: [
				"Dawn"
			],
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "RGFW",
			path: "Demos/RGFW",
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.target(
			name: "DemoUtils",
			dependencies: [
				"RGFW",
				"WebGPU",
			],
			path: "Demos/DemoUtils",
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
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
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings + [
				.linkedFramework("Cocoa", .when(platforms: [.macOS])),
				.linkedFramework("IOKit", .when(platforms: [.macOS])),
				.linkedFramework("Metal", .when(platforms: [.macOS])),
				.linkedLibrary("c++", .when(platforms: [.macOS])),
			]
		),
		.testTarget(
			name: "CodeGenerationTests",
			dependencies: [
				"GenerateDawnBindings",
				"GenerateDawnAPINotes",
				.product(name: "Testing", package: "swift-testing"),
			],
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
			linkerSettings: asanLinkerSettings
		),
		.testTarget(
			name: "DawnTests",
			dependencies: [
				"Dawn",
				.product(name: "Testing", package: "swift-testing"),
			],
			swiftSettings: strictSwiftSettings + asanSwiftSettings,
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
