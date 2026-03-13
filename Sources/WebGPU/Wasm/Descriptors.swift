// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

// This file contains all plain-data types that are not GPU objects — i.e., types that have no
// JS-backed identity or lifetime and carry no `@JSClass` decoration. This includes:
//   - Descriptor structs passed to GPU object creation methods (e.g. GPUBufferDescriptor)
//   - Attachment and state structs used as fields within descriptors (e.g. GPURenderPassColorAttachment)
//   - Geometry and layout types (e.g. GPUExtent3D, GPUTexelCopyBufferLayout)
//   - Callback info types that wrap Swift closures for async completions
//   - Stub types required for API compatibility with the native (Dawn) backend

@JS public struct GPUBufferDescriptor {
	public var label: String?
	public var usage: Int
	public var size: Int
	public var mappedAtCreation: Bool = false

	public init(
		label: String? = nil,
		usage: GPUBufferUsage,
		size: UInt64,
		mappedAtCreation: Bool = false
	) {
		self.label = label
		self.usage = Int(usage.rawValue)
		self.size = Int(size)
		self.mappedAtCreation = mappedAtCreation
	}
}

@JS public struct GPUShaderModuleDescriptor {
	public var label: String?
	public var code: String

	public init(label: String? = nil, code: String) {
		self.label = label
		self.code = code
	}
}

@JS public struct GPUVertexAttribute {
	public var format: GPUVertexFormat
	public var offset: Int
	public var shaderLocation: Int

	public init(format: GPUVertexFormat, offset: Int, shaderLocation: Int) {
		self.format = format
		self.offset = offset
		self.shaderLocation = shaderLocation
	}
}

@JS public struct GPUVertexBufferLayout {
	public var arrayStride: Int
	public var stepMode: GPUVertexStepMode = .vertex
	public var attributes: [GPUVertexAttribute]

	public init(
		arrayStride: Int,
		stepMode: GPUVertexStepMode = .vertex,
		attributes: [GPUVertexAttribute]
	) {
		self.arrayStride = arrayStride
		self.stepMode = stepMode
		self.attributes = attributes
	}
}

@JS public struct GPUPrimitiveState {
	public var topology: GPUPrimitiveTopology = .triangleList
	public var stripIndexFormat: GPUIndexFormat = .undefined
	public var frontFace: GPUFrontFace = .ccw
	public var cullMode: GPUCullMode = .none

	public init(
		topology: GPUPrimitiveTopology = .triangleList,
		stripIndexFormat: GPUIndexFormat = .undefined,
		frontFace: GPUFrontFace = .ccw,
		cullMode: GPUCullMode = .none
	) {
		self.topology = topology
		self.stripIndexFormat = stripIndexFormat
		self.frontFace = frontFace
		self.cullMode = cullMode
	}
}

@JS public struct GPUBlendComponent {
	public var operation: GPUBlendOperation
	public var srcFactor: GPUBlendFactor
	public var dstFactor: GPUBlendFactor

	public init(
		operation: GPUBlendOperation = .add,
		srcFactor: GPUBlendFactor = .one,
		dstFactor: GPUBlendFactor = .zero
	) {
		self.operation = operation
		self.srcFactor = srcFactor
		self.dstFactor = dstFactor
	}
}

@JS public struct GPUBlendState {
	public var color: GPUBlendComponent
	public var alpha: GPUBlendComponent

	public init(color: GPUBlendComponent, alpha: GPUBlendComponent) {
		self.color = color
		self.alpha = alpha
	}
}

@JS public struct GPUColorTargetState {
	public var format: GPUTextureFormat
	public var blend: GPUBlendState?
	public var writeMask: Int = Int(GPUColorWrite.all.rawValue)

	public init(format: GPUTextureFormat, blend: GPUBlendState? = nil, writeMask: GPUColorWrite = .all) {
		self.format = format
		self.blend = blend
		self.writeMask = Int(writeMask.rawValue)
	}
}

@JS public struct GPUColor {
	public var r: Double
	public var g: Double
	public var b: Double
	public var a: Double

	public init(r: Double, g: Double, b: Double, a: Double) {
		self.r = r
		self.g = g
		self.b = b
		self.a = a
	}
}

@JS public struct GPUCommandEncoderDescriptor {
	public var label: String?

