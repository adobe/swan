// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUTexture {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?
	@JSGetter public var format: String  // Returns string, convert to GPUTextureFormat if needed

	@JSFunction
	public func createView() throws(JSException) -> GPUTextureView

	@JSFunction
	public func destroy() throws(JSException)
}

