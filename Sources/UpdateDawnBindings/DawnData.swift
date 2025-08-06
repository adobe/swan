// Copyright 2025 Adobe
// All Rights Reserved.
// 
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import Foundation
import Logging

let logger: Logger = {
	var log = Logger(label: "UpdateDawnBindings")
	log.logLevel = .debug
	return log
}()

/// DawnData is a struct that represents the root of the Dawn JSON data.
struct DawnData: Decodable {
	var data: [Name: DawnEntity] = [:]

	public init(from decoder: Decoder) throws {
		let container: KeyedDecodingContainer<DynamicCodingKeys>? = try? decoder.container(keyedBy: DynamicCodingKeys.self)
		for key in container?.allKeys ?? [] {
			if key.stringValue == "_doc" || key.stringValue == "_metadata" || key.stringValue == "_comment" {
				continue
			}
			do {
				let value = try container?.decode(DawnEntity.self, forKey: key)
				self.data[Name(key.stringValue)] = value
			} catch {
				logger.error("Error decoding key: \(key.stringValue): \(error)")
			}
		}
	}
}

/// DawnEnum is a struct that represents an enum definition.
struct DawnEnum: Decodable {
	let category: String
	let emscriptenNoEnumTable: Bool?
	let values: [EnumValue]

	struct EnumValue: Decodable {
		let value: Int
		let name: String
		let tags: [String]?
		let jsrepr: String?
	}
}

/// A constant definition.
struct DawnConstant: Decodable {
	let category: String
	let type: String
	let value: String
	let cpp_value: String?
}

/// The extensible attribute of a structure.
enum Extensible: Decodable {
	case `in`
	case out
	case `false`

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode(String.self)
		if let value = value {
			switch value {
			case "in":
				self = .in
			case "out":
				self = .out
			default:
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Unknown extensible: \(value)"
				)
			}
		} else {
			let value = try container.decode(Bool.self)
			if value {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Unknown extensible: \(value)"
				)
			} else {
				self = .false
			}
		}
	}
}

/// A default value for a structure member, function or method argument.
enum DefaultValue: Decodable {
	case string(String)
	case double(Double)
	case int(Int)

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode(String.self)
		if let value = value {
			self = .string(value)
		} else if let value = try? container.decode(Double.self) {
			self = .double(value)
		} else if let value = try? container.decode(Int.self) {
			self = .int(value)
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Unknown default value"
			)
		}
	}
}

/// A structure member definition.
struct DawnStructureMember: Decodable {
	let name: String
	let type: String
	let optional: Bool?
	let `default`: DefaultValue?
}

/// A structure definition.
struct DawnStructure: Decodable {
	let category: String
	let extensible: Extensible?
	let members: [DawnStructureMember]
	let _comment: String?
	let tags: [String]?
}

/// A method definition for an object.
struct DawnMethod: Decodable {
	let name: Name
	let args: [DawnFunctionArgument]?
	let tags: [String]?
	let returns: DawnMethodReturnType?
}

/// A description of the return type of a method.
struct DawnMethodReturnTypeDescription: Decodable {
	let type: String
	let optional: Bool?
}

/// The return type of a method.
enum DawnMethodReturnType: Decodable {
	case name(Name)
	case description(DawnMethodReturnTypeDescription)

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode(Name.self)
		if let value = value {
			self = .name(value)
		} else {
			self = .description(try container.decode(DawnMethodReturnTypeDescription.self))
		}
	}
}

/// A method argument definition.
struct DawnFunctionArgument: Decodable {
	let name: Name
	let type: String
	let optional: Bool?
	let `default`: DefaultValue?
	let annotation: String?
}

/// An object definition.
struct DawnObject: Decodable {
	let category: String
	let noAutolock: Bool?
	let methods: [DawnMethod]
}

/// A native type definition.
struct DawnNativeType: Decodable {
	let category: String
	let isNullablePointer: Bool?
	let isNullable: Bool?
	let isPointer: Bool?
	let isSigned: Bool?
}

