// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// Bitonic Sort Demo (WASM) - GPU-accelerated parallel sorting with visualization
// Ported from Demos/BitonicSort/BitonicSort.swift for browser via WebAssembly

@_spi(Experimental) import JavaScriptKit
@_spi(Experimental) import WebGPUWasm

let gridWidth = 256
let gridHeight = 256
let totalElements = gridWidth * gridHeight
let updatesPerSecond = 5.0

struct BitonicSortDemo {
	// GPU resources (immutable after init)
	let device: GPUDevice
	let context: GPUCanvasContext
	let format: GPUTextureFormat

	// Buffers
	let elementsBufferA: GPUBuffer  // Ping buffer
	let elementsBufferB: GPUBuffer  // Pong buffer
	let uniformBuffer: GPUBuffer
	let bufferSize: Int

	// Pipelines
	let computePipeline: GPUComputePipeline
	let renderPipeline: GPURenderPipeline

	// Bind groups (swapped each step for double buffering)
	let computeBindGroupA: GPUBindGroup
	let computeBindGroupB: GPUBindGroup
	let renderBindGroupA: GPUBindGroup
	let renderBindGroupB: GPUBindGroup

	// Algorithm state
	var sortState: BitonicSortState
	let workgroupSize: Int = 256
	var currentBuffer: Int = 0  // 0 = A is current, 1 = B is current
	var nextUpdateTime: Double = 0
	var isPaused: Bool = false
	var highlightMode: Bool = true  // Toggle with 'H' key to show comparison pairs

	init(device: GPUDevice, context: GPUCanvasContext, format: GPUTextureFormat) throws {
		self.device = device
		self.context = context
		self.format = format
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: workgroupSize)

		// Create element buffers (ping-pong)
		let bufferSize = totalElements * MemoryLayout<UInt32>.size
		self.bufferSize = bufferSize

		self.elementsBufferA = try device.createBuffer(
			GPUBufferDescriptor(label: "Elements Buffer A", size: bufferSize, usage: [.storage, .copyDst])
		)
		self.elementsBufferB = try device.createBuffer(
			GPUBufferDescriptor(label: "Elements Buffer B", size: bufferSize, usage: [.storage, .copyDst])
		)

		// Create uniform buffer
		let uniformSize = 5 * MemoryLayout<UInt32>.size  // 5 x u32 fields
		self.uniformBuffer = try device.createBuffer(
			GPUBufferDescriptor(label: "Uniforms", size: uniformSize, usage: [.uniform, .copyDst])
		)

		// Randomize initial data
		try Self.randomizeBuffer(device: device, buffer: self.elementsBufferA)

		// Create shader modules
		let computeModule = try device.createShaderModule(
			GPUShaderModuleDescriptor(
				label: "Bitonic Compute Shader",
				code: bitonicComputeShader(workgroupSize: workgroupSize)
			)
		)
		let vertexModule = try device.createShaderModule(
			GPUShaderModuleDescriptor(label: "Display Vertex Shader", code: bitonicDisplayVertexShader)
		)
		let fragmentModule = try device.createShaderModule(
			GPUShaderModuleDescriptor(label: "Display Fragment Shader", code: bitonicDisplayFragmentShader)
		)

