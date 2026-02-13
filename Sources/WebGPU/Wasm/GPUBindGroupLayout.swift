// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JS public struct GPUBufferBindingLayout {
	public var type: GPUBufferBindingType

	public init(type: GPUBufferBindingType) {
		self.type = type
	}
}

@_spi(Experimental)
@JS public struct GPUBindGroupLayoutEntry {
	public var binding: Int
	public var visibility: Int
	public var buffer: GPUBufferBindingLayout?

	public init(
		binding: Int,
		visibility: Int,
		buffer: GPUBufferBindingLayout? = nil
	) {
		self.binding = binding
		self.visibility = visibility
		self.buffer = buffer
	}

	public init(
		binding: Int,
		visibility: GPUShaderStage,
		buffer: GPUBufferBindingLayout? = nil
	) {
		self.init(binding: binding, visibility: Int(visibility.rawValue), buffer: buffer)
	}
}

@_spi(Experimental)
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

@_spi(Experimental)
@JSClass public struct GPUBindGroupLayout {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?
}
