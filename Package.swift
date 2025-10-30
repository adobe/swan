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
			from: "6.2.0"
		),
		.package(url: "https://github.com/apple/swift-log", from: "1.6.4"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
		.package(url: "https://github.com/swiftlang/swift-format.git", from: "602.0.0"),
	],
	targets: [
		.binaryTarget(
			name: "DawnLib",
			url:
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-142.0.7404.0/dawn-chromium-canary-142.0.7404.0-release.zip",
			checksum: "4843d01428cfefc9e6d56c5eac1199544ceb323fbf25680636e3b58800e51feb"
		),
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
			name: "CodeGenerationTests",
			dependencies: [
				"GenerateDawnBindings",
				"GenerateDawnAPINotes",
				.product(name: "Testing", package: "swift-testing"),
			]
		),
		.testTarget(
			name: "DawnTests",
			dependencies: [
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
