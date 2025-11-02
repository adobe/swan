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
///
/// The dawn.json file that is part of the Dawn source describes the Dawn
/// C API in a form convenient for machine processing.
public struct DawnData: Decodable {
	public var data: [Name: DawnEntity] = [:]

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

	public var structures: [Name: DawnStructure] {
		return data.compactMapValues { entity in
			if case .structure(let structure) = entity {
				return structure
			}
			return nil
		}
	}
}

public struct Tags: Decodable {
	let tags: Set<String>

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode([String].self)
		self.tags = Set(value ?? [])
	}
}

public protocol HasTags {
	var tags: Tags? { get }
}

public extension HasTags {
	func hasTag(_ tag: String) -> Bool {
		return tags?.tags.contains(tag) ?? false
	}
}

/// DawnEnum is a struct that represents an enum definition.
public struct DawnEnum: Decodable {
	public let category: String
	public let emscriptenNoEnumTable: Bool?
	public let values: [EnumValue]

	public struct EnumValue: Decodable, HasTags {
		public let value: Int
		public let name: Name
		public let tags: Tags?
		public let jsrepr: String?
	}
}

/// A constant definition.
public struct DawnConstant: Decodable {
	public let category: String
	public let type: String
	public let value: String
	public let cpp_value: String?
}

/// The extensible attribute of a structure.
public enum Extensible: Decodable {
	case `in`
	case out
	case no

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
				self = .no
			}
		}
	}
}

/// The chained attribute of a structure.
public enum Chained: Decodable {
	case `in`
	case out
	case no

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
					debugDescription: "Unknown chained: \(value)"
				)
			}
		} else {
			let value = try container.decode(Bool.self)
			if value {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Unknown chained: \(value)"
				)
			} else {
				self = .no
			}
		}
	}
}

/// A default value for a structure member, function or method argument.
public enum DawnDefaultValue: Decodable {
	case name(Name)
	case double(Double)
	case int(Int)

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode(Name.self)
		if let value = value {
			self = .name(value)
		} else if let value = try? container.decode(Int.self) {
			self = .int(value)
		} else if let value = try? container.decode(Double.self) {
			self = .double(value)
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Unknown default value"
			)
		}
	}

	public var isNullPointer: Bool {
		if case .name(let name) = self {
			return name.raw == "nullptr"
		}
		return false
	}
}

/// A structure member definition.
public struct DawnStructureMember: Decodable {
	public let name: Name
	public let type: Name
	public let optional: Bool
	public let `default`: DawnDefaultValue?
	public let annotation: String?
	public let length: ArraySize?

	enum CodingKeys: String, CodingKey {
		case name
		case type
		case optional
		case `default`
		case annotation
		case length
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(Name.self, forKey: .name)
		type = try container.decode(Name.self, forKey: .type)
		`default` = try container.decodeIfPresent(DawnDefaultValue.self, forKey: .default)
		optional = try container.decodeIfPresent(Bool.self, forKey: .optional) ?? `default`?.isNullPointer ?? false
		annotation = try container.decodeIfPresent(String.self, forKey: .annotation)
		length = try container.decodeIfPresent(ArraySize.self, forKey: .length)
	}
}

/// The size of an array.
public enum ArraySize: Decodable {
	case name(Name)
	case int(Int)

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(String.self) {
			self = .name(Name(value))
		} else if let value = try? container.decode(Int.self) {
			self = .int(value)
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Unknown array size"
			)
		}
	}
}

/// A structure definition.
public struct DawnStructure: Decodable, HasTags {
	public let category: String
	public let extensible: Extensible
	public let chained: Chained?
	public let chainRoots: [Name]?
	public let members: [DawnStructureMember]
	public let _comment: String?
	public let tags: Tags?

	enum CodingKeys: String, CodingKey {
		case category
		case extensible
		case chained
		case chainRoots
		case members
		case _comment
		case tags
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		category = try container.decode(String.self, forKey: .category)
		extensible = try container.decodeIfPresent(Extensible.self, forKey: .extensible) ?? .no
		chained = try container.decodeIfPresent(Chained.self, forKey: .chained) ?? .no
		members = try container.decode([DawnStructureMember].self, forKey: .members)
		_comment = try container.decodeIfPresent(String.self, forKey: ._comment)
		tags = try container.decodeIfPresent(Tags.self, forKey: .tags)
		chainRoots = try container.decodeIfPresent([Name].self, forKey: .chainRoots)
	}
}

