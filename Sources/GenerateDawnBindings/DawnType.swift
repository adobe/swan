// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import DawnData
import SwiftSyntax

/// A record that describes a Dawn C type.
protocol DawnType {
	/// The name of the type in the Swan Swift API.
	func swiftTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool) -> String

	/// The C API name of the type.
	func cTypeNameForType(_ type: Name, annotation: String?, length: ArraySize?, optional: Bool?) -> String

	/// The default value for the type as a string, or nil if no default is appropriate.
	func defaultValue(_ type: Name, annotation: String?, length: ArraySize?) -> String?

	/// Code to unwrap a value of the type.
	func unwrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData,
		expression: ExprSyntax?
	) -> ExprSyntax

	/// Code to wrap a value of the type.
	func wrapValueOfType(
		_ type: Name,
		identifier: String,
		annotation: String?,
		length: ArraySize?,
		optional: Bool?,
		data: DawnData
	) -> ExprSyntax
}
