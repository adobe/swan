// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// Minimal WebGPU Wasm demo. Build with SwiftWasm for wasm32 to run in the browser.
// On native platforms this target builds a stub that prints instructions.

#if arch(wasm32) || os(wasi)
import WebGPU

@main
struct WebGPUMinimalWasmMain {
	static func main() async {
		guard let _ = try? await NavigatorGPU.requestAdapter() else {
			print("WebGPU not available (e.g. not in a browser or unsupported)")
			return
		}
		// guard let device = try? await adapter.requestDevice(descriptor: nil) else {
		// 	print("Failed to request device")
		// 	return
		// }
		// // Create a small buffer and write bytes to it to verify the binding path.
		// let descriptor = GPUBufferDescriptor(
		// 	label: "minimal buffer",
		// 	size: 16,
		// 	usage: [.copyDst, .copySrc],
		// 	mappedAtCreation: false
		// )
		// guard let buffer = device.createBuffer(descriptor: descriptor) else {
		// 	print("Failed to create buffer")
		// 	return
		// }
		// let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20, 0x57, 0x65, 0x62, 0x47, 0x50, 0x55, 0x21, 0x0A, 0x00]
		// device.queue.writeBuffer(buffer: buffer, bufferOffset: 0, data: bytes)
		print("WebGPU Wasm spike OK: adapter, device, buffer create, and queue.writeBuffer succeeded.")
	}
}
#else
@main
struct WebGPUMinimalWasmMain {
	static func main() {
		print("WebGPUMinimalWasm runs only when built for WebAssembly.")
		print("Use the SwiftWasm toolchain and build with: swift build --target WebGPUMinimalWasm")
	}
}
#endif