	public init(label: String? = nil) {
		self.label = label
	}
}

@JS public struct GPUCommandBufferDescriptor {
	public var label: String?

	public init(label: String? = nil) {
		self.label = label
	}
}

@JS public struct GPURenderPassColorAttachment {
	public var view: GPUTextureView
	public var loadOp: GPULoadOp
	public var storeOp: GPUStoreOp
	public var clearValue: GPUColor?

	public init(
		view: GPUTextureView,
		loadOp: GPULoadOp,
		storeOp: GPUStoreOp,
		clearValue: GPUColor? = nil
	) {
		self.view = view
		self.loadOp = loadOp
		self.storeOp = storeOp
		self.clearValue = clearValue
	}
}

// @JS — fields use Double/Int for BridgeJS compatibility
@JS public struct GPURenderPassDepthStencilAttachment {
	public var view: GPUTextureView
	public var depthLoadOp: GPULoadOp?
	public var depthStoreOp: GPUStoreOp?
	public var depthClearValue: Double  // Float stored as Double for BridgeJS
	public var depthReadOnly: Bool
	public var stencilLoadOp: GPULoadOp?
	public var stencilStoreOp: GPUStoreOp?
	public var stencilClearValue: Int   // UInt32 stored as Int for BridgeJS
	public var stencilReadOnly: Bool

	// Primary init — uses stored types (Double/Int) for BridgeJS compatibility
	public init(
		view: GPUTextureView,
		depthLoadOp: GPULoadOp? = nil,
		depthStoreOp: GPUStoreOp? = nil,
		depthClearValue: Double = 1.0,
		depthReadOnly: Bool = false,
		stencilLoadOp: GPULoadOp? = nil,
		stencilStoreOp: GPUStoreOp? = nil,
		stencilClearValue: Int = 0,
		stencilReadOnly: Bool = false
	) {
		self.view = view
		self.depthLoadOp = depthLoadOp
		self.depthStoreOp = depthStoreOp
		self.depthClearValue = depthClearValue
		self.depthReadOnly = depthReadOnly
		self.stencilLoadOp = stencilLoadOp
		self.stencilStoreOp = stencilStoreOp
		self.stencilClearValue = stencilClearValue
		self.stencilReadOnly = stencilReadOnly
	}

	// Convenience init — Float/UInt32 for Dawn API compatibility
	public init(
		view: GPUTextureView,
		depthLoadOp: GPULoadOp? = nil,
		depthStoreOp: GPUStoreOp? = nil,
		depthClearValue: Float,
		depthReadOnly: Bool = false,
		stencilLoadOp: GPULoadOp? = nil,
		stencilStoreOp: GPUStoreOp? = nil,
		stencilClearValue: UInt32 = 0,
		stencilReadOnly: Bool = false
	) {
		self.init(view: view, depthLoadOp: depthLoadOp, depthStoreOp: depthStoreOp,
			depthClearValue: Double(depthClearValue), depthReadOnly: depthReadOnly,
			stencilLoadOp: stencilLoadOp, stencilStoreOp: stencilStoreOp,
			stencilClearValue: Int(stencilClearValue), stencilReadOnly: stencilReadOnly)
	}
}

@JS public struct GPURenderPassDescriptor {
	public var label: String?
	public var colorAttachments: [GPURenderPassColorAttachment]
	public var depthStencilAttachment: GPURenderPassDepthStencilAttachment?
	public var timestampWrites: GPUPassTimestampWrites?

	public init(
		label: String? = nil,
		colorAttachments: [GPURenderPassColorAttachment],
		depthStencilAttachment: GPURenderPassDepthStencilAttachment? = nil,
		timestampWrites: GPUPassTimestampWrites? = nil
	) {
		self.label = label
		self.colorAttachments = colorAttachments
		self.depthStencilAttachment = depthStencilAttachment
		self.timestampWrites = timestampWrites
	}
}

@JS public struct GPUStencilFaceState {
	public var compare: GPUCompareFunction
	public var failOp: GPUStencilOperation
	public var depthFailOp: GPUStencilOperation
	public var passOp: GPUStencilOperation

