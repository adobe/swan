// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation

// Buffer and texture read-back utilities for testing and debugging.
// These helpers make it easy to verify GPU output by reading data back to the CPU.

public extension GPUBuffer {
    /// Map a buffer for reading and invoke the given completion with the data as an array.
    /// The buffer must have been created with .mapRead usage.
    /// The caller is responsible for calling gpuInstance.processEvents() so the async mapping completes.
    /// - Parameters:
    ///   - offset: Byte offset to start reading from
    ///   - count: Number of elements to read
    ///   - completion: Callback invoked with the array of elements read from the buffer
    func readDataAsync<T>(
        offset: Int = 0,
        count: Int,
        completion: @escaping ([T]) -> Void
    ) {
        let size = count * MemoryLayout<T>.stride
        _ = mapAsync(mode: .read, offset: offset, size: size, callbackInfo:
            .init(
                mode: .allowProcessEvents,
                callback: { [self] status, message in
                    guard status == .success else {
                        fatalError("Buffer map failed: \(message ?? "unknown error")")
                    }
                    guard let pointer = getConstMappedRange(offset: offset, size: size) else {
                        fatalError("Failed to get mapped range")
                    }
                    let typedPointer = pointer.assumingMemoryBound(to: T.self)
                    let result = Array(UnsafeBufferPointer(start: typedPointer, count: count))
                    unmap()
                    completion(result)
                }
            )
        )
    }
}

public extension GPUTexture {
    /// Read pixel data from a texture by copying it to a staging buffer, with async callback.
    /// The callback is invoked when instance.processEvents() is called and the mapping completes.
    /// - Parameters:
    ///   - device: GPU device used to create the staging buffer and command encoder
    ///   - width: Width of the texture region to read
    ///   - height: Height of the texture region to read
    ///   - completion: Callback invoked with the array of pixel data in BGRA format (or similar; assumes 4 bytes per pixel)
    func readPixelsAsync(
        device: GPUDevice,
        width: Int,
        height: Int,
        completion: @escaping ([UInt8]) -> Void
    ) {
        let bytesPerRow = width * 4  // BGRA (or similar) format = 4 bytes per pixel
        precondition(
            bytesPerRow % 256 == 0,
            "Width must result in bytesPerRow that is a multiple of 256 (WebGPU requirement). Use width >= 64."
        )
        let bufferSize = bytesPerRow * height

        // Create staging buffer for read-back
        let stagingBuffer = device.createBuffer(
            descriptor: GPUBufferDescriptor(
                label: "read back buffer",
                usage: [.copyDst, .mapRead],
                size: UInt64(bufferSize),
                mappedAtCreation: false
            )
        )
        guard let stagingBuffer = stagingBuffer else {
            fatalError("Failed to create staging buffer")
        }

        // Issue a command to copy the texture to the staging buffer
        let encoder = device.createCommandEncoder(
            descriptor: GPUCommandEncoderDescriptor(label: "read back encoder")
        )
        encoder.copyTextureToBuffer(
            source: GPUTexelCopyTextureInfo(
                texture: self,
                mipLevel: 0,
                origin: GPUOrigin3D(x: 0, y: 0, z: 0),
                aspect: .all
            ),
            destination: GPUTexelCopyBufferInfo(
                layout: GPUTexelCopyBufferLayout(
                    offset: 0,
                    bytesPerRow: UInt32(bytesPerRow),
                    rowsPerImage: UInt32(height)
                ),
                buffer: stagingBuffer
            ),
            copySize: GPUExtent3D(width: UInt32(width), height: UInt32(height), depthOrArrayLayers: 1)
        )
        let commandBuffer = encoder.finish(descriptor: nil)!
        device.queue.submit(commands: [commandBuffer])

        // Read back pixel data from buffer asynchronously
        stagingBuffer.readDataAsync(count: bufferSize) { (pixels: [UInt8]) in
            stagingBuffer.destroy()
            completion(pixels)
        }
    }
}

public extension GPUDevice {
	func createRenderTargetTexture(
		label: String? = nil,
		width: Int,
		height: Int,
		format: GPUTextureFormat = .RGBA8Unorm
	) -> GPUTexture {
		createTexture(
			descriptor: GPUTextureDescriptor(
				label: label,
				usage: [.copySrc, .renderAttachment],
				dimension: ._2D,
				size: GPUExtent3D(width: UInt32(width), height: UInt32(height), depthOrArrayLayers: 1),
				format: format
			)
		)
	}
}

