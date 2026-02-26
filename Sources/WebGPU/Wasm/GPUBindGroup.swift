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

	public init(binding: UInt32, buffer: GPUBuffer, offset: UInt64, size: UInt64) {
		self.init(
			binding: Int(binding),
			resource: GPUBufferBinding(buffer: buffer, offset: Int(offset), size: Int(size))
		)
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
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	public var label: String? { jsObject.label.string }
}

// public extension GPUBindGroupEntry {
// 	init(binding: UInt32, buffer: GPUBuffer, offset: UInt64, size: UInt64) {
// 		self.init(
// 			binding: Int(binding),
// 			resource: GPUBufferBinding(buffer: buffer, offset: Int(offset), size: Int(size))
// 		)
// 	}
// }
