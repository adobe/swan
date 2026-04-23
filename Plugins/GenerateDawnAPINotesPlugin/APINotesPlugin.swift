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
struct APINotesPlugin: BuildToolPlugin {

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
		let apiNotesURL = outputDirectoryURL.appending(path: "CDawn.apinotes")
		let moduleMapURL = outputDirectoryURL.appending(path: "module.modulemap")
		let dawnHeaderURL = context.package.directoryURL.appending(path: "Sources/CDawn/include/Dawn.h")

		let generatorTool = try context.tool(named: "GenerateDawnAPINotes")

		return [
			.buildCommand(
				displayName: "Generating Dawn APINotes and modulemap",
				executable: generatorTool.url,
				arguments: [
					dawnJsonURL.path,
					outputDirectoryURL.path,
					dawnHeaderURL.path,
				],
				inputFiles: [dawnJsonURL, dawnHeaderURL],
				outputFiles: [apiNotesURL, moduleMapURL]
			)
		]
	}
}
