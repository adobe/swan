// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import Logging
import SwiftSyntax
import SwiftSyntaxBuilder

let constantMap = [
	"UINT64_MAX": "UInt64.max",
	"UINT32_MAX": "UInt32.max",
	"NAN": "Float.nan",
	"SIZE_MAX": "Int.max",
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
		for (name, entity) in data {
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
				structureDecls.append(contentsOf: try structure.declarations(name: name, data: self))
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
}

extension DawnEntity {
	func isWrappedType() -> Bool {
		switch self {
		case .structure:
			return true
		default:
			return false
		}
	}

	// func unwrapValue(data: DawnData, identifier: String, body: any DeclSyntaxProtocol) -> String {
	// }
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

extension DawnCallbackFunction {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
	}
}

extension DawnCallbackInfo {
	func initDecl(data: DawnData) -> DeclSyntax {
		do {
			let members = try getMembers(data: data)
			let memberParams = members.map {
				"\($0.name): \($0.swiftType)\($0.defaultValue != nil ? " = \($0.defaultValue!)" : "")"
			}.joined(separator: ", ")
			let memberAssignments = members.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n")
			return DeclSyntax("public init(\(raw: memberParams)) { \(raw: memberAssignments) }")
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

	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		var decls: [DeclSyntaxProtocol] = []
		let cStructName = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		decls.append(DeclSyntax("extension \(raw: cStructName): RootStruct {}"))

		let memberDecls = try members.flatMap { try $0.declarations(data: data) }

		/// Create a wrapper to eliminate complicated pointer wrangling
		decls.append(
			DeclSyntax(
				"""
				public struct \(raw: swiftStructName): GPURootStruct {
					public typealias WGPUType = \(raw: cStructName)
					\(raw: memberDecls.map { $0.formatted().description }.joined(separator: "\n"))
					public var userData1: Any? = nil
					public var userData2: Any? = nil
					public var chain: [any GPUChainedStruct] = []
					
					\(initDecl(data: data))

					\(try applyPropertiesMethod(cStructName: cStructName))
				}

				"""
			)
		)

		return decls

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
}

extension DawnFunction {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}
}

protocol TypeDescriptor {
	var type: Name { get }
	func isWrappedType(data: DawnData) -> Bool
	func wrapperTypeName(data: DawnData) -> String
}

extension TypeDescriptor {
	func isWrappedType(data: DawnData) -> Bool {
		let dawnEntity: DawnEntity? = data.data[type]
		if dawnEntity == nil {
			return false
		}
		return dawnEntity!.isWrappedType()
	}

	func wrapperTypeName(data: DawnData) -> String {
		return "GPU\(type.CamelCase)"
	}
}

extension DawnFunctionArgument: TypeDescriptor {
}

extension DawnMethodReturnType: TypeDescriptor {
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

	func methodWrapperDecl(data: DawnData) -> DeclSyntax {
		let methodName = name.camelCase
		if let returns = returns {
			if returns.isWrappedType(data: data) {
				fatalError("Wrapped type return not implemented for method: \(methodName)")
			}
		}

		return DeclSyntax("")

	}
}

extension DawnNativeType {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return []
	}
}

extension DawnObject {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		// Create a typealias for the object.
		var declarations: [any DeclSyntaxProtocol] = [
			DeclSyntax("public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)")
		]
		// Create an extension with wrappers for any methods that use a wrapped type as an
		// argument.
		// var wrappedMethodDecls: [any DeclSyntaxProtocol] = []
		// for method in methods {
		// 	if method.usesWrappedType(data: data) {
		// 		wrappedMethodDecls.append(
		// 			DeclSyntax("public func \(raw: method.name)() -> GPU\(raw: method.returns.CamelCase) {")
		// 		)
		// 	}
		// }
		// declarations.append(contentsOf: wrappedMethodDecls)
		return declarations
	}
}

extension DawnStructureMember {

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
}

extension DawnStructure {

	func initDecl(data: DawnData) -> DeclSyntax {
		do {
			let members = try getMembers(data: data)
			let memberParams = members.map {
				"\($0.name): \($0.swiftType)\($0.defaultValue != nil ? " = \($0.defaultValue!)" : "")"
			}.joined(separator: ", ")
			let memberAssignments = members.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n")
			return DeclSyntax("public init(\(raw: memberParams)) { \(raw: memberAssignments) }")
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

	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		var decls: [DeclSyntaxProtocol] = []
		let cStructName = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		var sType: String? = nil
		let structProtocol: String

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

					\(try applyPropertiesMethod(cStructName: cStructName))
				}

				"""
			)
		)

		return decls

	}
}

func swiftTypeInformationForName(
	_ name: Name,
	dawnDefault: String? = nil,
	annotation: String? = nil,
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
	case .object, .structure:
		// For objects, if there is no default in the dawn.json file, we do not set a
		// default value.
		let valueString = dawnDefault
		return ("GPU\(name.CamelCase)", valueString)
	case .bitmask, .callbackInfo:
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
