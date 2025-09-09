// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

extension String {
	func withWGPUStringView<R>(_ lambda: (WGPUStringView) throws -> R) rethrows -> R {
		var stringView = WGPUStringView()
		var copy = self
		return try copy.withUTF8 { utf8String in
			return try utf8String.withMemoryRebound(to: CChar.self) { cString in
				stringView = WGPUStringView(data: cString.baseAddress, length: cString.count)
				return try lambda(stringView)
			}
		}
	}
}
