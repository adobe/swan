public protocol WithWGPUPointer {
	associatedtype WGPUType

	func withWGPUPointer<R>(_ lambda: (UnsafePointer<WGPUType>) -> R) -> R
	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R
}

public extension WithWGPUPointer where Self: GPUStruct {
	typealias WGPUType = Self.WGPUType

	func withWGPUPointer<R>(_ lambda: (UnsafePointer<WGPUType>) -> R) -> R {
		withWGPUStruct { wgpuStruct in
			withUnsafePointer(to: &wgpuStruct) { pointer in
				lambda(pointer)
			}
		}
	}

	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		withWGPUStruct { wgpuStruct in
			withUnsafeMutablePointer(to: &wgpuStruct) { pointer in
				lambda(pointer)
			}
		}
	}
}

public extension WithWGPUPointer where Self: GPUStructWrappable {
	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		withWGPUStruct { wgpuStruct in
			let result = withUnsafeMutablePointer(to: &wgpuStruct) { pointer in
				lambda(pointer)
			}
			self = Self(wgpuStruct: wgpuStruct)
			return result
		}
	}
}

public extension WithWGPUPointer where Self: GPUSimpleStruct, Self.WGPUType == Self {
	func withWGPUPointer<R>(_ lambda: (UnsafePointer<WGPUType>) -> R) -> R {
		var copy = self
		return withUnsafePointer(to: &copy) { pointer in
			lambda(pointer)
		}
	}

	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
		withUnsafeMutablePointer(to: &self) { pointer in
			lambda(pointer)
		}
	}
}

public extension Array where Element: GPUStruct {
	func withWGPUPointer<R>(_ lambda: (UnsafePointer<Element.WGPUType>) -> R) -> R {
		return withWGPUArrayPointer(self, lambda)
	}

	func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<Element.WGPUType>) -> R) -> R {
		return withWGPUMutableArrayPointer(self, lambda)
	}
}

public extension Optional where Wrapped: WithWGPUPointer {
	func withWGPUPointer<R>(_ lambda: (UnsafePointer<Wrapped.WGPUType>?) -> R) -> R {
		return self?.withWGPUPointer(lambda) ?? lambda(nil)
	}
	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<Wrapped.WGPUType>?) -> R) -> R {
		return self?.withWGPUMutablePointer(lambda) ?? lambda(nil)
	}
}

/// Given an array of strings, convert it to an array of C strings and call the lambda with the pointer to the WGPU array.
public func withWGPUArrayPointer<R>(_ array: [String], _ lambda: (UnsafePointer<UnsafePointer<CChar>?>) -> R) -> R {
	var result: R!
	var cStringArray = Array<UnsafePointer<CChar>?>()
	cStringArray.reserveCapacity(array.count)

	func process(index: Int) -> R {
		if index >= array.count {
			return cStringArray.withUnsafeBufferPointer { buffer in
				let pointer = UnsafePointer(buffer.baseAddress!)
				return lambda(pointer)
			}
		}
		return array[index].withCString { cString in
			cStringArray.append(cString)
			return process(index: index + 1)
		}
	}
	result = process(index: 0)
	return result
}

/// Given an array of Swift structs, convert it to an array of WGPU structs and call the lambda with the pointer to the WGPU array.
public func withWGPUArrayPointer<E: GPUStruct, R>(_ array: [E], _ lambda: (UnsafePointer<E.WGPUType>) -> R) -> R {
	return withWGPUMutableArrayPointer(array) { mutablePointer in
		return lambda(UnsafePointer(mutablePointer))
	}
}

/// Given an optional array of Swift structs, convert it to an array of WGPU structs and call the lambda with the pointer to the WGPU array or nil if the array is nil.
public func withWGPUArrayPointer<E: GPUStruct, R>(_ array: [E]?, _ lambda: (UnsafePointer<E.WGPUType>?) -> R) -> R {
	if let array = array {
		return withWGPUArrayPointer(array) { (pointer: UnsafePointer<E.WGPUType>) in
			lambda(pointer)
		}
	}
	return lambda(nil)
}

public func withWGPUMutableArrayPointer<E: GPUStruct, R>(_ array: [E], _ lambda: (UnsafeMutablePointer<E.WGPUType>) -> R) -> R {
	var result: R!
	var wgpuArray = Array<E.WGPUType>()
	wgpuArray.reserveCapacity(array.count)

	func process(index: Int) -> R {
		if index >= array.count {
			return wgpuArray.withUnsafeMutableBufferPointer { buffer in
				return lambda(buffer.baseAddress!)
			}
		}
		return array[index].withWGPUStruct { wgpuStruct in
			wgpuArray.append(wgpuStruct)
			return process(index: index + 1)
		}
	}
	result = process(index: 0)
	return result
}

public func withWGPUMutableArrayPointer<E: GPUStruct, R>(_ array: [E]?, _ lambda: (UnsafeMutablePointer<E.WGPUType>?) -> R) -> R {
	if let array = array {
		return withWGPUMutableArrayPointer(array) { (pointer: UnsafeMutablePointer<E.WGPUType>) in
			lambda(pointer)
		}
	}
	return lambda(nil)
}

public func withWGPUArrayPointer<E: GPUSimpleStruct, R>(_ array: [E], _ lambda: (UnsafePointer<E.WGPUType>) -> R) -> R where E.WGPUType == E {
	precondition(!array.isEmpty, "withWGPUArrayPointer requires a non-empty array")
	return array.withUnsafeBufferPointer { buffer in
		return lambda(buffer.baseAddress!)
	}
}

