// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JS public struct GPUVertexState {
	public var module: GPUShaderModule
	public var entryPoint: String
	public var buffers: [GPUVertexBufferLayout]

	public init(
		module: GPUShaderModule,
		entryPoint: String,
		buffers: [GPUVertexBufferLayout] = []
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.buffers = buffers
	}
}

@_spi(Experimental)
@JS public struct GPUFragmentState {
	public var module: GPUShaderModule
	public var entryPoint: String
	public var targets: [GPUColorTargetState]

	public init(
		module: GPUShaderModule,
		entryPoint: String,
		targets: [GPUColorTargetState]
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.targets = targets
	}
}

@_spi(Experimental)
@JS public struct GPURenderPipelineDescriptor {
	public var label: String?
	public var layout: String
	public var vertex: GPUVertexState
	public var primitive: GPUPrimitiveState?
	public var fragment: GPUFragmentState?

	public init(
		label: String? = nil,
		layout: String = "auto",
		vertex: GPUVertexState,
		primitive: GPUPrimitiveState? = nil,
		fragment: GPUFragmentState? = nil
	) {
		self.label = label
		self.layout = layout
		self.vertex = vertex
		self.primitive = primitive
		self.fragment = fragment
	}
}

@_spi(Experimental)
@JSClass public struct GPUDevice {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var queue: GPUQueue
	@JSGetter public var label: String?

	@JSFunction
	public func createBuffer(_ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer

	@JSFunction
	public func createShaderModule(_ descriptor: GPUShaderModuleDescriptor) throws(JSException)
		-> GPUShaderModule

	@JSFunction
	public func createRenderPipeline(_ descriptor: GPURenderPipelineDescriptor) throws(JSException)
		-> GPURenderPipeline

	@JSFunction
	public func createCommandEncoder(_ descriptor: GPUCommandEncoderDescriptor) throws(JSException)
		-> GPUCommandEncoder
}

