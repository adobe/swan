// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUBuffer {
	@JSGetter(jsName: "size") var _size: Int

	public var size: Int {
		get {
			return try! _size
		}
	}

	@JSGetter(jsName: "usage") var _usage: Int

	public var usage: Int {
		get {
			return try! _usage
		}
	}

	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "destroy")
	func _destroy() throws(JSException)

	public func destroy() {
		try! _destroy()
	}
}
