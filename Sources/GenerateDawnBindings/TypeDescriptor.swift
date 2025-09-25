// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

protocol TypeDescriptor {
	var type: Name { get }
	var optional: Bool { get }
	var `default`: DawnDefaultValue? { get }
	var annotation: String? { get }
	var length: ArraySize? { get }

	func isWrappedType(data: DawnData) -> Bool
	func swiftTypeName(data: DawnData) -> String
	func unwrapValueWithIdentifier(_ identifier: String, data: DawnData, expression: ExprSyntax) -> ExprSyntax
	func wrapValueWithIdentifier(_ identifier: String, data: DawnData) -> ExprSyntax
}

/// A record that describe the usage of a type.
extension TypeDescriptor {
	// Check if this type is wrapped.
	func isWrappedType(data: DawnData) -> Bool {
		let dawnEntity: DawnEntity? = data.data[type]
		if dawnEntity == nil {
			return false
		}
		let isWrapped = dawnEntity!.isWrappedType(name: type, data: data)
		if !isWrapped && annotation == "const*" {
			switch dawnEntity {
			case .structure:
				// Even a normally unwrapped structures needs to be wrapped if we are to get a pointer to it.
				return true
			case .object, .enum:
				assert(length != nil)
				// Arrays of objects need to be wrapped if we are to get a pointer to the array.
				return true
			case .native:
				if length != nil {
					if type.raw == "void" || type.raw == "uint8_t" {
						return false
					}
					return true
				}
				return false
			default:
				return false
			}
		}
		return isWrapped
	}

	// The name of the wrapper type.
	func swiftTypeName(data: DawnData) -> String {
		let entity: DawnEntity? = data.data[type]
		if entity == nil {
			fatalError("Unknown type: \(type)")
		}
		let optional = optional || (`default`?.isNullPointer ?? false)
		return entity!.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
	}

	func cTypeName(data: DawnData) -> String {
		let entity: DawnEntity? = data.data[type]
		if entity == nil {
			fatalError("Unknown type: \(type)")
		}
		return entity!.cTypeNameForType(type, annotation: annotation, length: length, optional: optional)
	}

	// Code to unwrap a value of a type that is wrapped in order to the Swan API more Swift-like.
	func unwrapValueWithIdentifier(_ identifier: String, data: DawnData, expression: ExprSyntax) -> ExprSyntax {
		let entity: DawnEntity? = data.data[type]
		if entity == nil {
			fatalError("Unknown type: \(type)")
		}
		return entity!.unwrapValueOfType(
			type,
			identifier: identifier,
			annotation: annotation,
			length: length,
			optional: optional,
			data: data,
			expression: expression
		)
	}

	// Code to wrap a value of a type that is wrapped.
	func wrapValueWithIdentifier(_ identifier: String, data: DawnData) -> ExprSyntax {
		if type.raw == "string view" {
			return "String(wgpuStringView: \(raw: identifier))"
		}
		let entity: DawnEntity? = data.data[type]
		guard let entity = entity else {
			fatalError("Unknown type: \(type)")
		}
		return entity.wrapValueOfType(
			type,
			identifier: identifier,
			annotation: annotation,
			length: length,
			optional: optional,
			data: data
		)
	}
}
