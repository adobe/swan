// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import PackagePlugin

@main
struct DawnBindingsPlugin: BuildToolPlugin {

	func createBuildCommands(
		context: PluginContext,
		target: Target
	) throws -> [Command] {
		let dependencies: [TargetDependency] = target.dependencies

		let dawnLib = dependencies.first(where: {
			if case let .target(target) = $0 { return target.name == "DawnLib" } else { return false }
		})
		guard case let .target(target) = dawnLib else {
			fatalError("\(target.name) does not depend on DawnLib")
		}

		print("DawnLib: \(target.name)")

		let directoryURL = target.directoryURL
		let dawnJsonURL = directoryURL.appending(path: "dawn.json")
		print("Dawn JSON path: \(dawnJsonURL)")

		let workingDirectoryURL = context.pluginWorkDirectoryURL
		let targetDirectoryURL = context.package.directoryURL

		print("Project directory: \(targetDirectoryURL)")

		let generatorTool = try context.tool(named: "GenerateDawnBindings")

		let outputs = [
			workingDirectoryURL.appending(path: "Bitmasks.swift"),
			workingDirectoryURL.appending(path: "CallbackFunctions.swift"),
			workingDirectoryURL.appending(path: "CallbackInfo.swift"),
			workingDirectoryURL.appending(path: "Enums.swift"),
			workingDirectoryURL.appending(path: "FunctionPointers.swift"),
			workingDirectoryURL.appending(path: "Objects.swift"),
			workingDirectoryURL.appending(path: "Structures.swift"),
		]

		return [
			.buildCommand(
				displayName: "Generate Dawn Bindings",
				executable: generatorTool.url,
				arguments: [
					"--dawn-json", dawnJsonURL.path,
					"--output-directory", workingDirectoryURL.path,
					"--swift-format-config", targetDirectoryURL.appending(path: ".swift-format").path,
				],
				environment: [:],
				inputFiles: [dawnJsonURL],
				outputFiles: outputs
			)
		]
	}
}
