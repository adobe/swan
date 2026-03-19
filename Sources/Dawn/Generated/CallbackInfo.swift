extension WGPUBufferMapCallbackInfo: WGPUStruct {
}

public struct GPUBufferMapCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUBufferMapCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUBufferMapCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUBufferMapCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBufferMapCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUBufferMapCallback = {
				(
					_ status: WGPUMapAsyncStatus,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUBufferMapCallback
				callback(status, message)

			}
			var wgpuStruct = WGPUBufferMapCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUCompilationInfoCallbackInfo: WGPUStruct {
}

public struct GPUCompilationInfoCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUCompilationInfoCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUCompilationInfoCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUCompilationInfoCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCompilationInfoCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUCompilationInfoCallback = {
				(
					_ status: WGPUCompilationInfoRequestStatus,
					_ compilationInfo: UnsafePointer<WGPUCompilationInfo>?,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let compilationInfo = GPUCompilationInfo(wgpuStruct: compilationInfo!.pointee)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUCompilationInfoCallback
				callback(status, compilationInfo)

			}
			var wgpuStruct = WGPUCompilationInfoCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUCreateComputePipelineAsyncCallbackInfo: WGPUStruct {
}

public struct GPUCreateComputePipelineAsyncCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUCreateComputePipelineAsyncCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUCreateComputePipelineAsyncCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUCreateComputePipelineAsyncCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCreateComputePipelineAsyncCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUCreateComputePipelineAsyncCallback = {
				(
					_ status: WGPUCreatePipelineAsyncStatus,
					_ pipeline: GPUComputePipeline?,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUCreateComputePipelineAsyncCallback
				callback(status, pipeline, message)

			}
			var wgpuStruct = WGPUCreateComputePipelineAsyncCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUCreateRenderPipelineAsyncCallbackInfo: WGPUStruct {
}

public struct GPUCreateRenderPipelineAsyncCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUCreateRenderPipelineAsyncCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUCreateRenderPipelineAsyncCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUCreateRenderPipelineAsyncCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCreateRenderPipelineAsyncCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUCreateRenderPipelineAsyncCallback = {
				(
					_ status: WGPUCreatePipelineAsyncStatus,
					_ pipeline: GPURenderPipeline?,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUCreateRenderPipelineAsyncCallback
				callback(status, pipeline, message)

			}
			var wgpuStruct = WGPUCreateRenderPipelineAsyncCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUDeviceLostCallbackInfo: WGPUStruct {
}

public struct GPUDeviceLostCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUDeviceLostCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUDeviceLostCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUDeviceLostCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDeviceLostCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUDeviceLostCallback = {
				(
					_ device: UnsafePointer<GPUDevice?>?,
					_ reason: WGPUDeviceLostReason,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let device = device
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUDeviceLostCallback
				callback(device, reason, message)

			}
			var wgpuStruct = WGPUDeviceLostCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPULoggingCallbackInfo: WGPUStruct {
}

public struct GPULoggingCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPULoggingCallbackInfo

	public let callback: GPULoggingCallback

	public init(callback: @escaping GPULoggingCallback) {

		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPULoggingCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPULoggingCallback = {
				(
					_ type: WGPULoggingType,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPULoggingCallback
				callback(type, message)

			}
			var wgpuStruct = WGPULoggingCallbackInfo(
				nextInChain: nil,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUPopErrorScopeCallbackInfo: WGPUStruct {
}

public struct GPUPopErrorScopeCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUPopErrorScopeCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUPopErrorScopeCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUPopErrorScopeCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPopErrorScopeCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUPopErrorScopeCallback = {
				(
					_ status: WGPUPopErrorScopeStatus,
					_ type: WGPUErrorType,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUPopErrorScopeCallback
				callback(status, type, message)

			}
			var wgpuStruct = WGPUPopErrorScopeCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUQueueWorkDoneCallbackInfo: WGPUStruct {
}

public struct GPUQueueWorkDoneCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUQueueWorkDoneCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPUQueueWorkDoneCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPUQueueWorkDoneCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUQueueWorkDoneCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUQueueWorkDoneCallback = {
				(
					_ status: WGPUQueueWorkDoneStatus,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUQueueWorkDoneCallback
				callback(status, message)

			}
			var wgpuStruct = WGPUQueueWorkDoneCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPURequestAdapterCallbackInfo: WGPUStruct {
}

public struct GPURequestAdapterCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPURequestAdapterCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPURequestAdapterCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPURequestAdapterCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestAdapterCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPURequestAdapterCallback = {
				(
					_ status: WGPURequestAdapterStatus,
					_ adapter: GPUAdapter?,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPURequestAdapterCallback
				callback(status, adapter, message)

			}
			var wgpuStruct = WGPURequestAdapterCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPURequestDeviceCallbackInfo: WGPUStruct {
}

public struct GPURequestDeviceCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPURequestDeviceCallbackInfo

	public let mode: GPUCallbackMode
	public let callback: GPURequestDeviceCallback

	public init(mode: GPUCallbackMode = .waitAnyOnly, callback: @escaping GPURequestDeviceCallback) {
		self.mode = mode
		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestDeviceCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPURequestDeviceCallback = {
				(
					_ status: WGPURequestDeviceStatus,
					_ device: GPUDevice?,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPURequestDeviceCallback
				callback(status, device, message)

			}
			var wgpuStruct = WGPURequestDeviceCallbackInfo(
				nextInChain: nil,
				mode: mode,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}

extension WGPUUncapturedErrorCallbackInfo: WGPUStruct {
}

public struct GPUUncapturedErrorCallbackInfo: GPUStruct {
	public typealias WGPUType = WGPUUncapturedErrorCallbackInfo

	public let callback: GPUUncapturedErrorCallback

	public init(callback: @escaping GPUUncapturedErrorCallback) {

		self.callback = callback
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUUncapturedErrorCallbackInfo) -> R
	) -> R {
		{
			let wgpuCallback: WGPUUncapturedErrorCallback = {
				(
					_ device: UnsafePointer<GPUDevice?>?,
					_ type: WGPUErrorType,
					_ message: WGPUStringView,
					_ userdata1: UnsafeMutableRawPointer?,
					_ userdata2: UnsafeMutableRawPointer?
				) in
				let device = device
				let message = String(wgpuStringView: message)
				assert(userdata1 != nil)
				let unmanagedCallback = Unmanaged<AnyObject>.fromOpaque(userdata1!)
				let callback = unmanagedCallback.takeUnretainedValue() as! GPUUncapturedErrorCallback
				callback(device, type, message)
				unmanagedCallback.release()
			}
			var wgpuStruct = WGPUUncapturedErrorCallbackInfo(
				nextInChain: nil,
				callback: wgpuCallback,
				userdata1: Unmanaged.passRetained(callback as AnyObject).toOpaque(),
				userdata2: nil
			)
			return lambda(&wgpuStruct)
		}()
	}
}
