#if os(Windows)
import RGFW
import WebGPU

@MainActor
func getSurface(window: OpaquePointer, instance: GPUInstance) -> GPUSurface {
	let hwnd = RGFW_window_getHWND(window);
	let hinstance = win32_get_HINSTANCE_from_HWND(hwnd);
	let finalChainSurface = GPUSurfaceSourceWindowsHWND(hinstance: hinstance, hwnd: hwnd);
	var surfaceDescriptor = GPUSurfaceDescriptor();
	surfaceDescriptor.nextInChain = finalChainSurface;
	return instance.createSurface(descriptor: surfaceDescriptor);
}

@MainActor
func updateSurface(surface: GPUSurface, window: OpaquePointer, device: GPUDevice, format: GPUTextureFormat) {
	print("No surface update")
}

func adapterOptions() -> GPURequestAdapterOptions {
	return GPURequestAdapterOptions(backendType: .D3D12);
}

#endif
