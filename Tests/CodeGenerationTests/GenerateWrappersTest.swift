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

				public init(vendor: String = "", architecture: String = "", device: String = "", description: String = "", backendType: GPUBackendType = .undefined, adapterType: GPUAdapterType = .discreteGPU, vendorID: UInt32 = 0, deviceID: UInt32 = 0, subgroupMinSize: UInt32 = 0, subgroupMaxSize: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
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
					self.nextInChain = nextInChain
				}



				public func withWGPUStruct<R>(
					_ lambda: (inout WGPUAdapterInfo) -> R
				) -> R {
					return vendor.withWGPUStruct { vendor in
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

	@Test("Wrapper for method with typed array excludes size params and extracts count")
	func testMethodWrapperDeclWithArraySizeExtraction() {
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
					"category": "object",
					"methods": []
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

		let generated = submitMethod.methodWrapperDecl(data: data).formatted().description

		// Check signature uses Swift array type and excludes size param
		#expect(generated.contains("func submit(commands: [GPUCommandBuffer])"))
		#expect(!generated.contains("commandCount: Int"))  // Size param excluded from signature

		// Check size extraction is present in the body
		#expect(generated.contains("let commandCount = commands.count"))

		// Check C API call includes both the extracted count and the array
		#expect(generated.contains("submit(commandCount: commandCount, commands: commands)"))
	}

	@Test("Method with multiple arrays extracts all sizes")
	func testMultipleArraySizeExtraction() {
		let testData = """
			{
				"encoder": {
					"category": "object",
					"methods": [
						{
							"name": "set buffers",
							"args": [
								{"name": "buffer count", "type": "size_t"},
								{"name": "buffers", "type": "buffer", "annotation": "const*", "length": "buffer count"},
								{"name": "offset count", "type": "size_t"},
								{"name": "offsets", "type": "uint64_t", "annotation": "const*", "length": "offset count"}
							]
						}
					]
				},
				"buffer": {
					"category": "object",
					"methods": []
				},
				"size_t": {
					"category": "native"
				},
				"uint64_t": {
					"category": "native"
				}
			}
			"""
		let data = try? JSONDecoder().decode(DawnData.self, from: testData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}
		guard case .object(let encoder) = data.data[Name("encoder")] else {
			Issue.record("Failed to get encoder")
			return
		}
		let setBuffersMethod = encoder.methods.first { $0.name == Name("set buffers") }!

		let generated = setBuffersMethod.methodWrapperDecl(data: data).formatted().description

		// Check signature excludes both size params but includes both array params
		// Note: offsets is [UInt64]? because native type arrays with const* are optional
		#expect(generated.contains("func setBuffers(buffers: [GPUBuffer], offsets: [UInt64]?)"))
		#expect(!generated.contains("bufferCount: Int"))  // Size param excluded from signature
		#expect(!generated.contains("offsetCount: Int"))  // Size param excluded from signature

		// Check size extractions are present in the body
		#expect(generated.contains("let bufferCount = buffers.count"))
		// offsets uses nil-coalescing because it's optional
		#expect(generated.contains("let offsetCount = offsets?.count ?? 0"))

		// Check C API call includes all extracted counts and arrays
		#expect(
			generated.contains(
				"setBuffers(bufferCount: bufferCount, buffers: buffers, offsetCount: offsetCount, offsets: offsets)"
			)
		)
	}

	@Test("Optional array uses nil-coalescing for count")
	func testOptionalArraySizeExtraction() {
		let testData = """
			{
				"pass": {
					"category": "object",
					"methods": [
						{
							"name": "set groups",
							"args": [
								{"name": "group count", "type": "size_t"},
								{"name": "groups", "type": "bind group", "annotation": "const*", "length": "group count", "optional": true}
							]
						}
					]
				},
				"bind group": {
					"category": "object",
					"methods": []
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
		guard case .object(let pass) = data.data[Name("pass")] else {
			Issue.record("Failed to get pass")
			return
		}
		let setGroupsMethod = pass.methods.first { $0.name == Name("set groups") }!

		let generated = setGroupsMethod.methodWrapperDecl(data: data).formatted().description

		// Check signature has optional array parameter
		#expect(generated.contains("groups: [GPUBindGroup]?"))

		// Check size extraction uses nil-coalescing for optional array
		#expect(generated.contains("let groupCount = groups?.count ?? 0"))
	}

	@Test("void* array uses UnsafeRawBufferPointer and excludes size param")
	func testVoidArrayUsesUnsafeRawBufferPointer() {
		let testData = """
			{
				"queue": {
					"category": "object",
					"methods": [
						{
							"name": "write buffer",
							"args": [
								{"name": "buffer", "type": "buffer"},
								{"name": "buffer offset", "type": "uint64_t"},
								{"name": "data", "type": "void", "annotation": "const*", "length": "size"},
								{"name": "size", "type": "size_t"}
							]
						}
					]
				},
				"buffer": {
					"category": "object",
					"methods": []
				},
				"uint64_t": {
					"category": "native"
				},
				"size_t": {
					"category": "native"
				},
				"void": {
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
		let writeBufferMethod = queue.methods.first { $0.name == Name("write buffer") }!

		let generated = writeBufferMethod.methodWrapperDecl(data: data).formatted().description

		// Check signature uses UnsafeRawBufferPointer and excludes size param
		#expect(generated.contains("data: UnsafeRawBufferPointer"))
		#expect(!generated.contains("size: Int"))  // Size param excluded from signature

		// Check body extracts count and baseAddress from the buffer pointer
		#expect(generated.contains("let size = data.count"))
		#expect(generated.contains("let data = data.baseAddress"))
	}

	@Test("swiftTypePrefix() returns empty string for Dawn types and GPU for others")
	func testSwiftTypePrefixForDawnTypes() {
		// Dawn-internal types should have no prefix
		#expect(Name("dawn toggles descriptor").swiftTypePrefix() == "")
		#expect(Name("dawn cache device descriptor").swiftTypePrefix() == "")
		#expect(Name("dawn format capabilities").swiftTypePrefix() == "")

		// Standard WebGPU types should have GPU prefix
		#expect(Name("shader module").swiftTypePrefix() == "GPU")
		#expect(Name("adapter info").swiftTypePrefix() == "GPU")
		#expect(Name("device").swiftTypePrefix() == "GPU")
	}

	@Test("Dawn-prefixed structures do not use GPU prefix in Swift API")
	func testDawnPrefixedStructureDeclarations() {
		let data = try? JSONDecoder().decode(DawnData.self, from: dawnPrefixedDawnData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let dawnDrmFormatProperties = data.data[Name("dawn drm format properties")]
		guard let dawnDrmFormatProperties = dawnDrmFormatProperties else {
			Issue.record("Failed to get dawn drm format properties")
			return
		}

		guard case .structure(let structure) = dawnDrmFormatProperties else {
			Issue.record("dawn drm format properties is not a structure")
			return
		}

		let declarations = try? structure.declarations(name: Name("dawn drm format properties"), needsWrap: false, data: data)
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

		// Verify the struct does not have a "GPU" prefix (GPUDawnDrmFormatProperties) and instead uses a typealias (DawnDrmFormatProperties)
		let combinedDescription = combined.description
		#expect(!combinedDescription.contains(" GPUDawnDrmFormatProperties"))
		#expect(combinedDescription.contains("public typealias DawnDrmFormatProperties = WGPUDawnDrmFormatProperties"))
		#expect(combinedDescription.contains("extension DawnDrmFormatProperties: GPUSimpleStruct"))
	}

	@Test("Struct init excludes array size parameters")
	func testStructInitExcludesArraySizeParameter() {
		let data = try? JSONDecoder().decode(DawnData.self, from: structWithArrayDawnData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let bindGroupLayoutDescriptor = data.data[Name("bind group layout descriptor")]
		guard let bindGroupLayoutDescriptor = bindGroupLayoutDescriptor else {
			Issue.record("Failed to get bind group layout descriptor")
			return
		}

		guard case .structure(let structure) = bindGroupLayoutDescriptor else {
			Issue.record("Bind group layout descriptor is not a structure")
			return
		}

		let declarations = try? structure.declarations(name: Name("bind group layout descriptor"), needsWrap: false, data: data)
		guard let declarations = declarations else {
			Issue.record("Failed to get declarations")
			return
		}
		let combined = declarations.map { $0.formatted().description }.joined(separator: "\n")

		// Verify init signature excludes entryCount parameter
		#expect(
			combined.contains(
				"public init(label: String? = nil, entries: [GPUBindGroupLayoutEntry] = [], nextInChain: (any GPUChainedStruct)? = nil)"
			)
		)
		#expect(!combined.contains("entryCount: Int"))

		// Verify stored properties exclude entryCount
		#expect(combined.contains("public var entries: [GPUBindGroupLayoutEntry]"))
		#expect(!combined.contains("public var entryCount"))
	}

	@Test("Inout struct parameters are detected for wrapping")
	func testInoutStructParametersDetectedForWrapping() {
		let data = try? JSONDecoder().decode(DawnData.self, from: inoutStructDawnData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let wrappableStructs = data.structuresRequiringWrapping()

		// The limits struct is used as an inout parameter (annotation "*") in adapter.getLimits(),
		// so it should be detected as requiring wrapping.
		#expect(wrappableStructs.contains(Name("limits")))
	}

	@Test("Struct withWGPUStruct derives count from array")
	func testStructWithWGPUStructDerivesCount() {
		let data = try? JSONDecoder().decode(DawnData.self, from: structWithArrayDawnData.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}

		let bindGroupLayoutDescriptor = data.data[Name("bind group layout descriptor")]
		guard let bindGroupLayoutDescriptor = bindGroupLayoutDescriptor else {
			Issue.record("Failed to get bind group layout descriptor")
			return
		}

		guard case .structure(let structure) = bindGroupLayoutDescriptor else {
			Issue.record("Bind group layout descriptor is not a structure")
			return
		}

		let declarations = try? structure.declarations(name: Name("bind group layout descriptor"), needsWrap: false, data: data)
		guard let declarations = declarations else {
			Issue.record("Failed to get declarations")
			return
		}
		let combined = declarations.map { $0.formatted().description }.joined(separator: "\n")

		// Verify withWGPUStruct extracts count from array
		#expect(combined.contains("let entryCount = entries.count"))
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

let dawnPrefixedDawnData = """
	{
		"dawn drm format properties": {
			"category": "structure",
			"tags": ["dawn"],
			"members": [
				{"name": "modifier", "type": "uint64_t"},
				{"name": "modifier plane count", "type": "uint32_t"}
			]
		},
		"uint64_t": {
			"category": "native",
			"wasm type": "j"
		},
		"uint32_t": {
			"category": "native",
			"wasm type": "i"
		}
	}
	"""

let inoutStructDawnData = """
	{
		"adapter": {
			"category": "object",
			"methods": [
				{
					"name": "get limits",
					"returns": "status",
					"args": [
						{"name": "limits", "type": "limits", "annotation": "*"}
					]
				}
			]
		},
		"limits": {
			"category": "structure",
			"extensible": "out",
			"members": [
				{"name": "max texture dimension 1D", "type": "uint32_t"}
			]
		},
		"status": {
			"category": "enum",
			"values": [
				{"value": 1, "name": "success"},
				{"value": 2, "name": "error"}
			]
		},
		"uint32_t": {
			"category": "native"
		}
	}
	"""

let structWithArrayDawnData = """
	{
		"bind group layout descriptor": {
			"category": "structure",
			"extensible": "in",
			"members": [
				{"name": "label", "type": "string view", "optional": true},
				{"name": "entry count", "type": "size_t"},
				{"name": "entries", "type": "bind group layout entry", "annotation": "const*", "length": "entry count"}
			]
		},
		"bind group layout entry": {
			"category": "structure",
			"members": [
				{"name": "binding", "type": "uint32_t"}
			]
		},
		"string view": {
			"category": "structure",
			"members": [
				{"name": "data", "type": "char", "annotation": "const*", "optional": true},
				{"name": "length", "type": "size_t", "default": "strlen"}
			]
		},
		"size_t": {
			"category": "native"
		},
		"uint32_t": {
			"category": "native"
		}
	}
	"""
