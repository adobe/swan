// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftBasicFormat
import SwiftSyntax

extension DawnStructure: DawnType {
	enum ExtensibilityType {
		case chained
		case extensible
		case none
	}

	/// The type of extensibility of the structure.
	var extensibilityType: ExtensibilityType {
		if extensible != .no {
			return .extensible
		}
		if chained != .no && chained != nil {
			return .chained
		}
		return .none
	}

	func isWrappedType(_ type: Name, data: DawnData) -> Bool {
		// String views structs are wrapped with a String
		if type.raw == "string view" {
			return true
		}
		// All structures that support chaining are wrapped.
		if extensible != .no || chainRoots != nil || chained != .no {
			return true
		}
		// If any of the members are wrapped, the structure is wrapped.
		return members.contains { $0.isWrappedType(data: data) }
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool = false) -> String {
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
		if optional {
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
		if annotation == "const*" {
			return "UnsafePointer<\(baseName)>?"
		}
		return baseName
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		// String views have a special default
		if type.raw == "string view" {
			return "\"\""
		}
		// Structures do not have default values unless specified in dawn.json
		return nil
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

	func isSimpleWGPUStruct(_ member: DawnStructureMember, data: DawnData) -> Bool {
		if !member.isWrappedType(data: data) || member.annotation != nil || member.type.raw == "string view" {
			return false
		}
		let typeData = data.data[member.type]
		guard let typeData = typeData else {
			fatalError("Unknown type: \(member.type)")
		}
		if case .structure = typeData {
			return true
		}
		return false
	}

	/// Unwrap the arguments for a method call, so that we can call the unwrapped WGPU method with the arguments.
	func unwrapMembers(
		_ members: [DawnStructureMember],
		wgpuStructIdentifier: String,
		data: DawnData,
		expression: ExprSyntax
	) -> ExprSyntax {
		if members.isEmpty {
			return expression.indented(by: Trivia.tab)
		}

		var members = members
		let lastMember = members.removeLast()

		let lastMemberDecl: ExprSyntax
		if lastMember.isWrappedType(data: data) {
			if isSimpleWGPUStruct(lastMember, data: data) {
				lastMemberDecl =
					"""
					\(raw: lastMember.name.camelCase).withWGPUStruct() {  \(raw: lastMember.name.camelCase) in
						\(expression)
					}
					"""
			} else {
				lastMemberDecl = lastMember.unwrapValueWithIdentifier(
					lastMember.name.camelCase,
					data: data,
					expression: expression
				)
			}
		} else {
			lastMemberDecl = expression
		}
		let formattedLastMemberDecl: ExprSyntax = "\(lastMemberDecl, format: TabFormat(initialIndentation: .tabs(0)))"
		if members.count > 0 {
			return unwrapMembers(
				members,
				wgpuStructIdentifier: wgpuStructIdentifier,
				data: data,
				expression: formattedLastMemberDecl
			)
		}
		return formattedLastMemberDecl
	}

	func withWGPUStructMethod(cStructName: String, data: DawnData) throws -> DeclSyntax {
		let initArgs = members.map { member in
			"\(member.name.camelCase): \(member.name.camelCase)"
		}.joined(separator: ", ")

		// An expresion to construct the WGPU struct, passing in the member values.
		let lambdaCallExpr: ExprSyntax
		switch extensibilityType {
		case .none:
			lambdaCallExpr =
				"""
				{
					var wgpuStruct = \(raw: cStructName)(\(raw: initArgs))
					return lambda(&wgpuStruct)
				}()
				"""
		case .chained:
			lambdaCallExpr =
				"""
				{	
					if nextInChain == nil {
						var wgpuStruct = \(raw: cStructName)(chain: WGPUChainedStruct(next: nil, sType: sType), \(raw: initArgs))
						return lambda(&wgpuStruct)
					} else {
						return nextInChain!.withNextInChain() { pointer in
							var wgpuStruct = \(raw: cStructName)(chain: WGPUChainedStruct(next: pointer, sType: sType), \(raw: initArgs))
							return lambda(&wgpuStruct)
						}
					}
				}()
				"""
		case .extensible:
			lambdaCallExpr =
				"""
				withWGPUStructChain { wgpuChainedStruct in
					Swift.withUnsafeMutablePointer(to: &wgpuChainedStruct) { pointer in
						var wgpuStruct = \(raw: cStructName)(nextInChain: pointer, \(raw: initArgs))
						return lambda(&wgpuStruct)
					}
				}
				"""
		}

		// Unwrap the members of the WGPU struct before calling the lambda.
		let unwrappedMemberExpr = unwrapMembers(
			members,
			wgpuStructIdentifier: "wgpuStruct",
			data: data,
			expression: lambdaCallExpr
		)

		return DeclSyntax(
			"""
			public func withWGPUStruct<R>(
				_ lambda: (inout \(raw: cStructName)) -> R
			) -> R {
				\(unwrappedMemberExpr)
			}
			"""
		)
	}

	/// Generate an init method that takes a WGPU struct, making the new struct a wrapper for
	/// the WGPU struct's data.
	func initWithWGPUStructMethod(cStructName: String, data: DawnData) -> DeclSyntax {
		let memberAssignments: CodeBlockItemListSyntax = CodeBlockItemListSyntax {
			for member in members {
				if member.isWrappedType(data: data) {
					"self.\(raw: member.name.camelCase) = \(member.wrapValueWithIdentifier("wgpuStruct.\(member.name.camelCase)", data: data))"
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
		// String views are handled by the String type, so they are not wrapped.
		if name.raw == "string view" {
			return []
		}

		var decls: [DeclSyntaxProtocol] = []
		let cStructName = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		if !isWrappedType(name, data: data) {
			return [
				DeclSyntax(
					"""
					public typealias \(raw: swiftStructName) = \(raw: cStructName)
					"""
				),
				DeclSyntax(
					"""
					extension \(raw: swiftStructName): GPUSimpleStruct {
						public typealias WGPUType = Self
					}
					"""
				),
			]
		}

		var sType: String? = nil
		var structProtocol: String

		/// Assign the RootStruct or ChainedStruct protocol to the Dawn C struct as appropriate.
		if extensibilityType == .extensible {
			decls.append(DeclSyntax("extension \(raw: cStructName): RootStruct {}"))
			structProtocol = "GPURootStruct"
		} else if extensibilityType == .chained {
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

		let chainMemberDecl: DeclSyntax? =
			extensibilityType == .none ? nil : "public var nextInChain: (any GPUChainedStruct)? = nil"

		/// Create a wrapper to eliminate complicated pointer wrangling
		decls.append(
			DeclSyntax(
				"""
				public struct \(raw: swiftStructName): \(raw: structProtocol) {
					public typealias WGPUType = \(raw: cStructName)
					\(sType != nil ? "public let sType: GPUSType = \(raw: sType!)" : "")
					\(raw: memberDecls.map { $0.formatted().description }.joined(separator: "\n"))

					\(chainMemberDecl)
					
					\(initDecl(data: data))

					\(needsWrap ? initWithWGPUStructMethod(cStructName: cStructName, data: data) : nil)

					\(try withWGPUStructMethod(cStructName: cStructName, data: data))
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
		expression: ExprSyntax?
	) -> ExprSyntax {
		// Check if this type of structure is normally wrapped.
		let isWrapped = isWrappedType(type, data: data)
		let optional = optional ?? false

		if !isWrapped {
			if length != nil {
				if case .int = length! {
					fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with length \(length!)")
				}
				if case .name(let lengthName) = length! {
					let count: ExprSyntax = optional ? "\(raw: identifier)?.count ?? 0" : "\(raw: identifier).count"
					return
						"""
						withWGPUArrayPointer(\(raw: identifier)) { _\(raw: identifier) in
							let \(raw: lengthName.camelCase) = \(count)
							let \(raw: identifier) = _\(raw: identifier)
							return \(expression ?? "", format: TabFormat(initialIndentation: .tabs(1)))
						}
						"""
				}
			}
			// Even though this type of structure is normally unwrapped, we still need to
			// "unwrap" it into a pointer that we can pass to the WGPU API.
			assert(annotation == "const*")
			if optional {
				return
					"""
					\(raw: identifier).withWGPUPointer() { \(raw: identifier) in
						\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
					}
					"""
			}
			return
				"""
				\(raw: identifier).withWGPUPointer() { \(raw: identifier) in
					\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
				}
				"""
		}

		if annotation != nil && annotation != "*" && annotation != "const*" {
			fatalError("Unimplemented unwrapValueOfType with annotation of \(annotation!) for type \(type.raw)")
		}
		if length != nil {
			switch annotation {
			case "const*":
				return
					"""
					withWGPUArrayPointer(\(raw: identifier)) { \(raw: identifier) in
						\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
					}
					"""
			case "*":
				return
					"""
					withWGPUMutableArrayPointer(\(raw: identifier)) { \(raw: identifier) in
						\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
					}
					"""
			default:
				fatalError("Unimplemented unwrapValueOfType with annotation of \(annotation!) for type \(type.raw)")
			}
		}
		switch annotation {
		case nil:
			// Without an annotation, we just provide a struct instance on the stack.
			return
				"""
				\(raw: identifier).withWGPUStruct { \(raw: identifier) in
					\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
				}
				"""
		case "const*":
			// For const pointers, we need to get a pointer to the struct.
			return
				"""
				\(raw: identifier).withWGPUPointer { \(raw: identifier) in
					\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
				}
				"""
		case "*":
			// For mutable pointers, we need to get a mutable pointer to the struct.
			return
				"""
				\(raw: identifier).withWGPUMutablePointer { \(raw: identifier) in
					\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
				}
				"""
		default:
			fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with annotation \(annotation!)")
		}
	}

	/// Wrap a WGPU struct with our Swift wrapper struct.
	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		if length != nil {
			assert(annotation == "const*")
			// When the length is an identifier, it will be a sibling of the identifier.
			let parentIdentifier = identifier.split(separator: ".").dropLast().joined(separator: ".")
			return
				"\(raw: identifier).wrapArrayWithCount(\(raw: length!.sizeWithIdentifier(parentIdentifier))) as [GPU\(raw: type.CamelCase)]"
		}
		if annotation == "const*" {
			if isWrappedType(type, data: data) {
				return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier)!.pointee)"
			} else {
				return "\(raw: identifier)?.pointee"
			}
		}
		return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier))"
	}
}
