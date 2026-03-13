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

	public func setLabel(label: String?) {
		try! setLabel_(label)
	}

	@JSFunction(jsName: "setPipeline")
	func _setPipeline(_ pipeline: GPURenderPipeline) throws(JSException)

	@JSFunction(jsName: "setVertexBuffer")
	func _setVertexBuffer(_ slot: Int, _ buffer: GPUBuffer, _ offset: Int, _ size: Int) throws(JSException)

	@JSFunction(jsName: "setIndexBuffer")
	func _setIndexBuffer(_ buffer: GPUBuffer, _ indexFormat: String, _ offset: Int, _ size: Int) throws(JSException)

	@JSFunction(jsName: "draw")
	func _draw(_ vertexCount: Int, _ instanceCount: Int, _ firstVertex: Int, _ firstInstance: Int) throws(JSException)

	@JSFunction(jsName: "drawIndexed")
	func _drawIndexed(_ indexCount: Int, _ instanceCount: Int, _ firstIndex: Int, _ baseVertex: Int, _ firstInstance: Int) throws(JSException)

	@JSFunction(jsName: "setBindGroup")
	func _setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup, _ dynamicOffsets: JSObject) throws(JSException)

	@JSFunction(jsName: "setScissorRect")
	func _setScissorRect(_ x: Int, _ y: Int, _ width: Int, _ height: Int) throws(JSException)

	@JSFunction(jsName: "writeTimestamp")
	func _writeTimestamp(_ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException)

	@JSFunction(jsName: "end")
	func _end() throws(JSException)

	public func setPipeline(pipeline: GPURenderPipeline) {
		try! _setPipeline(pipeline)
	}

	public func setVertexBuffer(slot: UInt32, buffer: GPUBuffer?, offset: UInt64 = 0, size: UInt64 = UInt64.max) {
		guard let buffer = buffer else { return }
		try! _setVertexBuffer(Int(slot), buffer, Int(offset), size == UInt64.max ? 0 : Int(size))
	}

	public func setIndexBuffer(buffer: GPUBuffer?, format: GPUIndexFormat, offset: UInt64 = 0, size: UInt64 = UInt64.max) {
		guard let buffer = buffer else { return }
		try! _setIndexBuffer(buffer, format.rawValue, Int(offset), size == UInt64.max ? 0 : Int(size))
	}

	public func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
		try! _draw(Int(vertexCount), Int(instanceCount), Int(firstVertex), Int(firstInstance))
	}

	public func drawIndexed(indexCount: UInt32, instanceCount: UInt32 = 1, firstIndex: UInt32 = 0, baseVertex: Int32 = 0, firstInstance: UInt32 = 0) {
		try! _drawIndexed(Int(indexCount), Int(instanceCount), Int(firstIndex), Int(baseVertex), Int(firstInstance))
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup?, dynamicOffsets: [UInt32]? = nil) {
		guard let group = group else { return }
		let offsetsArray = JSTypedArray<UInt32>(dynamicOffsets ?? [])
		try! _setBindGroup(Int(groupIndex), group, offsetsArray.jsObject)
	}

	public func setScissorRect(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
		try! _setScissorRect(Int(x), Int(y), Int(width), Int(height))
	}

	public func writeTimestamp(querySet: GPUQuerySet, queryIndex: UInt32) {
		try! _writeTimestamp(querySet, Int(queryIndex))
	}

	public func end() {
		try! _end()
	}
}
