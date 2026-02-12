// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JSClass public struct GPURenderPassEncoder {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?

	@JSFunction
	public func setPipeline(_ pipeline: GPURenderPipeline) throws(JSException)

	@JSFunction
	public func setVertexBuffer(_ slot: Int, _ buffer: GPUBuffer) throws(JSException)

	@JSFunction
	public func draw(
		_ vertexCount: Int,
		_ instanceCount: Int,
		_ firstVertex: Int,
		_ firstInstance: Int
	) throws(JSException)

	@JSFunction
	public func end() throws(JSException)
}

