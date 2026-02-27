// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUBuffer {
	@JSGetter public var size: Int
	@JSGetter public var usage: Int
	@JSGetter public var label: String?

	@JSFunction(jsName: "destroy")
	func internalDestroy() throws(JSException)

	public func destroy() {
		try! internalDestroy()
	}
}
