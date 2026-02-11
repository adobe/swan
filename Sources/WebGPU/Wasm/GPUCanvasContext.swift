// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JSClass
struct GPUCanvasContext {
	@JSFunction
	func configure(_ configuration: GPUCanvasConfiguration) throws(JSException)

	@JSFunction
	func getCurrentTexture() throws(JSException) -> GPUTexture
}

@JS struct GPUCanvasConfiguration {
	var device: GPUDevice
	var format: GPUTextureFormat
	var alphaMode: String = "premultiplied"

	init(device: GPUDevice, format: GPUTextureFormat, alphaMode: String = "premultiplied") {
		self.device = device
		self.format = format
		self.alphaMode = alphaMode
	}
}