	public init(
		compare: GPUCompareFunction = .always,
		failOp: GPUStencilOperation = .keep,
		depthFailOp: GPUStencilOperation = .keep,
		passOp: GPUStencilOperation = .keep
	) {
		self.compare = compare
		self.failOp = failOp
		self.depthFailOp = depthFailOp
		self.passOp = passOp
	}
}

@JS public struct GPUDepthStencilState {
	public var format: GPUTextureFormat
	public var depthWriteEnabled: Bool
	public var depthCompare: GPUCompareFunction
	public var stencilFront: GPUStencilFaceState
	public var stencilBack: GPUStencilFaceState
	public var stencilReadMask: Int   // UInt32 stored as Int for BridgeJS
	public var stencilWriteMask: Int  // UInt32 stored as Int for BridgeJS
	public var depthBias: Int         // Int32 stored as Int for BridgeJS
	public var depthBiasSlopeScale: Double  // Float stored as Double for BridgeJS
	public var depthBiasClamp: Double       // Float stored as Double for BridgeJS

	// Primary init — uses stored types (Int/Double) for BridgeJS compatibility
	public init(
		format: GPUTextureFormat,
		depthWriteEnabled: Bool = false,
		depthCompare: GPUCompareFunction = .always,
		stencilFront: GPUStencilFaceState = GPUStencilFaceState(),
		stencilBack: GPUStencilFaceState = GPUStencilFaceState(),
		stencilReadMask: Int = Int(bitPattern: 0xFFFFFFFF),
		stencilWriteMask: Int = Int(bitPattern: 0xFFFFFFFF),
		depthBias: Int = 0,
		depthBiasSlopeScale: Double = 0,
		depthBiasClamp: Double = 0
	) {
		self.format = format
		self.depthWriteEnabled = depthWriteEnabled
		self.depthCompare = depthCompare
		self.stencilFront = stencilFront
		self.stencilBack = stencilBack
		self.stencilReadMask = stencilReadMask
		self.stencilWriteMask = stencilWriteMask
		self.depthBias = depthBias
		self.depthBiasSlopeScale = depthBiasSlopeScale
		self.depthBiasClamp = depthBiasClamp
	}

}

// 3D geometry types (@JS — passed to WebGPU JS methods; fields use Int for
// BridgeJS compatibility; UInt32 convenience inits are provided for callers)
@JS public struct GPUExtent3D {
	public var width: Int
	public var height: Int
	public var depthOrArrayLayers: Int

	public init(width: UInt32, height: UInt32, depthOrArrayLayers: UInt32 = 1) {
		self.width = Int(width)
		self.height = Int(height)
		self.depthOrArrayLayers = Int(depthOrArrayLayers)
	}
}

@JS public struct GPUOrigin3D {
	public var x: Int
	public var y: Int
	public var z: Int

	public init(x: Int = 0, y: Int = 0, z: Int = 0) {
		self.x = x
		self.y = y
		self.z = z
	}
}

// Texture descriptor (@JS — all UInt32 fields converted to Int for BridgeJS)
@JS public struct GPUTextureDescriptor {
	public var label: String?
	public var size: GPUExtent3D
	public var mipLevelCount: Int
	public var sampleCount: Int
	public var dimension: GPUTextureDimension
	public var format: GPUTextureFormat
	public var usage: Int

	public init(
		label: String? = nil,
		usage: GPUTextureUsage,
		size: GPUExtent3D,
		format: GPUTextureFormat,
		mipLevelCount: UInt32 = 1,
		sampleCount: UInt32 = 1,
		dimension: GPUTextureDimension = ._2D
	) {
		self.label = label
		self.size = size
		self.mipLevelCount = Int(mipLevelCount)
		self.sampleCount = Int(sampleCount)
		self.dimension = dimension
		self.format = format
		self.usage = Int(usage.rawValue)
	}
}

// Texture view descriptor (@JS)
@JS public struct GPUTextureViewDescriptor {
	public var label: String?
	public var format: GPUTextureFormat?
	public var dimension: GPUTextureViewDimension?
	public var aspect: GPUTextureAspect
	public var baseMipLevel: Int
	public var mipLevelCount: Int?
	public var baseArrayLayer: Int
	public var arrayLayerCount: Int?

