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
struct APINotesPlugin: CommandPlugin {

	func performCommand(
		context: PluginContext,
		arguments: [String]
	) throws {
		// Parse command line arguments
		var argumentExtractor = ArgumentExtractor(arguments)

		// Look for --dawn-json-path argument
		let dawnJsonPath = argumentExtractor.extractOption(named: "dawn-json-path").first
		let outputPath = argumentExtractor.extractOption(named: "output-path").first

		// If no arguments provided, try to find DawnLib target
		var finalDawnJsonPath: String
		var finalOutputPath: String

		if let dawnJsonPath = dawnJsonPath, let outputPath = outputPath {
			finalDawnJsonPath = dawnJsonPath
			finalOutputPath = outputPath
		} else {
			// Try to find DawnLib target automatically
			let package = context.package
			guard let dawnLibTarget = package.targets.first(where: { $0.name == "DawnLib" }) else {
				print("Error: Could not find DawnLib target. Please specify --dawn-json-path and --output-path arguments.")
				print(
					"Usage: swift package plugin --allow-writing-to-package-directory GenerateDawnAPINotesPlugin --dawn-json-path <path> --output-path <path>"
				)
				return
			}

			finalDawnJsonPath = dawnLibTarget.directoryURL.appending(path: "dawn.json").path
			finalOutputPath = context.package.directoryURL.appending(path: "Sources/CDawn/include/CDawn.apinotes").path
		}

		print("Dawn JSON path: \(finalDawnJsonPath)")
		print("Output path: \(finalOutputPath)")

		// Get the generator tool
		let generatorTool = try context.tool(named: "GenerateDawnAPINotes")

		// Run the generator
		let process = Process()
		process.executableURL = generatorTool.url
		process.arguments = [finalDawnJsonPath, finalOutputPath]

		try process.run()
		process.waitUntilExit()

		if process.terminationStatus != 0 {
			print("Error: Generator failed with exit code \(process.terminationStatus)")
			return
		}

		print("APINotes generation completed successfully!")
	}
}
