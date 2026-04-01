// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUComputePassEncoder {
	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
	}

	@JSFunction(jsName: "setPipeline")
	func _setPipeline(_ pipeline: GPUComputePipeline) throws(JSException)

	@JSFunction(jsName: "setBindGroup")
	func _setBindGroup(_ groupIndex: Int, _ group: GPUBindGroup) throws(JSException)

	@JSFunction(jsName: "setBindGroup")
	func _setBindGroupWithOffsets(_ groupIndex: Int, _ group: GPUBindGroup, _ dynamicOffsets: JSObject) throws(JSException)

	@JSFunction(jsName: "dispatchWorkgroups")
	func _dispatchWorkgroups(_ workgroupCountX: Int, _ workgroupCountY: Int, _ workgroupCountZ: Int) throws(JSException)

	@JSFunction(jsName: "dispatchWorkgroupsIndirect")
	func _dispatchWorkgroupsIndirect(_ indirectBuffer: GPUBuffer, _ indirectOffset: Int) throws(JSException)

	@JSFunction(jsName: "writeTimestamp")
	func _writeTimestamp(_ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException)

	@JSFunction(jsName: "end")
	func _end() throws(JSException)

	public func setPipeline(pipeline: GPUComputePipeline) {
		try! _setPipeline(pipeline)
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup, dynamicOffsets: [UInt32]) {
		if dynamicOffsets.isEmpty {
			try! _setBindGroup(Int(groupIndex), group)
		} else {
			let offsetsArray = JSObject.global.Array.function!.new(dynamicOffsets.map { JSValue.number(Double($0)) })
			try! _setBindGroupWithOffsets(Int(groupIndex), group, offsetsArray)
		}
	}

	public func dispatchWorkgroups(workgroupCountX: UInt32, workgroupCountY: UInt32, workgroupCountZ: UInt32) {
		try! _dispatchWorkgroups(Int(workgroupCountX), Int(workgroupCountY), Int(workgroupCountZ))
	}

	public func dispatchWorkgroupsIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
		precondition(indirectOffset <= UInt64(Int.max), "indirectOffset \(indirectOffset) overflows Int on 32-bit WASM")
		try! _dispatchWorkgroupsIndirect(indirectBuffer, Int(indirectOffset))
	}

	public func writeTimestamp(querySet: GPUQuerySet, queryIndex: UInt32) {
		try! _writeTimestamp(querySet, Int(queryIndex))
	}

	public func end() {
		try! _end()
	}
}
