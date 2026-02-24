// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Testing

@testable import WebGPU

// Synchronous read-back helpers for tests only
// These loop on instance.processEvents() which should not be done in production code.

extension GPUBuffer {
	@MainActor
	func readData<T>(instance: GPUInstance, offset: Int = 0, count: Int) -> [T] {
		var result: [T]?
		readDataAsync(offset: offset, count: count) { data in
			result = data
		}
		// Poll until mapAsync request completes
		while result == nil {
			instance.processEvents()
		}
		return result!
	}
}

extension GPUTexture {
	@MainActor
	func readPixels(
		device: GPUDevice,
		instance: GPUInstance,
		width: Int,
		height: Int
	) -> [UInt8] {
		var result: [UInt8]?
		readPixelsAsync(device: device, width: width, height: height) { pixels in
			result = pixels
		}
		// Poll until mapAsync request completes
		while result == nil {
			instance.processEvents()
		}
		return result!
	}
}

extension GPUDevice {
	func createSimpleRenderPipeline(
		label: String,
		shaderModule: GPUShaderModule,
		vertexEntryPoint: String = "vertexMain",
		fragmentEntryPoint: String = "fragmentMain",
		format: GPUTextureFormat = .RGBA8Unorm
	) -> GPURenderPipeline {
		// No layout needed - WebGPU creates an implicit "auto" layout for shaders with no bindings
		return createRenderPipeline(
			descriptor: GPURenderPipelineDescriptor(
				label: label,
				vertex: GPUVertexState(
					module: shaderModule,
					entryPoint: vertexEntryPoint,
					buffers: []
				),
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
					module: shaderModule,
					entryPoint: fragmentEntryPoint,
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)
	}
}

struct WebGPUPipelineTests {

