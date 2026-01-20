#if os(Windows)
import RGFW
import WebGPU

@MainActor
func getSurface(window: OpaquePointer, instance: GPUInstance) -> GPUSurface {
	fatalError("DX12 surface creation not implemented")
}

@MainActor
func updateSurface(surface: GPUSurface, window: OpaquePointer, device: GPUDevice, format: GPUTextureFormat) {
	fatalError("DX12 surface update not implemented")
}
#endif
