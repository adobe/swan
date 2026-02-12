// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JSClass
public struct GPUCanvasContext {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSFunction
	public func configure(_ configuration: GPUCanvasConfiguration) throws(JSException)

	@JSFunction
	public func getCurrentTexture() throws(JSException) -> GPUTexture
}

@_spi(Experimental)
@JS public struct GPUCanvasConfiguration {
	public var device: GPUDevice
	public var format: GPUTextureFormat
	public var alphaMode: String = "premultiplied"

	public init(device: GPUDevice, format: GPUTextureFormat, alphaMode: String = "premultiplied") {
		self.device = device
		self.format = format
		self.alphaMode = alphaMode
	}
}

