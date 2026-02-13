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
}

public extension GPUComputePassEncoder {
	func dispatchWorkgroups(workgroupCountX: UInt32, workgroupCountY: UInt32 = 1, workgroupCountZ: UInt32 = 1, hasDefaults : Bool = true) {
		return self.dispatchWorkgroups(
			workgroupCountX: workgroupCountX,
			workgroupCountY: workgroupCountY,
			workgroupCountZ: workgroupCountZ )
	}
}

public extension GPUDevice {
	#if canImport(Metal)
	// When making Metal interop with other APIs, we need to be careful that QueueSubmit
	// doesn't mean that the operations will be visible to other APIs/Metal devices right
	// away. macOS does have a global queue of graphics operations, but the command
	// buffers are inserted there when they are "scheduled". Submitting other operations
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
