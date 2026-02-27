// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// Bitonic Sort Demo - GPU-accelerated parallel sorting with visualization
// Ported from https://github.com/webgpu/webgpu-samples/tree/main/sample/bitonicSort

import WebGPU

#if !arch(wasm32)
import DemoUtils
import RGFW
#endif

let gridWidth = 256
let gridHeight = 256
let totalElements = gridWidth * gridHeight
let updatesPerSecond = 5.0

struct BitonicSortDemo {
	var device: GPUDevice?
	var queue: GPUQueue?

	#if !arch(wasm32)
	var surface: GPUSurface?
	#else
	var context: GPUCanvasContext?
	#endif

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
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: workgroupSize)
	}

	// MARK: - Shared GPU Setup

	private mutating func setupGPU(device: GPUDevice, format: GPUTextureFormat) {
		self.device = device
		self.queue = device.queue

		#if !arch(wasm32)
		self.workgroupSize = maxWorkgroupSize(device: device)
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: self.workgroupSize)
		#endif

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

		self.updateUniforms()

		print(
			"BitonicSort initialized: \(totalElements) elements, \(self.sortState.totalSteps) steps, workgroup size: \(self.workgroupSize)"
		)
		print("Controls: P=pause/resume, R=reset, H=toggle highlight mode")
	}

	// MARK: - Resource Creation (shared)

	private func createShaderModules(
		device: GPUDevice
	)
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
			self.queue!.writeBuffer(
				buffer: buffer,
				bufferOffset: 0,
				data: data
			)
		}
	}

	private mutating func createUniformBuffer(device: GPUDevice) -> UInt64 {
		let uniformSize = UInt64(MemoryLayout<Uniforms>.size)
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
		self.computeBindGroupA = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group A",
				layout: computeBindGroupLayout,
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
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
				]
			)
		)

		self.renderBindGroupA = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Render Bind Group A",
				layout: renderBindGroupLayout,
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
				bindGroupLayouts: [computeBindGroupLayout]
			)
		)
		let renderPipelineLayout = device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Render Pipeline Layout",
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
				primitive: GPUPrimitiveState(topology: .triangleList),
				multisample: GPUMultisampleState(),
				fragment: GPUFragmentState(
					module: shaderModules.fragment,
					entryPoint: "fragmentMain",
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)
	}

	// MARK: - Uniforms & Sort Logic (shared)

	private func updateUniforms() {
		let uniforms = Uniforms(
			width: UInt32(gridWidth),
			height: UInt32(gridHeight),
			algorithmStep: self.sortState.currentStepType.rawValue,
			blockHeight: UInt32(self.sortState.blockHeight),
			highlight: self.highlightMode ? 1 : 0
		)
		withUnsafeBytes(of: uniforms) { data in
			self.queue!.writeBuffer(
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

		let bindGroup = (self.currentBuffer == 0) ? self.computeBindGroupA! : self.computeBindGroupB!
		computePass.setBindGroup(groupIndex: 0, group: bindGroup, dynamicOffsets: [])

		let workgroupCount = UInt32(self.sortState.workgroupsForCurrentStep)
		computePass.dispatchWorkgroups(workgroupCountX: workgroupCount, workgroupCountY: 1, workgroupCountZ: 1)
		computePass.end()

		let commandBuffer = encoder.finish(descriptor: GPUCommandBufferDescriptor(label: "Sort Step Command Buffer"))
		self.queue!.submit(commands: [commandBuffer])

		print(
			"Step \(self.sortState.currentStep + 1)/\(self.sortState.totalSteps): \(self.sortState.currentStepType), blockHeight=\(self.sortState.blockHeight)"
		)

		self.sortState.advanceStep()
		self.currentBuffer = self.currentBuffer == 0 ? 1 : 0
	}

	private mutating func resetSort() {
		guard let device = self.device else { return }

		self.randomizeBuffer(device: device, buffer: self.elementsBufferA!)
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: self.workgroupSize)
		self.currentBuffer = 0
		print("Sort reset: \(totalElements) elements, \(self.sortState.totalSteps) steps")
	}

	// MARK: - Shared Rendering

	private mutating func stepAndRender(time: Double) {
		guard let device = self.device, let renderPipeline = self.renderPipeline else {
			return
		}

		if !self.isPaused && time >= self.nextUpdateTime && !self.sortState.sortIsComplete {
			self.executeStep()
			self.nextUpdateTime = time + (1.0 / updatesPerSecond)

			if self.sortState.sortIsComplete {
				print("Sort complete!")
			}
		}

		self.updateUniforms()

		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "Render Encoder")
		)

		#if !arch(wasm32)
		let backbuffer = self.surface!.getCurrentTexture()
		#else
		let backbuffer = self.context!.getCurrentTexture()
		#endif
		let textureView = backbuffer.createView()

		let renderPass = encoder.beginRenderPass(
			descriptor: GPURenderPassDescriptor(
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

		let renderBindGroup = (self.currentBuffer == 0) ? self.renderBindGroupA! : self.renderBindGroupB!
		renderPass.setBindGroup(groupIndex: 0, group: renderBindGroup, dynamicOffsets: [])
		renderPass.draw(vertexCount: 3, instanceCount: 1, firstVertex: 0, firstInstance: 0)
		renderPass.end()

		let commandBuffer = encoder.finish(descriptor: GPUCommandBufferDescriptor(label: "Render Command Buffer"))
		self.queue!.submit(commands: [commandBuffer])

		#if !arch(wasm32)
		self.surface!.present()
		#endif
	}
}

// MARK: - Native Platform (DemoProvider)

#if !arch(wasm32)
extension BitonicSortDemo: DemoProvider {
	@MainActor
	mutating func initialize(device: GPUDevice, format: GPUTextureFormat, surface: GPUSurface) {
		self.surface = surface
		self.setupGPU(device: device, format: format)
	}

	@MainActor
	mutating func frame(time: Double) throws -> Bool {
		self.handleInput()
		self.stepAndRender(time: time)
		return true
	}

	private func maxWorkgroupSize(device: GPUDevice) -> Int {
		var limits = GPULimits()
		if device.getLimits(limits: &limits) == .success {
			return min(
				Int(limits.maxComputeWorkgroupSizeX),
				Int(limits.maxComputeInvocationsPerWorkgroup)
			)
		}
		return workgroupSize
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
}
#endif

// MARK: - WASM Platform

#if arch(wasm32)
extension BitonicSortDemo {
	init(device: GPUDevice, context: GPUCanvasContext, format: GPUTextureFormat) {
		self.init()
		self.context = context
		self.setupGPU(device: device, format: format)
	}

	mutating func frame(time: Double) {
		self.stepAndRender(time: time)
	}

	mutating func handleKey(_ key: String) {
		switch key.lowercased() {
		case "r":
			self.resetSort()
		case "p":
			self.isPaused.toggle()
			print(self.isPaused ? "Paused" : "Resumed")
		case "h":
			self.highlightMode.toggle()
			print("Highlight mode: \(self.highlightMode ? "ON" : "OFF")")
		default:
			break
		}
	}
}
#endif
