// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension DawnBitmask {
	func declarations(name: Name, data: DawnData) throws -> [any DeclSyntaxProtocol] {
		return [
			DeclSyntax(
				"public typealias \(raw: name.swiftTypePrefix())\(raw: name.CamelCase) = WGPU\(raw: name.CamelCase)"
			)
		]
	}
}
