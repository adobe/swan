// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUQuerySet {
	// @JSSetter macro requires `set` prefix
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
	}

	@JSGetter(jsName: "type") var _type: String

	public var type: GPUQueryType {
		get {
			let s = try! _type
			return GPUQueryType(rawValue: s) ?? .occlusion
		}
	}

	@JSGetter(jsName: "count") var _count: Int

	public var count: Int {
		get { return try! _count }
	}

	@JSFunction(jsName: "destroy")
	func _destroy() throws(JSException)

	public func destroy() {
		try! _destroy()
	}
}
