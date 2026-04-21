// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation
import PackagePlugin

@main
struct DawnBindingsPlugin: BuildToolPlugin {

	// File names produced by GenerateDawnBindings for each dawn.json category.
	// Keep in sync with the keys returned by DawnData.generateWrappers().
	private static let generatedFileNames = [
		"Bitmasks.swift",
		"CallbackFunctions.swift",
		"CallbackInfo.swift",
		"Enums.swift",
		"FunctionPointers.swift",
		"Objects.swift",
		"Structures.swift",
	]

	func createBuildCommands(
		context: PluginContext,
		target: Target
	) async throws -> [Command] {
		guard let dawnLibTarget = context.package.targets.first(where: { $0.name == "DawnLib" }) else {
			Diagnostics.error("Could not find DawnLib target.")
			return []
		}

		let dawnJsonURL = dawnLibTarget.directoryURL.appending(path: "dawn.json")
		let outputDirectoryURL = context.pluginWorkDirectoryURL
		let swiftFormatConfigURL = context.package.directoryURL.appending(path: ".swift-format")

		let generatorTool = try context.tool(named: "GenerateDawnBindings")

		let outputFiles = Self.generatedFileNames.map { outputDirectoryURL.appending(path: $0) }

		return [
			.buildCommand(
				displayName: "Generating Dawn Swift bindings",
				executable: generatorTool.url,
				arguments: [
					"--dawn-json", dawnJsonURL.path,
					"--output-directory", outputDirectoryURL.path,
					"--swift-format-config", swiftFormatConfigURL.path,
				],
				inputFiles: [dawnJsonURL, swiftFormatConfigURL],
				outputFiles: outputFiles
			)
		]
	}
}
