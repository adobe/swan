// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing

@testable import Dawn

struct WGSLStringViewTest {
	@Test("Getting WGPUStringView from String")
	func testWGPUStringViewFromString() {
		let string = "Hello, world!"
		string.withWGPUStruct { stringView in
			let stringViewString = String(wgpuStringView: stringView)
			#expect(stringViewString == string)
			#expect(stringView.length == string.count)
		}
	}

	@Test("Getting String from WGPUStringView")
	func testStringFromWGPUStringView() {
		let string = "Hello, world!"
		string.withWGPUStruct { stringView in
			let stringViewString = String(wgpuStringView: stringView)
			#expect(stringViewString == string)
			#expect(stringView.length == string.count)
		}
	}
}
