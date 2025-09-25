// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import Logging
import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder

class TabFormat: BasicFormat {
	public init(initialIndentation: Trivia = .tab) {
		super.init(indentationWidth: .tab, initialIndentation: initialIndentation)
	}
}

let constantMap = [
	"UINT64_MAX": "UInt64.max",
	"UINT32_MAX": "UInt32.max",
	"NAN": "Float.nan",
	"SIZE_MAX": "Int.max",
]

let nativeTypeMap: [String: String] = [
	"size_t": "Int"
]

enum SwiftTypeNameError: Error {
	case unknownTypeName(Name)
	case unhandledEntityType(String)
	case unhandledNativeType(String)
	case unhandledAnnotation(String)
	case unhandledEnumDefault(Name)
	case unknownEnumValue(Name)
	case unknownConstant(String)
}

/// A record that describes a Dawn C type.
protocol DawnType {
	/// The name of the type in the Swan Swift API.
	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String

	/// The C API name of the type.
	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String

	/// Code to unwrap a value of the type.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax

	/// Code to wrap a value of the type.
	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
	) -> ExprSyntax
}

extension DawnData {

	/// Generate the Swift wrappers for the Dawn data.
	///
	/// For each entity, we generate any Swift wrappers that are needed to make the API
	/// comfortable to use from Swift
	/// - Throws: An error if generation of wrappers fails
	/// - Returns: A dictionary of file names -> swift code
	func generateWrappers() throws -> [String: String] {
		var aliasDecls: [any DeclSyntaxProtocol] = []
		var bitmaskDecls: [any DeclSyntaxProtocol] = []
		var callbackFunctionDecls: [any DeclSyntaxProtocol] = []
		var callbackInfoDecls: [any DeclSyntaxProtocol] = []
		var constantDecls: [any DeclSyntaxProtocol] = []
		var enumDecls: [any DeclSyntaxProtocol] = []
		var functionDecls: [any DeclSyntaxProtocol] = []
		var functionPointerDecls: [any DeclSyntaxProtocol] = []
		var nativeDecls: [any DeclSyntaxProtocol] = []
		var objectDecls: [any DeclSyntaxProtocol] = []
		var result: [String: String] = [:]
		var structureDecls: [any DeclSyntaxProtocol] = []

		let wrappableStructures = structuredRequiringWrapping()

		let entityNames = data.keys.sorted()
		for name in entityNames {
			let entity = data[name]!
			// Skip emscripten definitions
			if entity.hasTag("emscripten") {
				continue
			}

			switch entity {
			case .alias(let alias):
				aliasDecls.append(contentsOf: try alias.declarations(name: name, data: self))
			case .bitmask(let bitmask):
				bitmaskDecls.append(contentsOf: try bitmask.declarations(name: name, data: self))
			case .callbackFunction(let callbackFunction):
				callbackFunctionDecls.append(contentsOf: try callbackFunction.declarations(name: name, data: self))
			case .callbackInfo(let callbackInfo):
				callbackInfoDecls.append(contentsOf: try callbackInfo.declarations(name: name, data: self))
			case .constant(let constant):
				constantDecls.append(contentsOf: try constant.declarations(name: name, data: self))
			case .enum(let `enum`):
				enumDecls.append(contentsOf: try `enum`.declarations(name: name, data: self))
			case .function(let function):
				functionDecls.append(contentsOf: try function.declarations(name: name, data: self))
			case .functionPointer(let functionPointer):
				functionPointerDecls.append(contentsOf: try functionPointer.declarations(name: name, data: self))
			case .native(let native):
				nativeDecls.append(contentsOf: try native.declarations(name: name, data: self))
			case .object(let object):
				objectDecls.append(contentsOf: try object.declarations(name: name, data: self))
			case .structure(let structure):
				structureDecls.append(
					contentsOf: try structure.declarations(
						name: name,
						needsWrap: wrappableStructures.contains(name),
						data: self
					)
				)
			}
		}

		if aliasDecls.count > 0 {
			fatalError("Aliases not implemented")
		}
		if bitmaskDecls.count > 0 {
			result["Bitmasks"] = bitmaskDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if callbackFunctionDecls.count > 0 {
			result["CallbackFunctions"] = callbackFunctionDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if callbackInfoDecls.count > 0 {
			result["CallbackInfo"] = callbackInfoDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if constantDecls.count > 0 {
			fatalError("Constants not implemented")
		}
		if enumDecls.count > 0 {
			result["Enums"] = enumDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if functionDecls.count > 0 {
			fatalError("Functions not implemented")
		}
		if functionPointerDecls.count > 0 {
			result["FunctionPointers"] = functionPointerDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if nativeDecls.count > 0 {
			fatalError("NativeTypes not implemented")
		}
		if objectDecls.count > 0 {
			result["Objects"] = objectDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		if structureDecls.count > 0 {
			result["Structures"] = structureDecls.map { $0.formatted().description }.joined(separator: "\n\n")
		}
		return result
	}

	/// Get the set of structure names used in returns or passed as a mutable pointer.
	///
	/// This is used to determine which structures to support being wrapped back into Swift API types.
	/// - Returns: A set of structure names
	func structuredRequiringWrapping() -> Set<Name> {
		var structureNames: Set<Name> = []

		// Iterate over all entities in the data
		for (_, entity) in data {
			switch entity {
			case .function(let function):
				// Check function arguments for structure types
				addArgumentStructures(arguments: function.args, structureNames: &structureNames)

				// Check function return type for structure types
				if let returnType = function.returns,
					let structureEntity = data[returnType],
					case .structure = structureEntity
				{
					structureNames.insert(returnType)
				}
			case .object(let object):
				// Check object methods for structure types
				for method in object.methods {
					// Check method arguments for structure types
					if let args = method.args {
						addArgumentStructures(arguments: args, structureNames: &structureNames)
					}

					// Check method return type for structure types
					if let returnType = method.returns,
						let structureEntity = data[returnType.type],
						case .structure = structureEntity
					{
						structureNames.insert(returnType.type)
					}
				}
			case .functionPointer(let functionPointer):
				// Check method arguments for structure types
				addArgumentStructures(arguments: functionPointer.args, structureNames: &structureNames)

				// Check function pointer return type for structure types
				if let returnType = functionPointer.returns,
					let structureEntity = data[returnType],
					case .structure = structureEntity
				{
					structureNames.insert(returnType)
				}
			default:
				// Skip other entity types
				break
			}
		}

		func addArgumentStructures(arguments: [DawnFunctionArgument], structureNames: inout Set<Name>) {
			for argument in arguments {
				if let structureEntity = data[argument.type],
					case .structure = structureEntity,
					argument.annotation == "*"
				{
					structureNames.insert(argument.type)
				}
			}
		}

		func addMemberStructures(name: Name, structureNames: inout Set<Name>) {
			guard let entity = data[name] else {
				fatalError("Unknown entity: \(name)")
			}
			if case .structure(let structure) = entity {
				for member in structure.members {
					if let memberEntity = data[member.type],
						case .structure = memberEntity
					{
						if !structureNames.contains(member.type) {
							structureNames.insert(member.type)
							addMemberStructures(name: member.type, structureNames: &structureNames)
						}
					}
				}
			}
		}

		for name in structureNames {
			addMemberStructures(name: name, structureNames: &structureNames)
		}

		return structureNames
	}
}

extension DawnEntity: DawnType {
	func isWrappedType(name: Name, data: DawnData) -> Bool {
		switch self {
		case .callbackInfo:
			return true
		case .structure(let structure):
			return structure.isWrappedType(name, data: data)
		case .native(let native):
			return native.isWrappedType(name: name, data: data)
		default:
			return false
		}
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		switch self {
		case .callbackInfo(let callbackInfo):
			return callbackInfo.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .native(let native):
			return native.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .object(let object):
			return object.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .structure(let structure):
			return structure.swiftTypeNameForType(type, annotation: annotation, length: length, optional: optional)
		case .enum, .bitmask:
			return "GPU\(type.CamelCase)"
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

	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax {
		switch self {
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
		case .enum, .bitmask:
			// Pass through the expression for enums.
			return expression
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
		data: DawnData,
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

extension DawnAlias {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}
}

extension DawnBitmask {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
	}
}

/// Generate a typealias for a callback function using wrapped types for the arguments.
extension DawnCallbackFunction {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		let argumentTypes = args.map { arg in
			"\(arg.swiftTypeName(data: data))"
		}

		return [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = (\(raw: argumentTypes.joined(separator: ", "))) -> Void")
		]
	}
}

extension DawnCallbackInfo: DawnType {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		let cStructName: String = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		let callbackMember: DawnStructureMember? = members.first { $0.name.raw == "callback" }
		guard let callbackMember = callbackMember else {
			fatalError("Callback info must have a callback member")
		}

		let swiftCallbackFunctionName = "GPU\(callbackMember.type.CamelCase)"

		// TODO: Need to add lambda wrapper for callback function in applyPropertiesToWGPUStruct
		return [
			DeclSyntax("extension \(raw: cStructName): WGPUStruct {}"),
			DeclSyntax(
				"""
				public struct \(raw: swiftStructName): GPUStruct {
					public typealias WGPUType = \(raw: cStructName)

					\(raw: hasModeProperty ? "public let mode: GPUCallbackMode" : "")
					public let callback: \(raw: swiftCallbackFunctionName)

					public init(\(raw: hasModeProperty ? "mode: GPUCallbackMode = .waitAnyOnly, " : "")callback: @escaping \(raw: swiftCallbackFunctionName)) {
						\(raw: hasModeProperty ? "self.mode = mode" : "")
						self.callback = callback
					}

					public func applyPropertiesToWGPUStruct<R>(
						_ wgpuStruct: inout \(raw: cStructName),
						_ lambda: (UnsafeMutablePointer<\(raw: cStructName)>) -> R
					) -> R {
						\(raw: hasModeProperty ? "wgpuStruct.mode = mode" : "")
						return lambda(&wgpuStruct)
					}
				}
				"""
			),
		]
	}

	var hasModeProperty: Bool {
		return members.contains { $0.name.raw == "mode" }
	}

	/// Unwrap a callback function wrapper to get a callback function compatible with the WGPU API.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax {
		return """
			\(raw: identifier).withWGPUStruct { _\(raw: identifier) in
				let \(raw: identifier) = _\(raw: identifier).pointee
				return \(raw: expression.indented(by: Trivia.tab).formatted().description)
			}
			"""
	}

	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		fatalError("Unimplemented wrapValueOfType for type \(type.raw)")
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		var name = "GPU\(type.CamelCase)"
		if length != nil {
			if case .name = length {
				name = "[\(name)]"
			} else if case .int = length {
				// For arrays of fixed size, use tuple syntax.
				fatalError("Unimplemented swiftTypeNameForType with numeric length for type \(type.raw)")
			}
		}
		if optional ?? false {
			name = "\(name)?"
		}
		return name
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		fatalError("Unimplemented cTypeNameForType for type \(type.raw)")
	}
}

extension DawnConstant {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}
}

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

extension DawnEnum {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		if hasInvalidIdentifier {
			return [
				DeclSyntax(
					"""
					@frozen public enum GPU\(raw: name.CamelCase) : UInt32, @unchecked Sendable {
						\(raw: values.map { "case \($0.name.camelCaseIdentifier) = \($0.value)" }.joined(separator: "\n"))
					}
					"""
				)
			]
		}
		return [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
	}

	var hasInvalidIdentifier: Bool {
		return values.contains { $0.name.raw.first?.isNumber == true }
	}

	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		assert(length != nil)
		assert(annotation == "const*")
		let parentIdentifier = identifier.split(separator: ".").dropLast().joined(separator: ".")
		return "\(raw: identifier).wrapArrayWithCount(\(raw: length!.sizeWithIdentifier(parentIdentifier)))"
	}
}

extension DawnFunction {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}
}

protocol TypeDescriptor {
	var type: Name { get }
	var optional: Bool { get }
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
			data: data,
		)
	}
}

