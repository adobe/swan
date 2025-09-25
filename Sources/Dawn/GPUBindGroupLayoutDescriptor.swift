// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// extension WGPUBufferBindingLayout: RootStruct {}
// extension WGPUSamplerBindingLayout: RootStruct {}
// extension WGPUTextureBindingLayout: RootStruct {}
// extension WGPUStorageTextureBindingLayout: RootStruct {}
// extension WGPUBindGroupLayoutEntry: RootStruct {}
// extension WGPUBindGroupLayoutDescriptor: RootStruct {}

// public typealias GPUBindGroupLayout = WGPUBindGroupLayoutImpl

// public struct GPUBufferBindingLayout: GPUStructRoot {
// 	public typealias WGPUType = WGPUBufferBindingLayout

// 	public var type: GPUBufferBindingType = .bindingNotUsed

// 	public var hasDynamicOffset: Bool = false

// 	public var minBindingSize: UInt64 = 0

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(type: GPUBufferBindingType, hasDynamicOffset: Bool = false, minBindingSize: UInt64 = 0) {
// 		self.type = type
// 		self.hasDynamicOffset = hasDynamicOffset
// 		self.minBindingSize = minBindingSize
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUBufferBindingLayout,
// 		_ lambda: (UnsafeMutablePointer<WGPUBufferBindingLayout>) -> R
// 	) -> R {
// 		wgpuStruct.type = type
// 		wgpuStruct.hasDynamicOffset = hasDynamicOffset ? 1 : 0
// 		wgpuStruct.minBindingSize = minBindingSize

// 		return lambda(&wgpuStruct)
// 	}
// }

// public struct GPUSamplerBindingLayout: GPUStructRoot {
// 	public typealias WGPUType = WGPUSamplerBindingLayout

// 	public var type: GPUSamplerBindingType = .bindingNotUsed

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(type: GPUSamplerBindingType) {
// 		self.type = type
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUSamplerBindingLayout,
// 		_ lambda: (UnsafeMutablePointer<WGPUSamplerBindingLayout>) -> R
// 	) -> R {
// 		wgpuStruct.type = type
// 		return lambda(&wgpuStruct)
// 	}
// }

// public struct GPUTextureBindingLayout: GPUStructRoot {
// 	public typealias WGPUType = WGPUTextureBindingLayout

// 	public var sampleType: GPUTextureSampleType = .bindingNotUsed

// 	public var viewDimension: GPUTextureViewDimension = ._Undefined

// 	public var multisampled: Bool = false

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(sampleType: GPUTextureSampleType, viewDimension: GPUTextureViewDimension, multisampled: Bool) {
// 		self.sampleType = sampleType
// 		self.viewDimension = viewDimension
// 		self.multisampled = multisampled
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUTextureBindingLayout,
// 		_ lambda: (UnsafeMutablePointer<WGPUTextureBindingLayout>) -> R
// 	) -> R {
// 		wgpuStruct.sampleType = sampleType
// 		wgpuStruct.viewDimension = viewDimension
// 		wgpuStruct.multisampled = multisampled ? 1 : 0
// 		return lambda(&wgpuStruct)
// 	}
// }

// public struct GPUStorageTextureBindingLayout: GPUStructRoot {
// 	public typealias WGPUType = WGPUStorageTextureBindingLayout

// 	public var access: GPUStorageTextureAccess = .undefined

// 	public var format: GPUTextureFormat = .undefined

// 	public var viewDimension: GPUTextureViewDimension = ._Undefined

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(access: GPUStorageTextureAccess, format: GPUTextureFormat, viewDimension: GPUTextureViewDimension) {
// 		self.access = access
// 		self.format = format
// 		self.viewDimension = viewDimension
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUStorageTextureBindingLayout,
// 		_ lambda: (UnsafeMutablePointer<WGPUStorageTextureBindingLayout>) -> R
// 	) -> R {
// 		wgpuStruct.access = access
// 		wgpuStruct.format = format
// 		wgpuStruct.viewDimension = viewDimension
// 		return lambda(&wgpuStruct)
// 	}
// }

// public struct GPUBindGroupLayoutEntry: GPUStructRoot {
// 	public typealias WGPUType = WGPUBindGroupLayoutEntry

// 	public var binding: UInt32 = 0

// 	public var visibility: WGPUShaderStage = .none

// 	public var bindingArraySize: UInt32 = 0

// 	public var buffer: GPUBufferBindingLayout = GPUBufferBindingLayout()

// 	public var sampler: GPUSamplerBindingLayout = GPUSamplerBindingLayout()

// 	public var texture: GPUTextureBindingLayout = GPUTextureBindingLayout()

// 	public var storageTexture: GPUStorageTextureBindingLayout = GPUStorageTextureBindingLayout()

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(
// 		binding: UInt32,
// 		visibility: WGPUShaderStage,
// 		buffer: GPUBufferBindingLayout = GPUBufferBindingLayout(),
// 		sampler: GPUSamplerBindingLayout = GPUSamplerBindingLayout(),
// 		texture: GPUTextureBindingLayout = GPUTextureBindingLayout(),
// 		storageTexture: GPUStorageTextureBindingLayout = GPUStorageTextureBindingLayout()
// 	) {
// 		self.binding = binding
// 		self.visibility = visibility
// 		self.buffer = buffer
// 		self.sampler = sampler
// 		self.texture = texture
// 		self.storageTexture = storageTexture
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUBindGroupLayoutEntry,
// 		_ lambda: (UnsafeMutablePointer<WGPUBindGroupLayoutEntry>) -> R
// 	) -> R {
// 		wgpuStruct.binding = binding
// 		wgpuStruct.visibility = visibility
// 		wgpuStruct.bindingArraySize = bindingArraySize
// 		return buffer.withWGPUStruct() { buffer in
// 			return sampler.withWGPUStruct() { sampler in
// 				return texture.withWGPUStruct() { texture in
// 					return storageTexture.withWGPUStruct() { storageTexture in
// 						wgpuStruct.buffer = buffer.pointee
// 						wgpuStruct.sampler = sampler.pointee
// 						wgpuStruct.texture = texture.pointee
// 						wgpuStruct.storageTexture = storageTexture.pointee
// 						return lambda(&wgpuStruct)
// 					}
// 				}
// 			}
// 		}
// 	}
// }

// public struct GPUBindGroupLayoutDescriptor: GPUStructRoot {
// 	public typealias WGPUType = WGPUBindGroupLayoutDescriptor

// 	public var label: String = ""

// 	public var entries: [GPUBindGroupLayoutEntry] = []

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(label: String, entries: [GPUBindGroupLayoutEntry]) {
// 		self.label = label
// 		self.entries = entries
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUBindGroupLayoutDescriptor,
// 		_ lambda: (UnsafeMutablePointer<WGPUBindGroupLayoutDescriptor>) -> R
// 	) -> R {
// 		return label.withWGPUStringView { labelStringView in
// 			wgpuStruct.label = labelStringView
// 			return lambda(&wgpuStruct)
// 		}
// 	}
// }
