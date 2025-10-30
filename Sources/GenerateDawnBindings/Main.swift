// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import ArgumentParser
import DawnData
import Foundation
import SwiftFormat

@main
struct Main: ParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "generate-dawn-bindings",
		abstract: "Generate Swift wrapper bindings from dawn.json"
	)

	@Option(name: .long, help: "Path to the dawn.json file")
	var dawnJson: String

	@Option(name: .long, help: "Directory to write the generated Swift files")
	var outputDirectory: String

	@Option(name: .long, help: "Path to the swift-format configuration file")
	var swiftFormatConfig: String?

	mutating func run() throws {
		guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: dawnJson)) else {
			throw ValidationError("Failed to read file at \(dawnJson)")
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let dawnData: DawnData
		do {
			dawnData = try decoder.decode(DawnData.self, from: jsonData)
		} catch {
			throw ValidationError("Failed to decode dawn.json: \(error)")
		}

		let swiftFormatConfiguration: Configuration?
		if let swiftFormatConfig {
			let swiftFormatConfigData = try Data(contentsOf: URL(fileURLWithPath: swiftFormatConfig))
			swiftFormatConfiguration = try JSONDecoder().decode(Configuration.self, from: swiftFormatConfigData)
		} else {
			swiftFormatConfiguration = nil
		}

		let wrappers: [String: String]
		do {
			wrappers = try dawnData.generateWrappers(swiftFormatConfiguration: swiftFormatConfiguration)
		} catch {
			throw ValidationError("Failed to generate wrappers: \(error)")
		}

		do {
			for (key, value) in wrappers {
				let url = URL(fileURLWithPath: outputDirectory).appendingPathComponent("\(key).swift")
				try value.write(to: url, atomically: true, encoding: .utf8)
			}
		} catch {
			throw ValidationError("Failed to write to \(outputDirectory): \(error)")
		}

		print("Processing complete!")
	}
}
