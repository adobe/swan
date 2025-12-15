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
}
