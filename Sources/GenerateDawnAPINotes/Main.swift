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

		guard arguments.count == 3 else {
			print("Usage: \(arguments[0]) <dawn.json-path> <output-apinotes-path>")
			exit(1)
		}

		let dawnJsonPath = arguments[1]
		let apiNotesURL = URL(fileURLWithPath: arguments[2])

		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: dawnJsonPath)) else {
			print("Failed to read file at \(dawnJsonPath)")
			exit(1)
		}
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let dawnData: DawnData
		do {
			dawnData = try decoder.decode(DawnData.self, from: jsonData)
			// print(dawnData)
		} catch {
			print("Failed to decode dawn.json: \(error)")
			exit(1)
		}

		let apinotes = dawnData.apiNotes()
		let yaml = yamlFromAPINotes(apinotes)
		do {
			try yaml.write(to: apiNotesURL, atomically: true, encoding: .utf8)
		} catch {
			print("Failed to write to \(apiNotesURL.path): \(error)")
			exit(1)
		}

		print("Processing complete!")
	}
}
