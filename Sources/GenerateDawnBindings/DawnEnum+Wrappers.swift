// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnEnum {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax(
				"""
				public typealias GPU\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)
				"""
			),
			DeclSyntax(
				"""
				extension WGPU\(raw: name.CamelCase): @retroactive RawRepresentable {}
				"""
			),
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

	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax?
	) -> ExprSyntax {
		guard length != nil else {
			assert(annotation == nil)
			return expression ?? ""
		}
		let optional = optional ?? false
		// Unpack an array of values. Count extraction is done at the top level via generateArraySizeExtractions().
		return
			"""
			withWGPUArrayPointer(\(raw: identifier)) { (\(raw: identifier): UnsafePointer<WGPU\(raw: type.CamelCase)>\(raw: optional ? "?" : "")) in
				return \(expression ?? "", format: TabFormat(initialIndentation: .tabs(1)))
			}
			"""
	}
}
