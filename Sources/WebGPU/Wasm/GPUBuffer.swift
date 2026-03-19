// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

// Holds WASM-allocated buffers from getConstMappedRange.
// The browser exposes mapped buffer data as a JS ArrayBuffer, which is a separate
// allocation from WASM linear memory. To return a valid raw pointer, we copy the
// data into WASM linear memory here and free it in unmap().
// A class (reference type) so that copies of the GPUBuffer struct share the same
// storage and unmap() on any copy frees the right allocations.
private final class MappedRangeStorage {
	var allocations: [UnsafeMutablePointer<UInt8>] = []
}

@JSClass
public struct GPUBuffer {
	private var _mappedRanges: MappedRangeStorage = .init()
	@JSGetter(jsName: "size") var _size: Int

	public var size: Int {
		get {
			return try! _size
		}
	}

	@JSGetter(jsName: "usage") var _usage: Int

	public var usage: Int {
		get {
			return try! _usage
		}
	}

	@JSGetter(jsName: "mapState") var _mapState: String

	public var mapState: GPUBufferMapState {
		get {
			let s = try! _mapState
			return GPUBufferMapState(rawValue: s) ?? .unmapped
		}
	}

	// @JSSetter macro requires `set` prefix, so we use `setLabel_` instead of `_setLabel`
	@JSSetter(jsName: "label") func setLabel_(_ value: String?) throws(JSException)

	public func setLabel(_ value: String?) {
		try! setLabel_(value)
	}

	@JSFunction(jsName: "destroy")
	func _destroy() throws(JSException)

	public func destroy() {
		try! _destroy()
	}

	@JSFunction(jsName: "mapAsync")
	func _mapAsync(_ mode: Int, _ offset: Int, _ size: Int) throws(JSException) -> JSObject

	@discardableResult
	public func mapAsync(mode: GPUMapMode, offset: Int, size: Int, callbackInfo: GPUBufferMapCallbackInfo) -> GPUFuture {
		let promise = JSPromise(unsafelyWrapping: try! _mapAsync(Int(mode.rawValue), offset, size))
		promise.then(
			success: { _ in
				callbackInfo.callback(.success, nil)
				return .undefined
			},
			failure: { _ in
				callbackInfo.callback(.error, "mapAsync failed")
				return .undefined
			}
		)
		return GPUFuture()
	}

	@JSFunction(jsName: "getMappedRange")
	func _getMappedRange(_ offset: Int, _ size: Int) throws(JSException) -> JSObject

	public func getConstMappedRange(offset: Int, size: Int) -> UnsafeRawPointer? {
		guard let arrayBuffer = try? _getMappedRange(offset, size) else { return nil }
		let uint8Array = JSObject.global.Uint8Array.function!.new(arrayBuffer)
		let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
		for i in 0..<size {
			if let val = uint8Array[i].number {
				ptr[i] = UInt8(val)
			}
		}
		_mappedRanges.allocations.append(ptr)
		return UnsafeRawPointer(ptr)
	}

	// On WASM, there is no stable pointer into JS ArrayBuffer memory, so a mutable raw pointer
	// cannot be returned. Use writeMappedRange to write data into a mapped buffer instead.
	public func getMappedRange(offset: Int, size: Int) -> UnsafeMutableRawPointer? { return nil }

	@discardableResult
	public func readMappedRange(offset: Int, data: UnsafeMutableRawPointer, size: Int) -> GPUStatus {
		guard let arrayBuffer = try? _getMappedRange(offset, size) else { return .error }
		let uint8Array = JSObject.global.Uint8Array.function!.new(arrayBuffer)
		let dest = data.assumingMemoryBound(to: UInt8.self)
		for i in 0..<size {
			if let val = uint8Array[i].number {
				dest[i] = UInt8(val)
			}
		}
		return .success
	}

	@discardableResult
	public func writeMappedRange(offset: Int, data: UnsafeRawBufferPointer) -> GPUStatus {
		guard let arrayBuffer = try? _getMappedRange(offset, data.count) else { return .error }
		let uint8Array = JSObject.global.Uint8Array.function!.new(arrayBuffer)
		for i in 0..<data.count {
			let byte = data.load(fromByteOffset: i, as: UInt8.self)
			uint8Array[i] = .number(Double(byte))
		}
		return .success
	}

	@JSFunction(jsName: "unmap")
	func _unmap() throws(JSException)

	public func unmap() {
		for ptr in _mappedRanges.allocations { ptr.deallocate() }
		_mappedRanges.allocations.removeAll()
		try! _unmap()
	}
}
