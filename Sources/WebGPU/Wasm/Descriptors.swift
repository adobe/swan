// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// Minimal descriptor types for the WebGPU Wasm spike.
// These mirror the browser WebGPU IDL; values match the Web GPU spec.

/// Buffer usage flags (matches Web GPU spec).
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
	public static let queryResolve = GPUBufferUsage(rawValue: 0x0100)
}

/// Descriptor for createBuffer (browser WebGPU).
public struct GPUBufferDescriptor {
	public var label: String?
	public var size: UInt64
	public var usage: GPUBufferUsage
	public var mappedAtCreation: Bool

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
