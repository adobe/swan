// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation
import WebGPU

final class Renderer {
	struct Shaders {
		var cell: String
		var simulation: String
	}

	// Constants
	private let workgroupSize: UInt32 = 8
	private let gridSize: Int = 32
	private let updateInterval: Double = 200  // Update every 200ms (5 times/sec)

	// WebGPU objects
	let device: WGPUDevice
	let surface: WGPUSurface
	// let format: GPUTextureFormat
	// let cellPipeline: WGPURenderPipeline
	// let simulationPipeline: WGPUComputePipeline
	let bindGroupLayout: WGPUBindGroupLayout
	// let bindGroups: [WGPUBindGroup]

	// Buffers
	private let vertexBuffer: WGPUBuffer
	private let uniformBuffer: WGPUBuffer
	private let cellStateStorage: [WGPUBuffer]

	// // State
	// private var step: UInt32 = 0
	// private var lastUpdateTime: Double = 0
	// private var lastTick: Double = 0
	// private var time: Double = 0

	init(
		device: WGPUDevice,
		surface: WGPUSurface,
		format: GPUTextureFormat,
		shaders: Shaders
	) throws {
		self.device = device
		self.surface = surface

		// surface.configure(
		// 	configuration: .init(
		// 		device: device,
		// 		format: format,
		// 		width: 1024,
		// 		height: 1024,
		// 	)
		// )

		// Create vertex buffer
		let vertices: [Float32] = [
			-0.8, -0.8, 0.8, -0.8, 0.8, 0.8, -0.8, -0.8, 0.8, 0.8, -0.8, 0.8,
		]
		vertexBuffer = device.createBuffer(
			descriptor: .init(
				label: "vertex buffer",
				usage: .vertex,
				size: vertices.lengthInBytes,
				mappedAtCreation: false
			)
		)
		device.queue.writeBuffer(
			buffer: vertexBuffer,
			bufferOffset: 0,
			data: .init(vertices),
			size: Int(vertices.lengthInBytes)
		)

		// Create uniform buffer
		let uniformArray = [Float32](repeating: 0, count: gridSize * gridSize)
		uniformBuffer = device.createBuffer(
			descriptor: .init(
				label: "uniform buffer",
				usage: .uniform,
				size: uniformArray.lengthInBytes,
				mappedAtCreation: false
			)
		)
		device.queue.writeBuffer(
			buffer: uniformBuffer,
			bufferOffset: 0,
			data: .init(uniformArray),
			size: Int(uniformArray.lengthInBytes)
		)

		// Create cell state storage buffers
		let cellStateArraySize = gridSize * gridSize * MemoryLayout<Float32>.size
		let descriptor = GPUBufferDescriptor(
			label: "cell state storage",
			usage: [.storage, .copyDst],
			size: UInt64(cellStateArraySize),
			mappedAtCreation: false
		)
		cellStateStorage = [
			device.createBuffer(
				descriptor: descriptor
			),
			device.createBuffer(
				descriptor: descriptor
			),
		]

		// Initialize cell state with random values
		var cellStateArray = [UInt32](repeating: 0, count: gridSize * gridSize)
		for i in 0..<(gridSize * gridSize) {
			cellStateArray[i] = Double.random(in: 0...1) > 0.6 ? 1 : 0
		}
		device.queue.writeBuffer(
			buffer: cellStateStorage[0],
			bufferOffset: 0,
			data: .init(cellStateArray),
			size: Int(cellStateArray.lengthInBytes)
		)
		device.queue.writeBuffer(
			buffer: cellStateStorage[1],
			bufferOffset: 0,
			data: .init(cellStateArray),
			size: Int(cellStateArray.lengthInBytes)
		)

		let cellShaderModule = device.createShaderModule(
			descriptor: .init(
				label: "cell shader",
				code: shaders.cell
			)
		)

		let simulationShaderModule = device.createShaderModule(
			descriptor: .init(
				label: "simulation shader",
				code: shaders.simulation
			)
		)

		// Create bind group layout
		bindGroupLayout = device.createBindGroupLayout(
			descriptor: .init(
				label: "Cell Bind Group Layout",
				entries: [
					.init(
						binding: 0,
						visibility: [.vertex, .compute, .fragment],
						buffer: .init()
					),
					.init(
						binding: 1,
						visibility: [.vertex, .compute],
						buffer: .init(type: .readOnlyStorage)
					),
					.init(
						binding: 2,
						visibility: [.compute],
						buffer: .init(type: .storage)
					),
				]
			)
		)

		// Create bind groups
		// bindGroups = [
		// 	device.createBindGroup(
		// 		descriptor: .init(
		// 			label: "Cell renderer bind group A",
		// 			layout: bindGroupLayout,
		// 			entries: [
		// 				.init(binding: 0, resource: WGPUBindingResource(.init(buffer: uniformBuffer))),
		// 				.init(binding: 1, resource: WGPUBindingResource(.init(buffer: cellStateStorage[0]))),
		// 				.init(binding: 2, resource: WGPUBindingResource(.init(buffer: cellStateStorage[1]))),
		// 			]
		// 		)
		// 	),
		// 	device.createBindGroup(
		// 		descriptor: .init(
		// 			label: "Cell renderer bind group B",
		// 			layout: bindGroupLayout,
		// 			entries: [
		// 				.init(binding: 0, resource: WGPUBindingResource(.init(buffer: uniformBuffer))),
		// 				.init(binding: 1, resource: WGPUBindingResource(.init(buffer: cellStateStorage[1]))),
		// 				.init(binding: 2, resource: WGPUBindingResource(.init(buffer: cellStateStorage[0]))),
		// 			]
		// 		)
		// 	),
		// ]

		// 	// Create pipeline layout
		// 	let pipelineLayout = device.createPipelineLayout(
		// 		descriptor: .init(
		// 			label: "Cell Pipeline Layout",
		// 			bindGroupLayouts: [bindGroupLayout]
		// 		)
		// 	)

		// 	// Create render pipeline
		// 	cellPipeline = device.createRenderPipeline(
		// 		descriptor: .init(
		// 			// label: "Cell pipeline",
		// 			layout: .init(pipelineLayout),
		// 			vertex: .init(
		// 				module: cellShaderModule,
		// 				entryPoint: "vertexMain",
		// 				buffers: [
		// 					.init(
		// 						arrayStride: 8,
		// 						attributes: [
		// 							.init(format: .float32x2, offset: 0, shaderLocation: 0)
		// 						]
		// 					)
		// 				]
		// 			),
		// 			fragment: .init(
		// 				module: cellShaderModule,
		// 				entryPoint: "fragmentMain",
		// 				targets: [.init(format: format)]
		// 			)
		// 		)
		// 	)

		// 	// Create compute pipeline
		// 	simulationPipeline = device.createComputePipeline(
		// 		descriptor: .init(
		// 			// label: "Simulation pipeline",
		// 			layout: .init(pipelineLayout),
		// 			compute: .init(
		// 				module: simulationShaderModule,
		// 				entryPoint: "computeMain"
		// 			)
		// 		)
		// 	)
	}