		// Create compute bind group layout (explicit)
		let computeBindGroupLayout = try device.createBindGroupLayout(
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

		// Create compute pipeline with explicit layout
		let computePipelineLayout = try device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Compute Pipeline Layout",
				bindGroupLayouts: [computeBindGroupLayout]
			)
		)
		self.computePipeline = try device.createComputePipeline(
			descriptor: GPUComputePipelineDescriptor(
				label: "Bitonic Sort Compute Pipeline",
				layout: computePipelineLayout,
				compute: GPUComputeState(module: computeModule, entryPoint: "computeMain")
			)
		)

		// Create render pipeline with "auto" layout (inferred from shader)
		self.renderPipeline = try device.createRenderPipeline(
			GPURenderPipelineDescriptor(
				label: "Display Render Pipeline",
				vertex: GPUVertexState(module: vertexModule, entryPoint: "vertexMain"),
				primitive: GPUPrimitiveState(topology: .triangleList),
				fragment: GPUFragmentState(
					module: fragmentModule,
					entryPoint: "fragmentMain",
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)

		// Get render bind group layout from the "auto" pipeline
		let renderBindGroupLayout = try self.renderPipeline.getBindGroupLayout(0)

		// Create compute bind groups (A reads from A, writes to B; B reads from B, writes to A)
		self.computeBindGroupA = try device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group A",
				layout: computeBindGroupLayout,
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferB, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer, offset: 0, size: uniformSize),
				]
			)
		)
		self.computeBindGroupB = try device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group B",
				layout: computeBindGroupLayout,
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferA, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer, offset: 0, size: uniformSize),
				]
			)
		)

		// Create render bind groups
		self.renderBindGroupA = try device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Render Bind Group A",
				layout: renderBindGroupLayout,
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer, offset: 0, size: uniformSize),
				]
			)
		)
		self.renderBindGroupB = try device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Render Bind Group B",
				layout: renderBindGroupLayout,
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB, offset: 0, size: bufferSize),
					GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer, offset: 0, size: uniformSize),
				]
			)
		)

		// Initialize uniform buffer with valid data for the first frame
		try self.updateUniforms()

		print(
			"BitonicSort initialized: \(totalElements) elements, \(self.sortState.totalSteps) steps, workgroup size: \(self.workgroupSize)"
		)
		print("Controls: P=pause/resume, R=reset, H=toggle highlight mode")
	}

	// MARK: - Buffer Helpers

	private static func randomizeBuffer(device: GPUDevice, buffer: GPUBuffer) throws {
		var elements = Array(0..<UInt32(totalElements))
		elements.shuffle()
		let typedArray = JSTypedArray<UInt32>(elements)
		try device.queue.writeBuffer(buffer, 0, typedArray.jsObject)
	}

	private func updateUniforms() throws {
		let data: [UInt32] = [
			UInt32(gridWidth),
			UInt32(gridHeight),
			self.sortState.currentStepType.rawValue,
			UInt32(self.sortState.blockHeight),
			self.highlightMode ? 1 : 0,
		]
		let typedArray = JSTypedArray<UInt32>(data)
		try self.device.queue.writeBuffer(self.uniformBuffer, 0, typedArray.jsObject)
	}

	// MARK: - Sort Execution

	private mutating func executeStep() throws {
		guard !self.sortState.sortIsComplete else { return }

		try self.updateUniforms()

		let encoder = try self.device.createCommandEncoder(
			GPUCommandEncoderDescriptor(label: "Sort Step Encoder")
		)
		let computePass = try encoder.beginComputePass(
			descriptor: GPUComputePassDescriptor(label: "Sort Step")
		)
		try computePass.setPipeline(self.computePipeline)

		// Select bind group based on current buffer
		let bindGroup = (self.currentBuffer == 0) ? self.computeBindGroupA : self.computeBindGroupB
		try computePass.setBindGroup(0, bindGroup)

		// Dispatch workgroups
		let workgroupCount = self.sortState.workgroupsForCurrentStep
		try computePass.dispatchWorkgroups(workgroupCount, 1, 1)
		try computePass.end()

		let commandBuffer = try encoder.finish()
		let commandBufferArray = JSObject.global.Array.function!.new(commandBuffer.jsObject)
		try self.device.queue.submit(commandBufferArray)

		// Log progress
		print(
			"Step \(self.sortState.currentStep + 1)/\(self.sortState.totalSteps): \(self.sortState.currentStepType), blockHeight=\(self.sortState.blockHeight)"
		)

		self.sortState.advanceStep()

		// Swap buffers (output becomes input for next step)
		self.currentBuffer = self.currentBuffer == 0 ? 1 : 0
	}

	// MARK: - Input

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

	private mutating func resetSort() {
		do {
			try Self.randomizeBuffer(device: self.device, buffer: self.elementsBufferA)
		} catch {
			print("Failed to reset: \(error)")
		}
		self.sortState = BitonicSortState(totalElements: totalElements, workgroupSize: self.workgroupSize)
		self.currentBuffer = 0
		print("Sort reset: \(totalElements) elements, \(self.sortState.totalSteps) steps")
	}

	// MARK: - Frame

	mutating func frame(time: Double) throws {
		// Execute a sort step if not paused and it's time
		if !self.isPaused && time >= self.nextUpdateTime && !self.sortState.sortIsComplete {
			try self.executeStep()
			self.nextUpdateTime = time + (1.0 / updatesPerSecond)

			if self.sortState.sortIsComplete {
				print("Sort complete!")
			}
		}

		// Update uniforms before rendering (ensures highlight toggle takes effect)
		try self.updateUniforms()

		// Render current state
		let encoder = try self.device.createCommandEncoder(
			GPUCommandEncoderDescriptor(label: "Render Encoder")
		)
		let texture = try self.context.getCurrentTexture()
		let textureView = try texture.createView()

		let renderPass = try encoder.beginRenderPass(
			GPURenderPassDescriptor(
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
		try renderPass.setPipeline(self.renderPipeline)

		// Display the current buffer (after compute, this is the output)
		let renderBindGroup = (self.currentBuffer == 0) ? self.renderBindGroupA : self.renderBindGroupB
		try renderPass.setBindGroup(0, renderBindGroup)
		try renderPass.draw(3, 1, 0, 0)
		try renderPass.end()

		let commandBuffer = try encoder.finish()
		let commandBufferArray = JSObject.global.Array.function!.new(commandBuffer.jsObject)
		try self.device.queue.submit(commandBufferArray)
	}
}
