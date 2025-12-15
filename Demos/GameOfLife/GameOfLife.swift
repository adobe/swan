import Dawn
import DemoUtils
import Foundation

let workgroupSize: UInt32 = 8
let gridSize: Int = 32
let updateInterval: Double = 0.2  // Update every 200ms (5 times/sec)

@main
struct Main {
	static func main() throws {
		try runDemo(title: "Game of Life") { surface, device, loop, format in
			// Create vertex buffer
			let vertices: [Float32] = [
				-0.8, -0.8, 0.8, -0.8, 0.8, 0.8, -0.8, -0.8, 0.8, 0.8, -0.8, 0.8,
			]
			let vertexBuffer = device.createBuffer(
				descriptor: .init(
					label: "vertex buffer",
					usage: [.vertex, .copyDst],
					size: vertices.lengthInBytes,
					mappedAtCreation: false
				)
			)!
			device.queue.writeBuffer(
				buffer: vertexBuffer,
				bufferOffset: 0,
				data: .init(vertices),
				size: Int(vertices.lengthInBytes)
			)

			// Create uniform buffer
			let uniformArray = [Float32(gridSize), Float32(gridSize)]
			let uniformBuffer = device.createBuffer(
				descriptor: .init(
					label: "Grid Uniforms",
					usage: [.uniform, .copyDst],
					size: UInt64(uniformArray.lengthInBytes),
				)
			)
			device.queue.writeBuffer(
				buffer: uniformBuffer,
				bufferOffset: 0,
				data: .init(uniformArray),
				// TODO: Shouldn't have to pass size
				size: Int(uniformArray.lengthInBytes)
			)

			// Create cell state storage buffers
			let cellStateArraySize: UInt64 = UInt64(gridSize * gridSize * MemoryLayout<Float32>.size)
			let cellStateStorage: [GPUBuffer] = [
				device.createBuffer(
					descriptor: .init(
						label: "Cell State A",
						usage: [.storage, .copyDst],
						size: cellStateArraySize
					)
				)!,
				device.createBuffer(
					descriptor: .init(
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
			device.queue.writeBuffer(
				buffer: cellStateStorage[0],
				bufferOffset: 0,
				data: .init(cellStateArray),
				// TODO: Shouldn't have to pass size
				size: Int(cellStateArray.lengthInBytes)
			)
			let cellStateArray2 = Array(unsafeUninitializedCapacity: gridCount) {
				(arrayBuffer: inout UnsafeMutableBufferPointer<UInt32>, initializedCount: inout Int) in
				for i: Int in 0..<gridCount {
					arrayBuffer[i] = Double.random(in: 0...1) > 0.6 ? 1 : 0
				}
				initializedCount = gridCount
			}
			device.queue.writeBuffer(
				buffer: cellStateStorage[1],
				bufferOffset: 0,
				data: .init(cellStateArray2),
				// TODO: Shouldn't have to pass size
				size: Int(cellStateArray2.lengthInBytes)
			)

			// Create shader modules
			let cellShaderModule = device.createShaderModule(
				descriptor: .init(label: "Cell shader", code: cellShader)
			)
			let simulationShaderModule = device.createShaderModule(
				descriptor: .init(label: "Game of Life simulation shader", code: simulationComputeShader)
			)

			// Create bind group layout
			let bindGroupLayout = device.createBindGroupLayout(
				descriptor: .init(
					label: "Cell Bind Group Layout",
					entryCount: 3,
					entries: [
						.init(
							binding: 0,
							visibility: GPUShaderStage([.vertex, .compute, .fragment]),
							buffer: .init()
						),
						.init(
							binding: 1,
							visibility: GPUShaderStage([.vertex, .compute]),
							buffer: .init(type: .readOnlyStorage)
						),
						.init(
							binding: 2,
							visibility: GPUShaderStage([.compute]),
							buffer: .init(type: .storage)
						),
					]
				)
			)

			// Create bind groups
			let bindGroups = [
				device.createBindGroup(
					descriptor: .init(
						label: "Cell renderer bind group A",
						layout: bindGroupLayout,
						entryCount: 3,
						entries: [
							.init(binding: 0, buffer: uniformBuffer),
							.init(binding: 1, buffer: cellStateStorage[0]),
							.init(binding: 2, buffer: cellStateStorage[1]),
						]
					)
				),
				device.createBindGroup(
					descriptor: .init(
						label: "Cell renderer bind group B",
						layout: bindGroupLayout,
						entryCount: 3,
						entries: [
							.init(binding: 0, buffer: uniformBuffer),
							.init(binding: 1, buffer: cellStateStorage[1]),
							.init(binding: 2, buffer: cellStateStorage[0]),
						]
					)
				),
			]

			// Create pipeline layout
			let pipelineLayout = device.createPipelineLayout(
				descriptor: .init(
					label: "Cell Pipeline Layout",
					bindGroupLayoutCount: 1,
					bindGroupLayouts: [bindGroupLayout]
				)
			)

			// Create render pipeline
			let cellPipeline = device.createRenderPipeline(
				descriptor: .init(
					label: "Cell pipeline",
					layout: .init(pipelineLayout),
					vertex: .init(
						module: cellShaderModule,
						entryPoint: "vertexMain",
						bufferCount: 1,
						buffers: [
							.init(
								arrayStride: 8,
								attributeCount: 1,
								attributes: [
									.init(format: .float32x2, offset: 0, shaderLocation: 0)
								]
							)
						]
					),
					primitive: .init(
						topology: .triangleList,
						stripIndexFormat: .undefined,
						frontFace: .CCW,
						cullMode: .none
					),
					multisample: .init(
						count: 1,
						mask: 0xFFFFFFFF,
						alphaToCoverageEnabled: false
					),
					fragment: .init(
						module: cellShaderModule,
						entryPoint: "fragmentMain",
						targetCount: 1,
						targets: [.init(format: format)]
					)
				)
			)

			// Create compute pipeline
			let simulationPipeline = device.createComputePipeline(
				descriptor: .init(
					// label: "Simulation pipeline",
					layout: .init(pipelineLayout),
					compute: .init(
						module: simulationShaderModule,
						entryPoint: "computeMain"
					)
				)
			)

			var step: UInt32 = 0
			var nextUpdateTime = Date()
			try loop {
				let now = Date()
				if now >= nextUpdateTime {
					nextUpdateTime = now + updateInterval
				} else {
					return
				}

				let encoder = device.createCommandEncoder(descriptor: .init(label: "command encoder"))

				// Compute pass
				let computePass = encoder.beginComputePass(descriptor: .init(label: "compute pass"))
				computePass.setPipeline(pipeline: simulationPipeline)
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

				// Render pass
				let pass = encoder.beginRenderPass(
					descriptor: .init(
						label: "render pass",
						colorAttachmentCount: 1,
						colorAttachments: [
							GPURenderPassColorAttachment(
								view: surface.getCurrentTexture().createView(),
								loadOp: .clear,
								storeOp: .store,
								clearValue: .init(r: 0, g: 0, b: 0.4, a: 1),
							)
						]
					)
				)

				pass.setPipeline(pipeline: cellPipeline)
				pass.setVertexBuffer(slot: 0, buffer: vertexBuffer, offset: 0, size: vertexBuffer.size)
				pass.setBindGroup(
					groupIndex: 0,
					group: bindGroups[Int(step % 2)],
					dynamicOffsetCount: 0,
					dynamicOffsets: []
				)
				pass.draw(vertexCount: 6, instanceCount: UInt32(gridSize * gridSize), firstVertex: 0, firstInstance: 0)
				pass.end()

				let commandBuffer = encoder.finish(descriptor: nil)!
				device.queue.submit(commandCount: 1, commands: [commandBuffer])

				surface.present()
			}
		}
	}
}
