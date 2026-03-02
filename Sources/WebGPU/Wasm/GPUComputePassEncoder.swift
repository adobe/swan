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
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "setPipeline")
	func _setPipeline(_ pipeline: GPUComputePipeline) throws(JSException)

	@JSFunction(jsName: "setBindGroup")
	func _setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction(jsName: "dispatchWorkgroups")
	func _dispatchWorkgroups(_ workgroupCountX: Int, _ workgroupCountY: Int, _ workgroupCountZ: Int) throws(JSException)

	@JSFunction(jsName: "end")
	func _end() throws(JSException)

	public func setPipeline(pipeline: GPUComputePipeline) {
		try! _setPipeline(pipeline)
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		try! _setBindGroup(Int(groupIndex), group)
	}

	public func dispatchWorkgroups(workgroupCountX: UInt32, workgroupCountY: UInt32, workgroupCountZ: UInt32) {
		try! _dispatchWorkgroups(Int(workgroupCountX), Int(workgroupCountY), Int(workgroupCountZ))
	}

	public func end() {
		try! _end()
	}
}
