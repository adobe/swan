// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation

public extension Array {
	/// The length of the array in bytes.
	var lengthInBytes: UInt64 {
		return UInt64(count * MemoryLayout<Element>.size)
	}
}

public extension GPUShaderModuleDescriptor {
	// Init compatible with the web version
	init(label: String, code: String) {
		self.init(label: label)
		nextInChain = GPUShaderSourceWGSL(code: code)
	}
}

public extension GPUSurface {
	/// Get the current texture from the surface.
	func getCurrentTexture() -> GPUTexture {
		var surfaceTexture = WGPUSurfaceTexture()
		getCurrentTexture(surfaceTexture: &surfaceTexture)
		return surfaceTexture.texture
	}
}

// hacked up things to make NGE work 

public extension GPUTexture {
	func createView() -> GPUTextureView {
		createView(descriptor: nil)
	}
}

public extension GPUDevice {
	func createCommandEncoder() -> GPUCommandEncoder {
		return self.createCommandEncoder(descriptor: nil)
	}
}

public extension GPUCommandEncoder {
	func beginComputePass() -> GPUComputePassEncoder {
		return self.beginComputePass(descriptor: nil)
	}

	func finish() -> GPUCommandBuffer {
		return self.finish(descriptor: nil)! // why is this optional
	}

	func clearBuffer(buffer: GPUBuffer?, offset: UInt64 = UInt64(0), size: UInt64 = UInt64.max, hasDefaults : Bool = true) {
		self.clearBuffer(buffer: buffer, offset: offset, size: size)
	}
}

public extension GPUComputePassEncoder {
	func dispatchWorkgroups(workgroupCountX: UInt32, workgroupCountY: UInt32 = 1, workgroupCountZ: UInt32 = 1, hasDefaults : Bool = true) {
		return self.dispatchWorkgroups(
			workgroupCountX: workgroupCountX,
			workgroupCountY: workgroupCountY,
			workgroupCountZ: workgroupCountZ )
	}

	func setBindGroup(groupIndex: UInt32, group: GPUBindGroup?, dynamicOffsets: [UInt32]? = nil, hasDefaults : Bool = true) {
		self.setBindGroup(
			groupIndex: groupIndex, 
			group: group, 
			dynamicOffsets: dynamicOffsets)
	}
}

public extension GPUExtent3D {
	init ( width: UInt32, height: UInt32 ) {
		self.init(width: width, height: height, depthOrArrayLayers: 1)
	}
}

extension GPUBuffer: @retroactive Equatable {
	public static func == (lhs: GPUBuffer, rhs: GPUBuffer) -> Bool {
		return withUnsafePointer(to: lhs) { 
			lhsPtr in  
			lhsPtr.withMemoryRebound(to: Int.self, capacity: 1) { 
				lhsInt in 
			withUnsafePointer(to: rhs) { 
			rhsPtr in  
			rhsPtr.withMemoryRebound(to: Int.self, capacity: 1) { 
				rhsInt in 
				return rhsInt[0] == lhsInt[0]
		}}}}
	}
}

public extension GPUBuffer {
	// warning: those are actually size_t params which swift translates to Int.
	func getMappedRange(offset: Int = 0, size: Int = -1, hasDefaults : Bool = true) -> UnsafeMutableRawPointer? {
		return self.getMappedRange(offset: offset, size: size)
	}

	// warning: those are actually size_t params which swift translates to Int.
	func getConstMappedRange(offset: Int = 0, size: Int = -1, hasDefaults : Bool = true) -> UnsafeRawPointer? {
		return self.getConstMappedRange(offset: offset, size: size)
	}
}

public extension GPURenderPassEncoder {
	func setIndexBuffer(buffer:GPUBuffer?, format:GPUIndexFormat, offset: UInt64 = 0, size: UInt64 = UInt64.max, hasDefaults : Bool = true) {
		self.setIndexBuffer(buffer: buffer, format: format, offset: offset, size: size)
	}

	func drawIndexed(indexCount:UInt32, instanceCount:UInt32=1, firstIndex:UInt32=0, baseVertex:Int32=0, firstInstance:UInt32=0, hasDefaults : Bool = true) {
		self.drawIndexed(
			indexCount: indexCount, 
			instanceCount: instanceCount, 
			firstIndex: firstIndex, 
			baseVertex: baseVertex, 
			firstInstance: firstInstance)
	}

	func setVertexBuffer(slot : UInt32, buffer : GPUBuffer?, offset : UInt64 = 0, size : UInt64 = UInt64.max, hasDefaults : Bool = true) {
		self.setVertexBuffer(
			slot: slot, 
			buffer: buffer, 
			offset: offset,
			size: size);
	}
}

public extension GPUDevice {
	#if canImport(Metal)
	// When making Metal interop with other APIs, we need to be careful that QueueSubmit
	// doesn't mean that the operations will be visible to other APIs/Metal devices right
	// away. macOS does have a global queue of graphics operations, but the command
	// buffers are inserted there when they are "scheduled". Submitting other operationscd ..

	// before the command buffer is scheduled could lead to races in who gets scheduled
	// first and incorrect rendering.
	//
	// Note:This may become unnecessary once Dawn migrates to commands scheduled futures
	// (crbug.com/444702048).
	func waitForCommandsToBeScheduled() {
		WaitForCommandsToBeScheduled(self)
	}
	#endif
}
