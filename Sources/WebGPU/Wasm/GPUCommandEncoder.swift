// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUCommandEncoder {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "beginRenderPass")
	func _beginRenderPass(_ descriptor: GPURenderPassDescriptor) throws(JSException) -> GPURenderPassEncoder

	@JSFunction(jsName: "beginComputePass")
	func _beginComputePass(_ descriptor: GPUComputePassDescriptor) throws(JSException) -> GPUComputePassEncoder

	@JSFunction(jsName: "finish")
	func _finish(_ descriptor: GPUCommandBufferDescriptor) throws(JSException) -> GPUCommandBuffer

	@JSFunction(jsName: "copyBufferToBuffer")
	func _copyBufferToBuffer(_ source: GPUBuffer, _ sourceOffset: Int, _ destination: GPUBuffer, _ destinationOffset: Int, _ size: Int) throws(JSException)

	@JSFunction(jsName: "copyBufferToTexture")
	func _copyBufferToTexture(_ source: JSObject, _ destination: JSObject, _ copySize: JSObject) throws(JSException)

	@JSFunction(jsName: "copyTextureToBuffer")
	func _copyTextureToBuffer(_ source: JSObject, _ destination: JSObject, _ copySize: JSObject) throws(JSException)

	@JSFunction(jsName: "resolveQuerySet")
	func _resolveQuerySet(_ querySet: GPUQuerySet, _ firstQuery: Int, _ queryCount: Int, _ destination: GPUBuffer, _ destinationOffset: Int) throws(JSException)

	@JSFunction(jsName: "clearBuffer")
	func _clearBuffer(_ buffer: GPUBuffer, _ offset: Int) throws(JSException)

	@JSFunction(jsName: "clearBuffer")
	func _clearBufferWithSize(_ buffer: GPUBuffer, _ offset: Int, _ size: Int) throws(JSException)

	@JSFunction(jsName: "writeTimestamp")
	func _writeTimestamp(_ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException)

	public func beginRenderPass(descriptor: GPURenderPassDescriptor) -> GPURenderPassEncoder {
		try! _beginRenderPass(descriptor)
	}

	public func beginComputePass(descriptor: GPUComputePassDescriptor) -> GPUComputePassEncoder {
		try! _beginComputePass(descriptor)
	}

	public func beginComputePass(descriptor: GPUComputePassDescriptor?) -> GPUComputePassEncoder {
		try! _beginComputePass(descriptor ?? GPUComputePassDescriptor())
	}

	public func finish(descriptor: GPUCommandBufferDescriptor) -> GPUCommandBuffer {
		try! _finish(descriptor)
	}

	public func finish(descriptor: GPUCommandBufferDescriptor?) -> GPUCommandBuffer {
		try! _finish(descriptor ?? GPUCommandBufferDescriptor())
	}

	public func finish() -> GPUCommandBuffer {
		try! _finish(GPUCommandBufferDescriptor())
	}

	public func copyBufferToBuffer(source: GPUBuffer, sourceOffset: UInt64, destination: GPUBuffer, destinationOffset: UInt64, size: UInt64) {
		try! _copyBufferToBuffer(source, Int(sourceOffset), destination, Int(destinationOffset), Int(size))
	}

	public func copyTextureToBuffer(source: GPUTexelCopyTextureInfo, destination: GPUTexelCopyBufferInfo, copySize: GPUExtent3D) {
		let srcObj = JSObject.global.Object.function!.new()
		srcObj.texture = source.texture.jsObject.jsValue
		srcObj.mipLevel = .number(Double(source.mipLevel))
		let originObj = JSObject.global.Object.function!.new()
		originObj.x = .number(Double(source.origin.x))
		originObj.y = .number(Double(source.origin.y))
		originObj.z = .number(Double(source.origin.z))
		srcObj.origin = .object(originObj)
		srcObj.aspect = .string(source.aspect.rawValue)
		let dstObj = JSObject.global.Object.function!.new()
		dstObj.buffer = destination.buffer.jsObject.jsValue
		dstObj.offset = .number(Double(destination.layout.offset))
		if let bpr = destination.layout.bytesPerRow { dstObj.bytesPerRow = .number(Double(bpr)) }
		if let rpi = destination.layout.rowsPerImage { dstObj.rowsPerImage = .number(Double(rpi)) }
		let sizeObj = JSObject.global.Object.function!.new()
		sizeObj.width = .number(Double(copySize.width))
		sizeObj.height = .number(Double(copySize.height))
		sizeObj.depthOrArrayLayers = .number(Double(copySize.depthOrArrayLayers))
		try! _copyTextureToBuffer(srcObj, dstObj, sizeObj)
	}

	public func copyBufferToTexture(source: GPUTexelCopyBufferInfo, destination: GPUTexelCopyTextureInfo, copySize: GPUExtent3D) {
		let srcObj = JSObject.global.Object.function!.new()
		srcObj.buffer = source.buffer.jsObject.jsValue
		srcObj.offset = .number(Double(source.layout.offset))
		if let bpr = source.layout.bytesPerRow { srcObj.bytesPerRow = .number(Double(bpr)) }
		if let rpi = source.layout.rowsPerImage { srcObj.rowsPerImage = .number(Double(rpi)) }
		let dstObj = JSObject.global.Object.function!.new()
		dstObj.texture = destination.texture.jsObject.jsValue
		dstObj.mipLevel = .number(Double(destination.mipLevel))
		let originObj = JSObject.global.Object.function!.new()
		originObj.x = .number(Double(destination.origin.x))
		originObj.y = .number(Double(destination.origin.y))
		originObj.z = .number(Double(destination.origin.z))
		dstObj.origin = .object(originObj)
		dstObj.aspect = .string(destination.aspect.rawValue)
		let sizeObj = JSObject.global.Object.function!.new()
		sizeObj.width = .number(Double(copySize.width))
		sizeObj.height = .number(Double(copySize.height))
		sizeObj.depthOrArrayLayers = .number(Double(copySize.depthOrArrayLayers))
		try! _copyBufferToTexture(srcObj, dstObj, sizeObj)
	}

	public func resolveQuerySet(querySet: GPUQuerySet, firstQuery: UInt32, queryCount: UInt32, destination: GPUBuffer, destinationOffset: UInt64) {
		try! _resolveQuerySet(querySet, Int(firstQuery), Int(queryCount), destination, Int(destinationOffset))
	}

	public func clearBuffer(buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64 = UInt64.max) {
		if size == UInt64.max {
			try! _clearBuffer(buffer, Int(offset))
		} else {
			try! _clearBufferWithSize(buffer, Int(offset), Int(size))
		}
	}

	public func clearBuffer(buffer: GPUBuffer?, offset: UInt64 = 0, size: UInt64 = UInt64.max) {
		guard let buffer = buffer else { return }
		clearBuffer(buffer: buffer, offset: offset, size: size)
	}

	public func writeTimestamp(querySet: GPUQuerySet, queryIndex: UInt32) {
		try! _writeTimestamp(querySet, Int(queryIndex))
	}
}
