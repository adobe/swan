// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "WebGPULife",
	platforms: [
		.macOS(.v15),  // macOS 15
		.iOS(.v18),  // iOS 18 (or adjust the version as needed)
	],
	products: [
		.plugin(
			name: "GenerateDawnBindingsPlugin",
			targets: ["GenerateDawnBindingsPlugin"]
		),
		.plugin(
			name: "GenerateDawnAPINotesPlugin",
			targets: ["GenerateDawnAPINotesPlugin"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/swiftlang/swift-testing.git",
			revision: "18c42c19cac3fafd61cab1156d4088664b7424ae"
		),
		.package(url: "https://github.com/apple/swift-log", from: "1.6.4"),
		.package(url: "https://github.com/swiftlang/swift-syntax.git", branch: "swift-DEVELOPMENT-SNAPSHOT-2025-08-04-a"),
	],
	targets: [
		.binaryTarget(
			name: "DawnLib",
			url:
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-142.0.7394.0-release/dawn_webgpu_chromium_142.0.7394.0_canary_0567736dfb04b0dfb51d764201800724aa8df8d2.zip",
			checksum: "d7fba4262135b6474e21736042c8a15ca3556477a89ab0676f9d278d285fea7f"
		),
		.executableTarget(
			name: "GenerateDawnBindings",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				.product(name: "SwiftSyntax", package: "swift-syntax"),
				.product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
				"DawnData",
			],
			exclude: [
				"README.md"
			]
		),
		.executableTarget(
			name: "GenerateDawnAPINotes",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnData",
			],
			exclude: [
				"README.md"
			]
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
		),
		.target(
			name: "DawnData",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnLib",
			],
		),
		.target(
			name: "Dawn",
			dependencies: [
				"CDawn",
				"DawnLib",
				"GenerateDawnBindingsPlugin",
			],
		),
		.target(
			name: "WebGPU",
			dependencies: [
				"Dawn"
			],
		),
		.testTarget(
			name: "WebGPUTests",
			dependencies: [
				"GenerateDawnBindings",
				"GenerateDawnAPINotes",
				"Dawn",
				.product(name: "Testing", package: "swift-testing"),
			],
			linkerSettings: [
				.linkedFramework("IOSurface"),
				.linkedFramework("Metal"),
				.linkedFramework("QuartzCore"),
			]
		),
	]
)
