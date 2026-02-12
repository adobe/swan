// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JSClass public struct GPUQueue {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?

	@JSFunction
	public func submit(_ commandBuffers: JSObject) throws(JSException)

	@JSFunction
	public func writeBuffer(
		_ buffer: GPUBuffer,
		_ bufferOffset: Int,
		_ data: JSObject
	) throws(JSException)
}

