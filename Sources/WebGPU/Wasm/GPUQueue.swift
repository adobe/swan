// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUQueue {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	public var label: String? { jsObject.label.string }

	@JSFunction
	func submit(_ commandBuffers: JSObject) throws(JSException)

	@JSFunction
	func writeBuffer(_ buffer: GPUBuffer, _ bufferOffset: Int, _ data: JSObject) throws(JSException)

	public func submit(commands: [GPUCommandBuffer]) {
		let jsArray = JSObject.global.Array.function!.new()
		for cmd in commands {
			_ = jsArray.push!(cmd.jsObject)
		}
		try! submit(jsArray)
	}

	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) {
		let bytes = Array(UnsafeBufferPointer(
			start: data.baseAddress?.assumingMemoryBound(to: UInt8.self),
			count: data.count
		))
		let jsArray = JSTypedArray<UInt8>(bytes)
		try! writeBuffer(buffer, Int(bufferOffset), jsArray.jsObject)
	}
}
