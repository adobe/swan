// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPURenderPipeline {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	public var label: String? { jsObject.label.string }

	@JSFunction
	func getBindGroupLayout(_ index: Int) throws(JSException) -> GPUBindGroupLayout

	public func getBindGroupLayout(index: UInt32) -> GPUBindGroupLayout {
		try! getBindGroupLayout(Int(index))
	}
}
