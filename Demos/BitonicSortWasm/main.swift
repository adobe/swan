// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit
import JavaScriptEventLoop
@_spi(Experimental) import WebGPUWasm

// Global state
nonisolated(unsafe) var demo: BitonicSortDemo!

/// JS-exported entry point — called from JavaScript after WebGPU initialization
@JS public func initializeBitonicSort(
	device deviceJS: JSObject,
	context contextJS: JSObject,
	format formatString: String
) {
	do {
		let device = GPUDevice(unsafelyWrapping: deviceJS)
		let context = GPUCanvasContext(unsafelyWrapping: contextJS)
		let format = GPUTextureFormat(rawValue: formatString) ?? .bgra8unorm

		demo = try BitonicSortDemo(device: device, context: context, format: format)
	} catch {
		print("Failed to initialize BitonicSort: \(error)")
	}
}

/// Called from JavaScript each frame via requestAnimationFrame
@JS public func renderFrame(time: Double) {
	guard demo != nil else { return }
	do {
		// requestAnimationFrame provides time in milliseconds; convert to seconds
		try demo.frame(time: time / 1000.0)
	} catch {
		print("Render error: \(error)")
	}
}

/// Called from JavaScript on keydown events
@JS public func keyPressed(key: String) {
	guard demo != nil else { return }
	demo.handleKey(key)
}

print("BitonicSortWasm loaded")
