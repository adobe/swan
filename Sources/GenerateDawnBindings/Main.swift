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
			print("Usage: \(arguments[0]) <dawn.json-path> <output-directory>")
			exit(1)
		}

		let dawnJsonPath = arguments[1]
		let outputWrappersPath = arguments[2]

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

		let wrappers: [String: String]
		do {
			wrappers = try dawnData.generateWrappers()
		} catch {
			print("Failed to generate wrappers: \(error)")
			exit(1)
		}

		do {
			for (key, value) in wrappers {
				let url = URL(fileURLWithPath: outputWrappersPath).appendingPathComponent("\(key).swift")
				try value.write(to: url, atomically: true, encoding: .utf8)
			}
		} catch {
			print("Failed to write to \(outputWrappersPath): \(error)")
			exit(1)
		}

		print("Processing complete!")

		// dawnData.printStats()
	}
}
