// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUTexture {
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}

	// Returns string, convert to GPUTextureFormat if needed
	@JSGetter(jsName: "format") var internalFormat: String

	public var format: String {
		get {
			return try! internalFormat
		}
	}

	@JSFunction(jsName: "createView")
	func internalCreateView() throws(JSException) -> GPUTextureView

	@JSFunction(jsName: "destroy")
	func internalDestroy() throws(JSException)

	public func createView() -> GPUTextureView {
		try! internalCreateView()
	}

	public func destroy() {
		try! internalDestroy()
	}
}
