// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JSClass
struct GPUQueue {
	@JSGetter var label: String?

	@JSFunction
	func submit(_ commandBuffers: JSObject) throws(JSException)

	@JSFunction
	func writeBuffer(
		_ buffer: GPUBuffer,
		_ bufferOffset: Int,
		_ data: JSObject
	) throws(JSException)
}