/// A method definition for an object.
public struct DawnMethod: Decodable, HasTags {
	public let name: Name
	public let args: [DawnFunctionArgument]?
	public let tags: Tags?
	public let returns: DawnMethodReturnType?
}

/// A description of the return type of a method.
public struct DawnMethodReturnTypeDescription: Decodable {
	public let type: Name
	public let optional: Bool

	enum CodingKeys: String, CodingKey {
		case type
		case optional
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		type = try container.decode(Name.self, forKey: .type)
		optional = try container.decodeIfPresent(Bool.self, forKey: .optional) ?? false
	}
}

/// The return type of a method.
public struct DawnMethodReturnType: Decodable {
	public let type: Name
	public let optional: Bool

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try? container.decode(Name.self)
		if let value = value {
			type = value
			optional = false
		} else {
			let value = try container.decode(DawnMethodReturnTypeDescription.self)
			type = value.type
			optional = value.optional
		}
	}
}

/// A method argument definition.
public struct DawnFunctionArgument: Decodable {
	public let name: Name
	public let type: Name
	public let optional: Bool
	public let `default`: DawnDefaultValue?
	public let annotation: String?
	public let length: ArraySize?

	enum CodingKeys: String, CodingKey {
		case name
		case type
		case optional
		case `default`
		case annotation
		case length
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(Name.self, forKey: .name)
		type = try container.decode(Name.self, forKey: .type)
		`default` = try container.decodeIfPresent(DawnDefaultValue.self, forKey: .default)
		annotation = try container.decodeIfPresent(String.self, forKey: .annotation)
		optional = try container.decodeIfPresent(Bool.self, forKey: .optional) ?? false
		length = try container.decodeIfPresent(ArraySize.self, forKey: .length)
	}
}

/// An object definition.
public struct DawnObject: Decodable {
	public let category: String
	public let noAutolock: Bool?
	public let methods: [DawnMethod]
}

/// A native type definition.
public struct DawnNativeType: Decodable {
	public let category: String
	public let isNullablePointer: Bool?
	public let isNullable: Bool?
	public let isPointer: Bool?
	public let isSigned: Bool?
	public let wasmType: String?
}

/// A callback info definition.
public struct DawnCallbackInfo: Decodable {
	public let category: String
	public let members: [DawnStructureMember]
}

/// A function definition.
public struct DawnFunction: Decodable, HasTags {
	public let category: String
	public let args: [DawnFunctionArgument]
	public let tags: Tags?
	public let returns: Name?
}

/// A function pointer definition.
public struct DawnFunctionPointer: Decodable, HasTags {
	public let category: String
	public let args: [DawnFunctionArgument]
	public let tags: Tags?
	public let returns: Name?
}

/// A callback function definition.
public struct DawnCallbackFunction: Decodable, HasTags {
	public let category: String
	public let args: [DawnFunctionArgument]
	public let tags: Tags?
}

/// An alias (typedef) definition.
public struct DawnAlias: Decodable, HasTags {
	public let category: String
	public let type: Name
	public let tags: Tags?
}

/// A bitmask definition.
public struct DawnBitmask: Decodable {
	public let category: String
	public let values: [DawnBitmaskValue]
}

/// A bitmask value definition.
public struct DawnBitmaskValue: Decodable, HasTags {
	public let value: Int
	public let name: Name
	public let tags: Tags?
}

/// An entity record in the Dawn JSON data.
///
/// The entity records are the top-level definitions in the Dawn JSON data.
public enum DawnEntity: Decodable {
	case alias(DawnAlias)
	case bitmask(DawnBitmask)
	case callbackFunction(DawnCallbackFunction)
	case callbackInfo(DawnCallbackInfo)
	case constant(DawnConstant)
	case `enum`(DawnEnum)
	case function(DawnFunction)
	case functionPointer(DawnFunctionPointer)
	case native(DawnNativeType)
	case object(DawnObject)
	case structure(DawnStructure)

	public init(from decoder: Decoder) throws {
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

	public func hasTag(_ tag: String) -> Bool {
		switch self {
		case .alias(let alias):
			return alias.hasTag(tag)
		case .structure(let structure):
			return structure.hasTag(tag)
		case .function(let function):
			return function.hasTag(tag)
		case .functionPointer(let functionPointer):
			return functionPointer.hasTag(tag)
		case .callbackFunction(let callbackFunction):
			return callbackFunction.hasTag(tag)
		default:
			return false
		}
	}
}
