// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUTexture {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	// Returns string, convert to GPUTextureFormat if needed
	@JSGetter(jsName: "format") var _format: String

	public var format: String {
		get {
			return try! _format
		}
	}

	@JSFunction(jsName: "createView")
	func _createView() throws(JSException) -> GPUTextureView

	@JSFunction(jsName: "destroy")
	func _destroy() throws(JSException)

	public func createView() -> GPUTextureView {
		try! _createView()
	}

	public func destroy() {
		try! _destroy()
	}
}