	public init(
		label: String? = nil,
		format: GPUTextureFormat? = nil,
		dimension: GPUTextureViewDimension? = nil,
		aspect: GPUTextureAspect = .all,
		baseMipLevel: Int = 0,
		mipLevelCount: Int? = nil,
		baseArrayLayer: Int = 0,
		arrayLayerCount: Int? = nil
	) {
		self.label = label
		self.format = format
		self.dimension = dimension
		self.aspect = aspect
		self.baseMipLevel = baseMipLevel
		self.mipLevelCount = mipLevelCount
		self.baseArrayLayer = baseArrayLayer
		self.arrayLayerCount = arrayLayerCount
	}

}

// Sampler descriptor (@JS — Float/UInt16 fields converted to Double/Int)
@JS public struct GPUSamplerDescriptor {
	public var label: String?
	public var addressModeU: GPUAddressMode
	public var addressModeV: GPUAddressMode
	public var addressModeW: GPUAddressMode
	public var magFilter: GPUFilterMode
	public var minFilter: GPUFilterMode
	public var mipmapFilter: GPUMipmapFilterMode
	public var lodMinClamp: Double
	public var lodMaxClamp: Double
	public var compare: GPUCompareFunction?
	public var maxAnisotropy: Int

	public init(
		label: String? = nil,
		addressModeU: GPUAddressMode = .clampToEdge,
		addressModeV: GPUAddressMode = .clampToEdge,
		addressModeW: GPUAddressMode = .clampToEdge,
		magFilter: GPUFilterMode = .nearest,
		minFilter: GPUFilterMode = .nearest,
		mipmapFilter: GPUMipmapFilterMode = .nearest,
		lodMinClamp: Double = 0,
		lodMaxClamp: Double = 32,
		compare: GPUCompareFunction? = nil,
		maxAnisotropy: Int = 1
	) {
		self.label = label
		self.addressModeU = addressModeU
		self.addressModeV = addressModeV
		self.addressModeW = addressModeW
		self.magFilter = magFilter
		self.minFilter = minFilter
		self.mipmapFilter = mipmapFilter
		self.lodMinClamp = lodMinClamp
		self.lodMaxClamp = lodMaxClamp
		self.compare = compare
		self.maxAnisotropy = maxAnisotropy
	}

}

// QuerySet descriptor (@JS — UInt32 count converted to Int)
@JS public struct GPUQuerySetDescriptor {
	public var label: String?
	public var type: GPUQueryType
	public var count: Int

	public init(label: String? = nil, type: GPUQueryType, count: Int) {
		self.label = label
		self.type = type
		self.count = count
	}

}

// Pass timestamp writes (@JS — GPUQuerySet @JSClass fields are bridgeable; indices use Int for BridgeJS)
@JS public struct GPUPassTimestampWrites {
	public var querySet: GPUQuerySet
	public var beginningOfPassWriteIndex: Int  // UInt32 stored as Int for BridgeJS
	public var endOfPassWriteIndex: Int        // UInt32 stored as Int for BridgeJS

	public init(querySet: GPUQuerySet, beginningOfPassWriteIndex: Int = 0, endOfPassWriteIndex: Int = 0) {
		self.querySet = querySet
		self.beginningOfPassWriteIndex = beginningOfPassWriteIndex
		self.endOfPassWriteIndex = endOfPassWriteIndex
	}

}

// Copy layout / info types (plain Swift structs — converted to JSObjects manually in methods)
public struct GPUTexelCopyBufferLayout {
	public var offset: UInt64
	public var bytesPerRow: UInt32?
	public var rowsPerImage: UInt32?

	public init(offset: UInt64 = 0, bytesPerRow: UInt32? = nil, rowsPerImage: UInt32? = nil) {
		self.offset = offset
		self.bytesPerRow = bytesPerRow
		self.rowsPerImage = rowsPerImage
	}
}

public struct GPUTexelCopyBufferInfo {
	public var layout: GPUTexelCopyBufferLayout
	public var buffer: GPUBuffer

	public init(layout: GPUTexelCopyBufferLayout, buffer: GPUBuffer) {
		self.layout = layout
		self.buffer = buffer
	}
}

public struct GPUTexelCopyTextureInfo {
	public var texture: GPUTexture
	public var mipLevel: UInt32
	public var origin: GPUOrigin3D
	public var aspect: GPUTextureAspect