	// func updateGrid() {
	// 	let encoder = device.createCommandEncoder(descriptor: .init(label: "command encoder"))

	// 	// Compute pass
	// 	let computePass = encoder.beginComputePass(descriptor: .init(label: "compute pass"))
	// 	computePass.setPipeline(pipeline: simulationPipeline)
	// 	computePass.setBindGroup(index: 0, bindGroup: bindGroups[Int(step % 2)])
	// 	let workgroupCount = UInt32(ceil(Double(gridSize) / Double(workgroupSize)))
	// 	computePass.dispatchWorkgroups(
	// 		workgroupCountX: WGPUSize32(workgroupCount),
	// 		workgroupCountY: WGPUSize32(workgroupCount)
	// 	)
	// 	computePass.end()

	// 	step += 1

	// 	// Render pass
	// 	let pass = encoder.beginRenderPass(
	// 		descriptor: .init(
	// 			label: "render pass",
	// 			colorAttachments: [
	// 				WGPURenderPassColorAttachment(
	// 					view: context.getCurrentTexture().createView(),
	// 					clearValue: .init([0, 0, 0.4, 1]),
	// 					loadOp: .clear,
	// 					storeOp: .store
	// 				)
	// 			]
	// 		)
	// 	)

	// 	pass.setPipeline(pipeline: cellPipeline)
	// 	pass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
	// 	pass.setBindGroup(index: 0, bindGroup: bindGroups[Int(step % 2)])
	// 	pass.draw(vertexCount: 6, instanceCount: WGPUSize32(gridSize * gridSize))
	// 	pass.end()

	// 	let commandBuffer = encoder.finish()
	// 	device.queue.submit(commandBuffers: [commandBuffer])
	// }

	// func update(delta: Double) {
	// 	// Check if it's time to update the grid
	// 	if time - lastUpdateTime >= updateInterval {
	// 		updateGrid()
	// 		lastUpdateTime = time
	// 	}
	// }

	// func render(timestamp: Double) {
	// 	let delta = max(0.0, timestamp - lastTick)
	// 	lastTick = timestamp
	// 	time += delta
	// 	self.update(delta: delta)
	// }
}
