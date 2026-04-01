// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// On WASM, surfaces are created from HTML canvas elements via GPUCanvasContext,
// not from native window handles. GPUSurface is a stub for source compatibility
// with Dawn-based surface creation code that is guarded with #if !arch(wasm32).
public struct GPUSurface {
	public init() {}

	// These stubs exist for source compatibility with native call sites.
	// GPUSurface is never instantiated on WASM — surface management is handled
	// by GPUCanvasContext. All usage must be guarded by #if !arch(wasm32).
	public func configure(config: GPUSurfaceConfiguration) {
		fatalError("GPUSurface is not supported on WASM")
	}

	public func getCurrentTexture() -> GPUTexture {
		fatalError("GPUSurface is not supported on WASM")
	}

	public func present() {
		fatalError("GPUSurface is not supported on WASM")
	}
}
