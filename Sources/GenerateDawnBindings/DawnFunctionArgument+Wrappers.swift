// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData

extension DawnFunctionArgument: TypeDescriptor {
	var isInOut: Bool {
		return annotation == "void*" || annotation == "*"
	}
}
