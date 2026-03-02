// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUQueue {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "submit")
	func _submit(_ commandBuffers: JSObject) throws(JSException)

	@JSFunction(jsName: "writeBuffer")
	func _writeBuffer(_ buffer: GPUBuffer, _ bufferOffset: Int, _ data: JSObject) throws(JSException)

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
}