public func withWGPUArrayPointer<E: GPUSimpleStruct, R>(_ array: [E]?, _ lambda: (UnsafePointer<E.WGPUType>?) -> R) -> R where E.WGPUType == E {
	if let array = array {
		return withWGPUArrayPointer(array, lambda)
	}
	return lambda(nil)
}

public func withWGPUArrayPointer<E: Numeric, R>(_ array: [E], _ lambda: (UnsafePointer<E>) -> R) -> R {
	return array.withUnsafeBufferPointer { buffer in
		return lambda(buffer.baseAddress!)
	}
}

public func withWGPUArrayPointer<E: Numeric, R>(_ array: [E]?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	if let array = array {
		return withWGPUArrayPointer(array) { (pointer: UnsafePointer<E>) in lambda(pointer) }
	}
	return lambda(nil)
}

public func withWGPUArrayPointer<E: RawRepresentable, R>(_ array: [E], _ lambda: (UnsafePointer<E>) -> R) -> R {
	precondition(!array.isEmpty, "withWGPUArrayPointer requires a non-empty array")
	return array.withUnsafeBufferPointer { buffer in
		return lambda(buffer.baseAddress!)
	}
}

public func withWGPUArrayPointer<E: RawRepresentable, R>(_ array: [E]?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	guard let array = array else {
		return lambda(nil)
	}
	return withWGPUArrayPointer(array, lambda)
}

// Tuples 7, 9, and 12 (used in color space conversion structures)
public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	var copy = tuple // Copy for mutability
	return withUnsafePointer(to: &copy) { tuplePointer in
		tuplePointer.withMemoryRebound(to: E.self, capacity: 7) { pointer in
			lambda(pointer)
		}
	}
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	var copy = tuple  // Copy for mutability
	return withUnsafePointer(to: &copy) { tuplePointer in
		tuplePointer.withMemoryRebound(to: E.self, capacity: 9) { pointer in
			lambda(pointer)
		}
	}
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	var copy = tuple  // Copy for mutability
	return withUnsafePointer(to: &copy) { tuplePointer in
		tuplePointer.withMemoryRebound(to: E.self, capacity: 12) { pointer in
			lambda(pointer)
		}
	}
}

// Optional tuples of the same arity
public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	if let tuple = tuple {
		return withWGPUArrayPointer(tuple) { (pointer: UnsafePointer<E>) in
			lambda(pointer)
		}
	}
	return lambda(nil)
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	if let tuple = tuple {
		return withWGPUArrayPointer(tuple) { (pointer: UnsafePointer<E>) in
			lambda(pointer)
		}
	}
	return lambda(nil)
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	if let tuple = tuple {
		return withWGPUArrayPointer(tuple) { (pointer: UnsafePointer<E>) in
			lambda(pointer)
		}
	}
	return lambda(nil)
}

extension UnsafePointer where Pointee: WGPUStruct {
	func wrapArrayWithCount<SType: GPUStructWrappable>(_ count: Int) -> [SType] where SType.WGPUType == Pointee {
		var structArray = Array<SType>()
		structArray.reserveCapacity(count)
		for i: Int in 0..<count {
			structArray.append(SType(wgpuStruct: self[i]))
		}
		return structArray
	}
}

extension UnsafePointer {
	func wrapArrayWithCount(_ count: Int) -> [Pointee] {
		var structArray = Array<Pointee>()
		structArray.reserveCapacity(count)
		for i in 0..<count {
			structArray.append(self[i])
		}
		return structArray
	}
}

extension UnsafePointer where Pointee: FloatingPoint {
	func wrapTuple7() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6])
	}

	func wrapTuple9() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8])
	}

	func wrapTuple12() -> (Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee, Pointee) {
		return (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11])
	}
}

extension UnsafePointer {
	/// Wrap an array of WGPU values, specified with a pointer, into a proper Swift array.
	func wrapWGPUArrayWithCount<T>(_ count: Int) -> [T] where Pointee == Optional<T> {
		var integerArray = Array<T>()
		integerArray.reserveCapacity(count)
		for i in 0..<count {
			integerArray.append(self[i]!)
		}
		return integerArray
	}
}

extension Array where Element: Numeric {
	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element>) -> R) -> R {
		precondition(!isEmpty, "unwrapWGPUArray requires a non-empty array")
		return self.withUnsafeBufferPointer { buffer in
			lambda(buffer.baseAddress!)
		}
	}
}

extension Array where Element: AnyObject {
	func unwrapWGPUObjectArray<R>(_ lambda: (UnsafePointer<Element?>?) -> R) -> R {
		if count == 0 {
			return lambda(nil)
		}
		var result: R!
		var optionalArray = Array<Element?>()
		optionalArray.reserveCapacity(count)

		func process(index: Int) -> R {
			if index >= count {
				return optionalArray.withUnsafeBufferPointer { buffer in
					let pointer = UnsafePointer(buffer.baseAddress!)
					return lambda(pointer)
				}
			}
			optionalArray.append(Optional(self[index]))
			return process(index: index + 1)
		}
		result = process(index: 0)
		return result
	}

	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element>) -> R) -> R {
		precondition(!isEmpty, "unwrapWGPUArray requires a non-empty array")
		return self.withUnsafeBufferPointer { buffer in
			lambda(buffer.baseAddress!)
		}
	}
}
