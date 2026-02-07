// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnStructureMember: NamedTypeDescriptor {

	func getMemberInfo(data: DawnData) throws -> (name: String, swiftType: String, defaultValue: String?) {
		var defaultString: String? = nil
		let isArray = if case .name = length { true } else { false }
		let isTuple = if case .int(let count) = length { count > 1 } else { false }

		if optional || isTuple {
			defaultString = "nil"
		} else if isArray && annotation != "const*const*" {
			defaultString = "[]"
		} else if let defaultValue = `default` {
			// There is a default value record for this member in the dawn.json file.
			defaultString = try defaultValue.defaultValueForType(type, data: data)
		} else {
			// Fall back to the type's default value
			let entity = data.data[type]
			if let entity = entity {
				defaultString = entity.defaultValue(type, annotation: annotation, length: length)
			}
		}

		let swiftType = swiftTypeName(data: data)
		return (
			name: self.name.camelCase, swiftType: swiftType,
			defaultValue: defaultString
		)
	}

	func declarations(data: DawnData) throws -> [any DeclSyntaxProtocol] {
		let memberInfo = try getMemberInfo(data: data)

		return [
			DeclSyntax(
				"public var \(raw: memberInfo.name): \(raw: memberInfo.swiftType)"  // \(memberInfo.defaultValue != nil ? " = \(raw: memberInfo.defaultValue!)" : "")"
			)
		]
	}

	// The name of the wrapper type.
	func swiftTypeName(data: DawnData) -> String {
		let entity = data.data[type]
		if entity == nil {
			fatalError("Unknown type: \(type)")
		}
		return entity!.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
	}
}
