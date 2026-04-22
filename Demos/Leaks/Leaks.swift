import WebGPU

public struct GPUContext {
	public private(set) var instance: GPUInstance
	public private(set) var adapter: GPUAdapter
	public private(set) var device: GPUDevice

	public enum InitError: Error {
		case adapterFailed
		case deviceFailed
	}

	public init() throws {
		self.instance = GPUInstance(descriptor: nil)!

		// Request adapter
		var adapterStatus: GPURequestAdapterStatus? = nil
		var adapter: GPUAdapter? = nil
		_ = instance.requestAdapter(
			options: GPURequestAdapterOptions(
				powerPreference: .highPerformance,
				backendType: .metal
			),
			callbackInfo: GPURequestAdapterCallbackInfo(
				mode: .allowProcessEvents,
				callback: { status, inAdapter, _ in
					adapter = inAdapter
					adapterStatus = status
				}
			)
		)
		while adapterStatus == nil { instance.processEvents() }
		guard adapterStatus == .success, let adapter else { throw InitError.adapterFailed }
		self.adapter = adapter

		// Request device with the adapter's full limits so large buffer allocations succeed
		var adapterLimits = GPULimits()
		_ = adapter.getLimits(limits: &adapterLimits)
		var deviceStatus: GPURequestDeviceStatus? = nil
		var device: GPUDevice? = nil
		_ = adapter.requestDevice(
			descriptor: GPUDeviceDescriptor(
				requiredLimits: adapterLimits,
				defaultQueue: GPUQueueDescriptor(),
				deviceLostCallbackInfo: GPUDeviceLostCallbackInfo(
					callback: { _, reason, _ in
						if reason.rawValue != 0x00000002 { // WGPUDeviceLostReason_Destroyed
							fatalError("Unexpected device lost")
						}
					}
				),
				uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo(
					callback: { _, errorType, message in
						fatalError("Uncaptured WebGPU error (\(errorType)): \(message ?? "")")
					}
				)
			),
			callbackInfo: GPURequestDeviceCallbackInfo(
				mode: .allowProcessEvents,
				callback: { status, inDevice, _ in
					device = inDevice
					deviceStatus = status
				}
			)
		)
		while deviceStatus == nil { instance.processEvents() }
		guard deviceStatus == .success, let device else { throw InitError.deviceFailed }
		self.device = device
	}
}

func allocateLargeBuffer(gpu: GPUContext) {
	let twoGB: UInt64 = 0x80000000
	let buffer = gpu.device.createBuffer(
		descriptor: GPUBufferDescriptor(
			label: "leak-test",
			usage: [.storage],
			size: twoGB,
			mappedAtCreation: false
		)
	)
	print("Allocated buffer of \(buffer?.size ?? 0) bytes")
}

// Failure modes by backend:
//   .D3D12:    crashes after ~17 iterations — D3D12CreateDevice fails (device limit exhausted)
//   .D3D11:    crashes after ~38 iterations — ID3D11Device::CreateBuffer fails (OOM)
//   .undefined: same as .D3D12 (D3D12 is the default on Windows)
for i in 1...10000 {
	print("Iteration \(i)")
	let gpu = try GPUContext()
	allocateLargeBuffer(gpu: gpu)
}

print("Completed all iterations — leak fixed.")