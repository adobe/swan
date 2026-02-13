// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// Minimal WebGPU Wasm demo. Build with SwiftWasm for wasm32 to run in the browser.
// On native platforms this target builds a stub that prints instructions.

#if arch(wasm32) || os(wasi)

@_spi(Experimental) import JavaScriptKit
import JavaScriptEventLoop
import WebGPU

// @main
@JS struct WebGPUMinimalWasmMain {

	@JS static func installGlobalEventLoopExecutor() {
		print("Installing global event loop executor")
		JavaScriptEventLoop.installGlobalExecutor()
	}

	@JS static func startDemoAsync() async {
		// print("WebGPUMinimalWasmMain main")
		// print("Installing global event loop executor")
		// JavaScriptEventLoop.installGlobalExecutor()

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
		div.innerHTML = "This text is from Swift!"
		_ = document.body.querySelector(".container").appendChild(div)

		// WebGPU testing
		// TODO
	}

	@JS static func test2DContext() {
		let document = JSObject.global.document

		// create canvas element
		let canvasContainer = document.querySelector(".canvas-container")
		let canvas = document.createElement("canvas")
		_ = canvasContainer.appendChild(canvas)

		let ctx: JSValue = canvas.getContext("2d")
		// Red square
		ctx.fillStyle = "#ff0000"
		_ = ctx.fillRect(20, 20, 100, 100)
	}

	@JS static func testWebGPUContext() async {

		print("Testing WebGPU context")
		let document = JSObject.global.document

		// create canvas element
		let canvasContainer = document.querySelector(".canvas-container")
		let canvas = document.createElement("canvas")
		_ = canvasContainer.appendChild(canvas)

		print("Got canvas")
		let ctx: JSValue = canvas.getContext("webgpu")
		print("Got context")
		print(ctx)

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

		print("Creating canvas context")
		let context = GPUCanvasContext(canvas: canvas.object!)
		print("Configuring canvas context")
		context.configure(device: device, format: "bgra8unorm")

		print("Canvas context configured")

	}
}
#else  // native platforms
struct WebGPUMinimalWasmMain {
	static func main() {
		print("WebGPUMinimalWasm runs only when built for WebAssembly.")
	}
}
#endif  // arch(wasm32) || os(wasi)
