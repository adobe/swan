// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPURenderPassEncoder {
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}

	@JSFunction
	func setPipeline(_ pipeline: GPURenderPipeline) throws(JSException)

	@JSFunction
	func setVertexBuffer(_ slot: Int, _ buffer: GPUBuffer) throws(JSException)

	@JSFunction
	func draw(_ vertexCount: Int, _ instanceCount: Int, _ firstVertex: Int, _ firstInstance: Int) throws(JSException)

	@JSFunction
	func setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction(jsName: "end")
	func internalEnd() throws(JSException)

	public func setPipeline(pipeline: GPURenderPipeline) {
		try! setPipeline(pipeline)
	}

	public func setVertexBuffer(slot: UInt32, buffer: GPUBuffer) {
		try! setVertexBuffer(Int(slot), buffer)
	}

	public func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
		try! draw(Int(vertexCount), Int(instanceCount), Int(firstVertex), Int(firstInstance))
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		try! setBindGroup(Int(groupIndex), group)
	}

	public func end() {
		try! internalEnd()
	}
}
