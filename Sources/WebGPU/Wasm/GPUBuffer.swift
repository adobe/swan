// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JSClass
public struct GPUBuffer {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var size: Int
	@JSGetter public var usage: Int
	@JSGetter public var label: String?

	@JSFunction
	public func destroy() throws(JSException)
}

