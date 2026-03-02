// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

#if arch(wasm32)
import JavaScriptKit
import WebGPU

nonisolated(unsafe) var demo: BitonicSortDemo!

@JS public func initializeBitonicSort(
	device deviceJS: JSObject,
	context contextJS: JSObject,
	format formatString: String
) {
	let device = GPUDevice(unsafelyWrapping: deviceJS)
	let context = GPUCanvasContext(unsafelyWrapping: contextJS)
	let format = GPUTextureFormat(rawValue: formatString) ?? .bgra8unorm

	demo = BitonicSortDemo(device: device, context: context, format: format)
}

@JS public func renderFrame(time: Double) {
	guard demo != nil else { return }
	demo.frame(time: time / 1000.0)
}

@JS public func keyPressed(key: String) {
	guard demo != nil else { return }
	demo.handleKey(key)
}

print("BitonicSort WASM loaded")

#else

import DemoUtils

try runDemo(title: "Bitonic Sort", provider: BitonicSortDemo())

#endif
