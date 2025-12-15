import AppKit
import RGFW
import WebGPU

@MainActor
public func runDemo(
	x: Int32 = 0,
	y: Int32 = 0,
	width: Int32 = 800,
	height: Int32 = 600,
	title: String,
	format: GPUTextureFormat = .BGRA8Unorm,
	_ lambda: (GPUSurface, GPUDevice, (() throws -> Void) throws -> Void, GPUTextureFormat) throws -> Void
) rethrows {
	let instance = GPUInstance(descriptor: nil)!

	var adapter: GPUAdapter? = nil;

	_ = instance.requestAdapter(
		options: nil,
		callbackInfo: .init(
			mode: .allowProcessEvents,
			callback: { status, inAdapter, message in
				guard inAdapter != nil else { fatalError("Failed to get adapter") }
				adapter = inAdapter;
			}
		)
	);

	while (adapter == nil) {
		instance.processEvents()
	}

	var device: GPUDevice? = nil;

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

	let metalDevice = MTLCreateSystemDefaultDevice()
	guard let metalDevice else {
		fatalError("Failed to create device")
	}

	let layer = CAMetalLayer()
	layer.device = metalDevice
	layer.pixelFormat = .bgra8Unorm

	let viewPointer = RGFW_window_getView_OSX(window)
	guard let viewPointer else {
		fatalError("Failed to get view")
	}

	let view = Unmanaged<NSView>.fromOpaque(viewPointer).takeUnretainedValue()
	view.layer = layer

	var surfaceDescriptor = GPUSurfaceDescriptor()
	surfaceDescriptor.nextInChain = GPUSurfaceSourceMetalLayer(layer: Unmanaged.passUnretained(layer).toOpaque())

	let surface = instance.createSurface(descriptor: surfaceDescriptor)
	surface.configure(config: .init(device: device!, format: format, width: UInt32(width), height: UInt32(height)))

	try lambda(
		surface,
		device!,
		{ lambda in
			while RGFW_window_shouldClose(window) == RGFW_FALSE {
				RGFW_pollEvents()

				var w: Int32 = 0
				var h: Int32 = 0
				RGFW_window_getSize(window, &w, &h)

				layer.drawableSize = CGSize(width: CGFloat(w), height: CGFloat(h))

				surface.configure(config: .init(device: device!, format: format, width: UInt32(w), height: UInt32(h)))

				try lambda()
			}
		},
		format
	)
}
