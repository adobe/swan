// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

/// Dawn's JSON file uses names where the parts are separated by spaces.
/// This struct represents such a name and provides methods to convert it to
/// various formats needed for the apinotes file.
public struct Name: Hashable, Decodable, Equatable, Sendable, Comparable {
	public let parts: [String]

	public init(_ name: String) {
		var parts = name.split(separator: " ").map { String($0) }
		if parts.count == 1 && parts[0].last == "T" {
			parts[0] = String(parts[0].dropLast()) + "_t"
		}
		self.parts = parts
	}

	public init(parts: [String]) {
		self.parts = parts
	}

	/// The name in camelCase, e.g. "getLimits" in "getLimits"
	public var camelCase: String {
		parts.enumerated().map { index, part in
			if index == 0 {
				return part
			} else {
				return part.prefix(1).uppercased() + part.dropFirst()
			}
		}.joined()
	}

	/// The name in camelCase as legal Swift identifier, e.g. "getLimits" in "getLimits"
	///
	/// If the first character is a number, it is prefixed with an underscore.
	public var camelCaseIdentifier: String {
		let result = parts.enumerated().map { index, part in
			if index == 0 {
				return part
			} else {
				return part.prefix(1).uppercased() + part.dropFirst()
			}
		}.joined()
		if result.first?.isNumber ?? false {
			return "_" + result
		}
		return result
	}

	/// The name in CamelCase, e.g. "GetLimits" in "getLimits"
	public var CamelCase: String {
		parts.map { part in
			return part.prefix(1).uppercased() + part.dropFirst()
		}.joined()
	}

	/// The name in CamelCase as legal Swift identifier, e.g. "GetLimits" in "getLimits"
	///
	/// If the first character is a number, it is prefixed with an underscore.
	public var CamelCaseIdentifier: String {
		let result = parts.map { part in
			return part.prefix(1).uppercased() + part.dropFirst()
		}.joined()
		if result.first?.isNumber ?? false {
			return "_" + result
		}
		return result
	}

	public var raw: String {
		parts.joined(separator: " ")
	}

	/// The last part of the name, e.g. "Limits" in "getLimits"
	public var lastPart: String {
		parts.last!
	}

	/// The first part of the name, e.g. "get" in "getLimits"
	public var firstPart: String {
		parts.first!
	}

	/// The number of parts in the name, e.g. 2 in "getLimits"
	public var count: Int {
		parts.count
	}

	/// The name from the given index to the end, e.g. "Limits" in "getLimits"
	public func subName(from: Int) -> Name {
		Name(parts: Array(parts[from...]))
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(String.self)
		self.init(value)
	}

	public static func < (lhs: Name, rhs: Name) -> Bool {
		return lhs.raw < rhs.raw
	}
}
