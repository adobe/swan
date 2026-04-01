// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUTexture {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
	}

	@JSGetter(jsName: "format") var _format: String

	public var format: GPUTextureFormat {
		get {
			let s = try! _format
			return GPUTextureFormat(rawValue: s) ?? .Undefined
		}
	}

	// NOTE: The native (Dawn) backend exposes these as methods (getWidth(), getHeight(),
	// getDepthOrArrayLayers(), getFormat()) rather than properties. If we need to resovle
	// the discrepancy, either the native side needs corresponding property wrappers added
	// or we need to add similar methods here in the WASM API.
	@JSGetter(jsName: "width") var _width: Int

	public var width: Int {
		get { return try! _width }
	}

	@JSGetter(jsName: "height") var _height: Int

	public var height: Int {
		get { return try! _height }
	}

	@JSGetter(jsName: "depthOrArrayLayers") var _depthOrArrayLayers: Int

	public var depthOrArrayLayers: Int {
		get { return try! _depthOrArrayLayers }
	}

	@JSFunction(jsName: "createView")
	func _createView() throws(JSException) -> GPUTextureView

	@JSFunction(jsName: "createView")
	func _createViewWithDescriptor(_ descriptor: GPUTextureViewDescriptor) throws(JSException) -> GPUTextureView

	@JSFunction(jsName: "destroy")
	func _destroy() throws(JSException)

	public func createView(descriptor: GPUTextureViewDescriptor? = nil) -> GPUTextureView {
		if let descriptor {
			return try! _createViewWithDescriptor(descriptor)
		}
		return try! _createView()
	}

	public func destroy() {
		try! _destroy()
	}
}
