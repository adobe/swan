// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

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
	public func setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction
	public func end() throws(JSException)
}

public extension GPURenderPassEncoder {
	func setPipeline(pipeline: GPURenderPipeline) {
		try! setPipeline(pipeline)
	}

	func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		try! setBindGroup(Int(groupIndex), group)
	}

	func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
		try! draw(Int(vertexCount), Int(instanceCount), Int(firstVertex), Int(firstInstance))
	}
}
