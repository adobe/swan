// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation
import Testing

@testable import Dawn

extension GPUDevice {
	func createSimpleRenderPipeline(
		label: String,
		shaderModule: GPUShaderModule
	) -> GPURenderPipeline {
		let vertexEntryPoint = "vertexMain"
		let fragmentEntryPoint = "fragmentMain"
		let format: GPUTextureFormat = .BGRA8Unorm

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
		format: GPUTextureFormat = .BGRA8Unorm
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

func savePPM(destFileName: String, bgra: UnsafePointer<UInt8>, w: Int, h: Int) {
    do {
        let fileManager = FileManager.default
        let folderURL = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        let fileURL = folderURL.appendingPathComponent(destFileName)
        let header: String = "P6\n\(w) \(h) 255\n"
        var data = header.data(using: .ascii)!
        for i in 0..<w * h {
            data.append(bgra[i * 4 + 2])
            data.append(bgra[i * 4 + 1])
            data.append(bgra[i * 4])
        }
        try data.write(to: fileURL)
        print("Saved: \(fileURL)")
    } catch {
        print("Failed to write file: \(destFileName). Error: \(error)")
    }
}

struct WebGPURenderingTests {

	/// Simplest test: Write to buffer and read it back (bypasses texture entirely)
	@Test("Write and read buffer directly")
	@MainActor
	func testWriteAndReadBuffer() {
		let (instance, _, device) = setupGPU()

		// Create a buffer that can be both written to and mapped for reading
		let buffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "test buffer",
				usage: [.copyDst, .mapRead],
				size: 16,  // 4 UInt32 values
				mappedAtCreation: false
			)
		)
		guard let buffer = buffer else {
			fatalError("Failed to create buffer")
		}

		// Write known data to buffer via queue
		let data: [UInt32] = [0xDEADBEEF, 0xCAFEBABE, 0x12345678, 0xABCDEF00]
		data.withUnsafeBytes { bytes in
			device.queue.writeBuffer(
				buffer: buffer,
				bufferOffset: 0,
				data: bytes.baseAddress!,
				size: bytes.count
			)
		}

		// Read it back
		let result: [UInt32] = buffer.readData(instance: instance, count: 4)

		print("DEBUG: Read back: \(result.map { String(format: "0x%08X", $0) })")

		#expect(result[0] == 0xDEADBEEF)
		#expect(result[1] == 0xCAFEBABE)
		#expect(result[2] == 0x12345678)
		#expect(result[3] == 0xABCDEF00)
	}

