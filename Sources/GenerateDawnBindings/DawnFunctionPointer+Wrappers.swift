// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnFunctionPointer: DawnType {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax(
				"public typealias \(raw: swiftTypePrefixForName(name: name))\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)"
			)
		]
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool = false) -> String {
		return "\(swiftTypePrefixForName(name: type))\(type.CamelCase)?"
	}

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		return "WGPU\(type.CamelCase)"
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		// Function pointers do not have default values
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
		fatalError("Unimplemented unwrapValueOfType for function pointer type \(type.raw)")
	}

	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax {
		fatalError("Unimplemented wrapValueOfType for function pointer type \(type.raw)")
	}
}
