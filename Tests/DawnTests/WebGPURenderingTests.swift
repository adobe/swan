// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Testing

@testable import Dawn

extension GPUDevice {
	func createSimpleRenderPipeline(
		label: String,
		shaderModule: GPUShaderModule,
		format: GPUTextureFormat = .RGBA8Unorm
	) -> GPURenderPipeline {
		let vertexEntryPoint = "vertexMain"
		let fragmentEntryPoint = "fragmentMain"

		// No layout needed - WebGPU creates an implicit "auto" layout for shaders with no bindings
		return createRenderPipeline(
			descriptor: GPURenderPipelineDescriptor(
				label: label,
				vertex: GPUVertexState(
					module: shaderModule,
					entryPoint: vertexEntryPoint,
					bufferCount: 0,
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
					targetCount: 1,
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)
	}

	func createRenderTargetTexture(
		label: String = "Render Target",
		width: UInt32 = 64,
		height: UInt32 = 64,
		format: GPUTextureFormat = .RGBA8Unorm
	) -> GPUTexture {
		createTexture(
			descriptor: GPUTextureDescriptor(
				label: label,
				usage: [.copySrc, .renderAttachment],
				dimension: ._2D,
				size: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1),
				format: format
			)
		)
	}
}

struct WebGPURenderingTests {

	@Test("Render solid color to offscreen texture")
	@MainActor
	func testRenderSolidColor() {
		let (instance, _, device) = setupGPU()

		let texture = device.createRenderTargetTexture()
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
			colorAttachmentCount: 1,
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

		let pixels = readPixels(
			from: texture,
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
			#expect(pixels[i * 4 + 2] == 64)   // B
			#expect(pixels[i * 4 + 3] == 255)  // A
		}
	}
}