	/// Test that copyBufferToBuffer works via command encoder
	@Test("Copy buffer to buffer")
	@MainActor
	func testCopyBufferToBuffer() {
		let (instance, _, device) = setupGPU()

		// Source buffer with known data
		let srcBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "src buffer",
				usage: [.copyDst, .copySrc],
				size: 16,
				mappedAtCreation: false
			)
		)!

		// Dest buffer that can be mapped for reading
		let dstBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "dst buffer",
				usage: [.copyDst, .mapRead],
				size: 16,
				mappedAtCreation: false
			)
		)!

		// Write data to source buffer
		let data: [UInt32] = [0xDEADBEEF, 0xCAFEBABE, 0x12345678, 0xABCDEF00]
		data.withUnsafeBytes { bytes in
			device.queue.writeBuffer(
				buffer: srcBuffer,
				bufferOffset: 0,
				data: bytes.baseAddress!,
				size: bytes.count
			)
		}

		// Use command encoder to copy from src to dst
		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "copy encoder")
		)
		encoder.copyBufferToBuffer(
			source: srcBuffer,
			sourceOffset: 0,
			destination: dstBuffer,
			destinationOffset: 0,
			size: 16
		)
		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		// Read from destination
		let result: [UInt32] = dstBuffer.readData(instance: instance, count: 4)

		print("DEBUG: Buffer copy result: \(result.map { String(format: "0x%08X", $0) })")

		#expect(result[0] == 0xDEADBEEF)
		#expect(result[1] == 0xCAFEBABE)
		#expect(result[2] == 0x12345678)
		#expect(result[3] == 0xABCDEF00)
	}

	/// Test buffer -> texture -> buffer copy chain (isolates copyBufferToTexture and copyTextureToBuffer)
	@Test("Buffer to texture to buffer")
	@MainActor
	func testBufferToTextureToBuffer() {
		let (instance, _, device) = setupGPU()

		let width: UInt32 = 64
		let height: UInt32 = 64
		let bytesPerRow: UInt32 = width * 4
		let totalBytes = Int(bytesPerRow * height)

		// Source buffer with known pixel data
		let srcBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "src buffer",
				usage: [.copyDst, .copySrc],
				size: UInt64(totalBytes),
				mappedAtCreation: false
			)
		)!

		// Texture
		let texture = device.createTexture(
			descriptor: GPUTextureDescriptor(
				label: "Test Texture",
				usage: [.copySrc, .copyDst],
				dimension: ._2D,
				size: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1),
				format: .BGRA8Unorm
			)
		)

		// Destination buffer for reading
		let dstBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "dst buffer",
				usage: [.copyDst, .mapRead],
				size: UInt64(totalBytes),
				mappedAtCreation: false
			)
		)!

		// Create red pixels in BGRA format: (B=0, G=0, R=255, A=255)
		var pixelData = [UInt8](repeating: 0, count: totalBytes)
		let pixelCount = Int(width * height)
		for i in 0..<pixelCount {
			pixelData[i * 4 + 0] = 0    // B
			pixelData[i * 4 + 1] = 0    // G
			pixelData[i * 4 + 2] = 255  // R
			pixelData[i * 4 + 3] = 255  // A
		}

		// Write pixel data to source buffer
		pixelData.withUnsafeBytes { bytes in
			device.queue.writeBuffer(
				buffer: srcBuffer,
				bufferOffset: 0,
				data: bytes.baseAddress!,
				size: bytes.count
			)
		}

		// Copy: srcBuffer -> texture -> dstBuffer
		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "copy encoder")
		)

		// Step 1: Buffer -> Texture
		encoder.copyBufferToTexture(
			source: GPUTexelCopyBufferInfo(
				layout: GPUTexelCopyBufferLayout(
					offset: 0,
					bytesPerRow: bytesPerRow,
					rowsPerImage: height
				),
				buffer: srcBuffer
			),
			destination: GPUTexelCopyTextureInfo(
				texture: texture,
				mipLevel: 0,
				origin: GPUOrigin3D(x: 0, y: 0, z: 0),
				aspect: .all
			),
			copySize: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1)
		)

		// Step 2: Texture -> Buffer
		encoder.copyTextureToBuffer(
			source: GPUTexelCopyTextureInfo(
				texture: texture,
				mipLevel: 0,
				origin: GPUOrigin3D(x: 0, y: 0, z: 0),
				aspect: .all
			),
			destination: GPUTexelCopyBufferInfo(
				layout: GPUTexelCopyBufferLayout(
					offset: 0,
					bytesPerRow: bytesPerRow,
					rowsPerImage: height
				),
				buffer: dstBuffer
			),
			copySize: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1)
		)

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commands: [commandBuffer])

		// Read back and verify
		let result: [UInt8] = dstBuffer.readData(instance: instance, count: totalBytes)

		print("DEBUG: First pixel (BGRA): \(result[0]), \(result[1]), \(result[2]), \(result[3])")

		// Verify all pixels
		for i in 0..<pixelCount {
			#expect(result[i * 4 + 0] == 0)    // B
			#expect(result[i * 4 + 1] == 0)    // G
			#expect(result[i * 4 + 2] == 255)  // R
			#expect(result[i * 4 + 3] == 255)  // A
		}
	}

	/// Test that writeTexture + readPixels works correctly (isolates the render issue)
	@Test("Write and read texture directly")
	@MainActor
	func testWriteAndReadTexture() {
		let (instance, _, device) = setupGPU()

		// Create texture with copyDst for writeTexture and copySrc for readback
		let texture = device.createTexture(
			descriptor: GPUTextureDescriptor(
				label: "Test Texture",
				usage: [.copySrc, .copyDst],
				dimension: ._2D,
				size: GPUExtent3D(width: 64, height: 64, depthOrArrayLayers: 1),
				format: .BGRA8Unorm
			)
		)

		// Create 64x64 red pixels in BGRA format: (B=0, G=0, R=255, A=255)
		let pixelCount = 64 * 64
		var pixelData = [UInt8](repeating: 0, count: pixelCount * 4)
		for i in 0..<pixelCount {
			pixelData[i * 4 + 0] = 0    // B
			pixelData[i * 4 + 1] = 0    // G
			pixelData[i * 4 + 2] = 255  // R
			pixelData[i * 4 + 3] = 255  // A
		}

		// Write pixels to texture
		pixelData.withUnsafeBytes { buffer in
			device.queue.writeTexture(
				destination: GPUTexelCopyTextureInfo(
					texture: texture,
					mipLevel: 0,
					origin: GPUOrigin3D(x: 0, y: 0, z: 0),
					aspect: .all
				),
				data: buffer,
				dataLayout: GPUTexelCopyBufferLayout(
					offset: 0,
					bytesPerRow: 64 * 4,
					rowsPerImage: 64
				),
				writeSize: GPUExtent3D(width: 64, height: 64, depthOrArrayLayers: 1)
			)
		}

		// Read back pixels
		let pixels = readPixels(
			from: texture,
			device: device,
			instance: instance,
			width: 64,
			height: 64
		)

		print("DEBUG: First pixel (BGRA): \(pixels[0]), \(pixels[1]), \(pixels[2]), \(pixels[3])")

		// Verify all pixels are red (B=0, G=0, R=255, A=255)
		for i in 0..<pixelCount {
			#expect(pixels[i * 4 + 0] == 0)    // B
			#expect(pixels[i * 4 + 1] == 0)    // G
			#expect(pixels[i * 4 + 2] == 255)  // R
			#expect(pixels[i * 4 + 3] == 255)  // A
		}
	}

	@Test("Render solid red to offscreen texture")
	@MainActor
	func testRenderSolidRed() {
		let (instance, _, device) = setupGPU()
		print("DEBUG: Device created")

		let texture = device.createRenderTargetTexture()
		print("DEBUG: Texture created")

		// Create and store the texture view to ensure it stays alive
		let textureView = texture.createView()
		print("DEBUG: TextureView created")

		let shaderCode = """
			@vertex
			fn vertexMain(@builtin(vertex_index) idx: u32) -> @builtin(position) vec4f {
			    // Full-screen triangle (CCW winding in NDC where Y points up)
			    var pos = array<vec2f, 3>(
			        vec2f(-1.0, -1.0),
			        vec2f(-1.0,  3.0),
			        vec2f( 3.0, -1.0)
			    );
			    return vec4f(pos[idx], 0.0, 1.0);
			}

			@fragment
			fn fragmentMain() -> @location(0) vec4f {
			    return vec4f(1.0, 0.0, 0.0, 1.0); // Solid red
			}
			"""
		// Load wgsl shader module
		let shaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Test Shader", code: shaderCode)
		)
		print("DEBUG: ShaderModule created")

		let pipeline = device.createSimpleRenderPipeline(label: "Test Pipeline", shaderModule: shaderModule)
		print("DEBUG: Pipeline created")

		// Step 5: Render - create command encoder, begin render pass, draw, end, submit
		let encoder = device.createCommandEncoder(
			descriptor: GPUCommandEncoderDescriptor(label: "Test Encoder")
		)
		print("DEBUG: CommandEncoder created")

		let renderPassDescriptor = GPURenderPassDescriptor(
			label: "Test Render Pass",
			colorAttachmentCount: 1,
			colorAttachments: [
				GPURenderPassColorAttachment(
					view: textureView,
					loadOp: .clear,
					storeOp: .store,
					clearValue: GPUColor(r: 0, g: 0, b: 0, a: 1)  // Clear to black first
				)
			]
		)
		print("DEBUG: RenderPassDescriptor created")

		let renderPass = encoder.beginRenderPass(descriptor: renderPassDescriptor)
		print("DEBUG: RenderPass began")

		renderPass.setPipeline(pipeline: pipeline)
		print("DEBUG: Pipeline set")
		renderPass.draw(vertexCount: 3, instanceCount: 1, firstVertex: 0, firstInstance: 0)  // Draw full-screen triangle
		print("DEBUG: Draw called")
		renderPass.end()
		print("DEBUG: RenderPass ended")

		let commandBuffer = encoder.finish(descriptor: nil)!
		print("DEBUG: CommandBuffer finished")
		device.queue.submit(commands: [commandBuffer])
		print("DEBUG: Commands submitted")

		let pixels = readPixels(
			from: texture,
			device: device,
			instance: instance,
			width: 64,
			height: 64
		)
		print("DEBUG: Pixels read, count: \(pixels.count)")

		// Print first few pixel values for debugging
		if pixels.count >= 4 {
			print("DEBUG: First pixel (BGRA): \(pixels[0]), \(pixels[1]), \(pixels[2]), \(pixels[3])")
		}

		pixels.withUnsafeBufferPointer { buffer in
			savePPM(destFileName: "test-render.ppm", bgra: buffer.baseAddress!, w: 64, h: 64)
		}

		// Verify all pixels are red (B=0, G=0, R=255, A=255)
		let pixelCount = 64 * 64
		for i in 0..<pixelCount {
			#expect(pixels[i * 4 + 0] == 0)
			#expect(pixels[i * 4 + 1] == 0)
			#expect(pixels[i * 4 + 2] == 255)
			#expect(pixels[i * 4 + 3] == 255)
		}
	}
}
