// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// extension WGPUShaderModuleDescriptor: RootStruct {}
// extension WGPUShaderSourceWGSL: ChainedStruct {}

// public struct GPUShaderModuleWGSLDescriptor: GPUChainedStruct {
// 	public typealias WGPUType = WGPUShaderSourceWGSL
// 	public var code: String = ""
// 	public let sType: GPUSType = .shaderSourceWGSL

// 	public init() {}

// 	public init(code: String) {
// 		self.code = code
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ shaderSourceWGSL: inout WGPUShaderSourceWGSL,
// 		_ lambda: (UnsafeMutablePointer<WGPUShaderSourceWGSL>) -> R
// 	) -> R {
// 		return code.withWGPUStringView { codeStringView in
// 			shaderSourceWGSL.code = codeStringView
// 			return lambda(&shaderSourceWGSL)
// 		}
// 	}
// }

// public struct GPUShaderModuleDescriptor: GPUStructRoot {
// 	public typealias WGPUType = WGPUShaderModuleDescriptor

// 	public var label: String = ""

// 	public var chain: [any GPUChainedStruct] = []

// 	public init() {}

// 	public init(label: String, code: String) {
// 		self.label = label
// 		self.chain = [GPUShaderModuleWGSLDescriptor(code: code)]
// 	}

// 	public func applyPropertiesToWGPUStruct<R>(
// 		_ wgpuStruct: inout WGPUShaderModuleDescriptor,
// 		_ lambda: (UnsafeMutablePointer<WGPUShaderModuleDescriptor>) -> R
// 	) -> R {
// 		label.withWGPUStringView { labelStringView in
// 			wgpuStruct.label = labelStringView
// 			return lambda(&wgpuStruct)
// 		}
// 	}
// }
