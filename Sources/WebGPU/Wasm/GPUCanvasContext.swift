// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

public final class GPUCanvasContext: @unchecked Sendable {
	let jsObject: JSObject

	public init(canvas: JSObject) {
		self.jsObject = canvas.getContext!("webgpu").object!
	}

	public init(jsObject: JSObject) {
		self.jsObject = jsObject
	}

	public var canvas: JSObject {
		jsObject.canvas.object!
	}

	public func configure(device: GPUDevice, format: String) {
		let obj = JSObject()
		obj.device = device.jsObject.jsValue
		obj.format = .string(format)
		_ = jsObject.configure!(obj)
	}
}
