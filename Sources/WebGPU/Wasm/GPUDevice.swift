// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

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

@JS public struct GPURenderPipelineDescriptor {
	public var label: String?
	public var layout: GPUPipelineLayout
	public var vertex: GPUVertexState
	public var primitive: GPUPrimitiveState?
	public var multisample: GPUMultisampleState?
	public var fragment: GPUFragmentState?

	public init(
		label: String? = nil,
		layout: GPUPipelineLayout,
		vertex: GPUVertexState,
		primitive: GPUPrimitiveState? = nil,
		multisample: GPUMultisampleState? = nil,
		fragment: GPUFragmentState? = nil
	) {
		self.label = label
		self.layout = layout
		self.vertex = vertex
		self.primitive = primitive
		self.multisample = multisample
		self.fragment = fragment
	}
}

@JS public struct GPUMultisampleState {
	public var count: UInt
	public var mask: UInt
	public var alphaToCoverageEnabled: Bool

	public init(
		count: UInt = 1,
		mask: UInt = 0xFFFFFFFF,
		alphaToCoverageEnabled: Bool = false
	) {
		self.count = count
		self.mask = mask
		self.alphaToCoverageEnabled = alphaToCoverageEnabled
	}
}

@JSClass public struct GPUDevice {
	@JSGetter(jsName: "queue") var _queue: GPUQueue

	public var queue: GPUQueue {
		get {
			return try! _queue
		}
	}

	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "createBuffer")
	func _createBuffer(_ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer

	@JSFunction(jsName: "createShaderModule")
	func _createShaderModule(_ descriptor: GPUShaderModuleDescriptor) throws(JSException) -> GPUShaderModule

	@JSFunction(jsName: "createRenderPipeline")
	func _createRenderPipeline(_ descriptor: GPURenderPipelineDescriptor) throws(JSException) -> GPURenderPipeline

	@JSFunction(jsName: "createCommandEncoder")
	func _createCommandEncoder(_ descriptor: GPUCommandEncoderDescriptor) throws(JSException) -> GPUCommandEncoder

	@JSFunction(jsName: "createBindGroupLayout")
	func _createBindGroupLayout(_ descriptor: GPUBindGroupLayoutDescriptor) throws(JSException) -> GPUBindGroupLayout

	@JSFunction(jsName: "createBindGroup")
	func _createBindGroup(_ descriptor: GPUBindGroupDescriptor) throws(JSException) -> GPUBindGroup

	@JSFunction(jsName: "createPipelineLayout")
	func _createPipelineLayout(_ descriptor: GPUPipelineLayoutDescriptor) throws(JSException) -> GPUPipelineLayout

	@JSFunction(jsName: "createComputePipeline")
	func _createComputePipeline(_ descriptor: GPUComputePipelineDescriptor) throws(JSException) -> GPUComputePipeline

	public func createBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer {
		try! _createBuffer(descriptor)
	}

	public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
		try! _createShaderModule(descriptor)
	}

	public func createRenderPipeline(descriptor: GPURenderPipelineDescriptor) -> GPURenderPipeline {
		try! _createRenderPipeline(descriptor)
	}

	public func createCommandEncoder(descriptor: GPUCommandEncoderDescriptor) -> GPUCommandEncoder {
		try! _createCommandEncoder(descriptor)
	}

	public func createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor) -> GPUBindGroupLayout {
		try! _createBindGroupLayout(descriptor)
	}

	public func createBindGroup(descriptor: GPUBindGroupDescriptor) -> GPUBindGroup {
		try! _createBindGroup(descriptor)
	}

	public func createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor) -> GPUPipelineLayout {
		try! _createPipelineLayout(descriptor)
	}

	public func createComputePipeline(descriptor: GPUComputePipelineDescriptor) -> GPUComputePipeline {
		try! _createComputePipeline(descriptor)
	}
}
