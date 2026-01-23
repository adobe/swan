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

	/// Check if the given argument is a size parameter for one of the args in the given list.
	///
	/// A size parameter will have a "name" that matches the "length" field of another argument.
	/// If that other argument is itself an Array (deduced by looking at its swiftTypeName), then
	/// this parameter is a size parameter for that Array.
	/// Example from dawn.json:
	/// "args": [
	/// 	{"name": "command count", "type": "size_t"},
	/// 	{"name": "commands", "type": "command buffer", "annotation": "const*", "length": "command count"}
	/// ]
	/// The second arg will have an Array type, and its "length" field matches the first arg's name.
	internal func isSizeParameter(_ arg: DawnFunctionArgument, in args: [DawnFunctionArgument], data: DawnData) -> Bool {
		return args.contains { otherArg in
			if case .name(let lengthName) = otherArg.length {
				if (lengthName == arg.name) {
					// otherArg's length field matches the arg's name. Now check if otherArg is an Array type.
					let swiftType = otherArg.swiftTypeName(data: data)
					// The C-API only support array collection types, so a simple prefix check is sufficient.
					return swiftType.hasPrefix("[")
				}
			}
			return false
		}
	}

	/// If the given parameter is a size parameter, return the array that we are the size parameter for.
	/// TODO: bmedina - can this be combined with isSizeParameter so we aren't searching twice?
	internal func arrayForSizeParameter(
		_ sizeParameter: DawnFunctionArgument,
		in args: [DawnFunctionArgument],
		data: DawnData
	) -> DawnFunctionArgument? {
		if !isSizeParameter(sizeParameter, in: args, data: data) {
			return nil
		}
		// Search for the array that has a length that matches the size parameter's name.
		return args.first { arg in
			/// TODO: bmedina - use the more concise syntax from isSizeParameter
			guard let length = arg.length else {
				return false
			}
			if case .name(let lengthName) = length {
				return lengthName == sizeParameter.name
			}
			return false
		}
	}

	/// For any of our args that are size parameters for an array, generate a let statement that contains the size
	/// of the array so that we can call the Dawn API that requires a separate parameter for the size.
	/// Example
	/// "args": [
	/// 	{"name": "command count", "type": "size_t"},
	/// 	{"name": "commands", "type": "command buffer", "annotation": "const*", "length": "command count"}
	/// ]
	/// "command count" is the size parameter for the "commands" array, so we would generate the following:
	/// let commandCount = commands.count
	/// TODO: bmedina - rename to generateArraySizeExtractionCode
	func generateArraySizeExtractions(data: DawnData) -> String {
		let allArgs = self.args ?? []
		var extractions = [String]()

		for arg in allArgs {
			// TODO: bmedina - don't really like `in` as the label here. Can we think of a better name?
			// TODO: bmedina - include the if clause as a `where` in the loop statement
			if isSizeParameter(arg, in: allArgs, data: data) {
				guard let array = arrayForSizeParameter(arg, in: allArgs, data: data) else {
					continue
				}
				let arrayName = array.name.camelCase
				let sizeName = arg.name.camelCase
				let swiftType = array.swiftTypeName(data: data)
				let isOptional = swiftType.hasSuffix("?")
				let countExpression = isOptional ? "\(arrayName)?.count ?? 0" : "\(arrayName).count"
				extractions.append("let \(sizeName) = \(countExpression)")
			}
		}

		if extractions.isEmpty {
			return ""
		}
		// Append a trailing newline here, so we don't have to do it conditionally later
		return extractions.joined(separator: "\n") + "\n"
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

		let argsForCMethod = self.args ?? []
		// Exclude all array size parameters from the Swift method signature.
		let argsForSwiftMethod = argsForCMethod.filter { !isSizeParameter($0, in: argsForCMethod, data: data) }

		let wgpuMethodCall: ExprSyntax =
			"""
			\(raw: name.camelCase)(\(raw: argsForCMethod.map { "\($0.name.camelCase): \($0.name.camelCase)" }.joined(separator: ", ")))
			"""

		// We need to unwrap the arguments, eventually calling the WGPU method with the unwrapped arguments.
		let unwrappedMethodCall = unwrapArgs(argsForSwiftMethod, data: data, expression: wgpuMethodCall)

		let wrappedReturns = returns != nil ? returns!.swiftTypeName(data: data) : "Void"

		// Create the body of the method.
		let arraySizeExtractionCode = generateArraySizeExtractions(data: data)

		var body: CodeBlockItemListSyntax
		if returns == nil {
			// No return value, so just call the WGPU method.
			body = "\(raw: arraySizeExtractionCode)\(unwrappedMethodCall)"
		} else if returns!.isWrappedType(data: data) {
			// The return value is a wrapped type, so we need to wrap it as we return it.
			body =
				"""
				\(raw: arraySizeExtractionCode)let result: \(raw: returns!.cTypeName(data: data)) = \(unwrappedMethodCall)
				return \(returns!.wrapValueWithIdentifier("result", data: data))
				"""
		} else {
			// The return value is not a wrapped type, so we can just return the result of the WGPU method.
			body = "\(raw: arraySizeExtractionCode)return \(unwrappedMethodCall)"
		}

		let argumentSignature = FunctionParameterListSyntax {
			for arg in argsForSwiftMethod {
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
