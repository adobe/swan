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
	var mutableProvider = provider
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

	let deviceDescriptor = GPUDeviceDescriptor(
		defaultQueue: GPUQueueDescriptor(),
		deviceLostCallbackInfo: .init(
			mode: .allowProcessEvents,
			callback: { device, reason, message in
				print("🚨 Device Lost!")
				print("  Reason: \(reason)")
				if let message = message {
					print("  Message: \(message)")
				}
			}
		),
		uncapturedErrorCallbackInfo: .init(
			callback: { device, type, message in
				print("❌ Uncaptured Error!")
				print("  Type: \(type)")
				if let message = message {
					print("  Message: \(message)")
				}
				fatalError("Terminating due to uncaptured error")
			}
		)
	)

	_ = adapter!.requestDevice(
		descriptor: deviceDescriptor,
		callbackInfo: .init(
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

	let surface = getSurface(window: window, instance: instance)
	surface.configure(config: .init(device: device!, format: format, width: UInt32(width), height: UInt32(height)))

	mutableProvider.initialize(device: device!, format: format, surface: surface)

	while RGFW_window_shouldClose(window) == RGFW_FALSE {
		RGFW_pollEvents()

		updateSurface(surface: surface, window: window, device: device!, format: format)

		let shouldContinue = try mutableProvider.frame(time: Date().timeIntervalSinceReferenceDate)
		if !shouldContinue {
			break
		}
	}
}
