// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax
import SwiftSyntaxBuilder

/// Generate a typealias for a callback function using wrapped types for the arguments.
extension DawnCallbackFunction {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		let argumentTypes = args.map { arg in
			let type = arg.swiftTypeName(data: data)
			return type == "String" ? "String?" : type
		}

		return [
			DeclSyntax(
				"public typealias \(raw: name.swiftTypePrefix())\(raw: name.CamelCase) = (\(raw: argumentTypes.joined(separator: ", "))) -> Void"
			)
		]
	}

	func wrapArgs(_ args: [DawnFunctionArgument], data: DawnData) -> [CodeBlockItemSyntax] {
		if args.isEmpty {
			return []
		}

		return args.filter { $0.isWrappedType(data: data) }.map { arg in
			CodeBlockItemSyntax(
				"let \(raw: arg.name.camelCase) = \(arg.wrapValueWithIdentifier(arg.name.camelCase, data: data))"
			)
		}
	}

	/// Unwrap a callback function wrapper to get a callback function compatible with the WGPU API.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax?
	) -> ExprSyntax {
		let argumentSignature = FunctionParameterListSyntax {
			for arg in args {
				"_ \(raw: arg.name.camelCase): \(raw: arg.isInOut ? "inout " : "")\(raw: arg.cTypeName(data: data))"
			}
			"_ userdata1: UnsafeMutableRawPointer?"
			"_ userdata2: UnsafeMutableRawPointer?"
		}
		return """
			{ (\(argumentSignature)) in
					\(raw: wrapArgs(args, data: data).map { $0.formatted().description }.joined(separator: "\n"))
					assert(userdata1 != nil)
					let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
					let callback = unmanagedCallback.takeUnretainedValue() as! GPU\(raw: type.CamelCase)
					callback(\(raw: args.map { "\($0.name.camelCase)" }.joined(separator: ", ")))
					\(raw: multipleUseCallbacks.contains(type) ? "unmanagedCallback.release()" : "")
			}
			"""
	}
}
