// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Testing

@testable import WebGPU

struct WebGPUDeviceTests {

	@Test("GPUAdapter.getInfo returns populated adapter info with strings")
	@MainActor
	func testGPUAdapterGetInfo() {
		let (_, adapter, _) = setupGPU()

		var info = GPUAdapterInfo()
		let status = adapter.getInfo(info: &info)

		#expect(status == .success)
		#expect(!info.vendor.isEmpty)
		#expect(!info.device.isEmpty)
		#expect(!info.description.isEmpty)
		// info.architecture may be empty on some CI/GPU configurations, so we're not checking that.
	}

	@Test("GPUShaderModule.getCompilationInfo returns compilation info for valid shader")
	@MainActor
	func testGPUShaderModuleGetCompilationInfo() {
		let (instance, _, device) = setupGPU()

		let shaderCode = """
			@vertex
			fn vertexMain() -> @builtin(position) vec4f {
				return vec4f(0.0, 0.0, 0.0, 1.0);
			}
			"""
		let shaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Test Shader", code: shaderCode)
		)

		var compilationInfo: GPUCompilationInfo?
		_ = shaderModule.getCompilationInfo(
			callbackInfo: GPUCompilationInfoCallbackInfo(
				mode: .allowProcessEvents,
				callback: { status, info in
					#expect(status == .success)
					compilationInfo = info
				}
			)
		)

		while compilationInfo == nil {
			instance.processEvents()
		}

		// A valid shader should compile with no error messages
		// (may have 0 messages or info-level messages depending on Dawn version)
		for message in compilationInfo!.messages {
			#expect(message.type != .error)
		}
	}

	@Test("GPUShaderModule.getCompilationInfo returns error for invalid shader")
	@MainActor
	func testGPUShaderModuleGetCompilationInfoInvalidShader() {
		// Suppress uncaptured error output — the invalid shader intentionally triggers a validation error
		let (instance, _, device) = setupGPU(suppressErrors: true)

		let shaderCode = """
			@vertex
			fn vertexMain() -> @builtin(position) vec4f {
				return notAVariable;
			}
			"""
		let shaderModule = device.createShaderModule(
			descriptor: GPUShaderModuleDescriptor(label: "Invalid Shader", code: shaderCode)
		)

		var compilationInfo: GPUCompilationInfo?
		_ = shaderModule.getCompilationInfo(
			callbackInfo: GPUCompilationInfoCallbackInfo(
				mode: .allowProcessEvents,
				callback: { status, info in
					#expect(status == .success)
					compilationInfo = info
				}
			)
		)

		while compilationInfo == nil {
			instance.processEvents()
		}

		// An invalid shader should have at least one error message
		let errorMessages = compilationInfo!.messages.filter { $0.type == .error }
		#expect(!errorMessages.isEmpty)
	}
}
