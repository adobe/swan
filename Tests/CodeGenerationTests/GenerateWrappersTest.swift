// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import Testing

@testable import GenerateDawnBindings

struct TestTypeDescriptor: TypeDescriptor {
	var type: Name
	var optional: Bool
	var annotation: String?
	var length: ArraySize?
	var `default`: DawnDefaultValue?

	init(
		type: Name,
		optional: Bool = false,
		annotation: String? = nil,
		length: ArraySize? = nil,
		`default`: DawnDefaultValue? = nil
	) {
		self.type = type
		self.optional = optional
		self.annotation = annotation
		self.length = length
		self.default = `default`
	}
}

@Suite struct GenerateWrappersTest {

	@Test("GenerateWrappersTest")
	func testGenerateWrappers() {
		let shaderModuleDescriptor = """
			{
			    "shader module descriptor": {
			        "category": "structure",
			        "extensible": "in",
			        "members": [
			            {"name": "label", "type": "string view", "optional": true}
			        ]
			    },
			    "shader source WGSL": {
			        "category": "structure",
			        "chained": "in",
			        "chain roots": ["shader module descriptor"],
			        "members": [
			            {"name": "code", "type": "string view"}
			        ]
			    },
				"string view": {
					"category": "structure",
					"members": [
						{"name": "data", "type": "char", "annotation": "const*", "optional": true},
						{"name": "length", "type": "size_t", "default": "strlen"}
					]
				},
			}
			"""

		let data = try? JSONDecoder().decode(DawnData.self, from: shaderModuleDescriptor.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}
		let wrappers = try? data.generateWrappers(swiftFormatConfiguration: nil)
		#expect(wrappers!.count > 0)
	}

