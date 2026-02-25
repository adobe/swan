// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUComputePassDescriptor {
	public var label: String?

	public init(label: String? = nil) {
		self.label = label
	}
}

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

public extension GPUComputePassEncoder {
	func setPipeline(pipeline: GPUComputePipeline) {
		try! setPipeline(pipeline)
	}

	func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		try! setBindGroup(Int(groupIndex), group)
	}

	func dispatchWorkgroups(workgroupCountX: UInt32, workgroupCountY: UInt32, workgroupCountZ: UInt32) {
		try! dispatchWorkgroups(Int(workgroupCountX), Int(workgroupCountY), Int(workgroupCountZ))
	}
}
