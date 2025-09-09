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
	/// Construct the WGPU struct
	func withWGPUStruct<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		var wgpuStruct: Self.WGPUType = WGPUType()
		return applyPropertiesToWGPUStruct(&wgpuStruct, lambda)
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
