// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// Bitonic Sort Demo - GPU-accelerated parallel sorting with visualization

import DemoUtils
import Foundation
import WebGPU

let gridWidth = 32
let gridHeight = 32
let totalElements = gridWidth * gridHeight
let updateInterval = 0.05  // 20 steps per second

struct BitonicSortDemo: DemoProvider {
	var device: GPUDevice?
	var surface: GPUSurface?

	// Buffers
	var elementsBufferA: GPUBuffer?  // Ping buffer
	var elementsBufferB: GPUBuffer?  // Pong buffer
	var uniformBuffer: GPUBuffer?

	// Pipelines
	var computePipeline: GPUComputePipeline?
	var renderPipeline: GPURenderPipeline?

	// Bind groups (swapped each step for double buffering)
	var computeBindGroupA: GPUBindGroup?
	var computeBindGroupB: GPUBindGroup?
	var renderBindGroupA: GPUBindGroup?
	var renderBindGroupB: GPUBindGroup?

	// Algorithm state
	var sortState: BitonicSortState
	var currentBuffer: Int = 0  // 0 = A is current, 1 = B is current
	var nextUpdateTime: Double = 0
	var isPaused: Bool = false

	init() {
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: bitonicWorkgroupSize)
	}

	@MainActor
	mutating func initialize(device: GPUDevice, format: GPUTextureFormat, surface: GPUSurface) {
		self.device = device
		self.surface = surface

		let bufferSize = self.createElementBuffers(device: device)
		let uniformSize = self.createUniformBuffer(device: device)
		let (computeBindGroupLayout, renderBindGroupLayout) = self.createBindGroupLayouts(device: device)
		self.createBindGroups(
			device: device,
			computeBindGroupLayout: computeBindGroupLayout,
			renderBindGroupLayout: renderBindGroupLayout,
			bufferSize: bufferSize,
			uniformSize: uniformSize
		)
		let shaderModules = self.createShaderModules(device: device)
		self.createPipelines(
			device: device,
			format: format,
			shaderModules: shaderModules,
			computeBindGroupLayout: computeBindGroupLayout,
			renderBindGroupLayout: renderBindGroupLayout
		)

		print("BitonicSort initialized: \(totalElements) elements, \(self.sortState.totalSteps) steps")
	}

	private func createShaderModules(device: GPUDevice)
		-> (compute: GPUShaderModule, vertex: GPUShaderModule, fragment: GPUShaderModule)
	{
		let computeModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(
				label: "Bitonic Compute Shader",
				code: bitonicComputeShader
			)
		)
		let vertexModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(
				label: "Display Vertex Shader",
				code: bitonicDisplayVertexShader
			)
		)
		let fragmentModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(
				label: "Display Fragment Shader",
				code: bitonicDisplayFragmentShader
			)
		)
		return (computeModule, vertexModule, fragmentModule)
	}

	private mutating func createElementBuffers(device: GPUDevice) -> UInt64 {
		let bufferSize = UInt64(totalElements * MemoryLayout<UInt32>.size)
		self.elementsBufferA = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Elements Buffer A",
				usage: [.storage, .copyDst],
				size: bufferSize,
				mappedAtCreation: false
			)
		)
		self.elementsBufferB = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Elements Buffer B",
				usage: [.storage, .copyDst],
				size: bufferSize,
				mappedAtCreation: false
			)
		)

		// Initialize with randomly shuffled values [0, totalElements)
		var elements = Array(0..<UInt32(totalElements))
		elements.shuffle()
		elements.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: self.elementsBufferA!,
				bufferOffset: 0,
				data: data
			)
		}
		return bufferSize
	}

	private mutating func createUniformBuffer(device: GPUDevice) -> UInt64 {
		let uniformSize = UInt64(4 * MemoryLayout<UInt32>.size)  // width, height, algo, blockHeight
		self.uniformBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Uniforms",
				usage: [.uniform, .copyDst],
				size: uniformSize,
				mappedAtCreation: false
			)
		)
		self.updateUniforms()
		return uniformSize
	}

	private func createBindGroupLayouts(device: GPUDevice) -> (GPUBindGroupLayout, GPUBindGroupLayout) {
		let computeBindGroupLayout = device.createBindGroupLayout(
			descriptor: GPUBindGroupLayoutDescriptor(
				label: "Compute Bind Group Layout",
				entryCount: 3,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupLayoutEntry(
						binding: 0,
						visibility: GPUShaderStage([.compute]),
						buffer: GPUBufferBindingLayout(type: .readOnlyStorage)
					),
					GPUBindGroupLayoutEntry(
						binding: 1,
						visibility: GPUShaderStage([.compute]),
						buffer: GPUBufferBindingLayout(type: .storage)
					),
					GPUBindGroupLayoutEntry(
						binding: 2,
						visibility: GPUShaderStage([.compute]),
						buffer: GPUBufferBindingLayout(type: .uniform)
					),
				]
			)
		)
		let renderBindGroupLayout = device.createBindGroupLayout(
			descriptor: GPUBindGroupLayoutDescriptor(
				label: "Render Bind Group Layout",
				entryCount: 2,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupLayoutEntry(
						binding: 0,
						visibility: GPUShaderStage([.fragment]),
						buffer: GPUBufferBindingLayout(type: .readOnlyStorage)
					),
					GPUBindGroupLayoutEntry(
						binding: 1,
						visibility: GPUShaderStage([.fragment]),
						buffer: GPUBufferBindingLayout(type: .uniform)
					),
				]
			)
		)
		return (computeBindGroupLayout, renderBindGroupLayout)
	}

	private mutating func createBindGroups(
		device: GPUDevice,
		computeBindGroupLayout: GPUBindGroupLayout,
		renderBindGroupLayout: GPUBindGroupLayout,
		bufferSize: UInt64,
		uniformSize: UInt64
	) {
		// Compute bind groups (A reads from A, writes to B; B reads from B, writes to A)
		self.computeBindGroupA = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group A",
				layout: computeBindGroupLayout,
				entryCount: 3,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
				]
			)
		)
		self.computeBindGroupB = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group B",
				layout: computeBindGroupLayout,
				entryCount: 3,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
				]
			)
		)

		// Render bind groups
		self.renderBindGroupA = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Render Bind Group A",
				layout: renderBindGroupLayout,
				entryCount: 2,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
				]
			)
		)
		self.renderBindGroupB = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Render Bind Group B",
				layout: renderBindGroupLayout,
				entryCount: 2,  // TODO: bmedina - count parameter should not be needed
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
				]
			)
		)
	}

	private mutating func createPipelines(
		device: GPUDevice,
		format: GPUTextureFormat,
		shaderModules: (compute: GPUShaderModule, vertex: GPUShaderModule, fragment: GPUShaderModule),
		computeBindGroupLayout: GPUBindGroupLayout,
		renderBindGroupLayout: GPUBindGroupLayout
	) {
		let computePipelineLayout = device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Compute Pipeline Layout",
				bindGroupLayoutCount: 1,  // TODO: bmedina - count parameter should not be needed
				bindGroupLayouts: [computeBindGroupLayout]
			)
		)
		let renderPipelineLayout = device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Render Pipeline Layout",
				bindGroupLayoutCount: 1,  // TODO: bmedina - count parameter should not be needed
				bindGroupLayouts: [renderBindGroupLayout]
			)
		)

		self.computePipeline = device.createComputePipeline(
			descriptor: GPUComputePipelineDescriptor(
				label: "Bitonic Sort Compute Pipeline",
				layout: computePipelineLayout,
				compute: GPUComputeState(module: shaderModules.compute, entryPoint: "computeMain")
			)
		)

		self.renderPipeline = device.createRenderPipeline(
			descriptor: GPURenderPipelineDescriptor(
				label: "Display Render Pipeline",
				layout: renderPipelineLayout,
				vertex: GPUVertexState(module: shaderModules.vertex, entryPoint: "vertexMain"),
				primitive: GPUPrimitiveState(
					topology: .triangleList,
					stripIndexFormat: .undefined,
					frontFace: .CCW,
					cullMode: .none
				),
				multisample: GPUMultisampleState(
					count: 1,
					mask: 0xFFFFFFFF,
					alphaToCoverageEnabled: false
				),
				fragment: GPUFragmentState(
					module: shaderModules.fragment,
					entryPoint: "fragmentMain",
					targetCount: 1,  // TODO: bmedina - count parameter should not be needed
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)
	}

	private func updateUniforms() {
		let uniforms: [UInt32] = [
			UInt32(gridWidth),
			UInt32(gridHeight),
			UInt32(self.sortState.currentStepType.rawValue),
			UInt32(self.sortState.blockHeight),
		]
		uniforms.withUnsafeBytes { data in
			self.device!.queue.writeBuffer(
				buffer: self.uniformBuffer!,
				bufferOffset: 0,
				data: data
			)
		}
	}

	private mutating func executeStep() {
		guard !self.sortState.sortIsComplete, let device = self.device, let computePipeline = self.computePipeline else {
			return
		}

		self.updateUniforms()

		let encoder = device.createCommandEncoder(descriptor: GPUCommandEncoderDescriptor(label: "Sort Step Encoder"))
		let computePass = encoder.beginComputePass(descriptor: GPUComputePassDescriptor(label: "Sort Step"))
		computePass.setPipeline(pipeline: computePipeline)

		// Select bind group based on current buffer
		let bindGroup = (self.currentBuffer == 0) ? self.computeBindGroupA! : self.computeBindGroupB!
		computePass.setBindGroup(groupIndex: 0, group: bindGroup, dynamicOffsets: [])  // TODO: bmedina - dynamicOffsets should not be needed

		// Dispatch workgroups
		let workgroupCount = UInt32(self.sortState.workgroupsForCurrentStep)
		computePass.dispatchWorkgroups(workgroupCountX: workgroupCount, workgroupCountY: 1, workgroupCountZ: 1)
		computePass.end()

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		// Log progress
		print(
			"Step \(self.sortState.currentStep + 1)/\(self.sortState.totalSteps): \(self.sortState.currentStepType), blockHeight=\(self.sortState.blockHeight)"
		)

		self.sortState.advanceStep()

		// Swap buffers (output becomes input for next step)
		self.currentBuffer = self.currentBuffer == 0 ? 1 : 0
	}

	@MainActor
	mutating func frame(time: Double) throws -> Bool {
		guard let device = self.device, let surface = self.surface, let renderPipeline = self.renderPipeline else {
			return false
		}

		// If we're not paused and it's time for the next update, execute a step
		if !self.isPaused && time >= self.nextUpdateTime && !self.sortState.sortIsComplete {
			self.executeStep()
			self.nextUpdateTime = time + updateInterval

			if self.sortState.sortIsComplete {
				print("Sort complete!")
			}
		}

		// Render current state
		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "Render Encoder")
		)
		let backbuffer = surface.getCurrentTexture()
		let textureView = backbuffer.createView()

		let renderPass = encoder.beginRenderPass(
			descriptor: GPURenderPassDescriptor(
				colorAttachmentCount: 1,
				colorAttachments: [
					GPURenderPassColorAttachment(
						view: textureView,
						loadOp: .clear,
						storeOp: .store,
						clearValue: GPUColor(r: 0.1, g: 0.1, b: 0.1, a: 1.0)
					)
				]
			)
		)
		renderPass.setPipeline(pipeline: renderPipeline)

		// Display the current buffer (after compute, this is the output)
		let renderBindGroup = (self.currentBuffer == 0) ? self.renderBindGroupA! : self.renderBindGroupB!
		renderPass.setBindGroup(groupIndex: 0, group: renderBindGroup, dynamicOffsets: [])
		renderPass.draw(vertexCount: 3, instanceCount: 1, firstVertex: 0, firstInstance: 0)
		renderPass.end()

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		surface.present()

		return true
	}
}

@main
struct Main {
	static func main() throws {
		try runDemo(title: "Bitonic Sort", provider: BitonicSortDemo())
	}
}