extension DawnFunctionArgument: TypeDescriptor {
	var isInOut: Bool {
		return annotation == "void*" || annotation == "*"
	}
}

extension DawnMethodReturnType: TypeDescriptor {
	var annotation: String? {
		return nil
	}

	var length: ArraySize? {
		return nil
	}
}

extension DawnFunctionPointer {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
	}
}

extension DawnMethod {
	/// Check if this method uses a wrapped type for any of its arguments.
	func usesWrappedType(data: DawnData) -> Bool {
		if let returns = returns {
			if returns.isWrappedType(data: data) {
				return true
			}
		}
		if let args = args {
			return args.contains { $0.isWrappedType(data: data) }
		}
		return false
	}

	/// Unwrap the arguments for a method call, so that we can call the unwrapped WGPU method with the arguments.
	func unwrapArgs(data: DawnData, args: [DawnFunctionArgument], expression: ExprSyntax) -> ExprSyntax {
		if args.isEmpty {
			return expression.indented(by: Trivia.tab)
		}

		var args = args
		let lastArg = args.removeLast()

		let lastArgDecl: ExprSyntax
		if lastArg.isWrappedType(data: data) {
			lastArgDecl = lastArg.unwrapValueWithIdentifier(lastArg.name.camelCase, data: data, expression: expression)
		} else {
			lastArgDecl = expression
		}
		if args.count > 0 {
			return unwrapArgs(data: data, args: args, expression: lastArgDecl)
		}
		return lastArgDecl
	}

