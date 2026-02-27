// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUBuffer {
	@JSGetter(jsName: "size") var internalSize: Int

	public var size: Int {
		get {
			return try! internalSize
		}
	}

	@JSGetter(jsName: "usage") var internalUsage: Int

	public var usage: Int {
		get {
			return try! internalUsage
		}
	}

	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}

	@JSFunction(jsName: "destroy")
	func internalDestroy() throws(JSException)

	public func destroy() {
		try! internalDestroy()
	}
}
