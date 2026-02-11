// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

@_spi(Experimental) import JavaScriptKit

@JSClass
struct GPUBuffer {
	@JSGetter var size: Int
	@JSGetter var usage: Int
	@JSGetter var label: String?

	@JSFunction
	func destroy() throws(JSException)
}

