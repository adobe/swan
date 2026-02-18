import Foundation
import RGFW
import WebGPU

public protocol DemoProvider {
	@MainActor
	mutating func initialize(device: GPUDevice, format: GPUTextureFormat, surface: GPUSurface)
	@MainActor
	mutating func frame(time: Double) throws -> Bool
}

@MainActor
public func runDemo<Provider: DemoProvider>(
	x: Int32 = 0,
	y: Int32 = 0,
	width: Int32 = 800,
	height: Int32 = 600,
	title: String,
	format: GPUTextureFormat = .BGRA8Unorm,
	provider: Provider
) throws {
	var mutableProvider: Provider = provider
	let instance: GPUInstance = GPUInstance(descriptor: nil)!

	var adapter: GPUAdapter? = nil

	_ = instance.requestAdapter(
		options: adapterOptions(),
		callbackInfo: GPURequestAdapterCallbackInfo(
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

	let limits = adapter!.getLimits();
	print ( limits );
	let info = adapter!.getInfo();
	print ( info );

	var device: GPUDevice? = nil

	var deviceDescriptor: GPUDeviceDescriptor = GPUDeviceDescriptor(
		requiredFeatures: [.shaderF16],
		requiredLimits: nil,
		defaultQueue: GPUQueueDescriptor(),
		deviceLostCallbackInfo: GPUDeviceLostCallbackInfo(
			mode: .allowProcessEvents,
			callback: { device, reason, message in
				print("Device Lost!")
				print("  Reason: \(reason)")
				if let message = message {
					print("  Message: \(message)")
				}
			}
		),
		uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo(
			callback: { device, type, message in
				print("Uncaptured Error!")
				print("  Type: \(type)")
				if let message = message {
					print("  Message: \(message)")
				}
				fatalError("Terminating due to uncaptured error")
			}
		)
	)

	deviceDescriptor.nextInChain = DawnTogglesDescriptor(
		enabledToggles: ["disable_symbol_renaming"],
		disabledToggles: []
	)

	_ = adapter!.requestDevice(
		descriptor: deviceDescriptor,
		callbackInfo: GPURequestDeviceCallbackInfo(
			mode: .allowProcessEvents,
			callback: { status, inDevice, message in
				guard inDevice != nil else { fatalError("Failed to get device") }
				device = inDevice;
			}
		)
	)

	while (device == nil) {
		instance.processEvents()
	}

	let window: OpaquePointer? = RGFW_createWindow(title, x, y, width, height, WindowFlags(0))
	RGFW_window_setExitKey(window, UInt8(RGFW_escape));

	defer { RGFW_window_close(window) }

	guard let window = window else {
		fatalError("Failed to create window")
	}

	let surface: GPUSurface = getSurface(window: window, instance: instance)
	surface.configure(config: GPUSurfaceConfiguration(device: device!, format: format, width: UInt32(width), height: UInt32(height)))

	mutableProvider.initialize(device: device!, format: format, surface: surface)

	while RGFW_window_shouldClose(window) == RGFW_FALSE {
		RGFW_pollEvents()
		instance.processEvents();  // very important to process webgpu async events per frame

		updateSurface(surface: surface, window: window, device: device!, format: format)

		let shouldContinue: Bool = try mutableProvider.frame(time: Date().timeIntervalSinceReferenceDate)
		if !shouldContinue {
			break
		}
	}
}
