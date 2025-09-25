// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// extension WGPUBindGroupEntry: RootStruct {}
// extension WGPUBindGroupDescriptor: RootStruct {}

// public struct GPUBindGroupEntry: GPUStructRoot {
// 	public typealias WGPUType = WGPUBindGroupEntry

// 	public var binding: Int = 0

//     public var buffer: GPUBuffer? = nil

//     public var offset: Int = 0

//     public var size: Int = 0

//     public var sampler: GPUSampler? = nil

//     public var textureView: GPUTextureView? = nil

//     public init() {}

//     public init(binding: Int, buffer: GPUBuffer? = nil, offset: Int = 0, size: Int = 0, sampler: GPUSampler? = nil, textureView: GPUTextureView? = nil) {
//         self.binding = binding
//         self.buffer = buffer
//         self.offset = offset
//         self.size = size
//         self.sampler = sampler
//         self.textureView = textureView
//     }

//     public func applyPropertiesToWGPUStruct<R>(_ struct: inout WGPUBindGroupEntry, _ lambda: (UnsafeMutablePointer<WGPUBindGroupEntry>) -> R) -> R {
//         struct.binding = binding
//         struct.resource = resource
//         return lambda(&struct)
//     }
// }

// public struct GPUBindGroupDescriptor: GPUStructRoot {
// 	public typealias WGPUType = WGPUBindGroupDescriptor

// 	public var label: String? = nil

// 	public var layout: GPUBindGroupLayout? = nil

// 	public var entries: [GPUBindGroupEntry] = []

//     public init() {}

//     public init(label: String? = nil, layout: GPUBindGroupLayout? = nil, entries: [GPUBindGroupEntry]) {
//         self.label = label
//         self.layout = layout
//         self.entries = entries
//     }

//     public func applyPropertiesToWGPUStruct<R>(_ struct: inout WGPUBindGroupDescriptor, _ lambda: (UnsafeMutablePointer<WGPUBindGroupDescriptor>) -> R) -> R {
//         struct.label = label
//         struct.layout = layout
//         struct.entries = entries
//         return lambda(&struct)
//     }
// }
