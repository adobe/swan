// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnObject: DawnType {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		// Create a typealias for the object.
		var declarations: [any DeclSyntaxProtocol] = [
			DeclSyntax(
				"public typealias \(raw: name.swiftTypePrefix())\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)"
			)
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
					extension \(raw: name.swiftTypePrefix())\(raw: name.CamelCase) {
					\(raw: wrappedMethodDecls.map { "\t\($0.formatted().description)\n" }.joined(separator: "\n"))
					}
					"""
				)
			)
		}

		// declarations.append(contentsOf: wrappedMethodDecls)
		return declarations
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool = false) -> String {
		if case .int(let count) = length {
			if count == 1 && annotation == "const*" {
				return "UnsafePointer<\(type.swiftTypePrefix())\(type.CamelCase)?>?"
			}
		}
		var name = "\(type.swiftTypePrefix())\(type.CamelCase)"
		if length != nil {
			name = "[\(name)]"
			if annotation != "const*" {
				fatalError("Unimplemented swiftTypeNameForType for type \(type.raw) with annotation \(annotation!)")
			}
		}
		if optional {
			name = "\(name)?"
		}
		return name
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool? = false) -> String {
		if annotation == "const*" {
			return "UnsafePointer<\(type.swiftTypePrefix())\(type.CamelCase)?>?"
		}
		if optional ?? false {
			return "\(type.swiftTypePrefix())\(type.CamelCase)?"
		}

		return "\(type.swiftTypePrefix())\(type.CamelCase)"
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		// Objects do not have default values unless specified in dawn.json
		return nil
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
		if length != nil {
			switch length! {
			case .name:
				return
					"""
					\(raw: identifier).unwrapWGPUObjectArray{ \(raw: identifier) in
						\(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
					}
					"""
			case .int(let count):
				fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with length \(count)")
			}
		} else if annotation != nil {
			fatalError("Unimplemented unwrapValueOfType for type \(type.raw) with annotation \(annotation!)")
		}
		return expression ?? ""
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
			if count == 1 {
				return "\(raw: identifier)"
			}
			return "\(raw: identifier).wrapTuple\(raw: count)()"
		}
	}
}
