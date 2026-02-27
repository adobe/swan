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
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "beginRenderPass")
	func _beginRenderPass(_ descriptor: GPURenderPassDescriptor) throws(JSException) -> GPURenderPassEncoder

	@JSFunction(jsName: "beginComputePass")
	func _beginComputePass(_ descriptor: GPUComputePassDescriptor) throws(JSException) -> GPUComputePassEncoder

	@JSFunction(jsName: "finish")
	func _finish(_ descriptor: GPUCommandBufferDescriptor) throws(JSException) -> GPUCommandBuffer

	public func beginRenderPass(descriptor: GPURenderPassDescriptor) -> GPURenderPassEncoder {
		try! _beginRenderPass(descriptor)
	}

	public func beginComputePass(descriptor: GPUComputePassDescriptor) -> GPUComputePassEncoder {
		try! _beginComputePass(descriptor)
	}

	// TODO: dawn API has optional descriptor parameter
	public func finish(descriptor: GPUCommandBufferDescriptor) -> GPUCommandBuffer {
		try! _finish(descriptor)
	}
}
