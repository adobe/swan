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
	@JSSetter(jsName: "label") func setLabel_(_ value: String) throws(JSException)

	public func setLabel(label: String) {
		try! setLabel_(label)
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

	/// Manual createSampler that constructs the JS descriptor directly.
	/// BridgeJS serializes `compare: nil` as `compare: null`, but WebGPU
	/// rejects null as an invalid GPUCompareFunction enum value. We omit
	/// the `compare` field entirely when it's nil.
	public func createSampler(descriptor: GPUSamplerDescriptor?) -> GPUSampler {
		let d = descriptor ?? GPUSamplerDescriptor()
		let obj = JSObject.global.Object.function!.new()
		if let l = d.label { obj.label = .string(l) }
		obj.addressModeU = .string(d.addressModeU.rawValue)
		obj.addressModeV = .string(d.addressModeV.rawValue)
		obj.addressModeW = .string(d.addressModeW.rawValue)
		obj.magFilter = .string(d.magFilter.rawValue)
		obj.minFilter = .string(d.minFilter.rawValue)
		obj.mipmapFilter = .string(d.mipmapFilter.rawValue)
		obj.lodMinClamp = .number(d.lodMinClamp)
		obj.lodMaxClamp = .number(d.lodMaxClamp)
		if let cmp = d.compare {
			obj.compare = .string(cmp.rawValue)
		}
		obj.maxAnisotropy = .number(Double(d.maxAnisotropy))
		let result = self.jsObject.createSampler!(obj)
		return GPUSampler(unsafelyWrapping: result.object!)
	}

	public func createQuerySet(descriptor: GPUQuerySetDescriptor) -> GPUQuerySet {
		try! _createQuerySet(descriptor)
	}

	public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
		try! _createShaderModule(descriptor)
	}

	/// Manual createRenderPipeline that constructs the JS descriptor directly.
	/// BridgeJS serializes nil optional fields (depthStencil, fragment, blend, etc.)
	/// as null, but WebGPU rejects present-but-null values for dictionary members.
	public func createRenderPipeline(descriptor: GPURenderPipelineDescriptor) -> GPURenderPipeline {
		let obj = JSObject.global.Object.function!.new()
		if let l = descriptor.label { obj.label = .string(l) }
		if let layout = descriptor.layout { obj.layout = layout.jsObject.jsValue }

		// vertex state
		let vertex = JSObject.global.Object.function!.new()
		vertex.module = descriptor.vertex.module.jsObject.jsValue
		if let ep = descriptor.vertex.entryPoint { vertex.entryPoint = .string(ep) }
		let bufs = JSObject.global.Array.function!.new()
		for (i, buf) in descriptor.vertex.buffers.enumerated() {
			let b = JSObject.global.Object.function!.new()
			b.arrayStride = .number(Double(buf.arrayStride))
			b.stepMode = .string(buf.stepMode.rawValue)
			let attrs = JSObject.global.Array.function!.new()
			for (j, attr) in buf.attributes.enumerated() {
				let a = JSObject.global.Object.function!.new()
				a.format = .string(attr.format.rawValue)
				a.offset = .number(Double(attr.offset))
				a.shaderLocation = .number(Double(attr.shaderLocation))
				attrs[j] = a.jsValue
			}
			b.attributes = attrs.jsValue
			bufs[i] = b.jsValue
		}
		vertex.buffers = bufs.jsValue
		obj.vertex = vertex.jsValue

		// primitive state
		let prim = JSObject.global.Object.function!.new()
		prim.topology = .string(descriptor.primitive.topology.rawValue)
		prim.frontFace = .string(descriptor.primitive.frontFace.rawValue)
		prim.cullMode = .string(descriptor.primitive.cullMode.rawValue)
		obj.primitive = prim.jsValue

		// depthStencil (optional — omit entirely when nil)
		if let ds = descriptor.depthStencil {
			let d = JSObject.global.Object.function!.new()
			d.format = .string(ds.format.rawValue)
			d.depthWriteEnabled = .boolean(ds.depthWriteEnabled)
			d.depthCompare = .string(ds.depthCompare.rawValue)
			func serializeStencilFace(_ sf: GPUStencilFaceState) -> JSObject {
				let s = JSObject.global.Object.function!.new()
				s.compare = .string(sf.compare.rawValue)
				s.failOp = .string(sf.failOp.rawValue)
				s.depthFailOp = .string(sf.depthFailOp.rawValue)
				s.passOp = .string(sf.passOp.rawValue)
				return s
			}
			d.stencilFront = serializeStencilFace(ds.stencilFront).jsValue
			d.stencilBack = serializeStencilFace(ds.stencilBack).jsValue
			d.stencilReadMask = .number(Double(ds.stencilReadMask))
			d.stencilWriteMask = .number(Double(ds.stencilWriteMask))
			d.depthBias = .number(Double(ds.depthBias))
			d.depthBiasSlopeScale = .number(ds.depthBiasSlopeScale)
			d.depthBiasClamp = .number(ds.depthBiasClamp)
			obj.depthStencil = d.jsValue
		}

		// multisample — mask is stored as Int (signed 32-bit on wasm32);
		// 0xFFFFFFFF becomes -1, which WebGPU rejects for unsigned long.
		let ms = JSObject.global.Object.function!.new()
		ms.count = .number(Double(descriptor.multisample.count))
		ms.mask = .number(Double(UInt32(bitPattern: Int32(truncatingIfNeeded: descriptor.multisample.mask))))
		ms.alphaToCoverageEnabled = .boolean(descriptor.multisample.alphaToCoverageEnabled)
		obj.multisample = ms.jsValue

		// fragment (optional — omit entirely when nil)
		if let frag = descriptor.fragment {
			let f = JSObject.global.Object.function!.new()
			f.module = frag.module.jsObject.jsValue
			if let ep = frag.entryPoint { f.entryPoint = .string(ep) }
			let targets = JSObject.global.Array.function!.new()
			for (i, target) in frag.targets.enumerated() {
				let t = JSObject.global.Object.function!.new()
				t.format = .string(target.format.rawValue)
				t.writeMask = .number(Double(target.writeMask))
				if let blend = target.blend {
					let bl = JSObject.global.Object.function!.new()
					func serializeBlendComponent(_ bc: GPUBlendComponent) -> JSObject {
						let c = JSObject.global.Object.function!.new()
						c.operation = .string(bc.operation.rawValue)
						c.srcFactor = .string(bc.srcFactor.rawValue)
						c.dstFactor = .string(bc.dstFactor.rawValue)
						return c
					}
					bl.color = serializeBlendComponent(blend.color).jsValue
					bl.alpha = serializeBlendComponent(blend.alpha).jsValue
					t.blend = bl.jsValue
				}
				targets[i] = t.jsValue
			}
			f.targets = targets.jsValue
			obj.fragment = f.jsValue
		}

		let result = self.jsObject.createRenderPipeline!(obj)
		return GPURenderPipeline(unsafelyWrapping: result.object!)
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

	/// Manual createBindGroupLayout that constructs JS objects directly.
	/// BridgeJS includes null optional fields (buffer, sampler, texture, storageTexture)
	/// in the serialized object, but WebGPU validates present-but-null values and rejects
	/// them with "not of type GPUStorageTextureBindingLayout" etc.
	public func createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor) -> GPUBindGroupLayout {
		let desc = JSObject.global.Object.function!.new()
		if let l = descriptor.label { desc.label = .string(l) }
		let jsEntries = JSObject.global.Array.function!.new()
		for (idx, entry) in descriptor.entries.enumerated() {
			let e = JSObject.global.Object.function!.new()
			e.binding = .number(Double(entry.binding))
			e.visibility = .number(Double(entry.visibility))
			if let buf = entry.buffer {
				let b = JSObject.global.Object.function!.new()
				b.type = .string(buf.type.rawValue)
				b.hasDynamicOffset = .boolean(buf.hasDynamicOffset)
				b.minBindingSize = .number(Double(buf.minBindingSize))
				e.buffer = .object(b)
			}
			if let sam = entry.sampler {
				let s = JSObject.global.Object.function!.new()
				s.type = .string(sam.type.rawValue)
				e.sampler = .object(s)
			}
			if let tex = entry.texture {
				let t = JSObject.global.Object.function!.new()
				t.sampleType = .string(tex.sampleType.rawValue)
				t.viewDimension = .string(tex.viewDimension.rawValue)
				t.multisampled = .boolean(tex.multisampled)
				e.texture = .object(t)
			}
			if let st = entry.storageTexture {
				let s = JSObject.global.Object.function!.new()
				s.access = .string(st.access.rawValue)
				s.format = .string(st.format.rawValue)
				s.viewDimension = .string(st.viewDimension.rawValue)
				e.storageTexture = .object(s)
			}
			jsEntries[idx] = e.jsValue
		}
		desc.entries = jsEntries.jsValue
		let result = self.jsObject.createBindGroupLayout!(desc)
		return GPUBindGroupLayout(unsafelyWrapping: result.object!)
	}

	/// Manual createBindGroup — BridgeJS serializes nil `offset`/`size` in GPUBufferBinding
	/// as null, but WebGPU interprets null size as 0 (not "whole buffer"). We omit nil fields.
	public func createBindGroup(descriptor: GPUBindGroupDescriptor) -> GPUBindGroup {
		let desc = JSObject.global.Object.function!.new()
		if let l = descriptor.label { desc.label = .string(l) }
		desc.layout = descriptor.layout.jsObject.jsValue
		let jsEntries = JSObject.global.Array.function!.new()
		for (idx, entry) in descriptor.entries.enumerated() {
			let e = JSObject.global.Object.function!.new()
			e.binding = .number(Double(entry.binding))
			let res = JSObject.global.Object.function!.new()
			res.buffer = entry.resource.buffer.jsObject.jsValue
			if let off = entry.resource.offset { res.offset = .number(Double(off)) }
			if let sz = entry.resource.size { res.size = .number(Double(sz)) }
			e.resource = res.jsValue
			jsEntries[idx] = e.jsValue
		}
		desc.entries = jsEntries.jsValue
		let result = self.jsObject.createBindGroup!(desc)
		return GPUBindGroup(unsafelyWrapping: result.object!)
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
