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
    /// Map a buffer for reading and return the data as an array.
    /// The buffer must have been created with .mapRead usage.
    /// - Parameters:
    ///   - instance: GPU instance required to call processEvents() until the mapAsync request completes
    ///   - offset: Byte offset to start reading from
    ///   - count: Number of elements to read
    /// - Returns: Array of elements read from the buffer
    @MainActor
    func readData<T>(instance: GPUInstance, offset: Int = 0, count: Int) -> [T]{
		print("Readback started...");

        var mapped = false
        let size = count * MemoryLayout<T>.stride
        _ = mapAsync(mode: .read, offset: offset, size: size, callbackInfo:
            .init(
                mode: .allowProcessEvents,
                callback: { status, message in
                    guard status == .success else {
                        fatalError("Buffer map failed: \(message ?? "unknown error")")
                    }
                    mapped = true
                }
            )
        )

        // Poll until mapAsync request completes
        while !mapped {
            instance.processEvents()
        }

        guard let pointer = getConstMappedRange(offset: offset, size: size) else {
            fatalError("Failed to get mapped range")
        }
        let typedPointer = pointer.assumingMemoryBound(to: T.self)
        // Copy into an array
        let result = Array(UnsafeBufferPointer(start: typedPointer, count: count))

        unmap()

        return result
    }
}

public extension GPUTexture {
    /// Read pixel data from a texture by copying it to a staging buffer.
    /// - Parameters:
    ///   - device: GPU device used to create the staging buffer and command encoder
    ///   - instance: GPU instance required to call processEvents() until the mapAsync request completes
    ///   - width: Width of the texture region to read
    ///   - height: Height of the texture region to read
    /// - Returns: Array of pixel data in BGRA format (4 bytes per pixel)
    @MainActor
    func readPixels(
        device: GPUDevice,
        instance: GPUInstance,
        width: UInt32,
        height: UInt32
    ) -> [UInt8] {
        let bytesPerRow = width * 4  // BGRA format = 4 bytes per pixel
        precondition(
            bytesPerRow % 256 == 0,
            "Width must result in bytesPerRow that is a multiple of 256 (WebGPU requirement). Use width >= 64."
        )
        let bufferSize = UInt64(bytesPerRow * height)

        // Create staging buffer for read-back
        let stagingBuffer = device.createBuffer(
            descriptor: GPUBufferDescriptor(
                label: "read back buffer",
                usage: [.copyDst, .mapRead],
                size: bufferSize,
                mappedAtCreation: false
            )
        )
        // Why would createBuffer ever fail?
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
                    bytesPerRow: bytesPerRow,
                    rowsPerImage: height
                ),
                buffer: stagingBuffer
            ),
            copySize: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1)
        )
        let commandBuffer = encoder.finish(descriptor: nil)!
        device.queue.submit(commands: [commandBuffer])

        // Read back pixel data from buffer
        let pixels: [UInt8] = stagingBuffer.readData(
            instance: instance,
            count: Int(bufferSize)
        )

        stagingBuffer.destroy()

        return pixels
    }
}

public extension GPUDevice {
	func createRenderTargetTexture(
		label: String = "Render Target",
		width: UInt32 = 64,
		height: UInt32 = 64,
		format: GPUTextureFormat = .RGBA8Unorm
	) -> GPUTexture {
		createTexture(
			descriptor: GPUTextureDescriptor(
				label: label,
				usage: [.copySrc, .renderAttachment],
				dimension: ._2D,
				size: GPUExtent3D(width: width, height: height, depthOrArrayLayers: 1),
				format: format
			)
		)
	}
}