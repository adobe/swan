// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUQueue {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
	}

	@JSFunction(jsName: "submit")
	func _submit(_ commandBuffers: JSObject) throws(JSException)

	@JSFunction(jsName: "writeBuffer")
	func _writeBuffer(_ buffer: GPUBuffer, _ bufferOffset: Int, _ data: JSObject) throws(JSException)

	@JSFunction(jsName: "writeTexture")
	func _writeTexture(_ destination: JSObject, _ data: JSObject, _ dataLayout: JSObject, _ size: JSObject) throws(JSException)

	public func submit(commands: [GPUCommandBuffer]) {
		let jsArray = JSObject.global.Array.function!.new()
		for cmd in commands {
			_ = jsArray.push!(cmd.jsObject)
		}
		try! _submit(jsArray)
	}

	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) {
		let bytes = Array(
			UnsafeBufferPointer(
				start: data.baseAddress?.assumingMemoryBound(to: UInt8.self),
				count: data.count
			)
		)
		let jsArray = JSTypedArray<UInt8>(bytes)
		try! _writeBuffer(buffer, Int(bufferOffset), jsArray.jsObject)
	}

	public func writeTexture(
		destination: GPUTexelCopyTextureInfo,
		data: UnsafeRawBufferPointer,
		dataLayout: GPUTexelCopyBufferLayout,
		writeSize: GPUExtent3D
	) {
		let bytes = Array(
			UnsafeBufferPointer(
				start: data.baseAddress?.assumingMemoryBound(to: UInt8.self),
				count: data.count
			)
		)
		let jsData = JSTypedArray<UInt8>(bytes)

		// Build JS objects for destination, dataLayout, writeSize
		let destObj = JSObject.global.Object.function!.new()
		destObj.texture = destination.texture.jsObject.jsValue
		destObj.mipLevel = .number(Double(destination.mipLevel))
		let originObj = JSObject.global.Object.function!.new()
		originObj.x = .number(Double(destination.origin.x))
		originObj.y = .number(Double(destination.origin.y))
		originObj.z = .number(Double(destination.origin.z))
		destObj.origin = originObj.jsValue
		destObj.aspect = .string(destination.aspect.rawValue)

		let layoutObj = JSObject.global.Object.function!.new()
		layoutObj.offset = .number(Double(dataLayout.offset))
		if let bpr = dataLayout.bytesPerRow {
			layoutObj.bytesPerRow = .number(Double(bpr))
		}
		if let rpi = dataLayout.rowsPerImage {
			layoutObj.rowsPerImage = .number(Double(rpi))
		}

		let sizeObj = JSObject.global.Object.function!.new()
		sizeObj.width = .number(Double(writeSize.width))
		sizeObj.height = .number(Double(writeSize.height))
		sizeObj.depthOrArrayLayers = .number(Double(writeSize.depthOrArrayLayers))

		try! _writeTexture(destObj, jsData.jsObject, layoutObj, sizeObj)
	}
}
