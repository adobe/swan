// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JSClass
struct GPURenderPassEncoder {
	@JSGetter var label: String?

	@JSFunction
	func setPipeline(_ pipeline: GPURenderPipeline) throws(JSException)

	@JSFunction
	func setVertexBuffer(_ slot: Int, _ buffer: GPUBuffer) throws(JSException)

	@JSFunction
	func draw(
		_ vertexCount: Int,
		_ instanceCount: Int,
		_ firstVertex: Int,
		_ firstInstance: Int
	) throws(JSException)

	@JSFunction
	func end() throws(JSException)
}

