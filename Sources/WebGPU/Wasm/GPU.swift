// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Entry point for the browser WebGPU API (navigator.gpu).
public final class GPU {
	let jsObject: JSObject

	public static var sharedInstance: GPU? {
		guard let navigator = JSObject.global.navigator.object else { return nil }
		guard let gpu = navigator.gpu.object else { return nil }
		return GPU(jsObject: gpu)
	}

	init(jsObject: JSObject) {
		self.jsObject = jsObject
	}

	/// Request an adapter from navigator.gpu (async). Returns nil if WebGPU is unavailable or no adapter is found.
	public func requestAdapter() async throws(WebGPUJSError) -> GPUAdapter? {
		guard jsObject.requestAdapter.function != nil else { throw WebGPUJSError.missingGPU }
		let result = jsObject.requestAdapter!()
		guard let promise = result.object.flatMap({ JSPromise($0) }) else { return nil }
		let value = try await promise.awaitValue()
		guard let adapterObj = value.object else { return nil }
		return GPUAdapter(jsObject: adapterObj)
	}
}
