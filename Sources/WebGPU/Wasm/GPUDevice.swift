// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Wrapper around the browser GPUDevice (from adapter.requestDevice()).
public final class GPUDevice {
	let jsObject: JSObject

	init(jsObject: JSObject) {
		self.jsObject = jsObject
	}

	/// The default queue for this device.
	public var queue: GPUQueue {
		guard let q = jsObject.queue.object else { fatalError("GPUDevice.queue is missing") }
		return GPUQueue(jsObject: q)
	}

	/// Create a buffer. Descriptor is converted to a JS object for the browser API.
	public func createBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer? {
		let descObj = descriptorToJS(descriptor)
		guard jsObject.createBuffer.function != nil else { return nil }
		let result = jsObject.createBuffer!(descObj)
		guard let bufferObj = result.object else { return nil }
		return GPUBuffer(jsObject: bufferObj, size: descriptor.size)
	}

	private func descriptorToJS(_ d: GPUBufferDescriptor) -> JSObject {
		let obj = JSObject()
		obj.size = .number(Double(d.size))
		obj.usage = .number(Double(d.usage.rawValue))
		obj.mappedAtCreation = .boolean(d.mappedAtCreation)
		if let label = d.label {
			obj.label = .string(JSString(label))
		}
		return obj
	}
}
