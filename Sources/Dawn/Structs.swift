// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

/// A WGPU struct from the Dawn C API
public protocol WGPUStruct {}

/// A root structure from the Dawn C API
///
/// The WGPU API uses structure chaining to pass multiple structures to a function.
/// The root structure is the first structure in the chain.
public protocol RootStruct: WGPUStruct {
	var nextInChain: UnsafeMutablePointer<WGPUChainedStruct>! { get set }
}

/// A chained structure from the Dawn C API.
public protocol ChainedStruct: WGPUStruct {
	var chain: WGPUChainedStruct { get set }
}

/// A simple structure from the Dawn C API that we use without wrapping.
public protocol GPUSimpleStruct: WithWGPUPointer {}

/// A Swift wrapper for a WGPU struct from the Dawn C API
public protocol GPUStruct: WithWGPUPointer {
	/// Create a new WGPU struct from the Swift struct
	func withWGPUStruct<R>(_ lambda: (inout WGPUType) -> R) -> R
}

/// A GPUStruct who's unwrapped type can be wrapped back into a new GPUStruct
public protocol GPUStructWrappable: GPUStruct {
	init(wgpuStruct: WGPUType)
}

/// A Swift wrapper for a root structure from the Dawn C API
public protocol GPURootStruct: GPUStruct where WGPUType: RootStruct {
	/// Chained structure providing extra parameters to the root structure
	var nextInChain: (any GPUChainedStruct)? { get }
}

/// A Swift wrapper for a chained structure from the Dawn C API
public protocol GPUChainedStruct: GPUStruct where WGPUType: ChainedStruct {
	var sType: GPUSType { get }

	/// Chained structure providing extra parameters to the root structure
	var nextInChain: (any GPUChainedStruct)? { get }

	func withNextInChain<R>(_ lambda: (UnsafeMutablePointer<WGPUChainedStruct>) -> R) -> R
}

extension GPUSimpleStruct {
	/// Construct a temporary WGPU struct and return the result passing it to the lambda
	func withWGPUStruct<R>(_ lambda: (inout Self) -> R) -> R {
		var copy = self
		return lambda(&copy)
	}
}

extension GPUStructWrappable {
	/// Construct the WGPU struct and return the result of the lambda, also unpacking the WGPU struct back into the Swift struct
	mutating func withWGPUStructInOut<R>(_ lambda: (inout WGPUType) -> R) -> R {
		withWGPUStruct() { wgpuStruct in
			let result = lambda(&wgpuStruct)
			self = Self(wgpuStruct: wgpuStruct)
			return result
		}
	}
}

public extension GPUChainedStruct {
	func withNextInChain<R>(_ lambda: (UnsafeMutablePointer<WGPUChainedStruct>) -> R) -> R {
		fatalError("Unimplemented withNextInChain")
	}
}

public extension GPURootStruct {
	/// Construct the linked chain of WGPUChainedStructs from the chain of wrapper structs
	func withWGPUStructChain<R>(_ lambda: (inout WGPUChainedStruct) -> R) -> R {
		fatalError("Unimplemented withWGPUStructChain")
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
	func withWGPUStruct<R>(_ lambda: (inout WGPUType) -> R) -> R {
		fatalError("Unimplemented withWGPUStruct")
		// var wgpuStruct: Self.WGPUType = WGPUType()
		// applyPropertiesToWGPUStruct(&wgpuStruct, lambda)
		//  {
		// 	withWGPUStructChain { chainedStruct in
		// 		wgpuStruct.nextInChain = chainedStruct
		// 		lambda(&wgpuStruct)
		// 	}
		// }
	}
}
