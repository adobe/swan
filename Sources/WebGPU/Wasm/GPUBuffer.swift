// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUBuffer {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	public var size: Int { Int(jsObject.size.number!) }
	public var usage: Int { Int(jsObject.usage.number!) }
	public var label: String? { jsObject.label.string }

	public func destroy() {
		_ = jsObject.destroy!()
	}
}
