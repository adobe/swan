// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JS struct GPUBufferDescriptor {
	var label: String?
	var size: Int
	var usage: Int
	var mappedAtCreation: Bool = false

	init(
		label: String? = nil,
		size: Int,
		usage: Int,
		mappedAtCreation: Bool = false
	) {
		self.label = label
		self.size = size
		self.usage = usage
		self.mappedAtCreation = mappedAtCreation
	}

	init(
		label: String? = nil,
		size: Int,
		usage: GPUBufferUsage,
		mappedAtCreation: Bool = false
	) {
		self.init(label: label, size: size, usage: Int(usage.rawValue), mappedAtCreation: mappedAtCreation)
	}
}

@JS struct GPUShaderModuleDescriptor {
	var label: String?
	var code: String

	init(label: String? = nil, code: String) {
		self.label = label
		self.code = code
	}
}

@JS struct GPUVertexAttribute {
	var format: GPUVertexFormat
	var offset: Int
	var shaderLocation: Int

	init(format: GPUVertexFormat, offset: Int, shaderLocation: Int) {
		self.format = format
		self.offset = offset
		self.shaderLocation = shaderLocation
	}
}

@JS struct GPUVertexBufferLayout {
	var arrayStride: Int
	var stepMode: GPUVertexStepMode = .vertex
	var attributes: [GPUVertexAttribute]

	init(
		arrayStride: Int,
		stepMode: GPUVertexStepMode = .vertex,
		attributes: [GPUVertexAttribute]
	) {
		self.arrayStride = arrayStride
		self.stepMode = stepMode
		self.attributes = attributes
	}
}

@JS struct GPUPrimitiveState {
	var topology: GPUPrimitiveTopology = .triangleList
	var frontFace: GPUFrontFace = .ccw
	var cullMode: GPUCullMode = .none

	init(
		topology: GPUPrimitiveTopology = .triangleList,
		frontFace: GPUFrontFace = .ccw,
		cullMode: GPUCullMode = .none
	) {
		self.topology = topology
		self.frontFace = frontFace
		self.cullMode = cullMode
	}
}

@JS struct GPUColorTargetState {
	var format: GPUTextureFormat
	var writeMask: Int = Int(GPUColorWrite.all.rawValue)

	init(format: GPUTextureFormat, writeMask: Int) {
		self.format = format
		self.writeMask = writeMask
	}

	init(format: GPUTextureFormat, writeMask: GPUColorWrite = .all) {
		self.init(format: format, writeMask: Int(writeMask.rawValue))
	}
}

@JS struct GPUColor {
	var r: Double
	var g: Double
	var b: Double
	var a: Double

	init(r: Double, g: Double, b: Double, a: Double) {
		self.r = r
		self.g = g
		self.b = b
		self.a = a
	}
}

@JS struct GPUCommandEncoderDescriptor {
	var label: String?

	init(label: String? = nil) {
		self.label = label
	}
}
