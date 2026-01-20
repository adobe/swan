// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// swift-tools-version: 6.1

import PackageDescription

let strictSwiftSettings: [SwiftSetting] = [
	.unsafeFlags(["-warnings-as-errors"])
]

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
		.binaryTarget(
			name: "DawnLib",
			url:
				"https://github.com/adobe/swan/releases/download/dawn-chromium-canary-145.0.7591.0/dawn-chromium-canary-145.0.7591.0-release.zip",
			checksum: "54097cc610bd8f2d853c03b95733229f59cec5e45028da05945b46c3714495b1"
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
			],
			swiftSettings: strictSwiftSettings
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
			swiftSettings: strictSwiftSettings
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
			swiftSettings: strictSwiftSettings
		),
		.target(
			name: "DawnData",
			dependencies: [
				.product(name: "Logging", package: "swift-log"),
				"DawnLib",
			],
			swiftSettings: strictSwiftSettings
		),
		.target(
			name: "Dawn",
			dependencies: [
				"CDawn",
				"DawnLib",
				"GenerateDawnBindingsPlugin",
			],
			swiftSettings: strictSwiftSettings
		),
		.target(
			name: "WebGPU",
			dependencies: [
				"Dawn"
			],
			swiftSettings: strictSwiftSettings
		),
		.target(
			name: "RGFW",
			path: "Demos/RGFW",
			swiftSettings: strictSwiftSettings
		),
		.target(
			name: "DemoUtils",
			dependencies: [
				"RGFW",
				"WebGPU",
			],
			path: "Demos/DemoUtils",
			swiftSettings: strictSwiftSettings
		),
		.executableTarget(
			name: "GameOfLife",
			dependencies: [
				"DemoUtils"
			],
			path: "Demos/GameOfLife",
			swiftSettings: strictSwiftSettings,
			linkerSettings: [
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
			swiftSettings: strictSwiftSettings
		),
		.testTarget(
			name: "DawnTests",
			dependencies: [
				"Dawn",
				.product(name: "Testing", package: "swift-testing"),
			],
			swiftSettings: strictSwiftSettings,
			linkerSettings: [
				.linkedFramework("IOSurface", .when(platforms: [.macOS])),
				.linkedFramework("Metal", .when(platforms: [.macOS])),
				.linkedFramework("QuartzCore", .when(platforms: [.macOS])),
			]
		),
	]
)
