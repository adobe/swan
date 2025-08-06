// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

/// Dawn's JSON file uses names where the parts are separated by spaces.
/// This struct represents such a name and provides methods to convert it to
/// various formats needed for the apinotes file.
struct Name: Hashable, Decodable {
	let parts: [String]

	init(_ name: String) {
		self.parts = name.split(separator: " ").map { String($0) }
	}

	init(parts: [String]) {
		self.parts = parts
	}

	/// The name in camelCase, e.g. "getLimits" in "getLimits"
	var camelCase: String {
		parts.enumerated().map { index, part in
			if index == 0 {
				return part
			} else {
				return part.prefix(1).uppercased() + part.dropFirst()
			}
		}.joined()
	}

	/// The name in CamelCase, e.g. "GetLimits" in "getLimits"
	var CamelCase: String {
		parts.map { part in
			return part.prefix(1).uppercased() + part.dropFirst()
		}.joined()
	}

	/// The last part of the name, e.g. "Limits" in "getLimits"
	var lastPart: String {
		parts.last!
	}

	/// The first part of the name, e.g. "get" in "getLimits"
	var firstPart: String {
		parts.first!
	}

	/// The name from the given index to the end, e.g. "Limits" in "getLimits"
	func subName(from: Int) -> Name {
		Name(parts: Array(parts[from...]))
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(String.self)
		self.init(value)
	}
}
