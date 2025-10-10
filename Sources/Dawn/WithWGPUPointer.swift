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
		fatalError("Unimplemented withWGPUPointer")
	}

	// mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<WGPUType>) -> R) -> R {
	// 	fatalError("Unimplemented withWGPUMutablePointer")
	// }
}

public extension Optional where Wrapped: WithWGPUPointer {
	func withWGPUPointer<R>(_ lambda: (UnsafePointer<Wrapped.WGPUType>?) -> R) -> R {
		return self?.withWGPUPointer(lambda) ?? lambda(nil)
	}
	mutating func withWGPUMutablePointer<R>(_ lambda: (UnsafeMutablePointer<Wrapped.WGPUType>?) -> R) -> R {
		return self?.withWGPUMutablePointer(lambda) ?? lambda(nil)
	}
}

public func withWGPUArrayPointer<E: GPUStruct, R>(_ array: [E], _ lambda: (UnsafePointer<E.WGPUType>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: GPUStruct, R>(_ array: [E]?, _ lambda: (UnsafePointer<E.WGPUType>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUMutableArrayPointer<E: GPUStruct, R>(_ array: [E], _ lambda: (UnsafeMutablePointer<E.WGPUType>) -> R) -> R {
	fatalError("Unimplemented withWGPUMutableArrayPointer")
}

public func withWGPUMutableArrayPointer<E: GPUStruct, R>(_ array: [E]?, _ lambda: (UnsafeMutablePointer<E.WGPUType>?) -> R) -> R {
	fatalError("Unimplemented withWGPUMutableArrayPointer")
}

public func withWGPUArrayPointer<E: GPUSimpleStruct, R>(_ array: [E], _ lambda: (UnsafePointer<E.WGPUType>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: GPUSimpleStruct, R>(_ array: [E]?, _ lambda: (UnsafePointer<E.WGPUType>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ array: [E], _ lambda: (UnsafePointer<E>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ array: [E]?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: RawRepresentable, R>(_ array: [E], _ lambda: (UnsafePointer<E>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: RawRepresentable, R>(_ array: [E]?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E, E, E, E), _ lambda: (UnsafePointer<E>) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

public func withWGPUArrayPointer<E: Numeric, R>(_ tuple: (E, E, E, E, E, E, E, E, E, E, E, E)?, _ lambda: (UnsafePointer<E>?) -> R) -> R {
	fatalError("Unimplemented withWGPUArrayPointer")
}

extension UnsafePointer where Pointee: WGPUStruct {
	func wrapArrayWithCount<SType: GPUStructWrappable>(_ count: Int) -> [SType] where SType.WGPUType == Pointee {
		return Array.init(unsafeUninitializedCapacity: count) {
			(structArrayBuffer: inout UnsafeMutableBufferPointer<SType>, initializedCount: inout Int) in
			for i in 0..<count {
				structArrayBuffer[i] = SType(wgpuStruct: self[i])
			}
			initializedCount = count
		}
	}
}

extension UnsafePointer {
	func wrapArrayWithCount(_ count: Int) -> [Pointee] {
		return Array.init(unsafeUninitializedCapacity: count) {
			(structArrayBuffer: inout UnsafeMutableBufferPointer<Pointee>, initializedCount: inout Int) in
			for i in 0..<count {
				structArrayBuffer[i] = self[i]
			}
		}
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
		return Array.init(unsafeUninitializedCapacity: count) {
			(integerArrayBuffer: inout UnsafeMutableBufferPointer<T>, initializedCount: inout Int) in
			for i in 0..<count {
				integerArrayBuffer[i] = self[i]!
			}
			initializedCount = count
		}
	}
}

extension Array where Element: GPUStruct {
	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element.WGPUType>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}

	func unwrapWGPUArray<R>(_ lambda: (UnsafeMutablePointer<Element.WGPUType>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}
}

extension Array where Element: Numeric {
	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}
}

extension Array {
	func unwrapWGPUObjectArray<R>(_ lambda: (UnsafePointer<Element?>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUObjectArray")
	}

	func unwrapWGPUArray<R>(_ lambda: (UnsafePointer<Element>) -> R) -> R {
		fatalError("Unimplemented unwrapWGPUArray")
	}
}