/// A callback info definition.
struct DawnCallbackInfo: Decodable {
	let category: String
	let members: [DawnStructureMember]
}

/// A function definition.
struct DawnFunction: Decodable {
	let category: String
	let args: [DawnFunctionArgument]
	let tags: [String]?
	let returns: String?
}

/// A function pointer definition.
struct DawnFunctionPointer: Decodable {
	let category: String
	let args: [DawnFunctionArgument]
	let tags: [String]?
	let returns: String?
}

/// A callback function definition.
struct DawnCallbackFunction: Decodable {
	let category: String
	let args: [DawnFunctionArgument]
	let tags: [String]?
}

/// An alias (typedef) definition.
struct DawnAlias: Decodable {
	let category: String
	let type: Name
	let tags: [String]?
}

/// A bitmask definition.
struct DawnBitmask: Decodable {
	let category: String
	let values: [DawnBitmaskValue]
}

/// A bitmask value definition.
struct DawnBitmaskValue: Decodable {
	let value: Int
	let name: Name
	let tags: [String]?
}

/// An entity record in the Dawn JSON data.
///
/// The entity records are the top-level definitions in the Dawn JSON data.
enum DawnEntity: Decodable {
	case `enum`(DawnEnum)
	case structure(DawnStructure)
	case object(DawnObject)
	case native(DawnNativeType)
	case callbackInfo(DawnCallbackInfo)
	case function(DawnFunction)
	case functionPointer(DawnFunctionPointer)
	case alias(DawnAlias)
	case bitmask(DawnBitmask)
	case callbackFunction(DawnCallbackFunction)
	case constant(DawnConstant)

	init(from decoder: Decoder) throws {
		let container: KeyedDecodingContainer<DynamicCodingKeys>? = try decoder.container(keyedBy: DynamicCodingKeys.self)
		let categoryKey = DynamicCodingKeys(stringValue: "category")!
		let category = try container?.decode(String.self, forKey: categoryKey)
		switch category {
		case "enum":
			let container = try decoder.singleValueContainer()
			let enumRecord = try container.decode(DawnEnum.self)
			self = .enum(enumRecord)
		case "structure":
			let container = try decoder.singleValueContainer()
			let structureRecord = try container.decode(DawnStructure.self)
			self = .structure(structureRecord)
		case "object":
			let container = try decoder.singleValueContainer()
			let objectRecord = try container.decode(DawnObject.self)
			self = .object(objectRecord)
		case "native":
			let container = try decoder.singleValueContainer()
			let nativeTypeRecord = try container.decode(DawnNativeType.self)
			self = .native(nativeTypeRecord)
		case "callback info":
			let container = try decoder.singleValueContainer()
			let callbackInfoRecord = try container.decode(DawnCallbackInfo.self)
			self = .callbackInfo(callbackInfoRecord)
		case "function":
			let container = try decoder.singleValueContainer()
			let functionRecord = try container.decode(DawnFunction.self)
			self = .function(functionRecord)
		case "function pointer":
			let container = try decoder.singleValueContainer()
			let functionPointerRecord = try container.decode(DawnFunctionPointer.self)
			self = .functionPointer(functionPointerRecord)
		case "typedef":
			let container = try decoder.singleValueContainer()
			let aliasRecord = try container.decode(DawnAlias.self)
			self = .alias(aliasRecord)
		case "bitmask":
			let container = try decoder.singleValueContainer()
			let bitmaskRecord = try container.decode(DawnBitmask.self)
			self = .bitmask(bitmaskRecord)
		case "callback function":
			let container = try decoder.singleValueContainer()
			let callbackFunctionRecord = try container.decode(DawnCallbackFunction.self)
			self = .callbackFunction(callbackFunctionRecord)
		case "constant":
			let container = try decoder.singleValueContainer()
			let constantRecord = try container.decode(DawnConstant.self)
			self = .constant(constantRecord)
		default:
			throw DecodingError.dataCorruptedError(
				forKey: categoryKey,
				in: container!,
				debugDescription: "Unknown category: \(category ?? "unknown")"
			)
		}
	}
}
