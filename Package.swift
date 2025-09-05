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
	dependencies: [
		.package(
			url: "https://github.com/swiftlang/swift-testing.git",
			revision: "18c42c19cac3fafd61cab1156d4088664b7424ae"
		),
		.package(url: "https://github.com/apple/swift-log", from: "1.6.4"),
	],
	targets: [
		.executableTarget(
			name: "WebGPULife",
			dependencies: [
				"WebGPU"
			],
		),
		.binaryTarget(
			name: "DawnFramework",
			path: "webgpu_dawn.xcframework"
		),
		.executableTarget(
			name: "UpdateDawnBindings",
			dependencies: [
				.product(name: "Logging", package: "swift-log")
			],
			exclude: [
				"README.md"
			]
		),
		.target(
			name: "Dawn",
			dependencies: [
				"DawnFramework"
			],
		),
		.target(
			name: "WebGPU",
			dependencies: [
				"Dawn"
			],
		),
		.testTarget(
			name: "UpdateDawnBindingsTest",
			dependencies: [
				"UpdateDawnBindings",
				.product(name: "Testing", package: "swift-testing"),
			]
		),
	]
)