	public init(
		texture: GPUTexture,
		mipLevel: UInt32 = 0,
		origin: GPUOrigin3D = GPUOrigin3D(),
		aspect: GPUTextureAspect = .all
	) {
		self.texture = texture
		self.mipLevel = mipLevel
		self.origin = origin
		self.aspect = aspect
	}
}

@JS public struct GPUBufferBindingLayout {
	public var type: GPUBufferBindingType
	public var hasDynamicOffset: Bool
	public var minBindingSize: UInt64

	public init(
		type: GPUBufferBindingType = .uniform,
		hasDynamicOffset: Bool = false,
		minBindingSize: UInt64 = 0
	) {
		self.type = type
		self.hasDynamicOffset = hasDynamicOffset
		self.minBindingSize = minBindingSize
	}
}

@JS public struct GPUSamplerBindingLayout {
	public var type: GPUSamplerBindingType

	public init(type: GPUSamplerBindingType = .filtering) {
		self.type = type
	}
}

@JS public struct GPUTextureBindingLayout {
	public var sampleType: GPUTextureSampleType
	public var viewDimension: GPUTextureViewDimension
	public var multisampled: Bool

	public init(
		sampleType: GPUTextureSampleType = .float,
		viewDimension: GPUTextureViewDimension = ._2D,
		multisampled: Bool = false
	) {
		self.sampleType = sampleType
		self.viewDimension = viewDimension
		self.multisampled = multisampled
	}
}

@JS public struct GPUStorageTextureBindingLayout {
	public var access: GPUStorageTextureAccess
	public var format: GPUTextureFormat
	public var viewDimension: GPUTextureViewDimension

	public init(
		access: GPUStorageTextureAccess = .writeOnly,
		format: GPUTextureFormat,
		viewDimension: GPUTextureViewDimension = ._2D
	) {
		self.access = access
		self.format = format
		self.viewDimension = viewDimension
	}
}

@JS public struct GPUBindGroupLayoutEntry {
	public var binding: Int
	public var visibility: Int
	public var buffer: GPUBufferBindingLayout?
	public var sampler: GPUSamplerBindingLayout?
	public var texture: GPUTextureBindingLayout?
	public var storageTexture: GPUStorageTextureBindingLayout?

	public init(
		binding: Int,
		visibility: Int,
		buffer: GPUBufferBindingLayout? = nil,
		sampler: GPUSamplerBindingLayout? = nil,
		texture: GPUTextureBindingLayout? = nil,
		storageTexture: GPUStorageTextureBindingLayout? = nil
	) {
		self.binding = binding
		self.visibility = visibility
		self.buffer = buffer
		self.sampler = sampler
		self.texture = texture
		self.storageTexture = storageTexture
	}

	public init(
		binding: Int,
		visibility: GPUShaderStage,
		buffer: GPUBufferBindingLayout? = nil,
		sampler: GPUSamplerBindingLayout? = nil,
		texture: GPUTextureBindingLayout? = nil,
		storageTexture: GPUStorageTextureBindingLayout? = nil
	) {
		self.init(
			binding: binding,
			visibility: Int(visibility.rawValue),
			buffer: buffer,
			sampler: sampler,
			texture: texture,
			storageTexture: storageTexture
		)
	}

	public init(
		binding: UInt32,
		visibility: GPUShaderStage,
		buffer: GPUBufferBindingLayout? = nil,
		sampler: GPUSamplerBindingLayout? = nil,
		texture: GPUTextureBindingLayout? = nil,
		storageTexture: GPUStorageTextureBindingLayout? = nil
	) {
		self.init(binding: Int(binding), visibility: visibility, buffer: buffer, sampler: sampler, texture: texture, storageTexture: storageTexture)
	}

	public init(
		binding: UInt32,
		visibility: Int,
		buffer: GPUBufferBindingLayout? = nil,
		sampler: GPUSamplerBindingLayout? = nil,
		texture: GPUTextureBindingLayout? = nil,
		storageTexture: GPUStorageTextureBindingLayout? = nil
	) {
		self.init(binding: Int(binding), visibility: visibility, buffer: buffer, sampler: sampler, texture: texture, storageTexture: storageTexture)
	}
}

