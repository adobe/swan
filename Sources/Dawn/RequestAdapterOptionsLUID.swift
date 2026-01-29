// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

#if os(Windows)
import CDawn

extension WGPURequestAdapterOptionsLUID: ChainedStruct {}

/// This allows specifying a specific GPU adapter by its LUID (Locally Unique Identifier)
/// when requesting a WebGPU adapter on Windows.
///
/// Example usage:
/// ```swift
/// let luid = LUID(LowPart: 0x12345678, HighPart: 0x9ABCDEF0)
/// let luidOptions = GPURequestAdapterOptionsLUID(adapterLUID: luid)
/// var options = GPURequestAdapterOptions(nextInChain: luidOptions)
/// ```
public struct GPURequestAdapterOptionsLUID: GPUChainedStruct {
	public typealias WGPUType = WGPURequestAdapterOptionsLUID
	public let sType: GPUSType = .requestAdapterOptionsLUID

	public var adapterLUID: LUID

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(adapterLUID: LUID) {
		self.adapterLUID = adapterLUID
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestAdapterOptionsLUID) -> R
	) -> R {
		{
			if nextInChain == nil {
				var wgpuStruct = WGPURequestAdapterOptionsLUID(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					adapterLUID: adapterLUID
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPURequestAdapterOptionsLUID(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						adapterLUID: adapterLUID
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension GPURequestAdapterOptionsLUID: CustomStringConvertible {
	public var description: String {
		return "GPURequestAdapterOptionsLUID(LowPart: \(adapterLUID.LowPart), HighPart: \(adapterLUID.HighPart))"
	}
}

#endif
