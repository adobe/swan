// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass public struct GPUDevice {
	@JSGetter(jsName: "queue") var _queue: GPUQueue

	public var queue: GPUQueue {
		get {
			return try! _queue
		}
	}

	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "createBuffer")
	func _createBuffer(_ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer

	@JSFunction(jsName: "createTexture")
	func _createTexture(_ descriptor: GPUTextureDescriptor) throws(JSException) -> GPUTexture

	@JSFunction(jsName: "createSampler")
	func _createSampler(_ descriptor: GPUSamplerDescriptor) throws(JSException) -> GPUSampler

	@JSFunction(jsName: "createQuerySet")
	func _createQuerySet(_ descriptor: GPUQuerySetDescriptor) throws(JSException) -> GPUQuerySet

	@JSFunction(jsName: "createShaderModule")
	func _createShaderModule(_ descriptor: GPUShaderModuleDescriptor) throws(JSException) -> GPUShaderModule

	@JSFunction(jsName: "createRenderPipeline")
	func _createRenderPipeline(_ descriptor: GPURenderPipelineDescriptor) throws(JSException) -> GPURenderPipeline

	@JSFunction(jsName: "createCommandEncoder")
	func _createCommandEncoder(_ descriptor: GPUCommandEncoderDescriptor) throws(JSException) -> GPUCommandEncoder

	@JSFunction(jsName: "createBindGroupLayout")
	func _createBindGroupLayout(_ descriptor: GPUBindGroupLayoutDescriptor) throws(JSException) -> GPUBindGroupLayout

	@JSFunction(jsName: "createBindGroup")
	func _createBindGroup(_ descriptor: GPUBindGroupDescriptor) throws(JSException) -> GPUBindGroup

	@JSFunction(jsName: "createBindGroup")
	func _createBindGroupRaw(_ descriptor: JSObject) throws(JSException) -> GPUBindGroup

	@JSFunction(jsName: "createPipelineLayout")
	func _createPipelineLayout(_ descriptor: GPUPipelineLayoutDescriptor) throws(JSException) -> GPUPipelineLayout

	@JSFunction(jsName: "createComputePipeline")
	func _createComputePipeline(_ descriptor: GPUComputePipelineDescriptor) throws(JSException) -> GPUComputePipeline

	@JSFunction(jsName: "pushErrorScope")
	func _pushErrorScope(_ filter: String) throws(JSException)

	@JSFunction(jsName: "popErrorScope")
	func _popErrorScope() throws(JSException) -> JSObject

	public func createBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer {
		try! _createBuffer(descriptor)
	}

	public func createTexture(descriptor: GPUTextureDescriptor) -> GPUTexture {
		try! _createTexture(descriptor)
	}

	public func createSampler(descriptor: GPUSamplerDescriptor?) -> GPUSampler {
		try! _createSampler(descriptor ?? GPUSamplerDescriptor())
	}

	public func createQuerySet(descriptor: GPUQuerySetDescriptor) -> GPUQuerySet {
		try! _createQuerySet(descriptor)
	}

	public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
		try! _createShaderModule(descriptor)
	}

	public func createRenderPipeline(descriptor: GPURenderPipelineDescriptor) -> GPURenderPipeline {
		try! _createRenderPipeline(descriptor)
	}

	public func createCommandEncoder(descriptor: GPUCommandEncoderDescriptor) -> GPUCommandEncoder {
		try! _createCommandEncoder(descriptor)
	}

	public func createCommandEncoder(descriptor: GPUCommandEncoderDescriptor?) -> GPUCommandEncoder {
		try! _createCommandEncoder(descriptor ?? GPUCommandEncoderDescriptor())
	}

	public func createCommandEncoder() -> GPUCommandEncoder {
		try! _createCommandEncoder(GPUCommandEncoderDescriptor())
	}

	public func createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor) -> GPUBindGroupLayout {
		try! _createBindGroupLayout(descriptor)
	}

	public func createBindGroup(descriptor: GPUBindGroupDescriptor) -> GPUBindGroup {
		try! _createBindGroup(descriptor)
	}

	/// Create a bind group with mixed resource types (buffer, sampler, textureView).
	/// Serializes entries manually as a JS object because BridgeJS serializes associated-value
	/// enums as tagged unions `{ tag: N, ... }`, which is incompatible with the WebGPU API's
	/// expectation that `resource` is a raw `GPUBufferBinding`, `GPUTextureView`, or `GPUSampler`
	/// object.
	public func createBindGroup(label: String? = nil, layout: GPUBindGroupLayout, entries: [GPUBindGroupEntryEx]) -> GPUBindGroup {
		let desc = JSObject.global.Object.function!.new()
		if let l = label { desc.label = .string(l) }
		desc.layout = layout.jsObject.jsValue
		let jsEntries = JSObject.global.Array.function!.new()
		for (idx, entry) in entries.enumerated() {
			let e = JSObject.global.Object.function!.new()
			e.binding = .number(Double(entry.binding))
			switch entry.resource {
			case .buffer(let bb):
				let res = JSObject.global.Object.function!.new()
				res.buffer = bb.buffer.jsObject.jsValue
				if let off = bb.offset { res.offset = .number(Double(off)) }
				if let sz = bb.size { res.size = .number(Double(sz)) }
				e.resource = .object(res)
			case .textureView(let tv):
				e.resource = tv.jsObject.jsValue
			case .sampler(let s):
				e.resource = s.jsObject.jsValue
			}
			jsEntries[idx] = e.jsValue
		}
		desc.entries = jsEntries.jsValue
		return try! _createBindGroupRaw(desc)
	}

	public func createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor) -> GPUPipelineLayout {
		try! _createPipelineLayout(descriptor)
	}

	public func createComputePipeline(descriptor: GPUComputePipelineDescriptor) -> GPUComputePipeline {
		try! _createComputePipeline(descriptor)
	}

	public func pushErrorScope(filter: GPUErrorType) {
		let filterStr: String
		switch filter {
		case .validation: filterStr = "validation"
		case .outOfMemory: filterStr = "out-of-memory"
		case .internal: filterStr = "internal"
		default: preconditionFailure("Invalid filter for pushErrorScope: \(filter)")
		}
		try! _pushErrorScope(filterStr)
	}

	@discardableResult
	public func popErrorScope(callbackInfo: GPUPopErrorScopeCallbackInfo) -> GPUFuture {
		let promise = JSPromise(unsafelyWrapping: try! _popErrorScope())
		promise.then(
			success: { errorVal in
				guard let errObj = errorVal.object else {
					callbackInfo.callback(.success, .noError, nil)
					return .undefined
				}
				let message = errObj.message.string
				let ctorName = errObj.constructor.object?.name.string ?? ""
				let errorType: GPUErrorType
				switch ctorName {
				case "GPUValidationError": errorType = .validation
				case "GPUOutOfMemoryError": errorType = .outOfMemory
				case "GPUInternalError": errorType = .internal
				default: errorType = .unknown
				}
				callbackInfo.callback(.success, errorType, message)
				return .undefined
			},
			failure: { _ in
				callbackInfo.callback(.error, .noError, nil)
				return .undefined
			}
		)
		return GPUFuture()
	}

	// createComputePipelineAsync — on WASM this is Promise-based;
	// for source compatibility we call the sync version and invoke callback.
	@discardableResult
	public func createComputePipelineAsync(descriptor: GPUComputePipelineDescriptor, callbackInfo: GPUCreateComputePipelineAsyncCallbackInfo) -> GPUFuture {
		let pipeline = try! _createComputePipeline(descriptor)
		callbackInfo.callback(.success, pipeline, nil)
		return GPUFuture()
	}
}
