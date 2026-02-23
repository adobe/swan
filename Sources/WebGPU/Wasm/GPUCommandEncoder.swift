// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPURenderPassColorAttachment {
	public var view: GPUTextureView
	public var loadOp: GPULoadOp
	public var storeOp: GPUStoreOp
	public var clearValue: GPUColor?

	public init(
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

@JS public struct GPURenderPassDescriptor {
	public var label: String?
	public var colorAttachments: [GPURenderPassColorAttachment]

	public init(
		label: String? = nil,
		colorAttachments: [GPURenderPassColorAttachment]
	) {
		self.label = label
		self.colorAttachments = colorAttachments
	}
}

@JSClass
public struct GPUCommandEncoder {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?

	@JSFunction
	public func beginRenderPass(_ descriptor: GPURenderPassDescriptor) throws(JSException)
		-> GPURenderPassEncoder

	@JSFunction
	public func beginComputePass(descriptor: GPUComputePassDescriptor) throws(JSException)
		-> GPUComputePassEncoder

	@JSFunction
	public func finish() throws(JSException) -> GPUCommandBuffer
}

