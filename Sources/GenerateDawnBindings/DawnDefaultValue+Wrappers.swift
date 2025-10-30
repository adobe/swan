// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData

extension DawnDefaultValue {
	// Get the default value for a type as represented by this default value record
	func defaultValueForType(_ type: Name, data: DawnData) throws -> String {
		let floatRegex = /^(\d+)\.f$/

		switch self {
		case .double(let value):
			return String(value)
		case .int(let value):
			return String(value)
		case .name(let name):
			// Check if this is a constant value.
			let valueType = data.data[name]
			if case .constant(let constant) = valueType {
				guard let value = constantMap[constant.value] else {
					throw SwiftTypeNameError.unknownConstant(constant.value)
				}
				return value
			}

			let dawnType = data.data[type]
			if dawnType == nil {
				throw SwiftTypeNameError.unknownTypeName(type)
			}
			switch dawnType {
			case .enum(let enumValue):
				guard enumValue.values.contains(where: { $0.name == name }) else {
					throw SwiftTypeNameError.unknownEnumValue(name)
				}
				return ".\(name.camelCaseIdentifier)"
			case .constant(let constant):
				guard let value = constantMap[constant.value] else {
					throw SwiftTypeNameError.unknownConstant(constant.value)
				}
				return value
			case .bitmask:
				return "[.\(name.camelCaseIdentifier)]"
			case .native:
				switch type.raw {
				case "float", "double":
					if let match = try? floatRegex.firstMatch(in: name.raw) {
						return "\(match.1).0"
					}
				default:
					return name.raw
				}
			default:
				let valueName = name.raw
				// Check if this is a float value encoded as a string.
				do {
					if let match = try floatRegex.firstMatch(in: valueName) {
						return String(match.1)
					}
				} catch {
					// Ignore the error.
				}

				if valueName == "zero" {
					// There is a strange case where structures have a "zero" default value.
					// This seems to mean that the first member of the structure is an enum which
					// should be set to the enum member which has the value 0.
					if case .structure(let structure) = dawnType {
						if let firstMember = structure.members.first {
							let memberType = data.data[firstMember.type]
							if case .enum(let enumValue) = memberType {
								if let value = enumValue.values.first(where: { $0.value == 0 }) {
									return
										"GPU\(type.CamelCase)(\(firstMember.name.camelCase): .\(value.name.camelCaseIdentifier))"
								}
							}
						}
					}
					return "0"
				} else if valueName == "nullptr" {
					return "nil"
				}

				// For most types, we just return the value from the dawn.json file as a
				// string.
				return String(name.raw)
			}
		}
		throw SwiftTypeNameError.unhandledNativeType(type.raw)
	}
}
