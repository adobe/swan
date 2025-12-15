// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

// import DOM
// import JavaScriptEventLoop
// import JavaScriptKit
// import WebAPIBase
// import WebGPU
// import _Concurrency

@main
struct Main {
	static func main() {
		print("Hello, World!")
	}
}

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// func fetchString(url: String) async throws(JSException) -> String {
// 	let result = try await Window.global.fetch(input: .init(url))
// 	return try await result.text()
// }

// @main
// struct Entrypoint {
//   static func main() {
//     JavaScriptEventLoop.installGlobalExecutor()
//     let gpu = Window.global.navigator.gpu
//     Task {
//       do throws(JSException) {
//         let adapter = try await gpu.requestAdapter()!
//         let device = try await adapter.requestDevice()

//         let renderer = try await Renderer(
//           device: device,
//           gpu: gpu,
//           shaders: .init(
//             cell: try await fetchString(url: "Resources/cellShader.wgsl"),
//             simulation: try await fetchString(url: "Resources/simulationCompute.wgsl")
//           )
//         )

//         draw(renderer: renderer)
//       } catch {
//         console.error(data: error.thrownValue)
//       }
//     }
//   }
// }
