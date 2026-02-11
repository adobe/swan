// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JSClass
struct GPUTexture {
	@JSGetter var label: String?
	@JSGetter var format: String  // Returns string, convert to GPUTextureFormat if needed

	@JSFunction
	func createView() throws(JSException) -> GPUTextureView

	@JSFunction
	func destroy() throws(JSException)
}

