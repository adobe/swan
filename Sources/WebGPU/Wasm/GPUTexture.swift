// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUTexture {
	@JSGetter public var label: String?
	@JSGetter public var format: String  // Returns string, convert to GPUTextureFormat if needed

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
