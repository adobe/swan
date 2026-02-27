// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUComputeState {
	public var module: GPUShaderModule
	public var entryPoint: String

	public init(
		module: GPUShaderModule,
		entryPoint: String
	) {
		self.module = module
		self.entryPoint = entryPoint
	}
}

@JS public struct GPUComputePipelineDescriptor {
	public var label: String?
	public var layout: GPUPipelineLayout
	public var compute: GPUComputeState

	public init(
		label: String? = nil,
		layout: GPUPipelineLayout,
		compute: GPUComputeState
	) {
		self.label = label
		self.layout = layout
		self.compute = compute
	}
}

@JSClass public struct GPUComputePipeline {
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}
}
