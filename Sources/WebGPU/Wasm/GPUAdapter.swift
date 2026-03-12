// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUAdapter {
	// @JSSetter macro requires `set` prefix
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	// Returns true if the adapter supports the given feature.
	// On WASM the JS API returns a boolean.
	@JSFunction(jsName: "hasFeature")
	func _hasFeature(_ feature: String) throws(JSException) -> Bool

	public func hasFeature(feature: GPUFeatureName) -> Bool {
		return try! _hasFeature(feature.rawValue)
	}

	// Dawn uses a callback-based requestDevice; the browser uses a JS Promise.
	// These models cannot be bridged synchronously. On WASM, adapter and device
	// acquisition happens on the JS side via `adapter.requestDevice()` before
	// Swift is invoked. GPUContext.init() is guarded with `#if !arch(wasm32)`,
	// so this method is never called at runtime on WASM.
	public func requestDevice(descriptor: GPUDeviceDescriptor?, callbackInfo: GPURequestDeviceCallbackInfo) -> GPUFuture {
		fatalError("requestDevice must not be called on WASM — initialize via the JS async path before entering Swift")
	}
	public func createDevice(descriptor: GPUDeviceDescriptor?) -> GPUDevice {
		fatalError("createDevice must not be called on WASM — initialize via the JS async path before entering Swift")
	}

	// getLimits and getInfo cannot be fully implemented on WASM today.
	// The JS API exposes these as `adapter.limits` and `adapter.info`, which are
	// JS objects with many individual properties (35+ fields for GPULimits).
	// BridgeJS only bridges scalar types; there is no mechanism to map a JS
	// object with many properties into a Swift struct in one call. A proper
	// implementation would require either: (a) a GPUSupportedLimits @JSClass
	// with a @JSGetter per field and a manual transfer loop, or (b) a custom JS
	// helper that serializes the data into a bridgeable form. Neither is in scope
	// for this PR. The inout structs are left at their default-initialized values.
	public func getLimits(limits: inout GPULimits) -> GPUStatus {
		return .error
	}

	public func getInfo(info: inout GPUAdapterInfo) -> GPUStatus {
		return .error
	}
}
