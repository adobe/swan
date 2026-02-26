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

	public var label: String? { jsObject.label.string }
	public var format: String { jsObject.format.string! }

	public func createView() -> GPUTextureView {
		GPUTextureView(unsafelyWrapping: jsObject.createView!().object!)
	}

	public func destroy() {
		_ = jsObject.destroy!()
	}
}
