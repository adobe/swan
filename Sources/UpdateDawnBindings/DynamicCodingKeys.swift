// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

/// A coding key that can be used to decode a dictionary with dynamic keys.
///
/// This is useful for decoding dictionaries with keys that are not known at compile time.
///
struct DynamicCodingKeys: CodingKey {
	var stringValue: String
	init?(stringValue: String) {
		self.stringValue = stringValue
	}
	var intValue: Int?
	init?(intValue: Int) {
		return nil
	}
}
