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

        // Create shader modules
        let computeModule = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
            label: "Bitonic Comput Shader",
            code: bitonicComputeShader
        ))
        let vertexModule = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
            label: "Display Vertex Shader",
            code: bitonicDisplayVertexShader
        ))
        let fragmentModule = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
            label: "Display Fragment Shader",
            code: bitonicDisplayFragmentShader
        ))

        let bufferSize = UInt64(totalElements * MemoryLayout<UInt32>.size)
        self.elementsBufferA = device.createBuffer(descriptor: GPUBufferDescriptor(
            label: "Elements Buffer A",
            usage: [.storage, .copyDst],
            size: bufferSize,
            mappedAtCreation: false
        ))
        self.elementsBufferB = device.createBuffer(descriptor: GPUBufferDescriptor(
            label: "Elements Buffer B",
            usage: [.storage, .copyDst],
            size: bufferSize,
            mappedAtCreation: false
        ))

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

        // Uniform (constants) buffer
        let uniformSize = UInt64(4 * MemoryLayout<UInt32>.size)  // width, height, algo, blockHeight
        self.uniformBuffer = device.createBuffer(descriptor: GPUBufferDescriptor(
            label: "Uniforms",
            usage: [.uniform, .copyDst],
            size: uniformSize,
            mappedAtCreation: false
        ))
        self.updateUniforms()

        // Create bind group layouts
        let computeBindGroupLayout = device.createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor(
            label: "Compute Bind Group Layout",
            entryCount: 3, // TODO: bmedina - count parameter should not be needed
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
        ))
        let renderBindGroupLayout = device.createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor(
            label: "Render Bind Group Layout",
            entryCount: 2, // TODO: bmedina - count parameter should not be needed
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
        ))

        // Create bind groups (A reads from A, writes to B; B reads from B, writes to A)
        self.computeBindGroupA = device.createBindGroup(descriptor: GPUBindGroupDescriptor(
            label: "Compute Bind Group A",
            layout: computeBindGroupLayout,
            entryCount: 3, // TODO: bmedina - count parameter should not be needed
            entries: [
                GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
            ]
        ))
        self.computeBindGroupB = device.createBindGroup(descriptor: GPUBindGroupDescriptor(
            label: "Compute Bind Group B",
            layout: computeBindGroupLayout,
            entryCount: 2, // TODO: bmedina - count parameter should not be needed
            entries: [
                GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 1, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 2, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
            ]
        ))

        // Create render bind groups
        self.renderBindGroupA = device.createBindGroup(descriptor: GPUBindGroupDescriptor(
            label: "Render Bind Group A",
            layout: renderBindGroupLayout,
            entryCount: 2, // TODO: bmedina - count parameter should not be needed
            entries: [
                GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferA!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
            ]
        ))
        self.renderBindGroupB = device.createBindGroup(descriptor: GPUBindGroupDescriptor(
            label: "Render Bind Group B",
            layout: renderBindGroupLayout,
            entryCount: 2, // TODO: bmedina - count parameter should not be needed
            entries: [
                GPUBindGroupEntry(binding: 0, buffer: self.elementsBufferB!, offset: 0, size: bufferSize),
                GPUBindGroupEntry(binding: 1, buffer: self.uniformBuffer!, offset: 0, size: uniformSize),
            ]
        ))

        // Create pipeline layouts
        let computePipelineLayout = device.createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor(
            label: "Compute Pipeline Layout",
            bindGroupLayoutCount: 1, // TODO: bmedina - count parameter should not be needed
            bindGroupLayouts: [computeBindGroupLayout]
        ))
        let renderPipelineLayout = device.createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor(
            label: "Render Pipeline Layout",
            bindGroupLayoutCount: 1, // TODO: bmedina - count parameter should not be needed
            bindGroupLayouts: [renderBindGroupLayout]
        ))

        // Create compute pipeline
        self.computePipeline = device.createComputePipeline(descriptor: GPUComputePipelineDescriptor(
            label: "Bitonic Sort Compute Pipeline",
            layout: computePipelineLayout,
            compute: GPUComputeState(module: computeModule, entryPoint: "computeMain")
        ))

        // Create render pipeline
        self.renderPipeline = device.createRenderPipeline(descriptor: GPURenderPipelineDescriptor(
            label: "Display Render Pipeline",
            layout: renderPipelineLayout,
            vertex: GPUVertexState(module: vertexModule, entryPoint: "vertexMain"),
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
                module: fragmentModule,
                entryPoint: "fragmentMain",
                targetCount: 1, // TODO: bmedina - count parameter should not be needed
                targets: [GPUColorTargetState(format: format)]
            )
        ))
        
        print("BitonicSort initialized: \(totalElements) elements, \(self.sortState.totalSteps) steps")
        // print("Press Space to pause/resume, R to randomize")
	}

    private func updateUniforms() {
        let uniforms: [UInt32] = [
            UInt32(gridWidth),
            UInt32(gridHeight),
            UInt32(self.sortState.currentStepType.rawValue),
            UInt32(self.sortState.blockHeight)
        ]
        uniforms.withUnsafeBytes { data in
            self.device!.queue.writeBuffer(
                buffer: self.uniformBuffer!,
                bufferOffset: 0,
                data: data
            )
        }
    }

	@MainActor
	mutating func frame(time: Double) throws -> Bool {
        return true
	}
}

@main
struct Main {
	static func main() throws {
		print("BitonicSort not yet implemented.")
		try runDemo(title: "Bitonic Sort", provider: BitonicSortDemo())
	}
}
