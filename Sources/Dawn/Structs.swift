// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

/// A WGPU struct from the Dawn C API
public protocol WGPUStruct {
	init()
}

extension UnsafePointer where Pointee: WGPUStruct {
	func wrapArrayWithCount<SType: GPUStructWrappable>(_ count: Int) -> [SType] where SType.WGPUType == Pointee {
		return Array.init(unsafeUninitializedCapacity: count) {
			(structArrayBuffer: inout UnsafeMutableBufferPointer<SType>, initializedCount: inout Int) in
			for i in 0..<count {
				structArrayBuffer[i] = SType(wgpuStruct: self[i])
			}
			initializedCount = count
		}
	}
}

extension UnsafePointer {
	func wrapArrayWithCount(_ count: Int) -> [Pointee] {
		return Array.init(unsafeUninitializedCapacity: count) {
			(structArrayBuffer: inout UnsafeMutableBufferPointer<Pointee>, initializedCount: inout Int) in
			for i in 0..<count {
				structArrayBuffer[i] = self[i]
			}
		}
	}
}

// extension UnsafePointer {
// 	func unwrapObjectArrayWithCount(_ count: Int) -> [Pointee] {
// 		return Array.init(unsafeUninitializedCapacity: count) {
// 			(objectArrayBuffer: inout UnsafeMutableBufferPointer<Pointee>, initializedCount: inout Int) in
// 			for i in 0..<count {
// 				objectArrayBuffer[i] = self[i]
// 			}
// 			initializedCount = count
// 		}
// 	}
// }

extension UnsafePointer where Pointee: FloatingPoint {
	func wrapTuple7() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6])
	}

	func wrapTuple9() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8])
	}

	func wrapTuple12() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11])
	}
}

extension UnsafePointer {
	/// Wrap an array of WGPU values, specified with a pointer, into a proper Swift array.
	func wrapWGPUArrayWithCount<T>(_ count: Int) -> [T] where Pointee == Optional<T> {
		return Array.init(unsafeUninitializedCapacity: count) {
			(integerArrayBuffer: inout UnsafeMutableBufferPointer<T>, initializedCount: inout Int) in
			for i in 0..<count {
				integerArrayBuffer[i] = self[i]!
			}
			initializedCount = count
		}
	}
}

extension Array where Element: GPUStruct {
	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element.WGPUType>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}

	func unwrapWGPUArray<R>(_ lambda: (UnsafeMutablePointer<Element.WGPUType>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}
}

extension Array where Element: Numeric {
	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}
}

extension Array {
	func unwrapWGPUObjectArray<R>(_ lambda: (UnsafePointer<Element?>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUObjectArray")
	}
}

/// A root structure from the Dawn C API
///
/// The WGPU API uses structure chaining to pass multiple structures to a function.
/// The root structure is the first structure in the chain.
public protocol RootStruct: WGPUStruct {
	var nextInChain: UnsafeMutablePointer<WGPUChainedStruct>! { get set }
}

/// A chained structure from the Dawn C API
public protocol ChainedStruct: WGPUStruct {
	var chain: WGPUChainedStruct { get set }
}

/// A Swift wrapper for a WGPU struct from the Dawn C API
public protocol GPUStruct {
	associatedtype WGPUType: WGPUStruct

	/// Create a new WGPU struct from the Swift struct
	func withWGPUStruct<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R

	/// Apply the properties of the wrapper struct to the WGPU struct
	func applyPropertiesToWGPUStruct<R>(_ struct: inout WGPUType, _ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R
}

/// A GPUStruct who's unwrapped type can be wrapped back into a new GPUStruct
public protocol GPUStructWrappable: GPUStruct {
	init(wgpuStruct: WGPUType)
}

/// A Swift wrapper for a root structure from the Dawn C API
public protocol GPURootStruct: GPUStruct where WGPUType: RootStruct {
	/// Chained structure providing extra parameters to the root structure
	// var chain: [any GPUChainedStruct] { get }
}

/// A Swift wrapper for a chained structure from the Dawn C API
public protocol GPUChainedStruct: GPUStruct where WGPUType: ChainedStruct {
	var sType: GPUSType { get }

	func withWGPUChainedStruct(_ lambda: (UnsafeMutablePointer<WGPUChainedStruct>) -> Void)
}

public extension GPUStruct {
	/// Construct the WGPU struct and return the result of the lambda
	func withWGPUStruct<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		var wgpuStruct: Self.WGPUType = WGPUType()
		return applyPropertiesToWGPUStruct(&wgpuStruct, lambda)
	}
}

extension GPUStructWrappable {
	/// Construct the WGPU struct and return the result of the lambda, also unpacking the WGPU struct back into the Swift struct
	mutating func withWGPUStructInOut<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		var wgpuStruct: Self.WGPUType = WGPUType()
		let result = applyPropertiesToWGPUStruct(&wgpuStruct, lambda)
		self = Self(wgpuStruct: wgpuStruct)
		return result
	}
}

public extension GPUChainedStruct {
	/// Construct the WGPUChainedStruct
	func withWGPUChainedStruct(_ lambda: (UnsafeMutablePointer<WGPUChainedStruct>) -> Void) {
		var wgpuChainedStruct = WGPUType()
		wgpuChainedStruct.chain.sType = sType
		applyPropertiesToWGPUStruct(&wgpuChainedStruct) { chainedStruct in
			let mutableRawPtr = UnsafeMutableRawPointer(chainedStruct)
			let pointer = mutableRawPtr.bindMemory(to: WGPUChainedStruct.self, capacity: 1)
			lambda(pointer)
		}
	}
}

public extension GPURootStruct {
	/// Construct the linked chain of WGPUChainedStructs from the chain of wrapper structs
	func withWGPUStructChain(_ lambda: (UnsafeMutablePointer<WGPUChainedStruct>) -> Void) {
		// let chain = chain

		// func nextChainedStruct(index: Int, next: UnsafeMutablePointer<WGPUChainedStruct>?) {
		// 	chain[index].withWGPUChainedStruct { chainedStruct in
		// 		chainedStruct.pointee.next = next

		// 		if index > 0 {
		// 			nextChainedStruct(index: index - 1, next: chainedStruct)
		// 		} else {
		// 			lambda(chainedStruct)
		// 		}
		// 	}
		// }

		// nextChainedStruct(index: chain.count - 1, next: nil)
	}

	/// Construct the WGPU struct including the linked chain of WGPUChainedStructs
	func withWGPUStruct(_ lambda: (UnsafeMutablePointer<WGPUType>) -> Void) {
		var wgpuStruct: Self.WGPUType = WGPUType()
		applyPropertiesToWGPUStruct(&wgpuStruct) { wgpuStruct in
			withWGPUStructChain { chainedStruct in
				wgpuStruct.pointee.nextInChain = chainedStruct
				lambda(wgpuStruct)
			}
		}
	}
}
