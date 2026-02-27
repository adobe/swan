// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUBufferBindingLayout {
	public var type: GPUBufferBindingType

	public init(type: GPUBufferBindingType) {
		self.type = type
	}
}

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

@JSClass public struct GPUBindGroupLayout {
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}
}
