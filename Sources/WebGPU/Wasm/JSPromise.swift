// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

extension JSPromise {
	/// Resolves the promise and returns the fulfilled value, or throws if rejected.
	public func awaitValue() async throws(WebGPUJSError) -> JSValue {
		do {
			return try await withCheckedThrowingContinuation { continuation in
				_ = then(
					success: { value in
						print("awaitValue success")
						continuation.resume(returning: value)
						return .undefined
					},
					failure: { error in
						print("awaitValue failure")
						continuation.resume(throwing: WebGPUJSError.rejected(error))
						return .undefined
					}
				)
			}
		} catch let e as WebGPUJSError {
			print("awaitValue WebGPUJSError", e)
			throw e
		} catch {
			print("awaitValue unknown error")
			throw WebGPUJSError.rejected(JSValue.string(JSString("rejected")))
		}
	}
}

/// WebGPU JS bridge errors. Marked @unchecked Sendable for WASM (single-threaded JS); `rejected(JSValue)` holds non-Sendable JSValue.
public enum WebGPUJSError: Error, @unchecked Sendable {
	case rejected(JSValue)
	case missingGPU
	case invalidAdapter
	case invalidDevice
}
