// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//

import DawnData

extension DawnData {
	func printStats() {
		let structureNames = data.filter {
			if case .structure = $0.value { return true }
			return false
		}.map { $0.key }
		let structNameSet = Set(structureNames)

		let functionsWithStructArgs = data.filter {
			if case .function(let function) = $0.value {
				for arg in function.args {
					if structNameSet.contains(arg.type) {
						return true
					}
				}
			}
			return false
		}
		print("Functions with struct args: \(functionsWithStructArgs.count)")
		for function in functionsWithStructArgs {
			print("  \(function.key.camelCase)")
		}

		print("Objects with methods that take struct args")
		var count = 0
		for (key, value) in data {
			if case .object(let object) = value {
				let methodsWithStructArgs = object.methods.filter { method in
					if method.args == nil {
						return false
					}
					for arg in method.args! {
						if structNameSet.contains(arg.type) {
							return true
						}
					}
					return false
				}
				if methodsWithStructArgs.count > 0 {
					print("  \(key.CamelCase)")
					for method in methodsWithStructArgs {
						print("    \(method.name.camelCase)")
					}
					count += methodsWithStructArgs.count
				}
			}
		}
		print("Total object methods that take struct args: \(count)")

		print("Structs with struct data members")
		count = 0
		for (key, value) in data {
			if case .structure(let structure) = value {
				for member in structure.members {
					if structNameSet.contains(member.type) {
						print(
							"  \(key.camelCase) has member \(member.name.camelCase) of type \(member.type.camelCase)"
						)
						count += 1
					}
				}
			}
		}
		print("Total structs with struct data members: \(count)")
		// print("Structures: \(structureNames.count)")
		// for name in structureNames {
		// 	print("  \(name)")
		// }
	}
}
