// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public enum GPUPrimitiveTopology: String, Sendable {
	case pointList = "point-list"
	case lineList = "line-list"
	case lineStrip = "line-strip"
	case triangleList = "triangle-list"
	case triangleStrip = "triangle-strip"
}

@JS public enum GPUVertexFormat: String, Sendable {
	case uint8x2 = "uint8x2"
	case uint8x4 = "uint8x4"
	case sint8x2 = "sint8x2"
	case sint8x4 = "sint8x4"
	case unorm8x2 = "unorm8x2"
	case unorm8x4 = "unorm8x4"
	case snorm8x2 = "snorm8x2"
	case snorm8x4 = "snorm8x4"
	case float16x2 = "float16x2"
	case float16x4 = "float16x4"
	case float32 = "float32"
	case float32x2 = "float32x2"
	case float32x3 = "float32x3"
	case float32x4 = "float32x4"
	case uint32 = "uint32"
	case uint32x2 = "uint32x2"
	case uint32x3 = "uint32x3"
	case uint32x4 = "uint32x4"
	case sint32 = "sint32"
	case sint32x2 = "sint32x2"
	case sint32x3 = "sint32x3"
	case sint32x4 = "sint32x4"
}

@JS public enum GPUVertexStepMode: String, Sendable {
	case vertex = "vertex"
	case instance = "instance"
}

@JS public enum GPUTextureFormat: String, Sendable {
	case bgra8unorm = "bgra8unorm"
	case bgra8unormSrgb = "bgra8unorm-srgb"
	case rgba8unorm = "rgba8unorm"
	case rgba8unormSrgb = "rgba8unorm-srgb"

	public static let BGRA8Unorm = GPUTextureFormat.bgra8unorm
	public static let BGRA8UnormSrgb = GPUTextureFormat.bgra8unormSrgb
	public static let RGBA8Unorm = GPUTextureFormat.rgba8unorm
	public static let RGBA8UnormSrgb = GPUTextureFormat.rgba8unormSrgb
}

@JS public enum GPULoadOp: String, Sendable {
	case load = "load"
	case clear = "clear"
}

@JS public enum GPUStoreOp: String, Sendable {
	case store = "store"
	case discard = "discard"
}

@JS public enum GPUFrontFace: String, Sendable {
	case ccw = "ccw"
	case cw = "cw"

	public static let CCW = GPUFrontFace.ccw
	public static let CW = GPUFrontFace.cw
}

@JS public enum GPUCullMode: String, Sendable {
	case none = "none"
	case front = "front"
	case back = "back"
}

@JS public enum GPUIndexFormat: String, Sendable {
	case undefined = "undefined"
	case uint16 = "uint16"
	case uint32 = "uint32"
	case force32 = "force32"
}

@JS public enum GPUBufferBindingType: String, Sendable {
	case uniform = "uniform"
	case storage = "storage"
	case readOnlyStorage = "read-only-storage"
}
