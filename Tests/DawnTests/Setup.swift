import Dawn

/// Initialize a GPU adapter and device for testing purposes.
/// Returns a tuple containing the instance, adapter, and device.
@MainActor
public func setupGPU() -> (GPUInstance, GPUAdapter, GPUDevice) {
	let instance = GPUInstance(descriptor: nil)!

	var adapter: GPUAdapter? = nil

	#if os(Windows)
	let options = GPURequestAdapterOptions(backendType: .D3D12)
	#else
	let options: GPURequestAdapterOptions? = nil
	#endif

	_ = instance.requestAdapter(
		options: options,
		callbackInfo: .init(
			mode: .allowProcessEvents,
			callback: { status, inAdapter, message in
				guard inAdapter != nil else { fatalError("Failed to get adapter") }
				adapter = inAdapter
			}
		)
	)

	while adapter == nil {
		instance.processEvents()
	}

	var device: GPUDevice? = nil

	_ = adapter!.requestDevice(
		descriptor: nil,
		callbackInfo: .init(
			mode: .allowProcessEvents,
			callback: { status, inDevice, message in
				guard inDevice != nil else { fatalError("Failed to get device") }
				device = inDevice
			}
		)
	)

	while device == nil {
		instance.processEvents()
	}

	return (instance, adapter!, device!)
}
