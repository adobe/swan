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

public extension GPUTextureFormat { 
	func toString() -> String { 
		switch self {
			case .undefined: assert(false); return "undefined"
			case .R8Unorm: return "r8unorm"
			case .R8Snorm: return "r8snorm"
			case .R8Uint: return "r8uint"
			case .R8Sint: return "r8sint"
			case .R16Unorm: return "r16unorm"
			case .R16Snorm: return "r16snorm"
			case .R16Uint: return "r16uint"
			case .R16Sint: return "r16sint"
			case .R16Float: return "r16float"
			case .RG8Unorm: return "rg8unorm"
			case .RG8Snorm: return "rg8snorm"
			case .RG8Uint: return "rg8uint"
			case .RG8Sint: return "rg8sint"
			case .R32Float: return "r32float"
			case .R32Uint: return "r32uint"
			case .R32Sint: return "r32sint"
			case .RG16Unorm: return "rg16unorm"
			case .RG16Snorm: return "rg16snorm"
			case .RG16Uint: return "rg16uint"
			case .RG16Sint: return "rg16sint"
			case .RG16Float: return "rg16float"
			case .RGBA8Unorm: return "rgba8unorm"
			case .RGBA8UnormSrgb: return "rgba8unormsrgb"
			case .RGBA8Snorm: return "rgba8snorm"
			case .RGBA8Uint: return "rgba8uint"
			case .RGBA8Sint: return "rgba8sint"
			case .BGRA8Unorm: return "bgra8unorm"
			case .BGRA8UnormSrgb: return "bgra8unormsrgb"
			case .RGB10A2Uint: return "rgb10a2uint"
			case .RGB10A2Unorm: return "rgb10a2unorm"
			case .RG11B10Ufloat: return "rg11b10ufloat"
			case .RGB9E5Ufloat: return "rgb9e5ufloat"
			case .RG32Float: return "rg32float"
			case .RG32Uint: return "rg32uint"
			case .RG32Sint: return "rg32sint"
			case .RGBA16Unorm: return "rgba16unorm"
			case .RGBA16Snorm: return "rgba16snorm"
			case .RGBA16Uint: return "rgba16uint"
			case .RGBA16Sint: return "rgba16sint"
			case .RGBA16Float: return "rgba16float"
			case .RGBA32Float: return "rgba32float"
			case .RGBA32Uint: return "rgba32uint"
			case .RGBA32Sint: return "rgba32sint"
			case .stencil8: return "stencil8"
			case .depth16Unorm: return "depth16unorm"
			case .depth24Plus: return "depth24plus"
			case .depth24PlusStencil8: return "depth24plusstencil8"
			case .depth32Float: return "depth32float"
			case .depth32FloatStencil8: return "depth32floatstencil8"
			case .BC1RGBAUnorm: return "bc1rgbaunorm"
			case .BC1RGBAUnormSrgb: return "bc1rgbaunormsrgb"
			case .BC2RGBAUnorm: return "bc2rgbaunorm"
			case .BC2RGBAUnormSrgb: return "bc2rgbaunormsrgb"
			case .BC3RGBAUnorm: return "bc3rgbaunorm"
			case .BC3RGBAUnormSrgb: return "bc3rgbaunormsrgb"
			case .BC4RUnorm: return "bc4runorm"
			case .BC4RSnorm: return "bc4rsnorm"
			case .BC5RGUnorm: return "bc5rgunorm"
			case .BC5RGSnorm: return "bc5rgsnorm"
			case .BC6HRGBUfloat: return "bc6hrgbufloat"
			case .BC6HRGBFloat: return "bc6hrgbfloat"
			case .BC7RGBAUnorm: return "bc7rgbaunorm"
			case .BC7RGBAUnormSrgb: return "bc7rgbaunormsrgb"
			case .ETC2RGB8Unorm: return "etc2rgb8unorm"
			case .ETC2RGB8UnormSrgb: return "etc2rgb8unormsrgb"
			case .ETC2RGB8A1Unorm: return "etc2rgb8a1unorm"
			case .ETC2RGB8A1UnormSrgb: return "etc2rgb8a1unormsrgb"
			case .ETC2RGBA8Unorm: return "etc2rgba8unorm"
			case .ETC2RGBA8UnormSrgb: return "etc2rgba8unormsrgb"
			case .EACR11Unorm: return "eacr11unorm"
			case .EACR11Snorm: return "eacr11snorm"
			case .EACRG11Unorm: return "eacrg11unorm"
			case .EACRG11Snorm: return "eacrg11snorm"
			case .ASTC4x4Unorm: return "astc4x4unorm"
			case .ASTC4x4UnormSrgb: return "astc4x4unormsrgb"
			case .ASTC5x4Unorm: return "astc5x4unorm"
			case .ASTC5x4UnormSrgb: return "astc5x4unormsrgb"
			case .ASTC5x5Unorm: return "astc5x5unorm"
			case .ASTC5x5UnormSrgb: return "astc5x5unormsrgb"
			case .ASTC6x5Unorm: return "astc6x5unorm"
			case .ASTC6x5UnormSrgb: return "astc6x5unormsrgb"
			case .ASTC6x6Unorm: return "astc6x6unorm"
			case .ASTC6x6UnormSrgb: return "astc6x6unormsrgb"
			case .ASTC8x5Unorm: return "astc8x5unorm"
			case .ASTC8x5UnormSrgb: return "astc8x5unormsrgb"
			case .ASTC8x6Unorm: return "astc8x6unorm"
			case .ASTC8x6UnormSrgb: return "astc8x6unormsrgb"
			case .ASTC8x8Unorm: return "astc8x8unorm"
			case .ASTC8x8UnormSrgb: return "astc8x8unormsrgb"
			case .ASTC10x5Unorm: return "astc10x5unorm"
			case .ASTC10x5UnormSrgb: return "astc10x5unormsrgb"
			case .ASTC10x6Unorm: return "astc10x6unorm"
			case .ASTC10x6UnormSrgb: return "astc10x6unormsrgb"
			case .ASTC10x8Unorm: return "astc10x8unorm"
			case .ASTC10x8UnormSrgb: return "astc10x8unormsrgb"
			case .ASTC10x10Unorm: return "astc10x10unorm"
			case .ASTC10x10UnormSrgb: return "astc10x10unormsrgb"
			case .ASTC12x10Unorm: return "astc12x10unorm"
			case .ASTC12x10UnormSrgb: return "astc12x10unormsrgb"
			case .ASTC12x12Unorm: return "astc12x12unorm"
			case .ASTC12x12UnormSrgb: return "astc12x12unormsrgb"
			case .R8BG8Biplanar420Unorm: return "r8bg8biplanar420unorm"
			case .R10X6BG10X6Biplanar420Unorm: return "r10x6bg10x6biplanar420unorm"
			case .R8BG8A8Triplanar420Unorm: return "r8bg8a8triplanar420unorm"
			case .R8BG8Biplanar422Unorm: return "r8bg8biplanar422unorm"
			case .R8BG8Biplanar444Unorm: return "r8bg8biplanar444unorm"
			case .R10X6BG10X6Biplanar422Unorm: return "r10x6bg10x6biplanar422unorm"
			case .R10X6BG10X6Biplanar444Unorm: return "r10x6bg10x6biplanar444unorm"
			case .External: return "external"
			case .force32: assert(false); return ("force32")
	}}
}

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



