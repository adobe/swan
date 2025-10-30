// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

extension ArraySize {
	func sizeWithIdentifier(_ identifier: String) -> ExprSyntax {
		switch self {
		case .name(let name):
			return "\(raw: identifier).\(raw: name.camelCase)"
		case .int(let int):
			return "\(raw: int)"
		}
	}
}
