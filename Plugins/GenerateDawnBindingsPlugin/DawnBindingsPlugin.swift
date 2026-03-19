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
struct DawnBindingsPlugin: CommandPlugin {

	func performCommand(
		context: PluginContext,
		arguments: [String]
	) throws {
		let package = context.package
		guard let dawnLibTarget = package.targets.first(where: { $0.name == "DawnLib" }) else {
			print("Error: Could not find DawnLib target.")
			return
		}

		let dawnJsonURL = dawnLibTarget.directoryURL.appending(path: "dawn.json")
		let outputDirectoryURL = package.directoryURL.appending(path: "Sources/Dawn/Generated")
		let swiftFormatConfigURL = package.directoryURL.appending(path: ".swift-format")

		print("Dawn JSON path: \(dawnJsonURL.path)")
		print("Output directory: \(outputDirectoryURL.path)")

		let generatorTool = try context.tool(named: "GenerateDawnBindings")

		let process = Process()
		process.executableURL = generatorTool.url
		process.arguments = [
			"--dawn-json", dawnJsonURL.path,
			"--output-directory", outputDirectoryURL.path,
			"--swift-format-config", swiftFormatConfigURL.path,
		]

		try process.run()
		process.waitUntilExit()

		if process.terminationStatus != 0 {
			print("Error: Generator failed with exit code \(process.terminationStatus)")
			return
		}

		print("Dawn bindings generation completed successfully!")
	}
}
