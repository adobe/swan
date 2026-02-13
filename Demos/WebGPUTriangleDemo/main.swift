// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptEventLoop
import JavaScriptKit
import WebGPUWasm

// Shader source (embedded)
let triangleShaderSource = """
	struct VertexOutput {
	    @builtin(position) position: vec4f,
	    @location(0) color: vec4f,
	};

	@vertex
	fn vertexMain(@builtin(vertex_index) vertexIndex: u32) -> VertexOutput {
	    var positions = array<vec2f, 3>(
	        vec2f( 0.0,  0.5),
	        vec2f(-0.5, -0.5),
	        vec2f( 0.5, -0.5),
	    );

	    var colors = array<vec4f, 3>(
	        vec4f(1.0, 0.0, 0.0, 1.0),
	        vec4f(0.0, 1.0, 0.0, 1.0),
	        vec4f(0.0, 0.0, 1.0, 1.0),
	    );

	    var output: VertexOutput;
	    output.position = vec4f(positions[vertexIndex], 0.0, 1.0);
	    output.color = colors[vertexIndex];
	    return output;
	}

	@fragment
	fn fragmentMain(input: VertexOutput) -> @location(0) vec4f {
	    return input.color;
	}
	"""

// Global state
nonisolated(unsafe) var device: GPUDevice!
nonisolated(unsafe) var context: GPUCanvasContext!
nonisolated(unsafe) var pipeline: GPURenderPipeline!
nonisolated(unsafe) var canvasFormat: GPUTextureFormat!

/// JS-exported entry point — wraps raw JSObjects into typed wrappers
@JS public func initializeWebGPU(
	device deviceJS: JSObject,
	context contextJS: JSObject,
	format formatString: String
) {
	_initializeWebGPU(
		device: GPUDevice(unsafelyWrapping: deviceJS),
		context: GPUCanvasContext(unsafelyWrapping: contextJS),
		format: formatString
	)
}

/// Called from JavaScript after WebGPU initialization
func _initializeWebGPU(
	device deviceJS: GPUDevice,
	context contextJS: GPUCanvasContext,
	format formatString: String
) {
	// Store JS objects
	device = deviceJS
	context = contextJS

	// Parse format string to enum
	canvasFormat = GPUTextureFormat(rawValue: formatString) ?? .bgra8unorm

	do {
		// Create shader module
		let shaderModule = try device.createShaderModule(
			GPUShaderModuleDescriptor(
				label: "Triangle Shader",
				code: triangleShaderSource
			)
		)

		// Create render pipeline
		pipeline = try device.createRenderPipeline(
			GPURenderPipelineDescriptor(
				label: "Triangle Pipeline",
				vertex: GPUVertexState(
					module: shaderModule,
					entryPoint: "vertexMain"
				),
				primitive: GPUPrimitiveState(
					topology: .triangleList
				),
				fragment: GPUFragmentState(
					module: shaderModule,
					entryPoint: "fragmentMain",
					targets: [
						GPUColorTargetState(format: canvasFormat)
					]
				)
			)
		)

		print("Swift WebGPU initialized successfully!")

	} catch {
		print("Failed to initialize WebGPU: \(error)")
	}
}

/// Called from JavaScript each frame via requestAnimationFrame
@JS public func renderFrame(time: Double) {
	guard let device = device,
		let context = context,
		let pipeline = pipeline
	else {
		return
	}

	do {
		// Get current texture from canvas
		let texture = try context.getCurrentTexture()
		let textureView = try texture.createView()

		// Create command encoder
		let encoder = try device.createCommandEncoder(
			GPUCommandEncoderDescriptor(label: "Render Encoder")
		)

		// Begin render pass
		let renderPass = try encoder.beginRenderPass(
			GPURenderPassDescriptor(
				label: "Main Render Pass",
				colorAttachments: [
					GPURenderPassColorAttachment(
						view: textureView,
						loadOp: .clear,
						storeOp: .store,
						clearValue: GPUColor(r: 0.1, g: 0.1, b: 0.2, a: 1.0)
					)
				]
			)
		)

		// Draw triangle
		try renderPass.setPipeline(pipeline)
		try renderPass.draw(3, 1, 0, 0)  // 3 vertices, 1 instance
		try renderPass.end()

		// Submit commands
		let commandBuffer = try encoder.finish()
		let commandBufferArray = JSObject.global.Array.function!.new(commandBuffer.jsObject)
		try device.queue.submit(commandBufferArray)

	} catch {
		print("Render error: \(error)")
	}
}

print("WebGPUTriangleDemo loaded")
