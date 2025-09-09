// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import Testing

@testable import GenerateDawnBindings

@Suite struct GenerateWrappersTest {

	@Test("GenerateWrappersTest")
	func testGenerateWrappers() {
		let shaderModuleDescriptor = """
			{
			    "shader module descriptor": {
			        "category": "structure",
			        "extensible": "in",
			        "members": [
			            {"name": "label", "type": "string view", "optional": true}
			        ]
			    },
			    "shader source WGSL": {
			        "category": "structure",
			        "chained": "in",
			        "chain roots": ["shader module descriptor"],
			        "members": [
			            {"name": "code", "type": "string view"}
			        ]
			    },
			}
			"""

		let data = try? JSONDecoder().decode(DawnData.self, from: shaderModuleDescriptor.data(using: .utf8)!)
		guard let data = data else {
			Issue.record("Failed to decode data")
			return
		}
		let wrappers = try? data.generateWrappers()
		#expect(wrappers!.count > 0)
	}
}