	@Test("Unwrapping a structure")
	func testUnwrappingAStructure() {
		let shaderModule = deviceDawnData

		let data = try? JSONDecoder().decode(DawnData.self, from: shaderModule.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let typeDescriptor = TestTypeDescriptor(type: Name("shader module descriptor"))
		let unwrapped = typeDescriptor.unwrapValueWithIdentifier(
			"shaderModuleDescriptor",
			data: data,
			expression: ExprSyntax("print(shaderModuleDescriptor)")
		)
		let expected = ExprSyntax(
			"""
			shaderModuleDescriptor.withWGPUStruct { shaderModuleDescriptor in
				print(shaderModuleDescriptor)
			}
			"""
		).formatted().description
		#expect(unwrapped.formatted().description == expected)
	}

	@Test("Wrapped method call")
	func testWrappedMethodCall() {
		let shaderModule = deviceDawnData

		let data = try? JSONDecoder().decode(DawnData.self, from: shaderModule.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let device = data.data[Name("device")]
		guard let device = device else {
			Issue.record("Failed to get device")
			return
		}
		guard case .object(let object) = device else {
			Issue.record("Device is not an object")
			return
		}
		let createShaderModule = object.methods.first { $0.name == Name("create shader module") }
		guard let createShaderModule = createShaderModule else {
			Issue.record("Failed to get create shader module")
			return
		}

		let unwrapped = createShaderModule.methodWrapperDecl(data: data)
		let expected = DeclSyntax(
			"""
			public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
					return descriptor.withWGPUPointer { descriptor in
						createShaderModule(descriptor: descriptor)
					}
			}
			"""
		).formatted(using: TabFormat(initialIndentation: .tabs(0)))
		#expect(unwrapped.formatted().description == expected.description)
	}

	@Test("Wrapping structures")
	func testWrappingStructures() {
		let data = try? JSONDecoder().decode(DawnData.self, from: adapterDawnData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let adapterInfo = data.data[Name("adapter info")]
		guard let adapterInfo = adapterInfo else {
			Issue.record("Failed to get adapter info")
			return
		}

		guard case .structure(let structure) = adapterInfo else {
			Issue.record("Adapter info is not a structure")
			return
		}

		let declarations = try? structure.declarations(name: Name("adapter info"), needsWrap: false, data: data)
		guard let declarations = declarations else {
			Issue.record("Failed to get declarations")
			return
		}
		#expect(declarations.count > 0)
		let combined = DeclSyntax(
			"""
			\(raw:declarations.map { $0.formatted().description }.joined(separator: "\n"))
			"""
		).formatted(using: TabFormat(initialIndentation: .tabs(0)))

		let expected = DeclSyntax(
			"""
			extension WGPUAdapterInfo: RootStruct {
			}
			public struct GPUAdapterInfo: GPURootStruct {
				public typealias WGPUType = WGPUAdapterInfo

				public var vendor: String
				public var architecture: String
				public var device: String
				public var description: String
				public var backendType: GPUBackendType
				public var adapterType: GPUAdapterType
				public var vendorID: UInt32
				public var deviceID: UInt32
				public var subgroupMinSize: UInt32
				public var subgroupMaxSize: UInt32

				public var nextInChain: (any GPUChainedStruct)? = nil

				public init(vendor: String = "", architecture: String = "", device: String = "", description: String = "", backendType: GPUBackendType = .undefined, adapterType: GPUAdapterType = .discreteGPU, vendorID: UInt32 = 0, deviceID: UInt32 = 0, subgroupMinSize: UInt32 = 0, subgroupMaxSize: UInt32 = 0) {
					self.vendor = vendor
					self.architecture = architecture
					self.device = device
					self.description = description
					self.backendType = backendType
					self.adapterType = adapterType
					self.vendorID = vendorID
					self.deviceID = deviceID
					self.subgroupMinSize = subgroupMinSize
					self.subgroupMaxSize = subgroupMaxSize
				}



				public func withWGPUStruct<R>(
					_ lambda: (inout WGPUAdapterInfo) -> R
				) -> R {
					vendor.withWGPUStruct { vendor in
						architecture.withWGPUStruct { architecture in
							device.withWGPUStruct { device in
								description.withWGPUStruct { description in
									withWGPUStructChain { pointer in
										var wgpuStruct = WGPUAdapterInfo(nextInChain: pointer, vendor: vendor, architecture: architecture, device: device, description: description, backendType: backendType, adapterType: adapterType, vendorID: vendorID, deviceID: deviceID, subgroupMinSize: subgroupMinSize, subgroupMaxSize: subgroupMaxSize)
										return lambda(&wgpuStruct)
									}
								}
							}
						}
					}
				}
			}

			"""
		).formatted(using: TabFormat(initialIndentation: .tabs(0)))

		#expect(
			combined.description == expected.description
		)
	}

	@Test("Size parameter detection for Array types")
	func testIsSizeParameter() {
		let testData = """
			{
				"queue": {
					"category": "object",
					"methods": [
						{
							"name": "submit",
							"args": [
								{"name": "command count", "type": "size_t"},
								{"name": "commands", "type": "command buffer", "annotation": "const*", "length": "command count"}
							]
						}
					]
				},
				"command buffer": {
					"category": "object"
				},
				"size_t": {
					"category": "native"
				}
			}
			"""
		let data = try? JSONDecoder().decode(DawnData.self, from: testData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}
		guard case .object(let queue) = data.data[Name("queue")] else {
			Issue.record("Failed to get queue")
			return
		}
		let submitMethod = queue.methods.first { $0.name == Name("submit") }!
		let args = submitMethod.args!

		// Direct test of isSizeParameter. TODO - bmedina: do we want to test this interal function, or just use
		// the public API, as further down?
		// The first arg, "command count", should be detected as a size parameter.
		#expect(submitMethod.isSizeParameter(args[0], in: args, data: data))
		// The second arg is the array, and should not be detected as a size parameter.
		#expect(!submitMethod.isSizeParameter(args[1], in: args, data: data))

		// The publicArgs function should filter out the size parameter.
		// let publicArgs = submitMethod.publicArgs(data: data)
		// #expect(publicArgs.count == 1)
		// #expect(publicArgs[0].name == Name("commands"))

		let generated = submitMethod.methodWrapperDecl(data: data).formatted().description
		print(generated)
		#expect(generated.contains("commands"))
		// "command count" should have been excluded from the Swift API
		#expect(!generated.contains("command count"))
	}
}

let deviceDawnData = """
	{
		"device": {
			"category": "object",
			"methods": [
				{
					"name": "create shader module",
					"no autolock": true,
					"returns": "shader module",
					"args": [
						{"name": "descriptor", "type": "shader module descriptor", "annotation": "const*"}
					]
				},
			]
		},
		"shader module descriptor": {
			"category": "structure",
			"extensible": "in",
			"members": [
				{"name": "label", "type": "string view", "optional": true}
			]
		},
		"shader source WGSL": {
			"category": "structure",
			"chained": "in",
			"chain roots": ["shader module descriptor"],
			"members": [
				{"name": "code", "type": "string view"}
			]
		},
		"shader module": {
			"category": "object",
			"methods": [
				{
					"name": "get compilation info",
					"returns": "future",
					"args": [
						{"name": "callback info", "type": "compilation info callback info"}
					]
				},
				{
					"name": "set label",
					"args": [
						{"name": "label", "type": "string view"}
					]
				}
			]
		},
	}
	"""

let adapterDawnData = """
	{        
		"adapter": {
			"category": "object",
			"no autolock": true,
			"methods": [
				{
					"name": "request device",
					"returns": "future",
					"args": [
						{"name": "descriptor", "type": "device descriptor", "annotation": "const*", "optional": true, "no_default": true},
						{"name": "callback info", "type": "request device callback info"}
					]
				},
			]
		},
		"adapter info": {
			"category": "structure",
			"extensible": "out",
			"members": [
				{"name": "vendor", "type": "string view"},
				{"name": "architecture", "type": "string view"},
				{"name": "device", "type": "string view"},
				{"name": "description", "type": "string view"},
				{"name": "backend type", "type": "backend type"},
				{"name": "adapter type", "type": "adapter type"},
				{"name": "vendor ID", "type": "uint32_t"},
				{"name": "device ID", "type": "uint32_t"},
				{"name": "subgroup min size", "type": "uint32_t"},
				{"name": "subgroup max size", "type": "uint32_t"}
			]
		},
		"string view": {
			"category": "structure",
			"members": [
				{"name": "data", "type": "char", "annotation": "const*", "optional": true},
				{"name": "length", "type": "size_t", "default": "strlen"}
			]
		},
		"backend type": {
			"category": "enum",
			"emscripten_no_enum_table": true,
			"values": [
				{"value": 0, "name": "undefined", "jsrepr": "undefined", "valid": false},
				{"value": 1, "name": "null"},
				{"value": 2, "name": "WebGPU"},
				{"value": 3, "name": "D3D11"},
				{"value": 4, "name": "D3D12"},
				{"value": 5, "name": "metal"},
				{"value": 6, "name": "vulkan"},
				{"value": 7, "name": "openGL"},
				{"value": 8, "name": "openGLES"}
			]
		},
		"adapter type": {
			"category": "enum",
			"emscripten_no_enum_table": true,
			"values": [
				{"value": 1, "name": "discrete GPU"},
				{"value": 2, "name": "integrated GPU"},
				{"value": 3, "name": "CPU"},
				{"value": 4, "name": "unknown"}
			]
		},
		"uint32_t": {
			"category": "native",
			"wasm type": "i"
		},
	}
	"""
