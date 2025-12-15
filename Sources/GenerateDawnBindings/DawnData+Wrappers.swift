// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import SwiftFormat
import SwiftSyntax

extension DawnData {

	/// Generate the Swift wrappers for the Dawn data.
	///
	/// For each entity, we generate any Swift wrappers that are needed to make the API
	/// comfortable to use from Swift
	/// - Throws: An error if generation of wrappers fails
	/// - Returns: A dictionary of file names -> swift code
	func generateWrappers(swiftFormatConfiguration: Configuration?) throws -> [String: String] {
		let formatter = Formatter(config: swiftFormatConfiguration)

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

		let wrappableStructures = structuresRequiringWrapping()

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

		func format(decls: [any DeclSyntaxProtocol]) throws -> String {
			let code = decls.map { $0.formatted().description }.joined(separator: "\n\n")
			var output = ""
			try formatter.format(code: code, filename: "output.swift", output: &output)
			return output
		}

		if aliasDecls.count > 0 {
			fatalError("Aliases not implemented")
		}
		if bitmaskDecls.count > 0 {
			result["Bitmasks"] = try format(decls: bitmaskDecls)
		}
		if callbackFunctionDecls.count > 0 {
			result["CallbackFunctions"] = try format(decls: callbackFunctionDecls)
		}
		if callbackInfoDecls.count > 0 {
			result["CallbackInfo"] = try format(decls: callbackInfoDecls)
		}
		if constantDecls.count > 0 {
			fatalError("Constants not implemented")
		}
		if enumDecls.count > 0 {
			result["Enums"] = try format(decls: enumDecls)
		}
		if functionDecls.count > 0 {
			fatalError("Functions not implemented")
		}
		if functionPointerDecls.count > 0 {
			result["FunctionPointers"] = try format(decls: functionPointerDecls)
		}
		if nativeDecls.count > 0 {
			fatalError("NativeTypes not implemented")
		}
		if objectDecls.count > 0 {
			result["Objects"] = try format(decls: objectDecls)
		}
		if structureDecls.count > 0 {
			result["Structures"] = try format(decls: structureDecls)
		}
		return result
	}

	/// Get the set of structure names used in returns or passed as a mutable pointer.
	///
	/// This is used to determine which structures to support being wrapped back into Swift API types.
	/// - Returns: A set of structure names
	func structuresRequiringWrapping() -> Set<Name> {
		var structureNames: Set<Name> = []

		// Iterate over all entities in the data
		for (name, entity) in data {
			switch entity {
			case .function(let function):
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
			case .callbackFunction(let callbackFunction):
				// Check callback function arguments for structure types
				addArgumentStructures(arguments: callbackFunction.args, structureNames: &structureNames)
			case .structure(let structure):
				if structure.chainRoots != nil {
					structureNames.insert(name)
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
					argument.annotation == "*" || argument.annotation == "const*"
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
