// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JSClass
public struct GPUBuffer {
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
		let modeVal = mode == .read ? 1 : 2
		let promise = JSPromise(unsafelyWrapping: try! _mapAsync(modeVal, offset, size))
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

	// Reading from a mapped GPUBuffer is not yet implemented on WASM.
	// TODO: Implement read-back (e.g. allocate WASM heap, copy ArrayBuffer bytes, free on unmap).
	public func getMappedRange(offset: Int, size: Int) -> UnsafeMutableRawPointer? { return nil }
	public func getConstMappedRange(offset: Int, size: Int) -> UnsafeRawPointer? { return nil }

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
		try! _unmap()
	}
}
