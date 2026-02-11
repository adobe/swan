// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JS struct GPURenderPassColorAttachment {
	var view: GPUTextureView
	var loadOp: GPULoadOp
	var storeOp: GPUStoreOp
	var clearValue: GPUColor?

	init(
		view: GPUTextureView,
		loadOp: GPULoadOp,
		storeOp: GPUStoreOp,
		clearValue: GPUColor? = nil
	) {
		self.view = view
		self.loadOp = loadOp
		self.storeOp = storeOp
		self.clearValue = clearValue
	}
}

@JS struct GPURenderPassDescriptor {
	var label: String?
	var colorAttachments: [GPURenderPassColorAttachment]

	init(
		label: String? = nil,
		colorAttachments: [GPURenderPassColorAttachment]
	) {
		self.label = label
		self.colorAttachments = colorAttachments
	}
}

@JSClass
struct GPUCommandEncoder {
	@JSGetter var label: String?

	@JSFunction
	func beginRenderPass(_ descriptor: GPURenderPassDescriptor) throws(JSException)
		-> GPURenderPassEncoder

	@JSFunction
	func finish() throws(JSException) -> GPUCommandBuffer
}