public extension GPUAdapter {
	func getInfo() -> GPUAdapterInfo {
		func CStringViewToString(_ c : WGPUStringView ) -> String {
			return c.data.withMemoryRebound(to: UInt8.self, capacity: c.length) { p in 
				return String(bytes: UnsafeBufferPointer(start: p, count: c.length), encoding: .utf8 )!;
			};
		}
		var i: WGPUAdapterInfo = WGPUAdapterInfo();
		withUnsafeMutablePointer(to: &i) { ptr in 
			let r = self.getInfo(info: ptr);
			assert(r == .success);
		}
		return GPUAdapterInfo (
			vendor: CStringViewToString(i.vendor),
			architecture: CStringViewToString(i.architecture),
			device: CStringViewToString(i.device),
			description: CStringViewToString(i.description),
			backendType: i.backendType,
			adapterType: i.adapterType,
			vendorID: i.vendorID,
			deviceID: i.deviceID,
			subgroupMinSize: i.subgroupMinSize,
			subgroupMaxSize: i.subgroupMaxSize,
			nextInChain: nil
		) 
	}

	func getLimits() -> GPULimits {
		var l: WGPULimits = WGPULimits();
		withUnsafeMutablePointer(to: &l) { ptr in 
			let r = self.getLimits(limits: ptr);
			assert(r == .success);
		}
		return GPULimits (
			maxTextureDimension1D: l.maxTextureDimension1D, 
			maxTextureDimension2D: l.maxTextureDimension2D, 
			maxTextureDimension3D: l.maxTextureDimension3D, 
			maxTextureArrayLayers: l.maxTextureArrayLayers, 
			maxBindGroups: l.maxBindGroups, 
			maxBindGroupsPlusVertexBuffers: l.maxBindGroupsPlusVertexBuffers, 
			maxBindingsPerBindGroup: l.maxBindingsPerBindGroup, 
			maxDynamicUniformBuffersPerPipelineLayout: l.maxDynamicUniformBuffersPerPipelineLayout, 
			maxDynamicStorageBuffersPerPipelineLayout: l.maxDynamicStorageBuffersPerPipelineLayout, 
			maxSampledTexturesPerShaderStage: l.maxSampledTexturesPerShaderStage, 
			maxSamplersPerShaderStage: l.maxSamplersPerShaderStage, 
			maxStorageBuffersPerShaderStage: l.maxStorageBuffersPerShaderStage, 
			maxStorageTexturesPerShaderStage: l.maxStorageTexturesPerShaderStage, 
			maxUniformBuffersPerShaderStage: l.maxUniformBuffersPerShaderStage, 
			maxUniformBufferBindingSize: l.maxUniformBufferBindingSize,
			maxStorageBufferBindingSize: l.maxStorageBufferBindingSize, 
			minUniformBufferOffsetAlignment: l.minUniformBufferOffsetAlignment, 
			minStorageBufferOffsetAlignment: l.minStorageBufferOffsetAlignment, 
			maxVertexBuffers: l.maxVertexBuffers, 
			maxBufferSize: l.maxBufferSize, 
			maxVertexAttributes: l.maxVertexAttributes, 
			maxVertexBufferArrayStride: l.maxVertexBufferArrayStride, 
			maxInterStageShaderVariables: l.maxInterStageShaderVariables, 
			maxColorAttachments: l.maxColorAttachments, 
			maxColorAttachmentBytesPerSample: l.maxColorAttachmentBytesPerSample, 
			maxComputeWorkgroupStorageSize: l.maxComputeWorkgroupStorageSize, 
			maxComputeInvocationsPerWorkgroup: l.maxComputeInvocationsPerWorkgroup, 
			maxComputeWorkgroupSizeX: l.maxComputeWorkgroupSizeX, 
			maxComputeWorkgroupSizeY: l.maxComputeWorkgroupSizeY, 
			maxComputeWorkgroupSizeZ: l.maxComputeWorkgroupSizeZ, 
			maxComputeWorkgroupsPerDimension: l.maxComputeWorkgroupsPerDimension, 
			maxImmediateSize: l.maxImmediateSize, 
			nextInChain: nil
		)
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
