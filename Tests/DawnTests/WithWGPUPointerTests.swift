// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing
import WebGPU

@testable import Dawn

struct WithWGPUPointerTests {
	@Test("withWGPUArrayPointer with GPUBindGroupLayoutEntry array")
	func testWithWGPUArrayPointerGPUBindGroupLayoutEntry() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(
				binding: 0,
				visibility: GPUShaderStage([.vertex, .compute, .fragment]),
				buffer: .init()
			),
			.init(
				binding: 1,
				visibility: GPUShaderStage([.vertex, .compute]),
				buffer: .init(type: .readOnlyStorage)
			),
			.init(
				binding: 2,
				visibility: GPUShaderStage([.compute]),
				buffer: .init(type: .storage)
			),
		]

		let result = withWGPUArrayPointer(entries) { pointer in
			// Verify we can access all three entries
			#expect(pointer[0].binding == 0)
			#expect(pointer[1].binding == 1)
			#expect(pointer[2].binding == 2)

			// Verify visibility flags - WGPUShaderStage is an OptionSet
			#expect(pointer[0].visibility.contains(.vertex))
			#expect(pointer[0].visibility.contains(.compute))
			#expect(pointer[0].visibility.contains(.fragment))
			#expect(pointer[1].visibility.contains(.vertex))
			#expect(pointer[1].visibility.contains(.compute))
			#expect(!pointer[1].visibility.contains(.fragment))
			#expect(pointer[2].visibility.contains(.compute))
			#expect(!pointer[2].visibility.contains(.vertex))
			#expect(!pointer[2].visibility.contains(.fragment))

			// Return a value to verify the function returns correctly
			return entries.count
		}

		#expect(result == 3)
	}

	@Test("withWGPUArrayPointer with single GPUBindGroupLayoutEntry")
	func testWithWGPUArrayPointerSingleGPUBindGroupLayoutEntry() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(
				binding: 42,
				visibility: GPUShaderStage([.fragment]),
				buffer: .init(type: .uniform)
			)
		]

		let result = withWGPUArrayPointer(entries) { pointer in
			// Verify we can access the single entry
			#expect(pointer[0].binding == 42)
			#expect(pointer[0].visibility.contains(.fragment))
			#expect(!pointer[0].visibility.contains(.vertex))

			// Verify buffer type
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: entries.count)
			#expect(bufferPointer.count == 1)

			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUArrayPointer with empty GPUBindGroupLayoutEntry array")
	func testWithWGPUArrayPointerEmptyGPUBindGroupLayoutEntry() {
		let entries: [GPUBindGroupLayoutEntry] = []

		let result = withWGPUArrayPointer(entries) { pointer in
			// Verify we get a valid pointer even for empty array
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: entries.count)
			#expect(bufferPointer.count == 0)

			return true
		}

		#expect(result == true)
	}

	@Test("withWGPUArrayPointer with GPUVertexAttribute array")
	func testWithWGPUArrayPointerGPUVertexAttribute() {
		let attributes: [GPUVertexAttribute] = [
			.init(format: .float32x2, offset: 0, shaderLocation: 0),
			.init(format: .float32x3, offset: 8, shaderLocation: 1),
			.init(format: .float32x4, offset: 20, shaderLocation: 2),
		]

		let result = withWGPUArrayPointer(attributes) { pointer in
			// Verify we can access all attributes
			#expect(pointer[0].offset == 0)
			#expect(pointer[0].shaderLocation == 0)

			#expect(pointer[1].offset == 8)
			#expect(pointer[1].shaderLocation == 1)

			#expect(pointer[2].offset == 20)
			#expect(pointer[2].shaderLocation == 2)

			// Verify buffer pointer works
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: attributes.count)
			#expect(bufferPointer.count == 3)

			return attributes.count
		}

		#expect(result == 3)
	}

	@Test("withWGPUArrayPointer recursion test - large array")
	func testWithWGPUArrayPointerLargeArray() {
		// Create a larger array to test the recursive processing
		let entries: [GPUBindGroupLayoutEntry] = (0..<100).map { index in
			.init(
				binding: UInt32(index),
				visibility: GPUShaderStage([.compute]),
				buffer: .init()
			)
		}

		let result = withWGPUArrayPointer(entries) { pointer in
			// Verify first and last elements
			#expect(pointer[0].binding == 0)
			#expect(pointer[99].binding == 99)

			// Verify all elements are correctly converted
			for i in 0..<entries.count {
				#expect(pointer[i].binding == UInt32(i))
			}

			return entries.count
		}

		#expect(result == 100)
	}

	@Test("withWGPUArrayPointer return type test")
	func testWithWGPUArrayPointerReturnTypes() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(binding: 0, visibility: GPUShaderStage([.vertex]), buffer: .init())
		]

		// Test returning different types
		let intResult: Int = withWGPUArrayPointer(entries) { _ in 42 }
		#expect(intResult == 42)

		let stringResult: String = withWGPUArrayPointer(entries) { _ in "test" }
		#expect(stringResult == "test")

		let tupleResult: (Int, String) = withWGPUArrayPointer(entries) { _ in (1, "value") }
		#expect(tupleResult.0 == 1)
		#expect(tupleResult.1 == "value")

		let optionalResult: Int? = withWGPUArrayPointer(entries) { _ in Optional(123) }
		#expect(optionalResult == 123)
	}

	@Test("unwrapWGPUObjectArray with empty array")
	func testUnwrapWGPUObjectArrayEmpty() {
		// Create an empty array of GPU objects
		let buffers: [GPUBuffer] = []

		let result = buffers.unwrapWGPUObjectArray { pointer in
			// Verify we can create a buffer pointer from it
			// The pointer should point to the start of an array of GPUBuffer?
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: buffers.count)
			#expect(bufferPointer.count == 0)

			// Return the count to verify the function works
			return buffers.count
		}

		#expect(result == 0)
	}

	@Test("unwrapWGPUObjectArray with non-empty array")
	@MainActor
	func testUnwrapWGPUObjectArrayNonEmpty() async {
		// Initialize GPU adapter and device
		let (_, _, device) = setupGPU()

		// Create real GPU buffer objects
		let buffers: [GPUBuffer] = [
			device.createBuffer(
				descriptor: .init(
					label: "Test Buffer 1",
					usage: .vertex,
					size: 256
				)
			)!,
			device.createBuffer(
				descriptor: .init(
					label: "Test Buffer 2",
					usage: .vertex,
					size: 256
				)
			)!,
			device.createBuffer(
				descriptor: .init(
					label: "Test Buffer 3",
					usage: .vertex,
					size: 256
				)
			)!,
			device.createBuffer(
				descriptor: .init(
					label: "Test Buffer 4",
					usage: .vertex,
					size: 256
				)
			)!,
			device.createBuffer(
				descriptor: .init(
					label: "Test Buffer 5",
					usage: .vertex,
					size: 256
				)
			)!,
		]

		let result = buffers.unwrapWGPUObjectArray { pointer in
			#expect(pointer != nil)

			// Verify we can access all elements through the pointer
			let bufferPointer = UnsafeBufferPointer(start: pointer!, count: buffers.count)
			#expect(bufferPointer.count == buffers.count)

			// Verify each element is accessible (as optional) and is not nil
			for i in 0..<buffers.count {
				#expect(bufferPointer[i] != nil)
			}

			// Verify we can access elements directly via pointer subscript
			#expect(pointer![0] != nil)
			#expect(pointer![1] != nil)
			#expect(pointer![2] != nil)
			#expect(pointer![3] != nil)
			#expect(pointer![4] != nil)

			// Return the count to verify the function works
			return buffers.count
		}

		#expect(result == 5)
	}

	@Test("withWGPUArrayPointer with Int array")
	func testWithWGPUArrayPointerInt() {
		let numbers: [Int] = [1, 2, 3, 4, 5]

		let result = withWGPUArrayPointer(numbers) { pointer in
			// Verify we can access all elements
			#expect(pointer[0] == 1)
			#expect(pointer[1] == 2)
			#expect(pointer[2] == 3)
			#expect(pointer[3] == 4)
			#expect(pointer[4] == 5)

			// Verify we can create a buffer pointer from it
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: numbers.count)
			#expect(bufferPointer.count == numbers.count)
			#expect(bufferPointer[0] == 1)
			#expect(bufferPointer[4] == 5)

			// Return a value to verify the function returns correctly
			return numbers.reduce(0, +)
		}

		#expect(result == 15)
	}

	@Test("withWGPUArrayPointer with Float array")
	func testWithWGPUArrayPointerFloat() {
		let numbers: [Float] = [1.5, 2.5, 3.5, 4.5]

		let result = withWGPUArrayPointer(numbers) { pointer in
			// Verify we can access all elements
			#expect(pointer[0] == 1.5)
			#expect(pointer[1] == 2.5)
			#expect(pointer[2] == 3.5)
			#expect(pointer[3] == 4.5)

			// Verify we can create a buffer pointer from it
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: numbers.count)
			#expect(bufferPointer.count == numbers.count)
			#expect(bufferPointer[0] == 1.5)
			#expect(bufferPointer[3] == 4.5)

			// Return a value to verify the function returns correctly
			return numbers.reduce(0, +)
		}

		#expect(result == 12.0)
	}

	@Test("withWGPUArrayPointer with Double array")
	func testWithWGPUArrayPointerDouble() {
		let numbers: [Double] = [10.1, 20.2, 30.3]

		let result = withWGPUArrayPointer(numbers) { pointer in
			// Verify we can access all elements
			#expect(pointer[0] == 10.1)
			#expect(pointer[1] == 20.2)
			#expect(pointer[2] == 30.3)

			// Return a value to verify the function returns correctly
			return numbers.count
		}

		#expect(result == 3)
	}

	@Test("withWGPUArrayPointer with UInt8 array")
	func testWithWGPUArrayPointerUInt8() {
		let numbers: [UInt8] = [0, 1, 2, 255]

		let result = withWGPUArrayPointer(numbers) { pointer in
			// Verify we can access all elements
			#expect(pointer[0] == 0)
			#expect(pointer[1] == 1)
			#expect(pointer[2] == 2)
			#expect(pointer[3] == 255)

			// Return a value to verify the function returns correctly
			return numbers.count
		}

		#expect(result == 4)
	}

	@Test("withWGPUArrayPointer with empty array")
	func testWithWGPUArrayPointerEmpty() {
		let numbers: [Int] = []

		let result = withWGPUArrayPointer(numbers) { pointer in
			// Verify we can create a buffer pointer from it
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: numbers.count)
			#expect(bufferPointer.count == 0)

			// Return a value to verify the function returns correctly
			return numbers.count
		}

		#expect(result == 0)
	}

	@Test("withWGPUArrayPointer with optional Int array - nil")
	func testWithWGPUArrayPointerOptionalIntNil() {
		let numbers: [Int]? = nil

		let result = withWGPUArrayPointer(numbers) { pointer in
			#expect(pointer == nil)
			return 42
		}

		#expect(result == 42)
	}

	@Test("withWGPUArrayPointer with optional Int array - non-nil")
	func testWithWGPUArrayPointerOptionalIntNonNil() {
		let numbers: [Int]? = [10, 20, 30]

		let result = withWGPUArrayPointer(numbers) { pointer in
			#expect(pointer != nil)
			#expect(pointer![0] == 10)
			#expect(pointer![1] == 20)
			#expect(pointer![2] == 30)
			return numbers!.count
		}

		#expect(result == 3)
	}

	@Test("createPipelineLayout with bindGroupLayouts array")
	@MainActor
	func testCreatePipelineLayoutWithBindGroupLayouts() async {
		// Initialize GPU adapter and device
		let (_, _, device) = setupGPU()

		// Create bind group layout similar to GameOfLife example
		let bindGroupLayout = device.createBindGroupLayout(
			descriptor: .init(
				label: "Cell Bind Group Layout",
				entries: [
					.init(
						binding: 0,
						visibility: GPUShaderStage([.vertex, .compute, .fragment]),
						buffer: .init()
					),
					.init(
						binding: 1,
						visibility: GPUShaderStage([.vertex, .compute]),
						buffer: .init(type: .readOnlyStorage)
					),
					.init(
						binding: 2,
						visibility: GPUShaderStage([.compute]),
						buffer: .init(type: .storage)
					),
				]
			)
		)

		// Create pipeline layout with bindGroupLayouts array (same as GameOfLife example)
		_ = device.createPipelineLayout(
			descriptor: .init(
				label: "Cell Pipeline Layout",
				bindGroupLayouts: [bindGroupLayout]
			)
		)
	}

	@Test("withWGPUArrayPointer with String array")
	func testWithWGPUArrayPointerString() {
		let strings = ["hello", "world", "test", "strings"]

		let result = withWGPUArrayPointer(strings) { pointer in
			// Verify we can access all C string pointers
			#expect(pointer[0] != nil)
			#expect(pointer[1] != nil)
			#expect(pointer[2] != nil)
			#expect(pointer[3] != nil)

			// Convert back to Swift strings and verify content
			let str0 = String(cString: pointer[0]!)
			let str1 = String(cString: pointer[1]!)
			let str2 = String(cString: pointer[2]!)
			let str3 = String(cString: pointer[3]!)

			#expect(str0 == "hello")
			#expect(str1 == "world")
			#expect(str2 == "test")
			#expect(str3 == "strings")

			// Return the count to verify the function returns correctly
			return strings.count
		}

		#expect(result == 4)
	}

	@Test("withWGPUArrayPointer with single String")
	func testWithWGPUArrayPointerSingleString() {
		let strings = ["single"]

		let result = withWGPUArrayPointer(strings) { pointer in
			#expect(pointer[0] != nil)

			let str = String(cString: pointer[0]!)
			#expect(str == "single")

			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUArrayPointer with empty String array")
	func testWithWGPUArrayPointerEmptyString() {
		let strings: [String] = []

		let result = withWGPUArrayPointer(strings) { pointer in
			// Verify we get a valid pointer even for empty array
			let bufferPointer = UnsafeBufferPointer(start: pointer, count: strings.count)
			#expect(bufferPointer.count == 0)

			return true
		}

		#expect(result == true)
	}

	@Test("withWGPUArrayPointer with String array - special characters")
	func testWithWGPUArrayPointerStringSpecialCharacters() {
		let strings = ["foo-bar", "test_123", "CamelCase", "with spaces", "unicode: 🚀"]

		let result = withWGPUArrayPointer(strings) { pointer in
			// Verify all strings are correctly converted
			for i in 0..<strings.count {
				#expect(pointer[i] != nil)
				let converted = String(cString: pointer[i]!)
				#expect(converted == strings[i])
			}

			return strings.count
		}

		#expect(result == 5)
	}

	// A simple RawRepresentable enum for testing
	private enum TestFormat: UInt32, RawRepresentable {
		case first = 1
		case second = 2
		case third = 3
		case fourth = 4
	}
	@Test("withWGPUArrayPointer with RawRepresentable array")
	func testWithWGPUArrayPointerRawRepresentable() {
		let formats: [TestFormat] = [.first, .second, .third, .fourth]
		let result = withWGPUArrayPointer(formats){ pointer in
			#expect(pointer[0] == .first)
			#expect(pointer[1] == .second)
			#expect(pointer[2] == .third)
			#expect(pointer[3] == .fourth)
			// Return a value to verify the generic return type works
			return formats.count
		}
		#expect(result == 4)
	}

	// A simple GPUSimpleStruct for testing
	private struct TestStruct: GPUSimpleStruct {
		var a: Int
		var b: Float
	}
	@Test("withWGPUArrayPointer with GPUSimpleStruct array")
	func testWithWGPUArrayPointerGPUSimpleStruct() {
		let testStructs = [TestStruct(a: 1, b: 1.0), TestStruct(a: 2, b: 2.0), TestStruct(a: 3, b: 3.0)]
		let result = withWGPUArrayPointer(testStructs) { pointer in
			#expect(pointer[0].a == 1)
			#expect(pointer[0].b == 1.0)
			#expect(pointer[1].a == 2)
			#expect(pointer[1].b == 2.0)
			#expect(pointer[2].a == 3)
			#expect(pointer[2].b == 3.0)
			return testStructs.count
		}
		#expect(result == 3)	
	}		
	@Test("withWGPUArrayPointer with optional GPUSimpleStruct array - nil")
	func testWithWGPUArrayPointerNilGPUSimpleStruct() {
		let testStructs: [TestStruct]? = nil
		let result = withWGPUArrayPointer(testStructs) { pointer in
			#expect(pointer == nil)
			return 42
		}
		#expect(result == 42)
	}

	@Test("withWGPUMutableArrayPointer with GPUStruct array")
	func testWithWGPUMutableArrayPointerGPUStruct() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(
				binding: 7,
				visibility: GPUShaderStage([.vertex, .fragment]),
				buffer: .init()
			),
			.init(
				binding: 9,
				visibility: GPUShaderStage([.compute]),
				buffer: .init(type: .readOnlyStorage)
			),
		]

		let result = withWGPUMutableArrayPointer(entries) { pointer in
			#expect(pointer[0].binding == 7)
			#expect(pointer[1].binding == 9)
			#expect(pointer[0].visibility.contains(.vertex))
			#expect(pointer[0].visibility.contains(.fragment))
			#expect(pointer[1].visibility.contains(.compute))
			return entries.count
		}

		#expect(result == 2)
	}

	@Test("withWGPUMutableArrayPointer with optional GPUStruct array - nil")
	func testWithWGPUMutableArrayPointerOptionalNil() {
		let entries: [GPUBindGroupLayoutEntry]? = nil

		let result = withWGPUMutableArrayPointer(entries) { pointer in
			#expect(pointer == nil)
			return 42
		}

		#expect(result == 42)
	}

	@Test("withWGPUMutableArrayPointer with optional GPUStruct array - non-nil")
	func testWithWGPUMutableArrayPointerOptionalNonNil() {
		let entries: [GPUBindGroupLayoutEntry]? = [
			.init(
				binding: 3,
				visibility: GPUShaderStage([.vertex]),
				buffer: .init()
			),
		]

		let result = withWGPUMutableArrayPointer(entries) { pointer in
			#expect(pointer != nil)
			#expect(pointer![0].binding == 3)
			#expect(pointer![0].visibility.contains(.vertex))
			return entries!.count
		}

		#expect(result == 1)
	}

	@Test("Array.withWGPUPointer with GPUStruct array")
	func testArrayWithWGPUPointer() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(
				binding: 0,
				visibility: GPUShaderStage([.vertex, .compute, .fragment]),
				buffer: .init()
			),
			.init(
				binding: 1,
				visibility: GPUShaderStage([.vertex, .compute]),
				buffer: .init(type: .readOnlyStorage)
			),
		]

		// Use the array instance method instead of the free function
		entries.withWGPUPointer { pointer in
			#expect(pointer[0].binding == 0)
			#expect(pointer[1].binding == 1)

			// Verify visibility flags
			#expect(pointer[0].visibility.contains(.vertex))
			#expect(pointer[0].visibility.contains(.compute))
			#expect(pointer[0].visibility.contains(.fragment))
			#expect(pointer[1].visibility.contains(.vertex))
			#expect(pointer[1].visibility.contains(.compute))
			#expect(!pointer[1].visibility.contains(.fragment))

			// Verify buffer types
			#expect(pointer[0].buffer.type == .uniform)
			#expect(pointer[1].buffer.type == .readOnlyStorage)
		}
	}

	@Test("Array.withWGPUPointer return type propagation")
	func testArrayWithWGPUPointerReturnType() {
		let entries: [GPUBindGroupLayoutEntry] = [
			.init(binding: 42, visibility: GPUShaderStage([.vertex]), buffer: .init()),
		]

		// Test that the return type is correctly propagated
		let result: UInt32 = entries.withWGPUPointer { pointer in
			return pointer[0].binding
		}

		#expect(result == 42)

		// Test with a different return type
		let stringResult: String = entries.withWGPUPointer { pointer in
			return "binding: \(pointer[0].binding)"
		}

		#expect(stringResult == "binding: 42")
	}

	@Test("withWGPUArrayPointer with 7-element tuple")
	func testWithWGPUArrayPointer7ElementTuple() {
		// 7 parameters for transfer function (like sRGB gamma curve)
		let transferParams: (Float, Float, Float, Float, Float, Float, Float) = (1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0)

		let result = withWGPUArrayPointer(transferParams) { pointer in
			#expect(pointer[0] == 1.0)
			#expect(pointer[1] == 2.0)
			#expect(pointer[2] == 3.0)
			#expect(pointer[3] == 4.0)
			#expect(pointer[4] == 5.0)
			#expect(pointer[5] == 6.0)
			#expect(pointer[6] == 7.0)
			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUArrayPointer with optional 7-element tuple - nil")
	func testWithWGPUArrayPointerNil7ElementTuple() {
		let transferParams: (Float, Float, Float, Float, Float, Float, Float)? = nil

		let result = withWGPUArrayPointer(transferParams) { pointer in
			#expect(pointer == nil)
			return "nil case"
		}

		#expect(result == "nil case")
	}

	@Test("withWGPUArrayPointer with optional 7-element tuple - non-nil")
	func testWithWGPUArrayPointerNonNil7ElementTuple() {
		let transferParams: (Float, Float, Float, Float, Float, Float, Float)? = (1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0)

		let result = withWGPUArrayPointer(transferParams) { pointer in
			#expect(pointer != nil)
			#expect(pointer![0] == 1.0)
			#expect(pointer![6] == 7.0)
			return "non-nil case"
		}

		#expect(result == "non-nil case")
	}

	@Test("withWGPUArrayPointer with 9-element tuple")
	func testWithWGPUArrayPointer9ElementTuple() {
		// 3x3 matrix (9 floats) for color space conversion
		let conversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float) =
			(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)

		let result = withWGPUArrayPointer(conversionMatrix) { pointer in
			#expect(pointer[0] == 1.0)
			#expect(pointer[4] == 5.0)
			#expect(pointer[8] == 9.0)
			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUArrayPointer with optional 9-element tuple - nil")
	func testWithWGPUArrayPointerNil9ElementTuple() {
		let conversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)? = nil

		let result = withWGPUArrayPointer(conversionMatrix) { pointer in
			#expect(pointer == nil)
			return "nil case"
		}

		#expect(result == "nil case")
	}

	@Test("withWGPUArrayPointer with optional 9-element tuple - non-nil")
	func testWithWGPUArrayPointerNonNil9ElementTuple() {
		let conversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)? =
			(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)

		let result = withWGPUArrayPointer(conversionMatrix) { pointer in
			#expect(pointer != nil)
			#expect(pointer![0] == 1.0)
			#expect(pointer![8] == 9.0)
			return "non-nil case"
		}

		#expect(result == "non-nil case")
	}

	@Test("withWGPUArrayPointer with 12-element tuple")
	func testWithWGPUArrayPointer12ElementTuple() {
		// 3x4 matrix (12 floats) for YUV to RGB conversion
		let yuvMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float) =
			(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0)

		let result = withWGPUArrayPointer(yuvMatrix) { pointer in
			#expect(pointer[0] == 1.0)
			#expect(pointer[5] == 6.0)
			#expect(pointer[11] == 12.0)
			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUArrayPointer with optional 12-element tuple - nil")
	func testWithWGPUArrayPointerNil12ElementTuple() {
		let yuvMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)? = nil

		let result = withWGPUArrayPointer(yuvMatrix) { pointer in
			#expect(pointer == nil)
			return "nil case"
		}

		#expect(result == "nil case")
	}

	@Test("withWGPUArrayPointer with optional 12-element tuple - non-nil")
	func testWithWGPUArrayPointerNonNil12ElementTuple() {
		let yuvMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)? =
			(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0)

		let result = withWGPUArrayPointer(yuvMatrix) { pointer in
			#expect(pointer != nil)
			#expect(pointer![0] == 1.0)
			#expect(pointer![11] == 12.0)
			return "non-nil case"
		}

		#expect(result == "non-nil case")
	}

	@Test("unwrapWGPUArray with Numeric array")
	func testUnwrapWGPUArrayNumeric() {
		let numbers: [Float] = [1.0, 2.0, 3.0, 4.0]

		let result = numbers.unwrapWGPUArray { pointer in
			#expect(pointer[0] == 1.0)
			#expect(pointer[1] == 2.0)
			#expect(pointer[2] == 3.0)
			#expect(pointer[3] == 4.0)
			return "success"
		}

		#expect(result == "success")
	}

	@Test("withWGPUMutablePointer reconstructs GPUStructWrappable after mutation")
	func testMutablePointerReconstructsWrappableStruct() {
		var limits = GPULimits()
		limits.withWGPUMutablePointer { pointer in
			pointer.pointee.maxTextureDimension1D = 42
		}
		#expect(limits.maxTextureDimension1D == 42)
	}

	// Simple test class for AnyObject array tests
	private class TestObject {
		let value: Int
		init(_ value: Int) { self.value = value }
	}

	@Test("unwrapWGPUArray with AnyObject array")
	func testUnwrapWGPUArrayAnyObject() {
		let objects: [TestObject] = [TestObject(1), TestObject(2), TestObject(3)]

		let result = objects.unwrapWGPUArray { pointer in
			#expect(pointer[0].value == 1)
			#expect(pointer[1].value == 2)
			#expect(pointer[2].value == 3)
			return "success"
		}

		#expect(result == "success")
	}
}
