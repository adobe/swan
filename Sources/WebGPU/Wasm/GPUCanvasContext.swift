// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

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

@JSClass
public struct GPUCanvasContext {

	@JSFunction
	func configure(_ configuration: GPUCanvasConfiguration) throws(JSException)

	@JSFunction(jsName: "getCurrentTexture")
	func internalGetCurrentTexture() throws(JSException) -> GPUTexture

	public func configure(configuration: GPUCanvasConfiguration) {
		try! configure(configuration)
	}

	public func getCurrentTexture() -> GPUTexture {
		try! internalGetCurrentTexture()
	}
}