	@Test("Render solid color to offscreen texture")
	@MainActor
	func testRenderSolidColor() {
		let (instance, _, device) = setupGPU()

		let texture = device.createRenderTargetTexture(width: 64, height: 64)
		let textureView = texture.createView()

		// Use distinct values for each channel to catch swizzling/ordering bugs
		// R=0.5 (128), G=0.75 (191), B=0.25 (64), A=1.0 (255)
		let shaderCode = """
			@vertex
			fn vertexMain(@builtin(vertex_index) idx: u32) -> @builtin(position) vec4f {
			    // Full-screen quad as two triangles (CCW winding)
			    var pos = array<vec2f, 6>(
			        // Triangle 1: bottom-left, bottom-right, top-left
			        vec2f(-1.0, -1.0),
			        vec2f( 1.0, -1.0),
			        vec2f(-1.0,  1.0),
			        // Triangle 2: bottom-right, top-right, top-left
			        vec2f( 1.0, -1.0),
			        vec2f( 1.0,  1.0),
			        vec2f(-1.0,  1.0)
			    );
			    return vec4f(pos[idx], 0.0, 1.0);
			}

			@fragment
			fn fragmentMain() -> @location(0) vec4f {
			    return vec4f(0.5, 0.75, 0.25, 1.0); // R=128, G=191, B=64, A=255
			}
			"""
		let shaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Test Shader", code: shaderCode)
		)
		let pipeline = device.createSimpleRenderPipeline(label: "Test Pipeline", shaderModule: shaderModule)

		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "Test Encoder")
		)

		let renderPassDescriptor = GPURenderPassDescriptor(
			label: "Test Render Pass",
			colorAttachments: [
				GPURenderPassColorAttachment(
					view: textureView,
					loadOp: .clear,
					storeOp: .store,
					clearValue: GPUColor(r: 0, g: 0, b: 0, a: 1)
				)
			]
		)

		let renderPass = encoder.beginRenderPass(descriptor: renderPassDescriptor)
		renderPass.setPipeline(pipeline: pipeline)
		renderPass.draw(vertexCount: 6, instanceCount: 1, firstVertex: 0, firstInstance: 0)
		renderPass.end()

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		let pixels = texture.readPixels(
			device: device,
			instance: instance,
			width: 64,
			height: 64
		)

		// Verify all pixels match expected RGBA values (128, 191, 64, 255)
		let pixelCount = 64 * 64
		for i in 0..<pixelCount {
			#expect(pixels[i * 4 + 0] == 128)  // R
			#expect(pixels[i * 4 + 1] == 191)  // G
			#expect(pixels[i * 4 + 2] == 64)  // B
			#expect(pixels[i * 4 + 3] == 255)  // A
		}
	}

	@Test("Run compute shader that doubles values")
	@MainActor
	func testComputeDoubleValues() {
		let (instance, _, device) = setupGPU()

		// Input data: [0, 1, 2, 3, ..., 63]
		let elementCount = 64
		let inputData: [UInt32] = (0..<UInt32(elementCount)).map { $0 }
		let bufferSize = inputData.lengthInBytes

		// Create storage buffer with input data (needs storage + copySrc for readback)
		let storageBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Storage Buffer",
				usage: [.storage, .copySrc, .copyDst],
				size: bufferSize,
				mappedAtCreation: false
			)
		)!

		// Write input data to buffer
		inputData.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: storageBuffer,
				bufferOffset: 0,
				data: data
			)
		}

		// Create compute shader that doubles each value
		let shaderCode = """
			@group(0) @binding(0) var<storage, read_write> data: array<u32>;

			@compute @workgroup_size(64)
			fn computeMain(@builtin(global_invocation_id) id: vec3u) {
			    data[id.x] = data[id.x] * 2u;
			}
			"""
		let shaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Compute Shader", code: shaderCode)
		)

		// Create bind group layout
		let bindGroupLayout = device.createBindGroupLayout(
			descriptor: GPUBindGroupLayoutDescriptor(
				label: "Compute Bind Group Layout",
				entries: [
					GPUBindGroupLayoutEntry(
						binding: 0,
						visibility: GPUShaderStage([.compute]),
						buffer: GPUBufferBindingLayout(type: .storage)
					)
				]
			)
		)

		// Create pipeline layout
		let pipelineLayout = device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Compute Pipeline Layout",
				bindGroupLayouts: [bindGroupLayout]
			)
		)

		// Create compute pipeline
		let computePipeline = device.createComputePipeline(
			descriptor: GPUComputePipelineDescriptor(
				label: "Double Values Pipeline",
				layout: pipelineLayout,
				compute: GPUComputeState(
					module: shaderModule,
					entryPoint: "computeMain"
				)
			)
		)

		// Create bind group
		let bindGroup = device.createBindGroup(
			descriptor: GPUBindGroupDescriptor(
				label: "Compute Bind Group",
				layout: bindGroupLayout,
				entries: [
					GPUBindGroupEntry(binding: 0, buffer: storageBuffer)
				]
			)
		)

		// Create command encoder and run compute pass
		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "Compute Encoder")
		)

		let computePass = encoder.beginComputePass(
			descriptor: GPUComputePassDescriptor(label: "Compute Pass")
		)
		computePass.setPipeline(pipeline: computePipeline)
		computePass.setBindGroup(
			groupIndex: 0,
			group: bindGroup,
			dynamicOffsetCount: 0,
			dynamicOffsets: []
		)
		// Dispatch 1 workgroup of 64 threads (one thread per element)
		computePass.dispatchWorkgroups(
			workgroupCountX: 1,
			workgroupCountY: 1,
			workgroupCountZ: 1
		)
		computePass.end()

		// Create staging buffer for readback
		let stagingBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Staging Buffer",
				usage: [.copyDst, .mapRead],
				size: bufferSize,
				mappedAtCreation: false
			)
		)!

		// Copy storage buffer to staging buffer
		encoder.copyBufferToBuffer(
			source: storageBuffer,
			sourceOffset: 0,
			destination: stagingBuffer,
			destinationOffset: 0,
			size: bufferSize
		)

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		// Read back results
		let results: [UInt32] = stagingBuffer.readData(
			instance: instance,
			count: elementCount
		)

		// Verify all values are doubled: [0, 2, 4, 6, ..., 126]
		for i in 0..<elementCount {
			#expect(results[i] == UInt32(i * 2))
		}

		storageBuffer.destroy()
		stagingBuffer.destroy()
	}
}
