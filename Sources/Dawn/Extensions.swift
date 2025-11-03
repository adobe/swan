// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import Foundation

public extension Array {
	/// The length of the array in bytes.
	var lengthInBytes: UInt64 {
		return UInt64(count * MemoryLayout<Element>.size)
	}
}

public extension GPUShaderModuleDescriptor {
	// Init compatible with the web version
	init(label: String, code: String) {
		self.init(label: label)
		nextInChain = GPUShaderSourceWGSL(code: code)
	}
}