@JS public struct GPUBindGroupLayoutDescriptor {
	public var label: String?
	public var entries: [GPUBindGroupLayoutEntry]

	public init(
		label: String? = nil,
		entries: [GPUBindGroupLayoutEntry]
	) {
		self.label = label
		self.entries = entries
	}
}

// Adapter/Device descriptor types (plain Swift structs — WASM uses a different
// async initialization path; these satisfy the type system for compilation)
public struct GPURequestAdapterOptions {
	public var powerPreference: GPUPowerPreference?
	public var backendType: GPUBackendType?
	public var forceFallbackAdapter: Bool

	public init(
		powerPreference: GPUPowerPreference? = nil,
		backendType: GPUBackendType? = nil,
		forceFallbackAdapter: Bool = false
	) {
		self.powerPreference = powerPreference
		self.backendType = backendType
		self.forceFallbackAdapter = forceFallbackAdapter
	}
}

public struct GPUQueueDescriptor {
	public var label: String?

	public init(label: String? = nil) {
		self.label = label
	}
}

public struct GPUDeviceDescriptor {
	public var label: String?
	public var requiredFeatures: [GPUFeatureName]
	public var requiredLimits: GPULimits
	public var defaultQueue: GPUQueueDescriptor
	public var deviceLostCallbackInfo: GPUDeviceLostCallbackInfo?
	public var uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo?

	public init(
		label: String? = nil,
		requiredFeatures: [GPUFeatureName] = [],
		requiredLimits: GPULimits = GPULimits(),
		defaultQueue: GPUQueueDescriptor = GPUQueueDescriptor(),
		deviceLostCallbackInfo: GPUDeviceLostCallbackInfo? = nil,
		uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo? = nil
	) {
		self.label = label
		self.requiredFeatures = requiredFeatures
		self.requiredLimits = requiredLimits
		self.defaultQueue = defaultQueue
		self.deviceLostCallbackInfo = deviceLostCallbackInfo
		self.uncapturedErrorCallbackInfo = uncapturedErrorCallbackInfo
	}
}

// Adapter/device info types (plain Swift structs)
public struct GPUAdapterInfo {
	public var vendor: String
	public var architecture: String
	public var device: String
	public var description: String
	public var backendType: GPUBackendType

	public init(
		vendor: String = "",
		architecture: String = "",
		device: String = "",
		description: String = "",
		backendType: GPUBackendType = .webGPU
	) {
		self.vendor = vendor
		self.architecture = architecture
		self.device = device
		self.description = description
		self.backendType = backendType
	}
}

public struct GPULimits {
	public var maxTextureDimension1D: UInt32
	public var maxTextureDimension2D: UInt32
	public var maxTextureDimension3D: UInt32
	public var maxTextureArrayLayers: UInt32
	public var maxBindGroups: UInt32
	public var maxBindGroupsPlusVertexBuffers: UInt32
	public var maxBindingsPerBindGroup: UInt32
	public var maxDynamicUniformBuffersPerPipelineLayout: UInt32
	public var maxDynamicStorageBuffersPerPipelineLayout: UInt32
	public var maxSampledTexturesPerShaderStage: UInt32
	public var maxSamplersPerShaderStage: UInt32
	public var maxStorageBuffersPerShaderStage: UInt32
	public var maxStorageTexturesPerShaderStage: UInt32
	public var maxUniformBuffersPerShaderStage: UInt32
	public var maxUniformBufferBindingSize: UInt64
	public var maxStorageBufferBindingSize: UInt64
	public var minUniformBufferOffsetAlignment: UInt32
	public var minStorageBufferOffsetAlignment: UInt32
	public var maxVertexBuffers: UInt32
	public var maxBufferSize: UInt64
	public var maxVertexAttributes: UInt32
	public var maxVertexBufferArrayStride: UInt32
	public var maxInterStageShaderComponents: UInt32
	public var maxInterStageShaderVariables: UInt32
	public var maxColorAttachments: UInt32
	public var maxColorAttachmentBytesPerSample: UInt32
	public var maxComputeWorkgroupStorageSize: UInt32
	public var maxComputeInvocationsPerWorkgroup: UInt32
	public var maxComputeWorkgroupSizeX: UInt32
	public var maxComputeWorkgroupSizeY: UInt32
	public var maxComputeWorkgroupSizeZ: UInt32
	public var maxComputeWorkgroupsPerDimension: UInt32

