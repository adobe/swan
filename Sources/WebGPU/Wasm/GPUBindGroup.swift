// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUBufferBinding {
	public var buffer: GPUBuffer
	public var offset: Int?
	public var size: Int?

	public init(
		buffer: GPUBuffer,
		offset: Int? = nil,
		size: Int? = nil
	) {
		self.buffer = buffer
		self.offset = offset
		self.size = size
	}
}

// GPUBindingResource is a union of buffer binding, texture view, and sampler.
// On WASM, we represent this as an enum to support all three resource types.
public enum GPUBindingResource {
	case buffer(GPUBufferBinding)
	case textureView(GPUTextureView)
	case sampler(GPUSampler)
}

@JS public struct GPUBindGroupEntry {
	public var binding: Int
	public var resource: GPUBufferBinding

	public init(
		binding: Int,
		resource: GPUBufferBinding
	) {
		self.binding = binding
		self.resource = resource
	}

	// Convenience initializers matching Dawn API for buffer bindings
	public init(binding: UInt32, buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64) {
		let sizeVal = size == UInt64.max ? nil : Int(size)
		self.init(binding: Int(binding), resource: GPUBufferBinding(buffer: buffer, offset: Int(offset), size: sizeVal))
	}

	public init(binding: Int, buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64) {
		let sizeVal = size == UInt64.max ? nil : Int(size)
		self.init(binding: binding, resource: GPUBufferBinding(buffer: buffer, offset: Int(offset), size: sizeVal))
	}

	// Whole-buffer convenience inits (no offset/size)
	public init(binding: UInt32, buffer: GPUBuffer) {
		self.init(binding: Int(binding), resource: GPUBufferBinding(buffer: buffer))
	}

	public init(binding: Int, buffer: GPUBuffer) {
		self.init(binding: binding, resource: GPUBufferBinding(buffer: buffer))
	}
}

// Extended entry type supporting texture views and samplers.
public struct GPUBindGroupEntryEx {
	public var binding: Int
	public var resource: GPUBindingResource

	public init(binding: Int, buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64) {
		let sizeVal = size == UInt64.max ? nil : Int(size)
		self.binding = binding
		self.resource = .buffer(GPUBufferBinding(buffer: buffer, offset: Int(offset), size: sizeVal))
	}

	public init(binding: Int, textureView: GPUTextureView) {
		self.binding = binding
		self.resource = .textureView(textureView)
	}

	public init(binding: Int, sampler: GPUSampler) {
		self.binding = binding
		self.resource = .sampler(sampler)
	}
}

@JS public struct GPUBindGroupDescriptor {
	public var label: String?
	public var layout: GPUBindGroupLayout
	public var entries: [GPUBindGroupEntry]

	public init(
		label: String? = nil,
		layout: GPUBindGroupLayout,
		entries: [GPUBindGroupEntry]
	) {
		self.label = label
		self.layout = layout
		self.entries = entries
	}
}

@JSClass public struct GPUBindGroup {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
	}
}
