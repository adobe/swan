// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@_spi(Experimental)
@JS public struct GPUComputePassDescriptor {
	public var label: String?

	public init(label: String? = nil) {
		self.label = label
	}
}

@_spi(Experimental)
@JSClass public struct GPUComputePassEncoder {
	public let jsObject: JSObject
	public init(unsafelyWrapping jsObject: JSObject) {
		self.jsObject = jsObject
	}

	@JSGetter public var label: String?

	@JSFunction
	public func setPipeline(_ pipeline: GPUComputePipeline) throws(JSException)

	@JSFunction
	public func setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction
	public func dispatchWorkgroups(
		_ workgroupCountX: Int,
		_ workgroupCountY: Int,
		_ workgroupCountZ: Int
	) throws(JSException)

	@JSFunction
	public func end() throws(JSException)
}