	public init(
		maxTextureDimension1D: UInt32 = 8192,
		maxTextureDimension2D: UInt32 = 8192,
		maxTextureDimension3D: UInt32 = 2048,
		maxTextureArrayLayers: UInt32 = 256,
		maxBindGroups: UInt32 = 4,
		maxBindGroupsPlusVertexBuffers: UInt32 = 24,
		maxBindingsPerBindGroup: UInt32 = 640,
		maxDynamicUniformBuffersPerPipelineLayout: UInt32 = 8,
		maxDynamicStorageBuffersPerPipelineLayout: UInt32 = 4,
		maxSampledTexturesPerShaderStage: UInt32 = 16,
		maxSamplersPerShaderStage: UInt32 = 16,
		maxStorageBuffersPerShaderStage: UInt32 = 8,
		maxStorageTexturesPerShaderStage: UInt32 = 4,
		maxUniformBuffersPerShaderStage: UInt32 = 12,
		maxUniformBufferBindingSize: UInt64 = 65536,
		maxStorageBufferBindingSize: UInt64 = 134217728,
		minUniformBufferOffsetAlignment: UInt32 = 256,
		minStorageBufferOffsetAlignment: UInt32 = 256,
		maxVertexBuffers: UInt32 = 8,
		maxBufferSize: UInt64 = 268435456,
		maxVertexAttributes: UInt32 = 16,
		maxVertexBufferArrayStride: UInt32 = 2048,
		maxInterStageShaderComponents: UInt32 = 60,
		maxInterStageShaderVariables: UInt32 = 16,
		maxColorAttachments: UInt32 = 8,
		maxColorAttachmentBytesPerSample: UInt32 = 32,
		maxComputeWorkgroupStorageSize: UInt32 = 16384,
		maxComputeInvocationsPerWorkgroup: UInt32 = 256,
		maxComputeWorkgroupSizeX: UInt32 = 256,
		maxComputeWorkgroupSizeY: UInt32 = 256,
		maxComputeWorkgroupSizeZ: UInt32 = 64,
		maxComputeWorkgroupsPerDimension: UInt32 = 65535
	) {
		self.maxTextureDimension1D = maxTextureDimension1D
		self.maxTextureDimension2D = maxTextureDimension2D
		self.maxTextureDimension3D = maxTextureDimension3D
		self.maxTextureArrayLayers = maxTextureArrayLayers
		self.maxBindGroups = maxBindGroups
		self.maxBindGroupsPlusVertexBuffers = maxBindGroupsPlusVertexBuffers
		self.maxBindingsPerBindGroup = maxBindingsPerBindGroup
		self.maxDynamicUniformBuffersPerPipelineLayout = maxDynamicUniformBuffersPerPipelineLayout
		self.maxDynamicStorageBuffersPerPipelineLayout = maxDynamicStorageBuffersPerPipelineLayout
		self.maxSampledTexturesPerShaderStage = maxSampledTexturesPerShaderStage
		self.maxSamplersPerShaderStage = maxSamplersPerShaderStage
		self.maxStorageBuffersPerShaderStage = maxStorageBuffersPerShaderStage
		self.maxStorageTexturesPerShaderStage = maxStorageTexturesPerShaderStage
		self.maxUniformBuffersPerShaderStage = maxUniformBuffersPerShaderStage
		self.maxUniformBufferBindingSize = maxUniformBufferBindingSize
		self.maxStorageBufferBindingSize = maxStorageBufferBindingSize
		self.minUniformBufferOffsetAlignment = minUniformBufferOffsetAlignment
		self.minStorageBufferOffsetAlignment = minStorageBufferOffsetAlignment
		self.maxVertexBuffers = maxVertexBuffers
		self.maxBufferSize = maxBufferSize
		self.maxVertexAttributes = maxVertexAttributes
		self.maxVertexBufferArrayStride = maxVertexBufferArrayStride
		self.maxInterStageShaderComponents = maxInterStageShaderComponents
		self.maxInterStageShaderVariables = maxInterStageShaderVariables
		self.maxColorAttachments = maxColorAttachments
		self.maxColorAttachmentBytesPerSample = maxColorAttachmentBytesPerSample
		self.maxComputeWorkgroupStorageSize = maxComputeWorkgroupStorageSize
		self.maxComputeInvocationsPerWorkgroup = maxComputeInvocationsPerWorkgroup
		self.maxComputeWorkgroupSizeX = maxComputeWorkgroupSizeX
		self.maxComputeWorkgroupSizeY = maxComputeWorkgroupSizeY
		self.maxComputeWorkgroupSizeZ = maxComputeWorkgroupSizeZ
		self.maxComputeWorkgroupsPerDimension = maxComputeWorkgroupsPerDimension
	}
}

