// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder

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
	func unwrapArgs(_ args: [DawnFunctionArgument], data: DawnData, expression: ExprSyntax) -> ExprSyntax {
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
		let lastArgFormatted: ExprSyntax = "\(lastArgDecl, format: TabFormat(initialIndentation: .tabs(0)))"
		if args.count > 0 {
			return unwrapArgs(args, data: data, expression: lastArgFormatted)
		}
		return lastArgFormatted
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
		let unwrappedMethodCall = unwrapArgs(args, data: data, expression: wgpuMethodCall)
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

		let argumentSignature = FunctionParameterListSyntax {
			for arg in args {
				"\(raw: arg.name.camelCase): \(raw: arg.isInOut ? "inout " : "")\(raw: arg.swiftTypeName(data: data))"
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
