// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

#if os(Windows)
import CDawn

// MARK: - SharedBufferMemoryD3D12ResourceDescriptor

extension WGPUSharedBufferMemoryD3D12ResourceDescriptor: ChainedStruct {}

/// A structure that allows passing an existing ID3D12Resource object to create shared buffer memory.
///
/// Example usage:
/// ```swift
/// let resource = UnsafeMutablePointer<ID3D12Resource>(...)
/// let descriptor = GPUSharedBufferMemoryD3D12ResourceDescriptor(resource: resource)
/// let sharedMemoryDescriptor = GPUSharedBufferMemoryDescriptor(nextInChain: descriptor)
/// ```
public struct GPUSharedBufferMemoryD3D12ResourceDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedBufferMemoryD3D12ResourceDescriptor
	public let sType: GPUSType = .sharedBufferMemoryD3D12ResourceDescriptor

	/// The ID3D12Resource object. Must be created from the same ID3D12Device used in the WGPUDevice.
	public var resource: UnsafeMutablePointer<ID3D12Resource>?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(resource: UnsafeMutablePointer<ID3D12Resource>?) {
		self.resource = resource
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryD3D12ResourceDescriptor) -> R
	) -> R {
		{
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedBufferMemoryD3D12ResourceDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					resource: resource
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedBufferMemoryD3D12ResourceDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						resource: resource
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

// MARK: - SharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor

extension WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor: ChainedStruct {}

/// A structure that allows creating shared buffer memory
/// from a Windows shared memory file handle created with CreateFileMapping.
///
/// Note: The size must be a multiple of D3D12_DEFAULT_RESOURCE_PLACEMENT_ALIGNMENT (64KB)
/// to hold a D3D12 buffer resource.
///
/// Example usage:
/// ```swift
/// let fileHandle: UnsafeMutableRawPointer? = ... // HANDLE from CreateFileMapping
/// let size: UInt64 = 65536 * 10 // 10 * 64KB (aligned)
/// let handleDescriptor = GPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor(
///     handle: fileHandle,
///     size: size
/// )
/// var sharedMemoryDescriptor = GPUSharedBufferMemoryDescriptor(nextInChain: handleDescriptor)
/// ```
public struct GPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor
	public let sType: GPUSType = .sharedBufferMemoryD3D12SharedMemoryFileMappingHandleDescriptor

	/// A handle to a shared memory file created with CreateFileMapping.
	/// The handle must be closed outside of Dawn with CloseHandle when it is no longer needed.
	public var handle: UnsafeMutableRawPointer?

	/// The size of the shared memory mapping.
	/// Must be a multiple of kRequiredAlignment (64KB) to hold a D3D12 buffer resource.
	public var size: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	/// The required alignment for size (D3D12_DEFAULT_RESOURCE_PLACEMENT_ALIGNMENT = 64KB)
	public static let kRequiredAlignment: UInt32 = 65536

	public init(handle: UnsafeMutableRawPointer?, size: UInt64) {
		self.handle = handle
		self.size = size
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor) -> R
	) -> R {
		{
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle,
					size: size
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle,
						size: size
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

// MARK: - SharedTextureMemoryD3D12ResourceDescriptor

extension WGPUSharedTextureMemoryD3D12ResourceDescriptor: ChainedStruct {}

/// A structure that allows passing an existing ID3D12Resource object to create shared texture memory.
///
/// Example usage:
/// ```swift
/// let resource = UnsafeMutablePointer<ID3D12Resource>(...)
/// let descriptor = GPUSharedTextureMemoryD3D12ResourceDescriptor(resource: resource)
/// let sharedMemoryDescriptor = GPUSharedTextureMemoryDescriptor(nextInChain: descriptor)
/// ```
public struct GPUSharedTextureMemoryD3D12ResourceDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryD3D12ResourceDescriptor
	public let sType: GPUSType = .sharedTextureMemoryD3D12ResourceDescriptor

	/// The ID3D12Resource object. Must be created from the same ID3D12Device used in the WGPUDevice.
	public var resource: UnsafeMutablePointer<ID3D12Resource>?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(resource: UnsafeMutablePointer<ID3D12Resource>?) {
		self.resource = resource
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryD3D12ResourceDescriptor) -> R
	) -> R {
		{
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryD3D12ResourceDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					resource: resource
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryD3D12ResourceDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						resource: resource
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

#endif
