// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

public struct GPUBufferUsage: OptionSet, Sendable {
	public let rawValue: UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	public static let mapRead = GPUBufferUsage(rawValue: 0x0001)
	public static let mapWrite = GPUBufferUsage(rawValue: 0x0002)
	public static let copySrc = GPUBufferUsage(rawValue: 0x0004)
	public static let copyDst = GPUBufferUsage(rawValue: 0x0008)
	public static let index = GPUBufferUsage(rawValue: 0x0010)
	public static let vertex = GPUBufferUsage(rawValue: 0x0020)
	public static let uniform = GPUBufferUsage(rawValue: 0x0040)
	public static let storage = GPUBufferUsage(rawValue: 0x0080)
	public static let indirect = GPUBufferUsage(rawValue: 0x0100)
	public static let queryResolve = GPUBufferUsage(rawValue: 0x0200)
}

public struct GPUShaderStage: OptionSet, Sendable {
	public let rawValue: UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	public static let vertex = GPUShaderStage(rawValue: 0x1)
	public static let fragment = GPUShaderStage(rawValue: 0x2)
	public static let compute = GPUShaderStage(rawValue: 0x4)
}

public struct GPUTextureUsage: OptionSet, Sendable {
	public let rawValue: UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	public static let copySrc = GPUTextureUsage(rawValue: 0x01)
	public static let copyDst = GPUTextureUsage(rawValue: 0x02)
	public static let textureBinding = GPUTextureUsage(rawValue: 0x04)
	public static let storageBinding = GPUTextureUsage(rawValue: 0x08)
	public static let renderAttachment = GPUTextureUsage(rawValue: 0x10)
}

public struct GPUColorWrite: OptionSet, Sendable {
	public let rawValue: UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	public static let red = GPUColorWrite(rawValue: 0x1)
	public static let green = GPUColorWrite(rawValue: 0x2)
	public static let blue = GPUColorWrite(rawValue: 0x4)
	public static let alpha = GPUColorWrite(rawValue: 0x8)
	public static let all = GPUColorWrite(rawValue: 0xF)
}
