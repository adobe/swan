// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPURenderPassEncoder {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "setPipeline")
	func _setPipeline(_ pipeline: GPURenderPipeline) throws(JSException)

	@JSFunction(jsName: "setVertexBuffer")
	func _setVertexBuffer(_ slot: Int, _ buffer: GPUBuffer) throws(JSException)

	@JSFunction(jsName: "draw")
	func _draw(_ vertexCount: Int, _ instanceCount: Int, _ firstVertex: Int, _ firstInstance: Int) throws(JSException)

	@JSFunction(jsName: "setBindGroup")
	func _setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction(jsName: "end")
	func _end() throws(JSException)

	public func setPipeline(pipeline: GPURenderPipeline) {
		try! _setPipeline(pipeline)
	}

	public func setVertexBuffer(slot: UInt32, buffer: GPUBuffer) {
		try! _setVertexBuffer(Int(slot), buffer)
	}

	public func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
		try! _draw(Int(vertexCount), Int(instanceCount), Int(firstVertex), Int(firstInstance))
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		try! _setBindGroup(Int(groupIndex), group)
	}

	public func end() {
		try! _end()
	}
}
