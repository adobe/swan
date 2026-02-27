// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPURenderPipeline {
	@JSGetter public var label: String?

	@JSFunction
	func getBindGroupLayout(_ index: Int) throws(JSException) -> GPUBindGroupLayout

	public func getBindGroupLayout(index: UInt32) -> GPUBindGroupLayout {
		return try! getBindGroupLayout(Int(index))
	}
}
