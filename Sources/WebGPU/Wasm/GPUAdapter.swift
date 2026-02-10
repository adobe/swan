// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Wrapper around the browser GPUAdapter (from navigator.gpu.requestAdapter()).
public final class GPUAdapter {
	let jsObject: JSObject

	init(jsObject: JSObject) {
		self.jsObject = jsObject
	}

	/// Request a device (async). Optionally pass a descriptor; for the spike we use nil (default device).
	public func requestDevice(descriptor: JSObject? = nil) async throws(WebGPUJSError) -> GPUDevice {
		guard jsObject.requestDevice.function != nil else { throw WebGPUJSError.invalidAdapter }
		let result: JSValue
		if let desc = descriptor {
			result = jsObject.requestDevice!(desc)
		} else {
			result = jsObject.requestDevice!()
		}
		guard let promise = result.object.flatMap({ JSPromise($0) }) else { throw WebGPUJSError.invalidAdapter }
		let value = try await promise.awaitValue()
		guard let deviceObj = value.object else { throw WebGPUJSError.invalidDevice }
		return GPUDevice(jsObject: deviceObj)
	}
}
