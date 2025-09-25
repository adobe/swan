// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnCallbackInfo: DawnType {
	/// Generate an init method that takes a WGPU struct, making the new struct a wrapper for
	/// the WGPU struct's data.
	func initWithWGPUStructMethod(cStructName: String, data: DawnData) -> DeclSyntax {
		return
			"""
			public init(wgpuStruct: \(raw: cStructName)) {
				\(raw: hasModeProperty ? "self.mode = wgpuStruct.mode" : "")
				self.callback = wgpuStruct.callback
			}
			"""
	}

	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		let cStructName: String = "WGPU\(name.CamelCase)"
		let swiftStructName = "GPU\(name.CamelCase)"

		let callbackMember: DawnStructureMember? = members.first { $0.name.raw == "callback" }
		guard let callbackMember = callbackMember else {
			fatalError("Callback info must have a callback member")
		}

		let swiftCallbackFunctionName = "GPU\(callbackMember.type.CamelCase)"
		let initArgsSignature = hasModeProperty ? "mode: GPUCallbackMode = .waitAnyOnly, " : ""

		let callbackEntity: DawnEntity? = data.data[callbackMember.type]
		guard let callbackEntity = callbackEntity else {
			fatalError("Unknown callback type: \(callbackMember.type)")
		}
		let lambdaLiteral = callbackEntity.unwrapValueOfType(
			callbackMember.type,
			identifier: "callback",
			annotation: nil,
			length: nil,
			optional: nil,
			data: data,
			expression: nil
		)

		let initArgs =
			"nextInChain: nil, \(hasModeProperty ? "mode: mode, " : "")callback: wgpuCallback, userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(), userdata2: nil"
		let lambdaCallExpr: ExprSyntax =
			"""
			{
				let wgpuCallback: WGPU\(raw: callbackMember.type.CamelCase) = \(lambdaLiteral)
				var wgpuStruct = \(raw: cStructName)(\(raw: initArgs))
				return lambda(&wgpuStruct)
			}()
			"""

		return [
			DeclSyntax("extension \(raw: cStructName): WGPUStruct {}"),
			DeclSyntax(
				"""
				public struct \(raw: swiftStructName): GPUStruct {
					public typealias WGPUType = \(raw: cStructName)

					\(raw: hasModeProperty ? "public let mode: GPUCallbackMode" : "")
					public let callback: \(raw: swiftCallbackFunctionName)

					public init(\(raw: initArgsSignature)callback: @escaping \(raw: swiftCallbackFunctionName)) {
						\(raw: hasModeProperty ? "self.mode = mode" : "")
						self.callback = callback
					}

					public func withWGPUStruct<R>(
						_ lambda: (inout \(raw: cStructName)) -> R
					) -> R {
						\(lambdaCallExpr)
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
		expression: ExprSyntax?
	) -> ExprSyntax {
		return """
			\(raw: identifier).withWGPUStruct { \(raw: identifier) in
				return \(expression ?? "", format: TabFormat(initialIndentation: .tabs(0)))
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
		assert(length == nil)
		if annotation == "const*" {
			return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier).pointee)"
		}
		return "GPU\(raw: type.CamelCase)(wgpuStruct: \(raw: identifier))"
	}

	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool = false) -> String {
		var name = "GPU\(type.CamelCase)"
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

	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String {
		fatalError("Unimplemented cTypeNameForType for type \(type.raw)")
	}

	/// The default value for the type.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String? {
		// Callback infos do not have default values
		return nil
	}
}
