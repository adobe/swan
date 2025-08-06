// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Testing

@testable import UpdateDawnBindings

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
}
