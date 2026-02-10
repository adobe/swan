// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Wrapper around the browser GPUQueue (device.queue).
public final class GPUQueue {
	let jsObject: JSObject

	init(jsObject: JSObject) {
		self.jsObject = jsObject
	}

	/// Write bytes into a buffer at the given offset. Copies Swift data into a JS Uint8Array and calls queue.writeBuffer.
	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: [UInt8]) {
		guard !data.isEmpty else { return }
		let typedArray = JSTypedArray<UInt8>(data)
		guard jsObject.writeBuffer.function != nil else { return }
		let offsetJS: JSValue = .number(Double(bufferOffset))
		_ = jsObject.writeBuffer!(buffer.jsObject, offsetJS, typedArray.jsObject)
	}

	/// Write raw bytes (e.g. from UnsafeRawBufferPointer) into the buffer.
	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) {
		let bytes = [UInt8](data)
		writeBuffer(buffer: buffer, bufferOffset: bufferOffset, data: bytes)
	}
}
