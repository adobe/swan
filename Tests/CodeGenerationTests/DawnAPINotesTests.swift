// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing

@testable import GenerateDawnAPINotes

@Suite struct DawnAPINotesTests {

	// MARK: - Initialization Tests

	@Test("APINote initialization with values")
	func testAPINoteInitialization() {
		let values = ["key1": "value1", "key2": "value2"]
		let apiNote = APINote(category: .function, name: "testFunction", values: values)

		#expect(apiNote.category == .function)
		#expect(apiNote.name == "testFunction")
		#expect(apiNote.values == values)
	}

	@Test("APINote initialization with empty values")
	func testAPINoteInitializationWithEmptyValues() {
		let apiNote = APINote(category: .tag, name: "emptyTag", values: [:])

		#expect(apiNote.category == .tag)
		#expect(apiNote.name == "emptyTag")
		#expect(apiNote.values.isEmpty)
	}

	// MARK: - Category Tests

	@Test("All APINote categories")
	func testAllCategories() {
		let tagNote = APINote(category: .tag, name: "tag", values: [:])
		let typedefNote = APINote(category: .typedef, name: "typedef", values: [:])
		let functionNote = APINote(category: .function, name: "function", values: [:])
		let globalNote = APINote(category: .global, name: "global", values: [:])

		#expect(tagNote.category == .tag)
		#expect(typedefNote.category == .typedef)
		#expect(functionNote.category == .function)
		#expect(globalNote.category == .global)
	}

	// MARK: - Dynamic Member Lookup Tests

	@Test("Dynamic member lookup get")
	func testDynamicMemberLookupGet() {
		let values = ["returnType": "void", "parameters": "int, string"]
		let apiNote = APINote(category: .function, name: "testFunc", values: values)

		#expect(apiNote.returnType == "void")
		#expect(apiNote.parameters == "int, string")
		#expect(apiNote.nonExistentKey == nil)
	}

	@Test("Dynamic member lookup set")
	func testDynamicMemberLookupSet() {
		var apiNote = APINote(category: .function, name: "testFunc", values: [:])

		apiNote.returnType = "int"
		apiNote.parameters = "string"

		#expect(apiNote.values["returnType"] == "int")
		#expect(apiNote.values["parameters"] == "string")
		#expect(apiNote.returnType == "int")
		#expect(apiNote.parameters == "string")
	}

	@Test("Dynamic member lookup update")
	func testDynamicMemberLookupUpdate() {
		var apiNote = APINote(category: .function, name: "testFunc", values: ["existing": "oldValue"])

		apiNote.existing = "newValue"

		#expect(apiNote.values["existing"] == "newValue")
		#expect(apiNote.existing == "newValue")
	}

	// MARK: - Description Tests

	@Test("Description with values")
	func testDescriptionWithValues() {
		let values = ["returnType": "void", "parameters": "int, string"]
		let apiNote = APINote(category: .function, name: "testFunction", values: values)

		let description = apiNote.description()

		#expect(description.contains("- Name: testFunction"))
		#expect(description.contains("  returnType: void"))
		#expect(description.contains("  parameters: int, string"))
	}

	@Test("Description formatting")
	func testDescriptionFormatting() {
		let values = ["key1": "value1", "key2": "value2", "key3": "value3"]
		let apiNote = APINote(category: .global, name: "testGlobal", values: values)

		let description = apiNote.description()
		let lines = description.components(separatedBy: "\n").sorted()

		#expect(lines.count == 4)  // Name line + 3 value lines
		#expect(lines[0].contains("  key1: value1"))
		#expect(lines[1].contains("  key2: value2"))
		#expect(lines[2].contains("  key3: value3"))
		#expect(lines[3].contains("- Name: testGlobal"))
	}

	// MARK: - YAML Tests

	@Test("YAML generation")
	func testYAMLGeneration() {
		let apinotes = [
			APINote(
				category: .tag,
				name: "WGPUTextureViewImpl",
				values: [
					"SwiftImportAs": "reference", "SwiftReleaseOp": "wgpuTextureViewRelease",
					"SwiftRetainOp": "wgpuTextureViewRetain",
				]
			),
			APINote(category: .tag, name: "WGPUAdapterType", values: ["EnumExtensibility": "closed"]),
			APINote(category: .typedef, name: "WGPUBufferUsage", values: ["SwiftWrapper": "struct"]),
			APINote(category: .function, name: "wgpuAdapterAddRef", values: ["SwiftName": "WGPUAdapterImpl.addRef(self:)"]),
			APINote(category: .global, name: "WGPUBufferUsage_None", values: ["SwiftName": "WGPUBufferUsage.none"]),
		]

		let expectedYAML = """
			---
			Name: DawnC
			Functions:
			- Name: wgpuAdapterAddRef
			  SwiftName: WGPUAdapterImpl.addRef(self:)
			Globals:
			- Name: WGPUBufferUsage_None
			  SwiftName: WGPUBufferUsage.none
			Tags:
			- Name: WGPUAdapterType
			  EnumExtensibility: closed
			- Name: WGPUTextureViewImpl
			  SwiftImportAs: reference
			  SwiftReleaseOp: wgpuTextureViewRelease
			  SwiftRetainOp: wgpuTextureViewRetain
			Typedefs:
			- Name: WGPUBufferUsage
			  SwiftWrapper: struct

			"""

		let yaml = yamlFromAPINotes(apinotes)

		#expect(yaml == expectedYAML)
	}
}