	/// Create a wrapper for a method call that will unwrap the arguments and call the WGPU method.
	func methodWrapperDecl(data: DawnData) -> FunctionDeclSyntax {
		let methodName = name.camelCase

		let args = self.args ?? []

		// Ultimately, we have to call the WGPU method with the arguments.
		let wgpuMethodCall: ExprSyntax =
			"""
			\(raw: name.camelCase)(\(raw: args.map { "\($0.name.camelCase): \($0.name.camelCase)" }.joined(separator: ", ")))
			"""

		// We need to unwrap the arguments, eventually calling the WGPU method with the unwrapped arguments.
		let unwrappedMethodCall = unwrapArgs(data: data, args: args, expression: wgpuMethodCall)
		let wrappedReturns = returns != nil ? returns!.swiftTypeName(data: data) : "Void"

		// Create the body of the method.
		var body: CodeBlockItemListSyntax
		if returns == nil {
			// No return value, so just call the WGPU method.
			body = "\(unwrappedMethodCall)"
		} else if returns!.isWrappedType(data: data) {
			// The return value is a wrapped type, so we need to wrap it as we return it.
			body =
				"""
				let result: \(raw: returns!.cTypeName(data: data)) = \(unwrappedMethodCall)
				return \(returns!.wrapValueWithIdentifier("result", data: data))
				"""
		} else {
			// The return value is not a wrapped type, so we can just return the result of the WGPU method.
			body = "return \(unwrappedMethodCall)"
		}

		let argumentSignature: FunctionParameterListSyntax = FunctionParameterListSyntax {
			for arg in args {
				FunctionParameterSyntax(
					"\(raw: arg.name.camelCase): \(raw: arg.isInOut ? "inout " : "")\(raw: arg.swiftTypeName(data: data))"
				)
			}
		}

		do {
			return try FunctionDeclSyntax(
				"""
				public func \(raw: methodName)(\(argumentSignature)) -> \(raw: wrappedReturns) {
				\(body, format: TabFormat(initialIndentation: .tabs(2)))
				}
				"""
			)
		} catch {
			fatalError("Failed to create wrapped method declaration: \(error)")
		}
	}
}

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
	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
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
				return "UnsafePointer<UnsafePointer<CChar>>"
			default:
				fatalError("Unhandled annotation: \(annotation)")
			}
		case "double": return "Double"
		case "float": return "Float"
		case "int": return "Int"
		case "uint8_t":
			if length != nil {
				if annotation == "const*" {
					return "UnsafeRawPointer"
				}
				fatalError(
					"Unimplemented swiftTypeNameForType for type \(type.raw) with annotation \(annotation!) and length \(length!)"
				)
			}
			return "UInt8"
		case "int16_t": return "Int16"
		case "int32_t": return "Int32"
		case "int64_t": return "Int64"
		case "size_t": return "Int"
		case "uint16_t": return "UInt16"
		case "uint32_t":
			if length != nil {
				return "[UInt32]"
			}
			return "UInt32"
		case "uint64_t": return "UInt64"
		case "void":
			switch annotation {
			case "*":
				return "UnsafeMutableRawPointer"
			case "const*":
				return "UnsafeRawPointer"
			default:
				return "Void"
			}
		case "void *":
			return "UnsafeMutableRawPointer"
		case "void const *":
			return "UnsafeRawPointer"
		default:
			fatalError("Unhandled native type: \(type.raw)")
		}
	}

	/// The C API name of the type.
	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		switch type.raw {
		case "bool": return "WGPUBool"
		default:
			return type.raw
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
		expression: ExprSyntax
	) -> ExprSyntax {
		if (annotation == "*" || annotation == "const*")
			&& (type.raw == "void" || type.raw == "uint8_t")
		{
			// Pass through the expression for raw data pointers.
			return expression
		}
		if length != nil {
			return
				"""
				\(raw: identifier).unwrapWGPUArray { \(raw: identifier) in
					\(expression, format: TabFormat(initialIndentation: .tabs(0)))
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
			return expression
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
		case "float", "uint64_t":
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

extension DawnObject: DawnType {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		// Create a typealias for the object.
		var declarations: [any DeclSyntaxProtocol] = [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
		// Create an extension with wrappers for any methods that use a wrapped type as an
		// argument.
		var wrappedMethodDecls: [any DeclSyntaxProtocol] = []
		for method in methods {
			if method.usesWrappedType(data: data) {
				wrappedMethodDecls.append(method.methodWrapperDecl(data: data))
			}
		}

		if !wrappedMethodDecls.isEmpty {
			declarations.append(
				DeclSyntax(
					"""
					extension GPU\(raw: name.CamelCase) {
					\(raw: wrappedMethodDecls.map { "\t\($0.formatted().description)\n" }.joined(separator: "\n"))
					}
					"""
				)
			)
		}

		// declarations.append(contentsOf: wrappedMethodDecls)
		return declarations
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		if case .int(let count) = length {
			if count == 1 && annotation == "const*" {
				return "UnsafePointer<GPU\(type.CamelCase)?>?"
			}
		}
		var name = "GPU\(type.CamelCase)"
		if length != nil {
			name = "[\(name)]"
			if annotation != "const*" {
				fatalError("Unimplemented swiftTypeNameForType for type \(type.raw) with annotation \(annotation!)")
			}
		}
		if optional ?? false {
			name = "\(name)?"
		}
		return name
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		fatalError("Unimplemented cTypeNameForType for type \(type.raw)")
	}

	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax {
		if length != nil {
			switch length! {
			case .name:
				return
					"""
					\(raw: identifier).unwrapWGPUObjectArray{ commands in
						\(expression, format: TabFormat(initialIndentation: .tabs(0)))
					}
					"""
			case .int(let count):
				fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with length \(count)")
			}
		} else if annotation != nil {
			fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with annotation \(annotation!)")
		}
		return expression
	}

	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		if length == nil {
			assert(annotation == nil)
			return "\(raw: identifier)"
		}
		switch length! {
		case .name:
			let parentIdentifier = identifier.split(separator: ".").dropLast().joined(separator: ".")
			return "\(raw: identifier).wrapWGPUArrayWithCount(\(raw: length!.sizeWithIdentifier(parentIdentifier)))"
		case .int(let count):
			fatalError("Unimplemented wrapValueOfType for type \(type.raw) with length \(count)")
		}
	}
}

extension DawnStructureMember: TypeDescriptor {

	func getMemberInfo(data: DawnData) throws -> (name: String, swiftType: String, defaultValue: String?) {
		var defaultString: String? = nil
		let isArray = length != nil

		if isOptional {
			defaultString = "nil"
		} else if isArray {
			defaultString = "[]"
		} else if let defaultValue = `default` {
			// There is a default value record for this member in the dawn.json file.
			defaultString = try defaultValue.defaultValueForType(type, data: data)
		} else {
			defaultString = nil
		}
		let typeInfo = try swiftTypeInformationForName(
			type,
			dawnDefault: defaultString,
			annotation: annotation,
			data: data,
		)
		var swiftType = typeInfo.swiftType
		if isArray {
			swiftType = "[\(swiftType)]"
		}
		if isOptional {
			swiftType = "\(swiftType)?"
		}
		return (
			name: self.name.camelCase, swiftType: swiftType,
			defaultValue: typeInfo.defaultValue
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

extension DawnStructure: DawnType {
	func isWrappedType(_ type: Name, data: DawnData) -> Bool {
		// String views structs are wrapped with a String
		if type.raw == "string view" {
			return true
		}
		// All structures that support chaining are wrapped.
		if extensible != .no {
			return true
		}
		// If any of the members are wrapped, the structure is wrapped.
		return members.contains { $0.isWrappedType(data: data) }
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		var name = "GPU\(type.CamelCase)"
		if type.raw == "string view" {
			name = "String"
		}
		if length != nil {
			if case .name = length {
				name = "[\(name)]"
			} else if case .int = length {
				// For arrays of fixed size, use tuple syntax.
				fatalError("Unimplemented swiftTypeNameForType with numeric length for type \(type.raw)")
			}
		}
		if optional ?? false {
			name = "\(name)?"
		}
		return name
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		let baseName = "WGPU\(type.CamelCase)"
		if length != nil {
			if annotation != "const*" {
				fatalError("Unknown struct annotation: \(annotation!)")
			}
			if case .name = length {
				return "[\(baseName)]"
			} else if case .int = length {
				fatalError("Unimplemented cTypeNameForType with numeric length for type \(type.raw)")
			}
		}
		return baseName
	}

	func initDecl(data: DawnData) -> DeclSyntax {
		do {
			let members = try getMembers(data: data)
			let memberParams = members.map {
				"\($0.name): \($0.swiftType)\($0.defaultValue != nil ? " = \($0.defaultValue!)" : "")"
			}.joined(separator: ", ")
			let memberAssignments = members.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n\t")
			return DeclSyntax(
				"""
				public init(\(raw: memberParams)) {
					\(raw: memberAssignments)
				}
				"""
			)
		} catch {
			fatalError("Failed to get members for creating init: \(error)")
		}
	}

	func getMembers(data: DawnData) throws -> [(name: String, swiftType: String, defaultValue: String?)] {
		return
			try members
			.map { try $0.getMemberInfo(data: data) }
	}

	func applyPropertiesMethod(cStructName: String) throws -> DeclSyntax {
		return DeclSyntax(
			"""
			public func applyPropertiesToWGPUStruct<R>(
				_ wgpuStruct: inout \(raw: cStructName),
				_ lambda: (UnsafeMutablePointer<\(raw: cStructName)>) -> R
			) -> R {
				return lambda(&wgpuStruct)
			}
			"""
		)
	}

	/// Generate an init method that takes a WGPU struct, making this struct a wrapper for
	/// the WGPU struct's data.
	func initWithWGPUStructMethod(cStructName: String, data: DawnData) -> DeclSyntax {
		let memberAssignments: CodeBlockItemListSyntax = CodeBlockItemListSyntax {
			for member in members {
				if member.isWrappedType(data: data) {
					"let _\(raw: member.name.camelCase) = \(member.wrapValueWithIdentifier("wgpuStruct.\(member.name.camelCase)", data: data))"
					"self.\(raw: member.name.camelCase) = _\(raw: member.name.camelCase)"
				} else {
					"self.\(raw: member.name.camelCase) = wgpuStruct.\(raw: member.name.camelCase)"
				}
			}
		}
		return DeclSyntax(
			"""
			public init(wgpuStruct: \(raw: cStructName)) {
				\(memberAssignments, format: TabFormat(initialIndentation:.tabs(0)))
			}
			"""
		)
	}

	func declarations(name: Name, needsWrap: Bool, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		var decls: [DeclSyntaxProtocol] = []
		let cStructName = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		if !isWrappedType(name, data: data) {
			return [
				DeclSyntax("public typealias \(raw: swiftStructName) = \(raw: cStructName)")
			]
		}

		var sType: String? = nil
		var structProtocol: String

		/// Assign the RootStruct or ChainedStruct protocol to the Dawn C struct as appropriate.
		if extensible == .in {
			decls.append(DeclSyntax("extension \(raw: cStructName): RootStruct {}"))
			structProtocol = "GPURootStruct"
		} else if chained == .in {
			decls.append(DeclSyntax("extension \(raw: cStructName): ChainedStruct {}"))
			structProtocol = "GPUChainedStruct"
			sType = ".\(name.camelCase)"
		} else {
			decls.append(DeclSyntax("extension \(raw: cStructName): WGPUStruct {}"))
			structProtocol = "GPUStruct"
		}
		if needsWrap {
			structProtocol = "\(structProtocol), GPUStructWrappable"
		}

		let memberDecls = try members.flatMap { try $0.declarations(data: data) }

		/// Create a wrapper to eliminate complicated pointer wrangling
		decls.append(
			DeclSyntax(
				"""
				public struct \(raw: swiftStructName): \(raw: structProtocol) {
					public typealias WGPUType = \(raw: cStructName)
					\(sType != nil ? "public let sType: GPUSType = \(raw: sType!)" : "")
					\(raw: memberDecls.map { $0.formatted().description }.joined(separator: "\n"))
					public var chain: [any GPUChainedStruct] = []
					
					\(initDecl(data: data))

					\(needsWrap ? initWithWGPUStructMethod(cStructName: cStructName, data: data) : nil)

					\(try applyPropertiesMethod(cStructName: cStructName))
				}

				"""
			)
		)

		return decls
	}

	/// Unwrap a structure wrapper to get a struct compatible with the WGPU API.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax {
		// Check if this type of structure is normally wrapped.
		let isWrapped = isWrappedType(type, data: data)

		if !isWrapped {
			// Even though this type of structure is normally unwrapped, we still need to
			// "unwrap" it into a pointer that we can pass to the WGPU API.
			let withFunc: String
			switch annotation {
			case "const*":
				withFunc = "withUnsafePointer"
			default:
				fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with annotation \(annotation!)")
			}
			return
				"""
				{
					var _\(raw: identifier) = \(raw: identifier)
					\(raw: withFunc)(to: &_\(raw: identifier)) { \(raw: identifier) in
						\(expression, format: TabFormat(initialIndentation: .tabs(0)))
					}
				}()
				"""
		}

		let withGPUStructMethod = annotation == "*" ? "withWGPUStructInOut" : "withWGPUStruct"
		if annotation != nil && annotation != "*" && annotation != "const*" {
			fatalError("Unimplemented unwrapValueOfType with annotation of \(annotation!) for type \(type.raw)")
		}
		if length != nil {
			assert(annotation == "*" || annotation == "const*")
			if optional ?? false {
				// TODO: This needs to be more careful about mutable vs immutable pointers.
				return
					"""
					\(raw: identifier) != nil ? \(raw: identifier)!.unwrapWGPUArray { \(raw: identifier) in
						\(raw: expression.indented(by: Trivia.tab).formatted().description)
					} : {
						let \(raw: identifier) = UnsafeMutablePointer<WGPU\(raw: type.CamelCase)>(nil)
						return \(raw: expression.indented(by: Trivia.tab).formatted().description)
					}()
					"""
			}
			return
				"""
				\(raw: identifier).unwrapWGPUArray { \(raw: identifier) in
					\(raw: expression.indented(by: Trivia.tab).formatted().description)
				}
				"""
		}
		if optional ?? false {
			return
				"""
				\(raw: identifier) != nil ? \(raw: identifier)!.\(raw: withGPUStructMethod) { \(raw: identifier) in
					\(raw: expression.indented(by: Trivia.tab).formatted().description)
				} : {
					let \(raw: identifier) = UnsafeMutablePointer<WGPU\(raw: type.CamelCase)>(nil)
					return \(raw: expression.indented(by: Trivia.tab).formatted().description)
				}()
				"""
		}
		return
			"""
			\(raw: identifier).\(raw: withGPUStructMethod) { \(raw: identifier) in
				\(raw: expression.indented(by: Trivia.tab).formatted().description)
			}
			"""
	}

	/// Wrap a WGPU struct with our Swift wrapper struct.
	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
	) -> ExprSyntax {
		if length != nil {
			assert(annotation == "const*")
			// When the length is an identifier, it will be a sibling of the identifier.
			let parentIdentifier = identifier.split(separator: ".").dropLast().joined(separator: ".")
			return
				"\(raw: identifier).wrapArrayWithCount(\(raw: length!.sizeWithIdentifier(parentIdentifier))) as [GPU\(raw: type.CamelCase)]"
		}
		if annotation == "const*" {
			return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier).pointee)"
		}
		return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier))"
	}
}

extension ArraySize {
	func sizeWithIdentifier(_ identifier: String) -> ExprSyntax {
		switch self {
		case .name(let name):
			return "\(raw: identifier).\(raw: name.camelCase)"
		case .int(let int):
			return "\(raw: int)"
		}
	}
}

func swiftTypeInformationForName(
	_ name: Name,
	dawnDefault: String? = nil,
	annotation: String? = nil,
	length: ArraySize? = nil,
	data: DawnData,
) throws -> (swiftType: String, defaultValue: String?) {
	if name == Name("string view") {
		return ("String", "\"\"")
	}

	let entity = data.data[name]
	if entity == nil {
		throw SwiftTypeNameError.unknownTypeName(name)
	}

	switch entity {
	case .object, .structure, .callbackInfo:
		// For objects, if there is no default in the dawn.json file, we do not set a
		// default value.
		let valueString = dawnDefault
		return ("GPU\(name.CamelCase)", valueString)
	case .bitmask:
		let valueString = dawnDefault ?? "GPU\(name.CamelCase)()"
		return ("GPU\(name.CamelCase)", valueString)
	case .callbackFunction, .functionPointer:
		return ("GPU\(name.CamelCase)", dawnDefault)
	case .enum(let enumValue):
		let defaultCase = dawnDefault ?? ".\(enumValue.values.first!.name.camelCaseIdentifier)"
		return ("GPU\(name.CamelCase)", defaultCase)
	case .native:
		switch name.raw {
		case "bool": return ("Bool", dawnDefault ?? "false")
		case "char":
			if annotation == nil {
				return ("CChar", dawnDefault ?? "0")
			}
			switch annotation {
			case "const*":
				return ("UnsafePointer<CChar>", dawnDefault)
			case "const*const*":
				return ("UnsafePointer<UnsafePointer<CChar>>", dawnDefault)
			default:
				throw SwiftTypeNameError.unhandledAnnotation(annotation!)
			}
		case "double": return ("Double", dawnDefault ?? "0.0")
		case "float": return ("Float", dawnDefault ?? "0.0")
		case "int": return ("Int", dawnDefault ?? "0")
		case "int16_t": return ("Int16", dawnDefault ?? "0")
		case "int32_t": return ("Int32", dawnDefault ?? "0")
		case "int64_t": return ("Int64", dawnDefault ?? "0")
		case "size_t": return ("Int", dawnDefault ?? "0")
		case "uint16_t": return ("UInt16", dawnDefault ?? "0")
		case "uint32_t": return ("UInt32", dawnDefault ?? "0")
		case "uint64_t": return ("UInt64", dawnDefault ?? "0")
		case "void":
			if annotation == "*" {
				return ("UnsafeMutableRawPointer", dawnDefault)
			}
		case "void *":
			return ("UnsafeMutableRawPointer", dawnDefault)
		case "void const *":
			return ("UnsafeRawPointer", dawnDefault)
		default:
			throw SwiftTypeNameError.unhandledNativeType(name.raw)
		}
	default:
		break
	}
	throw SwiftTypeNameError.unhandledEntityType(name.raw)
}
