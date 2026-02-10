// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

/// Wrapper around the browser GPUBuffer (from device.createBuffer).
public final class GPUBuffer {
	let jsObject: JSObject
	/// Size in bytes (cached from descriptor).
	public let size: UInt64

	init(jsObject: JSObject, size: UInt64) {
		self.jsObject = jsObject
		self.size = size
	}
}
