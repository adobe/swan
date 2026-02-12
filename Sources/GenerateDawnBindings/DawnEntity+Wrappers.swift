// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnEntity: DawnType {
	func isWrappedType(name: Name, data: DawnData) -> Bool {
		switch self {
		case .callbackInfo, .callbackFunction:
			return true
		case .structure(let structure):
			return structure.isWrappedType(name, data: data)
		case .native(let native):
			return native.isWrappedType(name: name, data: data)
		default:
			return false
		}
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool) -> String {
		switch self {
		case .callbackInfo(let callbackInfo):
			return callbackInfo.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .native(let native):
			return native.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .object(let object):
			return object.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .structure(let structure):
			return structure.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .functionPointer(let functionPointer):
			return functionPointer.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .enum, .bitmask:
			var type = "\(type.swiftTypePrefix())\(type.CamelCase)"
			if length != nil {
				type = "[\(type)]"
			}
			if optional {
				type = "\(type)?"
			}
			return type
		default:
			fatalError("Unhandled type: \(self)")
		}
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		switch self {
		case .callbackInfo(let callbackInfo):
			return callbackInfo.cTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .native(let native):
			return native.cTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .object(let object):
			return object.cTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .structure(let structure):
			return structure.cTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .enum, .bitmask:
			return "WGPU\(type.CamelCase)"
		default:
			fatalError("Unhandled type: \(self)")
		}
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		switch self {
		case .callbackInfo(let callbackInfo):
			return callbackInfo.defaultValue(type, annotation: annotation, length: length)
		case .native(let native):
			return native.defaultValue(type, annotation: annotation, length: length)
		case .object(let object):
			return object.defaultValue(type, annotation: annotation, length: length)
		case .structure(let structure):
			return structure.defaultValue(type, annotation: annotation, length: length)
		case .functionPointer(let functionPointer):
			return functionPointer.defaultValue(type, annotation: annotation, length: length)
		case .bitmask:
			return "\(type.swiftTypePrefix())\(type.CamelCase)()"
		case .enum(let enumValue):
			return ".\(enumValue.values.first!.name.camelCaseIdentifier)"
		default:
			return nil
		}
	}

	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax?
	) -> ExprSyntax {
		switch self {
		case .callbackFunction(let callbackFunction):
			return callbackFunction.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .callbackInfo(let callbackInfo):
			return callbackInfo.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .native(let native):
			return native.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .object(let object):
			return object.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .structure(let structure):
			return structure.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .enum(let enumValue):
			return enumValue.unwrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data,
				expression: expression
			)
		case .bitmask:
			// Pass through the expression for enums.
			return expression ?? ""
		default:
			fatalError("Unhandled type: \(self)")
		}
	}

	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		switch self {
		case .callbackInfo(let callbackInfo):
			return callbackInfo.wrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data
			)
		case .object(let object):
			return object.wrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data
			)
		case .native(let native):
			return native.wrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data
			)
		case .structure(let structure):
			return structure.wrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data
			)
		case .enum(let enumValue):
			return enumValue.wrapValueOfType(
				type,
				identifier: identifier,
				annotation: annotation,
				length: length,
				optional: optional,
				data: data
			)
		default:
			fatalError("Unhandled type: \(self)")
		}
	}
}
