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
				// Native types with a length are wrapped (Tuple for fixed-size, Array for dynamic-size, UnsafeRawBufferPointer for void*).
				return length != nil
			default:
				return false
			}
		}
		// Special case for string arrays.
		if type.raw == "char" && annotation == "const*const*" {
			return true
		}
		return isWrapped
	}

	/// Returns true if the Swift type for this descriptor includes the collection length.
	///
	/// When true, the corresponding size parameter in the C API can be derived from the Swift
	/// collection (e.g., `array.count`), so it should be excluded from the Swift API signature.
	func includesArrayLength() -> Bool {
		guard case .name = length else {
			// For Arrays, length will be the name of another arg.
			return false
		}
		return true
	}

	/// Returns true if this descriptor represents a void* array (raw buffer pointer type).
	/// These use UnsafeRawBufferPointer in the Swift API.
	func isRawBufferPointerType() -> Bool {
		return type.raw == "void" && annotation == "const*" && length != nil
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

/// A TypeDescriptor that also has a name, used for function arguments and structure members.
protocol NamedTypeDescriptor: TypeDescriptor {
	var name: Name { get }
}

/// Check if the given item is a size item for an array item in the list.
///
/// A size item has a "name" that matches the "length" field of another item that is an array.
/// Example from dawn.json:
/// "members": [
/// 	{"name": "entry count", "type": "size_t"},
/// 	{"name": "entries", "type": "bind group layout entry", "annotation": "const*", "length": "entry count"}
/// ]
/// The second item will have an array type, and its "length" field matches the first item's name.
func isArraySizeItem(_ item: any NamedTypeDescriptor, allItems: [any NamedTypeDescriptor]) -> Bool {
	return allItems.contains { otherItem in
		if case .name(let lengthName) = otherItem.length {
			return lengthName == item.name
		}
		return false
	}
}

/// If the given item is a size item, return the array item for which it provides the size.
func arrayForSizeItem(
	_ sizeItem: any NamedTypeDescriptor,
	allItems: [any NamedTypeDescriptor]
) -> (any NamedTypeDescriptor)? {
	guard isArraySizeItem(sizeItem, allItems: allItems) else {
		return nil
	}
	return allItems.first { item in
		if case .name(let lengthName) = item.length {
			return lengthName == sizeItem.name
		}
		return false
	}
}

/// Convert an array count expression to match the C parameter type, if needed.
/// E.g. Array.count returns Int, but some Dawn APIs use uint32_t or uint64_t for size params.
func castCountIfNeeded(_ countExpr: String, forParameterType type: Name) -> String {
	switch type.raw {
	case "size_t":
		// size_t maps to Int, which matches Array.count - no conversion needed
		return countExpr
	case "uint32_t":
		return "UInt32(\(countExpr))"
	case "uint64_t":
		return "UInt64(\(countExpr))"
	default:
		fatalError("Unexpected size parameter type: \(type.raw)")
	}
}

/// Generates let statements that extract array sizes from Swift collections.
///
/// The Dawn C API requires separate size items for array items, but Swift collections
/// include their size via `.count`. This function generates the size extraction code needed to bridge
/// between these conventions.
///
/// For `UnsafeRawBufferPointer` types (void* arrays), this also extracts the `baseAddress`.
func generateArraySizeExtractions(
	items: [any NamedTypeDescriptor],
	data: DawnData
) -> CodeBlockItemListSyntax {
	return CodeBlockItemListSyntax {
		for item in items where isArraySizeItem(item, allItems: items) {
			if let array = arrayForSizeItem(item, allItems: items) {
				let swiftType = array.swiftTypeName(data: data)
				let arrayName = array.name.camelCase
				let sizeName = item.name.camelCase
				let isOptional = swiftType.hasSuffix("?")

				let countExpr = isOptional ? "\(arrayName)?.count ?? 0" : "\(arrayName).count"
				let convertedCountExpr = castCountIfNeeded(countExpr, forParameterType: item.type)

				"let \(raw: sizeName) = \(raw: convertedCountExpr)"

				if array.isRawBufferPointerType() {
					// For UnsafeRawBufferPointer, also extract baseAddress
					let baseAddressExpr = isOptional ? "\(arrayName)?.baseAddress" : "\(arrayName).baseAddress"
					"let \(raw: arrayName) = \(raw: baseAddressExpr)"
				}
			}
		}
	}
}
