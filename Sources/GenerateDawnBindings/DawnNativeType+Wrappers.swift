// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnNativeType: DawnType {
	func isWrappedType(name: Name, data: DawnData) -> Bool {
		if name.raw == "bool" {
			return true
		}
		return false
	}

	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}

	/// The name of the type in the Swan Swift API.
	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool) -> String {
		var numericType: String?

		switch type.raw {
		case "bool": return "Bool"
		case "char":
			guard let annotation = annotation else {
				return "CChar"
			}
			switch annotation {
			case "const*":
				return "UnsafePointer<CChar>"
			case "const*const*":
				return "[String]"
			default:
				fatalError("Unhandled annotation: \(annotation)")
			}
		case "double": numericType = "Double"
		case "float": numericType = "Float"
		case "int": numericType = "Int32"
		case "int16_t": numericType = "Int16"
		case "int32_t": numericType = "Int32"
		case "int64_t": numericType = "Int64"
		case "size_t": numericType = "Int"
		case "uint8_t": numericType = "UInt8"
		case "uint16_t": numericType = "UInt16"
		case "uint32_t": numericType = "UInt32"
		case "uint64_t": numericType = "UInt64"
		case "void":
			switch annotation {
			case "*":
				return "UnsafeMutableRawPointer?"
			case "const*":
				return length != nil ? "UnsafeRawBufferPointer" : "UnsafeRawPointer"
			default:
				return "Void"
			}
		case "void *":
			return "UnsafeMutableRawPointer?"
		case "void const *":
			return "UnsafeRawPointer"
		default:
			fatalError("Unhandled native type: \(type.raw)")
		}
		if var numericType {
			if length != nil {
				if case .int(let count) = length {
					numericType = "(\(Array(repeating: numericType, count: count).joined(separator: ", ")))"
				} else {
					numericType = "[\(numericType)]"
				}
			}
			if optional || annotation == "const*" {
				numericType = "\(numericType)?"
			}
			return numericType
		}
		fatalError("Unhandled native type: \(type.raw)")
	}

	/// The C API name of the type.
	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		switch type.raw {
		case "bool": return "WGPUBool"
		default:
			return type.raw
		}
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		switch type.raw {
		case "bool": return "false"
		case "char":
			if annotation == nil {
				return "0"
			}
			if annotation == "const*const*" {
				return "[]"
			}
			return nil
		case "double": return "0.0"
		case "float":
			if case .int = length {
				return nil  // Tuple types don't have a simple default
			}
			return "0.0"
		case "int": return "0"
		case "int16_t": return "0"
		case "int32_t": return "0"
		case "int64_t": return "0"
		case "size_t": return "0"
		case "uint8_t": return "0"
		case "uint16_t": return "0"
		case "uint32_t": return "0"
		case "uint64_t": return "0"
		case "void", "void *", "void const *":
			return nil
		default:
			return nil
		}
	}

	/// Code to unwrap a value of the type.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax?
	) -> ExprSyntax {
		if (annotation == "*" || annotation == "const*") && type.raw == "void" && length != nil {
			// We wrap void arrays in UnsafeRawBufferPointer. Both count and baseAddress are extracted in
			// generateArraySizeExtractions, so just pass through the expression.
			return expression ?? ""
		}
		if length != nil {
			return
				"""
				withWGPUArrayPointer(\(raw: identifier)) { \(raw: identifier) in
					\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
				}
				"""
		}
		if annotation != nil {
			fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with annotation \(annotation!)")
		}
		switch type.raw {
		case "size_t", "int8_t", "int16_t", "int32_t", "int64_t", "uint8_t", "uint16_t", "uint32_t", "uint64_t", "float", "double",
			"void *",
			"void const *":
			return expression ?? ""
		case "bool":
			return
				"""
				{
					let \(raw: identifier): WGPUBool = \(raw: identifier) ? 1 : 0
					return \(expression ?? "")
				}()
				"""
		default:
			fatalError("Unimplemented unwrapValueOfType for type \(type.raw)")
		}
	}

	// Code to wrap a value of a WGPU native type into the appropriate Swift type.
	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		switch type.raw {
		case "bool":
			return "Bool(\(raw: identifier) != 0)"
		case "char":
			if annotation == nil {
				return "CChar(\(raw: identifier))"
			}
			switch annotation {
			case "const*":
				return "UnsafePointer<CChar>(\(raw: identifier))"
			case "const*const*":
				return "UnsafePointer<UnsafePointer<CChar>>(\(raw: identifier))"
			default:
				fatalError("Unhandled annotation: \(annotation!)")
			}
		case "float", "uint64_t", "uint32_t":
			if annotation == nil {
				return "\(raw: identifier)"
			}
			if length == nil {
				fatalError("Unimplemented wrap for type \(type.raw)")
			}
			if case .int(let count) = length! {
				// TODO: Implement wrap for float arrays.
				// fatalError("Unimplemented wrap for float arrays \(type.raw)")
				return "\(raw: identifier).wrapTuple\(raw: count)()"
			} else if case .name = length! {
				let parentIdentifier: String = identifier.split(separator: ".").dropLast().joined(separator: ".")
				return "\(raw: identifier).wrapArrayWithCount(\(raw: length!.sizeWithIdentifier(parentIdentifier)))"
			}
		case "void *":
			return "\(raw: identifier)!"
		default:
			assert(annotation == nil)
			assert(length == nil)
			return "\(raw: identifier)"
		}
		fatalError("Unimplemented wrap for type \(type.raw)")
	}
}
