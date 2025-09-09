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
		string.withWGPUStringView { stringView in
			let stringViewString = String(cString: stringView.data!)
			#expect(stringViewString == string)
			#expect(stringView.length == string.count)
		}
	}
}
