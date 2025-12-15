// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

extension String {
	/// Call a closure with a WGPUStringView that contains the string
	/// String argument is valid for the lifetime of the closure.
	func withWGPUStruct<R>(_ lambda: (WGPUStringView) throws -> R) rethrows -> R {
		var stringView = WGPUStringView()
		var copy = self
		return try copy.withUTF8 { utf8String in
			return try utf8String.withMemoryRebound(to: CChar.self) { cString in
				stringView = WGPUStringView(data: cString.baseAddress, length: cString.count)
				return try lambda(stringView)
			}
		}
	}

	/// Initialize a String from a WGPUStringView.
	init?(wgpuStringView: WGPUStringView) {
		guard let data = wgpuStringView.data, wgpuStringView.length > 0 else {
			return nil
		}
		var string: String = ""
		data.withMemoryRebound(to: UInt8.self, capacity: wgpuStringView.length) { data in
			string = String(decoding: UnsafeBufferPointer(start: data, count: wgpuStringView.length), as: UTF8.self)
		}
		self.init(string)
	}
}

extension Optional where Wrapped == String {
	func withWGPUStruct<R>(_ lambda: (WGPUStringView) throws -> R) rethrows -> R {
		guard let self = self else {
			return try lambda(WGPUStringView(data: nil, length: 0))
		}
		return try self.withWGPUStruct(lambda)
	}
}
