// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// GPUInstance is a compilation shim for WASM. On WASM, GPU initialization
// happens asynchronously on the JS side via the navigator.gpu Promise API
// before Swift is invoked. This type exists only so that GPUContext, which
// holds `var instance: GPUInstance`, compiles on WASM. It must not be
// instantiated or used at runtime on WASM.
public struct GPUInstance {
	public init() {}

	// processEvents is a no-op on WASM — event processing is handled by the
	// JavaScript event loop, not by Swift polling.
	public func processEvents() {}
}
