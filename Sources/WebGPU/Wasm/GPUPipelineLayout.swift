// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public struct GPUPipelineLayoutDescriptor {
	public var label: String?
	public var bindGroupLayouts: [GPUBindGroupLayout]

	public init(
		label: String? = nil,
		bindGroupLayouts: [GPUBindGroupLayout]
	) {
		self.label = label
		self.bindGroupLayouts = bindGroupLayouts
	}
}

@JSClass public struct GPUPipelineLayout {
	@JSSetter(jsName: "label") func setInternalLabel(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setInternalLabel(value)
	}
}
