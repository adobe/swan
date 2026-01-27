// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import Foundation
import SwiftBasicFormat
import SwiftSyntax

class TabFormat: BasicFormat {
	public init(initialIndentation: Trivia = .tab) {
		super.init(indentationWidth: .tab, initialIndentation: initialIndentation)
	}
}

let constantMap = [
	"UINT64_MAX": "UInt64.max",
	"UINT32_MAX": "UInt32.max",
	"NAN": "Float.nan",
	"SIZE_MAX": "Int.max",
]

let nativeTypeMap: [String: String] = [
	"size_t": "Int"
]

let multipleUseCallbacks = Set<Name>([
	Name("uncaptured error callback")
])

enum SwiftTypeNameError: Error {
	case unknownTypeName(Name)
	case unhandledEntityType(String)
	case unhandledNativeType(String)
	case unhandledAnnotation(String)
	case unhandledEnumDefault(Name)
	case unknownEnumValue(Name)
	case unknownConstant(String)
}
