// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
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

@_spi(Experimental)
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

	public init(
		binding: Int,
		buffer: GPUBuffer,
		offset: Int? = nil,
		size: Int? = nil
	) {
		self.init(binding: binding, resource: GPUBufferBinding(buffer: buffer, offset: offset, size: size))
	}
}

@_spi(Experimental)
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

@_spi(Experimental)
@JSClass public struct GPUBindGroup {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?
}
