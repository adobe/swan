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
import JavaScriptEventLoop
import JavaScriptKit

@main
struct WebGPUMinimalWasmMain {
	static func main() async {
		print("WebGPUMinimalWasmMain main")
		print("Installing global event loop executor")
		JavaScriptEventLoop.installGlobalExecutor()

		print("Requesting adapter")
		guard let adapter = try? await GPU.sharedInstance?.requestAdapter() else {
			print("Failed to request adapter")
			print("WebGPU not available (e.g. not in a browser or unsupported)")
			return
		}

		print("Requesting device")
		guard let device = try? await adapter.requestDevice(descriptor: nil) else {
			print("Failed to request device")
			return
		}

		print("Creating buffer")
		let descriptor = GPUBufferDescriptor(
			label: "minimal buffer",
			size: 16,
			usage: [.copyDst, .copySrc],
			mappedAtCreation: false
		)
		guard let buffer = device.createBuffer(descriptor: descriptor) else {
			print("Failed to create buffer")
			return
		}

		print("Writing buffer")
		let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20, 0x57, 0x65, 0x62, 0x47, 0x50, 0x55, 0x21, 0x0A, 0x00]  // "Hello, WebGPU!\n"
		device.queue.writeBuffer(buffer: buffer, bufferOffset: 0, data: bytes)

		#if hasFeature(Embedded)
		// Code specific to bare-metal or no-stdlib environment
		print("Running in Embedded Swift")
		#else
		// Code for standard Swift environment
		print("Running in regular Swift")
		#endif

		print("adapter, device, buffer create, and queue.writeBuffer succeeded.")

		let document = JSObject.global.document
		let div = document.createElement("div")
		div.innerHTML = "This text is from Swift! <br/> <code>print()</code> calls are visible in the console."
		_ = document.body.appendChild(div)

		// // 2D testing JavaScriptKit
		// let canvas = document.getElementById("canvas")
		// let ctx: JSValue = canvas.getContext("2d")
		// // Red square
		// ctx.fillStyle = "#ff0000"
		// _ = ctx.fillRect(20, 20, 100, 100)

		// WebGPU testing
		// TODO
	}
}
#else
@main
struct WebGPUMinimalWasmMain {
	static func main() {
		print("WebGPUMinimalWasm runs only when built for WebAssembly.")
	}
}
#endif
