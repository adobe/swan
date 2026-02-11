// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JS struct GPUVertexState {
	var module: GPUShaderModule
	var entryPoint: String
	var buffers: [GPUVertexBufferLayout]?

	init(
		module: GPUShaderModule,
		entryPoint: String,
		buffers: [GPUVertexBufferLayout]? = nil
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.buffers = buffers
	}
}

@JS struct GPUFragmentState {
	var module: GPUShaderModule
	var entryPoint: String
	var targets: [GPUColorTargetState]

	init(
		module: GPUShaderModule,
		entryPoint: String,
		targets: [GPUColorTargetState]
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.targets = targets
	}
}

@JS struct GPURenderPipelineDescriptor {
	var label: String?
	var vertex: GPUVertexState
	var primitive: GPUPrimitiveState?
	var fragment: GPUFragmentState?

	init(
		label: String? = nil,
		vertex: GPUVertexState,
		primitive: GPUPrimitiveState? = nil,
		fragment: GPUFragmentState? = nil
	) {
		self.label = label
		self.vertex = vertex
		self.primitive = primitive
		self.fragment = fragment
	}
}

@JSClass
struct GPUDevice {
	@JSGetter var queue: GPUQueue
	@JSGetter var label: String?

	@JSFunction
	func createBuffer(_ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer

	@JSFunction
	func createShaderModule(_ descriptor: GPUShaderModuleDescriptor) throws(JSException)
		-> GPUShaderModule

	@JSFunction
	func createRenderPipeline(_ descriptor: GPURenderPipelineDescriptor) throws(JSException)
		-> GPURenderPipeline

	@JSFunction
	func createCommandEncoder(_ descriptor: GPUCommandEncoderDescriptor) throws(JSException)
		-> GPUCommandEncoder
}

