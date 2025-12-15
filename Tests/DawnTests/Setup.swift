import Dawn

/// Initialize a GPU adapter and device for testing purposes.
/// Returns a tuple containing the instance, adapter, and device.
@MainActor
public func setupGPU() -> (GPUInstance, GPUAdapter, GPUDevice) {
	let instance = GPUInstance(descriptor: nil)!

	var adapter: GPUAdapter? = nil

	_ = instance.requestAdapter(
		options: nil,
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
