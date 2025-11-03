// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing

@testable import Dawn

struct StructsTest {
	@Test("Constructing a GPUShaderModuleDescriptor")
	func testConstructingAGPUShaderModuleDescriptor() {
		let descriptor = GPUShaderModuleDescriptor(label: "test", code: "fn main() -> void { }")

		descriptor.withWGPUStruct { wgpuStruct in
			let label = String(cString: wgpuStruct.label.data!)
			#expect(wgpuStruct.label.length == 4)
			let chainPointer = wgpuStruct.nextInChain
			let rawChainPointer = UnsafeRawPointer(chainPointer)!
			let codePointer = rawChainPointer.load(as: WGPUShaderSourceWGSL.self)
			let code = String(cString: codePointer.code.data!)
			#expect(codePointer.code.length == 21)
			#expect(label == "test")
			#expect(code == "fn main() -> void { }")
			#expect(chainPointer?.pointee.next == nil)
			#expect(chainPointer?.pointee.sType == .shaderSourceWGSL)
		}
	}
}
