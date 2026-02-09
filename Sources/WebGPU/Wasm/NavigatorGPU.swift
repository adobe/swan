// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Entry point for the browser WebGPU API (navigator.gpu).
public enum NavigatorGPU {
	/// Returns the GPU object from navigator.gpu, or nil if not available (e.g. not in a browser or WebGPU not supported).
	public static var gpu: JSObject? {
		guard let navigator = JSObject.global.navigator.object else { return nil }
		guard let gpu = navigator.gpu.object else { return nil }
		return gpu
	}

	/// Request an adapter from navigator.gpu (async). Returns nil if WebGPU is unavailable or no adapter is found.
	public static func requestAdapter() async throws(WebGPUJSError) -> GPUAdapter? {
		print("requestAdapter")
		guard let gpuObj = gpu else { throw WebGPUJSError.missingGPU }
		guard gpuObj.requestAdapter.function != nil else { throw WebGPUJSError.missingGPU }
		print("requestAdapter 2")
		let result = gpuObj.requestAdapter!()
		print("requestAdapter 3")
		guard let promise = result.object.flatMap({ JSPromise($0) }) else {
			print("requestAdapter 4")
			return nil
		}
		print("requestAdapter 5")
		let value = try await promise.awaitValue()
		print("requestAdapter 6")
		guard let adapterObj = value.object else { return nil }
		print("requestAdapter 7")
		return GPUAdapter(jsObject: adapterObj)
	}
}
