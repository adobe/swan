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
import RGFW
import WebGPU

let gridWidth = 256
let gridHeight = 256
let totalElements = gridWidth * gridHeight
let updatesPerSecond = 5.0

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
	// Workgroup size for compute shader. Each invocation processes 2 elements, so shared memory
	// usage is workgroupSize * 2 * sizeof(u32). Larger values mean more work done in fast shared
	// memory (local operations) vs slower global memory, but must not exceed device limits.
	// WebGPU spec guarantees at least 256. Powers of 2 recommended (64, 128, 256).
	var workgroupSize: Int = 256
	var currentBuffer: Int = 0  // 0 = A is current, 1 = B is current
	var nextUpdateTime: Double = 0
	var isPaused: Bool = false
	var highlightMode: Bool = true  // Toggle with 'H' key to show comparison pairs

	init() {
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: 256)
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

		// Initialize uniform buffer with valid data for the first frame
		self.updateUniforms()

		print(
			"BitonicSort initialized: \(totalElements) elements, \(self.sortState.totalSteps) steps, workgroup size: \(self.workgroupSize)"
		)
		print("Controls: P=pause/resume, R=reset, H=toggle highlight mode")
	}

	private func createShaderModules(device: GPUDevice)
		-> (compute: GPUShaderModule, vertex: GPUShaderModule, fragment: GPUShaderModule)
	{
		let computeModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(
				label: "Bitonic Compute Shader",
				code: bitonicComputeShader(workgroupSize: self.workgroupSize)
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

		self.randomizeBuffer(device: device, buffer: self.elementsBufferA!)
		return bufferSize
	}

	private func randomizeBuffer(device: GPUDevice, buffer: GPUBuffer) {
		var elements = Array(0..<UInt32(totalElements))
		elements.shuffle()
		elements.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: buffer,
				bufferOffset: 0,
				data: data
			)
		}
	}

	private mutating func createUniformBuffer(device: GPUDevice) -> UInt64 {
		let uniformSize = UInt64(5 * MemoryLayout<UInt32>.size)  // width, height, algo, blockHeight, highlight
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
			self.highlightMode ? 1 : 0,
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

	private mutating func resetSort() {
		guard let device = self.device else { return }

		self.randomizeBuffer(device: device, buffer: self.elementsBufferA!)
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: self.workgroupSize)
		self.currentBuffer = 0
		print("Sort reset: \(totalElements) elements, \(self.sortState.totalSteps) steps")
	}

	private func keyIsPressed(_ key: UInt8) -> Bool {
		return RGFW_isKeyReleased(key) != 0
	}

	private mutating func handleInput() {
		if self.keyIsPressed(UInt8(RGFW_r)) {
			self.resetSort()
		}
		if self.keyIsPressed(UInt8(RGFW_p)) {
			self.isPaused.toggle()
			print(self.isPaused ? "Paused" : "Resumed")
		}
		if self.keyIsPressed(UInt8(RGFW_h)) {
			self.highlightMode.toggle()
			print("Highlight mode: \(self.highlightMode ? "ON" : "OFF")")
		}
	}

	@MainActor
	mutating func frame(time: Double) throws -> Bool {
		guard let device = self.device, let surface = self.surface, let renderPipeline = self.renderPipeline else {
			return false
		}

		self.handleInput()

		// If we're not paused and it's time for the next update, execute a step
		if !self.isPaused && time >= self.nextUpdateTime && !self.sortState.sortIsComplete {
			self.executeStep()
			self.nextUpdateTime = time + (1.0 / updatesPerSecond)

			if self.sortState.sortIsComplete {
				print("Sort complete!")
			}
		}

		// Update uniforms before rendering (ensures highlight toggle takes effect)
		self.updateUniforms()

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
