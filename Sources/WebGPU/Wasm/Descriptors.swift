// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUBufferDescriptor {
	public var label: String?
	public var size: UInt64
	public var usage: GPUBufferUsage
	public var mappedAtCreation: Bool = false

	public init(
		label: String? = nil,
		size: UInt64,
		usage: GPUBufferUsage,
		mappedAtCreation: Bool = false
	) {
		self.label = label
		self.size = size
		self.usage = usage
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
	public var offset: UInt64
	public var shaderLocation: UInt32

	public init(format: GPUVertexFormat, offset: UInt64, shaderLocation: UInt32) {
		self.format = format
		self.offset = offset
		self.shaderLocation = shaderLocation
	}
}

@JS public struct GPUVertexBufferLayout {
	public var arrayStride: UInt64
	public var stepMode: GPUVertexStepMode = .vertex
	public var attributes: [GPUVertexAttribute]

	public init(
		arrayStride: UInt64,
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
	public var frontFace: GPUFrontFace = .ccw
	public var cullMode: GPUCullMode = .none

	public init(
		topology: GPUPrimitiveTopology = .triangleList,
		frontFace: GPUFrontFace = .ccw,
		cullMode: GPUCullMode = .none
	) {
		self.topology = topology
		self.frontFace = frontFace
		self.cullMode = cullMode
	}
}

@JS public struct GPUColorTargetState {
	public var format: GPUTextureFormat
	public var writeMask: GPUColorWrite = .all

	public init(format: GPUTextureFormat, writeMask: GPUColorWrite = .all) {
		self.format = format
		self.writeMask = writeMask
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



