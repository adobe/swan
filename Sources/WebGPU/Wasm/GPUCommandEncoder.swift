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
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}

	@JSFunction
	func beginRenderPass(_ descriptor: GPURenderPassDescriptor) throws(JSException) -> GPURenderPassEncoder

	@JSFunction
	func beginComputePass(_ descriptor: GPUComputePassDescriptor) throws(JSException) -> GPUComputePassEncoder

	@JSFunction(jsName: "finish")
	func internalFinish(descriptor: GPUCommandBufferDescriptor) throws(JSException) -> GPUCommandBuffer

	public func beginRenderPass(descriptor: GPURenderPassDescriptor) -> GPURenderPassEncoder {
		try! beginRenderPass(descriptor)
	}

	public func beginComputePass(descriptor: GPUComputePassDescriptor) -> GPUComputePassEncoder {
		try! beginComputePass(descriptor)
	}

	// TODO: dawn API has optional descriptor parameter
	public func finish(descriptor: GPUCommandBufferDescriptor) -> GPUCommandBuffer {
		try! internalFinish(descriptor: descriptor)
	}
}
