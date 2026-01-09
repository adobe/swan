#if canImport(AppKit)
import AppKit
import RGFW
import WebGPU

@MainActor
func getSurface(window: OpaquePointer, instance: GPUInstance) -> GPUSurface {

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

	return instance.createSurface(descriptor: surfaceDescriptor)
}

@MainActor
func updateSurface(surface: GPUSurface, window: OpaquePointer, device: GPUDevice, format: GPUTextureFormat) {
	let viewPointer = RGFW_window_getView_OSX(window)
	guard let viewPointer else {
		fatalError("Failed to get view")
	}

	var w: Int32 = 0
	var h: Int32 = 0
	RGFW_window_getSize(window, &w, &h)

	let view = Unmanaged<NSView>.fromOpaque(viewPointer).takeUnretainedValue()
	let layer = view.layer as! CAMetalLayer
	layer.drawableSize = CGSize(width: CGFloat(w), height: CGFloat(h))

	surface.configure(config: .init(device: device, format: format, width: UInt32(w), height: UInt32(h)))
}
#endif
