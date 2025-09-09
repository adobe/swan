// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing

@testable import DawnData

struct NameTests {
	@Test("Name initialization with single word")
	func testSingleWord() {
		let name = Name("hello")
		#expect(name.parts == ["hello"])
		#expect(name.camelCase == "hello")
	}

	@Test("Name initialization with multiple words")
	func testMultipleWords() {
		let name = Name("hello world")
		#expect(name.parts == ["hello", "world"])
		#expect(name.camelCase == "helloWorld")
	}

	@Test("Name initialization with mixed case")
	func testMixedCase() {
		let name = Name("HELLO world TEST")
		#expect(name.parts == ["HELLO", "world", "TEST"])
		#expect(name.camelCase == "HELLOWorldTEST")
	}

	@Test("Name initialization with empty string")
	func testEmptyString() {
		let name = Name("")
		#expect(name.parts == [])
		#expect(name.camelCase == "")
	}

	@Test("Name initialization with single character")
	func testSingleCharacter() {
		let name = Name("a")
		#expect(name.parts == ["a"])
		#expect(name.camelCase == "a")
	}

	@Test("Name initialization with numbers")
	func testWithNumbers() {
		let name = Name("test 123 number")
		#expect(name.parts == ["test", "123", "number"])
		#expect(name.camelCase == "test123Number")
	}

	@Test("CamelCase property with single word")
	func testCamelCaseSingleWord() {
		let name = Name("hello")
		#expect(name.CamelCase == "Hello")
	}

	@Test("CamelCase property with multiple words")
	func testCamelCaseMultipleWords() {
		let name = Name("get limits")
		#expect(name.CamelCase == "GetLimits")
	}

	@Test("CamelCase property with mixed case")
	func testCamelCaseMixedCase() {
		let name = Name("HELLO world TEST")
		#expect(name.CamelCase == "HELLOWorldTEST")
	}

	@Test("camelCaseIdentifier property with single word")
	func testCamelCaseIdentifierSingleWord() {
		let name = Name("hello")
		#expect(name.camelCaseIdentifier == "hello")
	}

	@Test("camelCaseIdentifier property with multiple words")
	func testCamelCaseIdentifierMultipleWords() {
		let name = Name("get limits")
		#expect(name.camelCaseIdentifier == "getLimits")
	}

	@Test("camelCaseIdentifier property with mixed case")
	func testCamelCaseIdentifierMixedCase() {
		let name = Name("HELLO world TEST")
		#expect(name.camelCaseIdentifier == "HELLOWorldTEST")
	}

	@Test("camelCaseIdentifier property with number prefix")
	func testCamelCaseIdentifierNumberPrefix() {
		let name = Name("123 test")
		#expect(name.camelCaseIdentifier == "_123Test")
	}

	@Test("camelCaseIdentifier property with number in middle")
	func testCamelCaseIdentifierNumberInMiddle() {
		let name = Name("test 123 number")
		#expect(name.camelCaseIdentifier == "test123Number")
	}

	@Test("CamelCaseIdentifier property with single word")
	func testCapitalCamelCaseIdentifierSingleWord() {
		let name = Name("hello")
		#expect(name.CamelCaseIdentifier == "Hello")
	}

	@Test("CamelCaseIdentifier property with multiple words")
	func testCapitalCamelCaseIdentifierMultipleWords() {
		let name = Name("get limits")
		#expect(name.CamelCaseIdentifier == "GetLimits")
	}

	@Test("CamelCaseIdentifier property with mixed case")
	func testCapitalCamelCaseIdentifierMixedCase() {
		let name = Name("HELLO world TEST")
		#expect(name.CamelCaseIdentifier == "HELLOWorldTEST")
	}

	@Test("CamelCaseIdentifier property with number prefix")
	func testCapitalCamelCaseIdentifierNumberPrefix() {
		let name = Name("123 test")
		#expect(name.CamelCaseIdentifier == "_123Test")
	}

	@Test("CamelCaseIdentifier property with number in middle")
	func testCapitalCamelCaseIdentifierNumberInMiddle() {
		let name = Name("test 123 number")
		#expect(name.CamelCaseIdentifier == "Test123Number")
	}

	@Test("lastPart property with single word")
	func testLastPartSingleWord() {
		let name = Name("hello")
		#expect(name.lastPart == "hello")
	}

	@Test("lastPart property with multiple words")
	func testLastPartMultipleWords() {
		let name = Name("get limits")
		#expect(name.lastPart == "limits")
	}

	@Test("firstPart property with single word")
	func testFirstPartSingleWord() {
		let name = Name("hello")
		#expect(name.firstPart == "hello")
	}

	@Test("firstPart property with multiple words")
	func testFirstPartMultipleWords() {
		let name = Name("get limits")
		#expect(name.firstPart == "get")
	}

	@Test("count property with single word")
	func testCountSingleWord() {
		let name = Name("hello")
		#expect(name.count == 1)
	}

	@Test("count property with multiple words")
	func testCountMultipleWords() {
		let name = Name("get limits")
		#expect(name.count == 2)
	}

	@Test("count property with empty string")
	func testCountEmptyString() {
		let name = Name("")
		#expect(name.count == 0)
	}

	@Test("count property with three words")
	func testCountThreeWords() {
		let name = Name("hello world test")
		#expect(name.count == 3)
	}

	@Test("raw property with single word")
	func testRawSingleWord() {
		let name = Name("hello")
		#expect(name.raw == "hello")
	}

	@Test("raw property with multiple words")
	func testRawMultipleWords() {
		let name = Name("hello world")
		#expect(name.raw == "hello world")
	}

	@Test("raw property with mixed case")
	func testRawMixedCase() {
		let name = Name("HELLO world TEST")
		#expect(name.raw == "HELLO world TEST")
	}

	@Test("raw property with numbers")
	func testRawWithNumbers() {
		let name = Name("test 123 number")
		#expect(name.raw == "test 123 number")
	}

	@Test("raw property with empty string")
	func testRawEmptyString() {
		let name = Name("")
		#expect(name.raw == "")
	}

	@Test("raw property with three words")
	func testRawThreeWords() {
		let name = Name("hello world test")
		#expect(name.raw == "hello world test")
	}
}
