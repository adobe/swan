import Dawn
import DemoUtils
import Foundation
import RGFW

let workgroupSize: UInt32 = 8
let gridSize: Int = 32
let updateInterval: Double = 0.2  // Update every 200ms (5 times/sec)

struct GameOfLifeDemo: DemoProvider {
	private var device: GPUDevice?
	private var surface: GPUSurface?
	private var vertexBuffer: GPUBuffer?
	private var uniformBuffer: GPUBuffer?
	private var cellStateStorage: [GPUBuffer] = []
	private var cellPipeline: GPURenderPipeline?
	private var simulationPipeline: GPUComputePipeline?
	private var bindGroups: [GPUBindGroup] = []
	private var step: UInt32 = 0
	private var nextUpdateTime: Double = 0

	@MainActor
	mutating func initialize(device: GPUDevice, format: GPUTextureFormat, surface: GPUSurface) {
		self.device = device
		self.surface = surface
		// Create vertex buffer
		let vertices: [Float32] = [
			-0.8, -0.8, 0.8, -0.8, 0.8, 0.8, -0.8, -0.8, 0.8, 0.8, -0.8, 0.8,
		]
		self.vertexBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "vertex buffer",
				usage: [.vertex, .copyDst],
				size: vertices.lengthInBytes,
				mappedAtCreation: false
			)
		)!
		vertices.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: vertexBuffer!,
				bufferOffset: 0,
				data: data
			)
		}

		// Create uniform buffer
		let uniformArray = [Float32(gridSize), Float32(gridSize)]
		self.uniformBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Grid Uniforms",
				usage: [.uniform, .copyDst],
				size: UInt64(uniformArray.lengthInBytes),
			)
		)
		uniformArray.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: uniformBuffer!,
				bufferOffset: 0,
				data: data
			)
		}

		// Create cell state storage buffers
		let cellStateArraySize: UInt64 = UInt64(gridSize * gridSize * MemoryLayout<Float32>.size)
		self.cellStateStorage = [
			device.createBuffer(
				descriptor: GPUBufferDescriptor(
					label: "Cell State A",
					usage: [.storage, .copyDst],
					size: cellStateArraySize
				)
			)!,
			device.createBuffer(
				descriptor: GPUBufferDescriptor(
					label: "Cell State B",
					usage: [.storage, .copyDst],
					size: cellStateArraySize
				)
			)!,
		]
		// Initialize cell state with random values
		let gridCount = gridSize * gridSize
		let cellStateArray = Array(unsafeUninitializedCapacity: gridCount) {
			(arrayBuffer: inout UnsafeMutableBufferPointer<UInt32>, initializedCount: inout Int) in
			for i: Int in 0..<gridCount {
				arrayBuffer[i] = Double.random(in: 0...1) > 0.6 ? 1 : 0
			}
			initializedCount = gridCount
		}
		cellStateArray.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: cellStateStorage[0],
				bufferOffset: 0,
				data: data
			)
		}
		let cellStateArray2 = Array(unsafeUninitializedCapacity: gridCount) {
			(arrayBuffer: inout UnsafeMutableBufferPointer<UInt32>, initializedCount: inout Int) in
			for i: Int in 0..<gridCount {
				arrayBuffer[i] = Double.random(in: 0...1) > 0.6 ? 1 : 0
			}
			initializedCount = gridCount
		}
		cellStateArray2.withUnsafeBytes { data in
			device.queue.writeBuffer(
				buffer: cellStateStorage[1],
				bufferOffset: 0,
				data: data
			)
		}

		// Create shader modules
		let cellShaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Cell shader", code: cellShader)
		)
		let simulationShaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Game of Life simulation shader", code: simulationComputeShader)
		)

		// Create bind group layout
		let bindGroupLayout = device.createBindGroupLayout(
			descriptor: GPUBindGroupLayoutDescriptor(
				label: "Cell Bind Group Layout",
				entryCount: 3,
				entries: [
					GPUBindGroupLayoutEntry(
						binding: 0,
						visibility: GPUShaderStage([.vertex, .compute, .fragment]),
						buffer: GPUBufferBindingLayout()
					),
					GPUBindGroupLayoutEntry(
						binding: 1,
						visibility: GPUShaderStage([.vertex, .compute]),
						buffer: GPUBufferBindingLayout(type: .readOnlyStorage)
					),
					GPUBindGroupLayoutEntry(
						binding: 2,
						visibility: GPUShaderStage([.compute]),
						buffer: GPUBufferBindingLayout(type: .storage)
					),
				]
			)
		)

		// Create bind groups
		self.bindGroups = [
			device.createBindGroup(
				descriptor: GPUBindGroupDescriptor(
					label: "Cell renderer bind group A",
					layout: bindGroupLayout,
					entryCount: 3,
					entries: [
						GPUBindGroupEntry(binding: 0, buffer: uniformBuffer!),
						GPUBindGroupEntry(binding: 1, buffer: cellStateStorage[0]),
						GPUBindGroupEntry(binding: 2, buffer: cellStateStorage[1]),
					]
				)
			),
			device.createBindGroup(
				descriptor: GPUBindGroupDescriptor(
					label: "Cell renderer bind group B",
					layout: bindGroupLayout,
					entryCount: 3,
					entries: [
						GPUBindGroupEntry(binding: 0, buffer: uniformBuffer!),
						GPUBindGroupEntry(binding: 1, buffer: cellStateStorage[1]),
						GPUBindGroupEntry(binding: 2, buffer: cellStateStorage[0]),
					]
				)
			),
		]

		// Create pipeline layout
		let pipelineLayout = device.createPipelineLayout(
			descriptor: GPUPipelineLayoutDescriptor(
				label: "Cell Pipeline Layout",
				bindGroupLayoutCount: 1,
				bindGroupLayouts: [bindGroupLayout]
			)
		)

		// Create render pipeline
		self.cellPipeline = device.createRenderPipeline(
			descriptor: GPURenderPipelineDescriptor(
				label: "Cell pipeline",
				layout: pipelineLayout,
				vertex: GPUVertexState(
					module: cellShaderModule,
					entryPoint: "vertexMain",
					bufferCount: 1,
					buffers: [
						GPUVertexBufferLayout(
							arrayStride: 8,
							attributeCount: 1,
							attributes: [
								GPUVertexAttribute(format: .float32x2, offset: 0, shaderLocation: 0)
							]
						)
					]
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
					module: cellShaderModule,
					entryPoint: "fragmentMain",
					targetCount: 1,
					targets: [GPUColorTargetState(format: format)]
				)
			)
		)

		// Create compute pipeline
		self.simulationPipeline = device.createComputePipeline(
			descriptor: GPUComputePipelineDescriptor(
				// label: "Simulation pipeline",
				layout: pipelineLayout,
				compute: GPUComputeState(
					module: simulationShaderModule,
					entryPoint: "computeMain"
				)
			)
		)
	}

	func renderToTexture(destTexture: GPUTexture, encoder: GPUCommandEncoder) {
		// Render pass
		let pass = encoder.beginRenderPass(
			descriptor: GPURenderPassDescriptor(
				label: "render pass",
				colorAttachmentCount: 1,
				colorAttachments: [
					GPURenderPassColorAttachment(
						view: destTexture.createView(),
						loadOp: .clear,
						storeOp: .store,
						clearValue: GPUColor(r: 0, g: 0, b: 0.4, a: 1)
					)
				]
			)
		)

		pass.setPipeline(pipeline: cellPipeline!)
		pass.setVertexBuffer(slot: 0, buffer: vertexBuffer!, offset: 0, size: vertexBuffer!.size)
		pass.setBindGroup(
			groupIndex: 0,
			group: bindGroups[Int(step % 2)],
			dynamicOffsetCount: 0,
			dynamicOffsets: []
		)
		pass.draw(vertexCount: 6, instanceCount: UInt32(gridSize * gridSize), firstVertex: 0, firstInstance: 0)
		pass.end()
	}

	func screenShotRender(encoder: GPUCommandEncoder, w: Int, h: Int, format: GPUTextureFormat) -> GPUBuffer {
		guard let device: GPUDevice = self.device else {
			fatalError("Device not initialized")
		}
		let targetTexture: GPUTexture = device.createTexture(
			descriptor: GPUTextureDescriptor(
				label: "Temp screenshot",
				usage: [GPUTextureUsage.copySrc, GPUTextureUsage.renderAttachment],
				dimension: GPUTextureDimension._2D,  // unsigthly _, probably no way around it though?
				size: GPUExtent3D(width: UInt32(w), height: UInt32(h), depthOrArrayLayers: 1),  // note: should have default value for depthOrArrayLayers
				format: format
			)
		)
			;
		let readbackBuffer: GPUBuffer = device.createBuffer(
			descriptor: GPUBufferDescriptor(
				label: "Temp screenshot",
				usage: [GPUBufferUsage.copyDst, GPUBufferUsage.mapRead],
				size: UInt64(w * h * 4),  // consider: should we map those to swift Int instead?
				mappedAtCreation: false
			)
		)!  // unclear why this returns an optional (create texture does not)

		renderToTexture(destTexture: targetTexture, encoder: encoder)

		encoder.copyTextureToBuffer(
			source: GPUTexelCopyTextureInfo(
				texture: targetTexture,
				mipLevel: 0,
				origin: GPUOrigin3D(x: 0, y: 0, z: 0),
				aspect: WGPUTextureAspect.all
			),
			destination: GPUTexelCopyBufferInfo(
				layout: GPUTexelCopyBufferLayout(
					offset: 0,
					bytesPerRow: UInt32(w * 4),
					rowsPerImage: UInt32(h)
				),
				buffer: readbackBuffer
			),
			copySize: GPUExtent3D(width: UInt32(w), height: UInt32(h), depthOrArrayLayers: 1)
		)
		return readbackBuffer
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

	func screenshotReadback(readbackBuffer: GPUBuffer, w: Int, h: Int) {
		// inconsistent: sizes here are Ints
		print("Readback started...");
		let _ = readbackBuffer.mapAsync(
			mode: GPUMapMode.read,
			offset: 0,
			size: Int(readbackBuffer.size),
			callbackInfo: GPUBufferMapCallbackInfo(
				mode: GPUCallbackMode.allowProcessEvents,
				callback: { status, message in
					if (status != GPUMapAsyncStatus.success) {
						fatalError(message ?? "map async failed");
					}
					guard
						let ptr: UnsafeRawPointer = readbackBuffer.getConstMappedRange(
							offset: 0,
							size: Int(readbackBuffer.size)
						)
					else {
						fatalError("map returned null pointer");
					}
					print("Readback ok!")

					let ptr2: UnsafePointer<UInt8> = ptr.bindMemory(to: UInt8.self, capacity: Int(readbackBuffer.size))
					savePPM(destFileName: "myshot.ppm", bgra: ptr2, w: w, h: h);

					readbackBuffer.unmap();
					readbackBuffer.destroy();
				}
			)
		);
	}

	@MainActor
	mutating func frame(time: Double) throws -> Bool {
		guard let device = device else {
			fatalError("Device not initialized")
		}
		guard let surface = surface else {
			fatalError("Surface not initialized")
		}

		let sPressed = RGFW_isKeyReleased(UInt8(RGFW_s)) != 0;

		if time >= nextUpdateTime || sPressed {
			nextUpdateTime = time + updateInterval
		} else {
			return true
		}

		let encoder = device.createCommandEncoder(descriptor: GPUCommandEncoderDescriptor(label: "command encoder"))

		// Compute pass
		let computePass = encoder.beginComputePass(descriptor: GPUComputePassDescriptor(label: "compute pass"))
		computePass.setPipeline(pipeline: simulationPipeline!)
		computePass.setBindGroup(
			groupIndex: 0,
			group: bindGroups[Int(step % 2)],
			dynamicOffsetCount: 0,
			dynamicOffsets: []
		)
		let workgroupCount = UInt32(ceil(Double(gridSize) / Double(workgroupSize)))
		computePass.dispatchWorkgroups(
			workgroupCountX: workgroupCount,
			workgroupCountY: workgroupCount,
			workgroupCountZ: 1
		)
		computePass.end()

		step += 1

		let backbuffer = surface.getCurrentTexture();
		renderToTexture(destTexture: backbuffer, encoder: encoder)

		var screenShotRenderedBuffer: GPUBuffer?;
		let screenShotW = 1024;
		let screenShotH = 600;

		if (sPressed) {
			print("Screen shot!")
			screenShotRenderedBuffer = self.screenShotRender(
				encoder: encoder,
				w: screenShotW,
				h: screenShotH,
				format: backbuffer.format
			)
		}

		let commandBuffer = encoder.finish(descriptor: nil)!
		device.queue.submit(commandCount: 1, commands: [commandBuffer])

		if let screenShotRenderedBuffer2 = screenShotRenderedBuffer {
			self.screenshotReadback(readbackBuffer: screenShotRenderedBuffer2, w: screenShotW, h: screenShotH)
			screenShotRenderedBuffer = nil;
		}

		surface.present()

		return true
	}
}

@main
struct Main {
	static func main() throws {
		try runDemo(title: "Game of Life", provider: GameOfLifeDemo())
	}
}
