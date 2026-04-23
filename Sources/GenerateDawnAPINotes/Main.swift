// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation

@main
struct Main {
	static func main() {
		let arguments = CommandLine.arguments

		guard arguments.count == 4 else {
			print("Usage: \(arguments[0]) <dawn.json-path> <output-directory> <dawn-header-path>")
			exit(1)
		}

		let dawnJsonPath = arguments[1]
		let outputDirectoryURL = URL(fileURLWithPath: arguments[2])
		let dawnHeaderURL = URL(fileURLWithPath: arguments[3])

		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: dawnJsonPath)) else {
			print("Failed to read file at \(dawnJsonPath)")
			exit(1)
		}
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let dawnData: DawnData
		do {
			dawnData = try decoder.decode(DawnData.self, from: jsonData)
		} catch {
			print("Failed to decode dawn.json: \(error)")
			exit(1)
		}

		do {
			try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)
		} catch {
			print("Failed to create output directory \(outputDirectoryURL.path): \(error)")
			exit(1)
		}

		let apiNotesURL = outputDirectoryURL.appendingPathComponent("CDawn.apinotes")
		let moduleMapURL = outputDirectoryURL.appendingPathComponent("module.modulemap")

		let apinotes = dawnData.apiNotes()
		let yaml = yamlFromAPINotes(apinotes)
		do {
			try yaml.write(to: apiNotesURL, atomically: true, encoding: .utf8)
		} catch {
			print("Failed to write to \(apiNotesURL.path): \(error)")
			exit(1)
		}

		// Emit a module.modulemap alongside the apinotes so that clang discovers
		// both files in the same directory. The header reference uses an absolute
		// path to the real Dawn.h, which lives in the source tree.
		let modulemap = """
			module CDawn [system] {
				header "\(dawnHeaderURL.path)"
				export *
			}

			"""
		do {
			try modulemap.write(to: moduleMapURL, atomically: true, encoding: .utf8)
		} catch {
			print("Failed to write to \(moduleMapURL.path): \(error)")
			exit(1)
		}

		print("Processing complete!")
	}
}