// Compilation message stub (plain Swift struct)
public struct GPUCompilationMessage {
	public var message: String
	public var type: GPUCompilationMessageType
	public var lineNum: UInt64
	public var linePos: UInt64
	public var length: UInt64
	public var offset: UInt64

	public init(
		message: String = "",
		type: GPUCompilationMessageType = .info,
		lineNum: UInt64 = 0,
		linePos: UInt64 = 0,
		length: UInt64 = 0,
		offset: UInt64 = 0
	) {
		self.message = message
		self.type = type
		self.lineNum = lineNum
		self.linePos = linePos
		self.length = length
		self.offset = offset
	}
}

// Callback info types — pure Swift structs (not @JS, not passed to JavaScript).
// These capture Swift closures for async completion notifications.

public struct GPUBufferMapCallbackInfo {
	public var mode: GPUCallbackMode
	public var callback: (GPUMapAsyncStatus, String?) -> Void

	public init(mode: GPUCallbackMode = .allowProcessEvents, callback: @escaping (GPUMapAsyncStatus, String?) -> Void) {
		self.mode = mode
		self.callback = callback
	}
}

public struct GPURequestAdapterCallbackInfo {
	public var mode: GPUCallbackMode
	public var callback: (GPURequestAdapterStatus, GPUAdapter?, String?) -> Void

	public init(mode: GPUCallbackMode = .allowProcessEvents, callback: @escaping (GPURequestAdapterStatus, GPUAdapter?, String?) -> Void) {
		self.mode = mode
		self.callback = callback
	}
}

public struct GPURequestDeviceCallbackInfo {
	public var mode: GPUCallbackMode
	public var callback: (GPURequestDeviceStatus, GPUDevice?, String?) -> Void

	public init(mode: GPUCallbackMode = .allowProcessEvents, callback: @escaping (GPURequestDeviceStatus, GPUDevice?, String?) -> Void) {
		self.mode = mode
		self.callback = callback
	}
}

public struct GPUDeviceLostCallbackInfo {
	public var callback: (GPUDevice?, GPUDeviceLostReason, String?) -> Void

	public init(callback: @escaping (GPUDevice?, GPUDeviceLostReason, String?) -> Void) {
		self.callback = callback
	}
}

public struct GPUPopErrorScopeCallbackInfo {
	public var mode: GPUCallbackMode
	public var callback: (GPUPopErrorScopeStatus, GPUErrorType, String?) -> Void

	public init(mode: GPUCallbackMode = .allowProcessEvents, callback: @escaping (GPUPopErrorScopeStatus, GPUErrorType, String?) -> Void) {
		self.mode = mode
		self.callback = callback
	}
}

public struct GPUUncapturedErrorCallbackInfo {
	public var callback: (GPUDevice?, GPUErrorType, String?) -> Void

	public init(callback: @escaping (GPUDevice?, GPUErrorType, String?) -> Void) {
		self.callback = callback
	}
}

public struct GPUCreateComputePipelineAsyncCallbackInfo {
	public var mode: GPUCallbackMode
	public var callback: (GPURequestDeviceStatus, GPUComputePipeline?, String?) -> Void

	public init(mode: GPUCallbackMode = .allowProcessEvents, callback: @escaping (GPURequestDeviceStatus, GPUComputePipeline?, String?) -> Void) {
		self.mode = mode
		self.callback = callback
	}
}

// GPUFuture stub — returned by async Dawn operations, not used on WASM
public struct GPUFuture {
	public var id: UInt64

	public init(id: UInt64 = 0) {
		self.id = id
	}
}
