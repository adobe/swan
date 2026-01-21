// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
import DawnData

/// A single API note for and apinotes YAML file
@dynamicMemberLookup
struct APINote {
	enum Category {
		case tag
		case typedef
		case function
		case global
		case enumerator

		var description: String {
			switch self {
			case .tag:
				return "Tags"
			case .typedef:
				return "Typedefs"
			case .function:
				return "Functions"
			case .global:
				return "Globals"
			case .enumerator:
				return "Enumerators"
			}
		}
	}

	let category: Category
	let name: String
	var values: [String: String]

	init(category: Category, name: String, values: [String: String]) {
		self.category = category
		self.name = name
		self.values = values
	}

	subscript(dynamicMember member: String) -> String? {
		get {
			return values[member]
		}
		set {
			values[member] = newValue
		}
	}

	func description() -> String {
		let sortedValues = values.sorted { $0.key < $1.key }
		let valueStrings = sortedValues.map { "  \($0.key): \($0.value)" }.joined(separator: "\n")
		return """
			- Name: \(name)
			\(valueStrings)
			"""
	}
}

extension DawnData {
	func apiNotes() -> [APINote] {
		var apinotes: [APINote] = []
		for (name, entity) in data {
			apinotes.append(contentsOf: entity.apiNotesWithName(name, data: self))
		}
		return apinotes
	}
}

extension DawnEnum {
	func apiNotesWithName(_ name: Name) -> [APINote] {
		var notes: [APINote] = [
			APINote(
				category: .tag,
				name: "WGPU\(name.CamelCase)",
				values: [
					"EnumExtensibility": "closed"
				]
			)
		]
		for value in values {
			notes.append(
				APINote(
					category: .enumerator,
					name: "WGPU\(name.CamelCase)_\(value.name.CamelCase)",
					values: [
						"SwiftName": value.name.camelCaseIdentifier
					]
				)
			)
		}
		return notes
	}
}

extension DawnStructure {
	func apiNotesWithName(_ name: Name) -> [APINote] {
		return []
	}
}

extension DawnObject {
	func apiNotesWithName(_ name: Name, data: DawnData) -> [APINote] {
		let objectName = "WGPU\(name.CamelCase)Impl"
		let methodNotes: [APINote] = methods.flatMap { method in
			return method.apiNotesWithObjectName(name, data: data)
		}
		return [
			APINote(
				category: .tag,
				name: objectName,
				values: [
					"SwiftImportAs": "reference",
					"SwiftReleaseOp": "wgpu\(name.CamelCase)Release",
					"SwiftRetainOp": "wgpu\(name.CamelCase)AddRef",
				]
			),
			APINote(
				category: .function,
				name: "wgpu\(name.CamelCase)AddRef",
				values: [
					"SwiftName": "\(objectName).addRef(self:)"
				]
			),
			APINote(
				category: .function,
				name: "wgpu\(name.CamelCase)Release",
				values: [
					"SwiftName": "\(objectName).release(self:)"
				]
			),
		] + methodNotes
	}
}

extension DawnMethod {

	func returnsObject(data: DawnData) -> Bool {
		if let returns = returns {
			if let dawnEntity = data.data[returns.type], case .object = dawnEntity {
				return true
			}
			return false
		}
		return false
	}

	func apiNotesWithObjectName(_ objectName: Name, data: DawnData) -> [APINote] {
		let functionName = "wgpu\(objectName.CamelCase)\(name.CamelCase)"
		let argumentsString: String
		if let args = args, args.count > 0 {
			let argumentLabels = args.map { $0.name.camelCase }
			argumentsString = argumentLabels.joined(separator: ":") + ":"
		} else {
			argumentsString = ""
		}

		// Methods acting as getters are special-cased.
		if args == nil && name.firstPart == "get" {
			let subName = name.subName(from: 1)
			return [
				APINote(
					category: .function,
					name: functionName,
					values: [
						"SwiftName": "getter:WGPU\(objectName.CamelCase)Impl.\(subName.camelCase)(self:)"
					]
				)
			]
		}

		// Treat all other functions as normal.
		var values: [String: String] = [
			"SwiftName": "WGPU\(objectName.CamelCase)Impl.\(name.camelCase)(self:\(argumentsString))"
		]
		if returnsObject(data: data) {
			values["SwiftReturnOwnership"] = "retained"
		}
		return [
			APINote(
				category: .function,
				name: functionName,
				values: values
			)
		]
	}
}

extension DawnFunction {
	func apiNotesWithName(_ name: Name, data: DawnData) -> [APINote] {
		let argumentLabels = args.map { $0.name.camelCase }
		let argumentsString = argumentLabels.joined(separator: ":") + ":"

		if name.firstPart == "create" {
			let objectName = name.subName(from: 1)
			if let entity = data.data[objectName], case .object = entity {
				/// This is a special case for init functions
				return [
					APINote(
						category: .function,
						name: "wgpu\(name.CamelCase)",
						values: [
							"SwiftReturnOwnership": "retained",
							"SwiftName": "WGPU\(objectName.CamelCase)Impl.init(\(argumentsString))",
						]
					)
				]
			}
		}
		return []
	}
}

extension DawnBitmask {
	func apiNotesWithName(_ name: Name) -> [APINote] {
		let bitmaskName = "WGPU\(name.CamelCase)"
		return [
			APINote(
				category: .typedef,
				name: bitmaskName,
				values: [
					"SwiftWrapper": "struct",
					"SwiftConformsTo": "Swift.OptionSet",
				]
			)
		]
			+ values.map { value in
				APINote(
					category: .global,
					name: "\(bitmaskName)_\(value.name.CamelCase)",
					values: [
						"SwiftName": "\(bitmaskName).\(value.name.camelCase)"
					]
				)
			}
	}
}

extension DawnEntity {
	func apiNotesWithName(_ name: Name, data: DawnData) -> [APINote] {
		switch self {
		case .enum(let `enum`):
			return `enum`.apiNotesWithName(name)
		case .object(let object):
			return object.apiNotesWithName(name, data: data)
		case .function(let function):
			return function.apiNotesWithName(name, data: data)
		case .bitmask(let bitmask):
			return bitmask.apiNotesWithName(name)
		default:
			return []
		}
	}
}

/// Generate a text representation of the API notes.
func yamlFromAPINotes(_ apinotes: [APINote]) -> String {
	var text = "---\nName: DawnC\n"
	var notesByCategory: [APINote.Category: [APINote]] = [:]
	for apinote in apinotes {
		notesByCategory[apinote.category, default: []].append(apinote)
	}

	let sortedCategories = notesByCategory.keys.sorted { $0.description < $1.description }
	for category in sortedCategories {
		let notes = notesByCategory[category]!
		if notes.isEmpty {
			continue
		}
		let categoryText = category.description
		let notesText = notes.map { $0.description() }.joined(separator: "\n")
		text += """
			\(categoryText):
			\(notesText)\n
			"""
	}
	return text
}
