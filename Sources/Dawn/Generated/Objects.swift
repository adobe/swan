public typealias GPUAdapter = WGPUAdapter

extension GPUAdapter {
	public func getLimits(limits: inout GPULimits) -> GPUStatus {
		return limits.withWGPUMutablePointer { limits in
			getLimits(limits: limits)
		}
	}

	public func getInfo(info: inout GPUAdapterInfo) -> GPUStatus {
		return info.withWGPUMutablePointer { info in
			getInfo(info: info)
		}
	}

	public func hasFeature(feature: GPUFeatureName) -> Bool {
		let result: WGPUBool = hasFeature(feature: feature)
		return Bool(result != 0)
	}

	public func getFeatures(features: inout GPUSupportedFeatures) -> Void {
		features.withWGPUMutablePointer { features in
			getFeatures(features: features)
		}
	}

	public func requestDevice(descriptor: GPUDeviceDescriptor?, callbackInfo: GPURequestDeviceCallbackInfo) -> GPUFuture {
		return descriptor.withWGPUPointer { descriptor in
			callbackInfo.withWGPUStruct { callbackInfo in
				return requestDevice(descriptor: descriptor, callbackInfo: callbackInfo)
			}
		}
	}

	public func createDevice(descriptor: GPUDeviceDescriptor?) -> GPUDevice {
		return descriptor.withWGPUPointer { descriptor in
			createDevice(descriptor: descriptor)
		}
	}

	public func getFormatCapabilities(format: GPUTextureFormat, capabilities: inout DawnFormatCapabilities) -> GPUStatus {
		return capabilities.withWGPUMutablePointer { capabilities in
			getFormatCapabilities(format: format, capabilities: capabilities)
		}
	}

}

public typealias GPUBindGroup = WGPUBindGroup

extension GPUBindGroup {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUBindGroupLayout = WGPUBindGroupLayout

extension GPUBindGroupLayout {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUBuffer = WGPUBuffer

extension GPUBuffer {
	public func mapAsync(mode: GPUMapMode, offset: Int, size: Int, callbackInfo: GPUBufferMapCallbackInfo) -> GPUFuture {
		return callbackInfo.withWGPUStruct { callbackInfo in
			return mapAsync(mode: mode, offset: offset, size: size, callbackInfo: callbackInfo)
		}
	}

	public func writeMappedRange(offset: Int, data: UnsafeRawBufferPointer) -> GPUStatus {
		let size = data.count
		let data = data.baseAddress
		return writeMappedRange(offset: offset, data: data, size: size)
	}

	public func createTexelView(descriptor: GPUTexelBufferViewDescriptor) -> GPUTexelBufferView {
		return descriptor.withWGPUPointer { descriptor in
			createTexelView(descriptor: descriptor)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUCommandBuffer = WGPUCommandBuffer

extension GPUCommandBuffer {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUCommandEncoder = WGPUCommandEncoder

extension GPUCommandEncoder {
	public func finish(descriptor: GPUCommandBufferDescriptor?) -> GPUCommandBuffer {
		return descriptor.withWGPUPointer { descriptor in
			finish(descriptor: descriptor)
		}
	}

	public func beginComputePass(descriptor: GPUComputePassDescriptor?) -> GPUComputePassEncoder {
		return descriptor.withWGPUPointer { descriptor in
			beginComputePass(descriptor: descriptor)
		}
	}

	public func beginRenderPass(descriptor: GPURenderPassDescriptor) -> GPURenderPassEncoder {
		return descriptor.withWGPUPointer { descriptor in
			beginRenderPass(descriptor: descriptor)
		}
	}

	public func copyBufferToTexture(source: GPUTexelCopyBufferInfo, destination: GPUTexelCopyTextureInfo, copySize: GPUExtent3D) -> Void
	{
		source.withWGPUPointer() { source in
			destination.withWGPUPointer() { destination in
				copySize.withWGPUPointer() { copySize in
					copyBufferToTexture(source: source, destination: destination, copySize: copySize)
				}
			}
		}
	}

	public func copyTextureToBuffer(source: GPUTexelCopyTextureInfo, destination: GPUTexelCopyBufferInfo, copySize: GPUExtent3D) -> Void
	{
		source.withWGPUPointer() { source in
			destination.withWGPUPointer() { destination in
				copySize.withWGPUPointer() { copySize in
					copyTextureToBuffer(source: source, destination: destination, copySize: copySize)
				}
			}
		}
	}

	public func copyTextureToTexture(
		source: GPUTexelCopyTextureInfo,
		destination: GPUTexelCopyTextureInfo,
		copySize: GPUExtent3D
	) -> Void {
		source.withWGPUPointer() { source in
			destination.withWGPUPointer() { destination in
				copySize.withWGPUPointer() { copySize in
					copyTextureToTexture(source: source, destination: destination, copySize: copySize)
				}
			}
		}
	}

	public func injectValidationError(message: String) -> Void {
		message.withWGPUStruct { message in
			injectValidationError(message: message)
		}
	}

	public func insertDebugMarker(markerLabel: String) -> Void {
		markerLabel.withWGPUStruct { markerLabel in
			insertDebugMarker(markerLabel: markerLabel)
		}
	}

	public func pushDebugGroup(groupLabel: String) -> Void {
		groupLabel.withWGPUStruct { groupLabel in
			pushDebugGroup(groupLabel: groupLabel)
		}
	}

	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: [UInt8]?) -> Void {
		let size = UInt64(data?.count ?? 0)
		withWGPUArrayPointer(data) { data in
			writeBuffer(buffer: buffer, bufferOffset: bufferOffset, data: data, size: size)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUComputePassEncoder = WGPUComputePassEncoder

extension GPUComputePassEncoder {
	public func insertDebugMarker(markerLabel: String) -> Void {
		markerLabel.withWGPUStruct { markerLabel in
			insertDebugMarker(markerLabel: markerLabel)
		}
	}

	public func pushDebugGroup(groupLabel: String) -> Void {
		groupLabel.withWGPUStruct { groupLabel in
			pushDebugGroup(groupLabel: groupLabel)
		}
	}

	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup?, dynamicOffsets: [UInt32]?) -> Void {
		let dynamicOffsetCount = dynamicOffsets?.count ?? 0
		withWGPUArrayPointer(dynamicOffsets) { dynamicOffsets in
			setBindGroup(
				groupIndex: groupIndex,
				group: group,
				dynamicOffsetCount: dynamicOffsetCount,
				dynamicOffsets: dynamicOffsets
			)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func setImmediates(offset: UInt32, data: UnsafeRawBufferPointer) -> Void {
		let size = data.count
		let data = data.baseAddress
		setImmediates(offset: offset, data: data, size: size)
	}

}

public typealias GPUComputePipeline = WGPUComputePipeline

extension GPUComputePipeline {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUDevice = WGPUDevice

extension GPUDevice {
	public func createBindGroup(descriptor: GPUBindGroupDescriptor) -> GPUBindGroup {
		return descriptor.withWGPUPointer { descriptor in
			createBindGroup(descriptor: descriptor)
		}
	}

	public func createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor) -> GPUBindGroupLayout {
		return descriptor.withWGPUPointer { descriptor in
			createBindGroupLayout(descriptor: descriptor)
		}
	}

	public func createBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer? {
		return descriptor.withWGPUPointer { descriptor in
			createBuffer(descriptor: descriptor)
		}
	}

	public func createErrorBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer {
		return descriptor.withWGPUPointer { descriptor in
			createErrorBuffer(descriptor: descriptor)
		}
	}

	public func createCommandEncoder(descriptor: GPUCommandEncoderDescriptor?) -> GPUCommandEncoder {
		return descriptor.withWGPUPointer { descriptor in
			createCommandEncoder(descriptor: descriptor)
		}
	}

	public func createComputePipeline(descriptor: GPUComputePipelineDescriptor) -> GPUComputePipeline {
		return descriptor.withWGPUPointer { descriptor in
			createComputePipeline(descriptor: descriptor)
		}
	}

	public func createComputePipelineAsync(
		descriptor: GPUComputePipelineDescriptor,
		callbackInfo: GPUCreateComputePipelineAsyncCallbackInfo
	) -> GPUFuture {
		return descriptor.withWGPUPointer { descriptor in
			callbackInfo.withWGPUStruct { callbackInfo in
				return createComputePipelineAsync(descriptor: descriptor, callbackInfo: callbackInfo)
			}
		}
	}

	public func createExternalTexture(externalTextureDescriptor: GPUExternalTextureDescriptor) -> GPUExternalTexture {
		return externalTextureDescriptor.withWGPUPointer { externalTextureDescriptor in
			createExternalTexture(externalTextureDescriptor: externalTextureDescriptor)
		}
	}

	public func createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor) -> GPUPipelineLayout {
		return descriptor.withWGPUPointer { descriptor in
			createPipelineLayout(descriptor: descriptor)
		}
	}

	public func createQuerySet(descriptor: GPUQuerySetDescriptor) -> GPUQuerySet {
		return descriptor.withWGPUPointer { descriptor in
			createQuerySet(descriptor: descriptor)
		}
	}

	public func createRenderPipelineAsync(
		descriptor: GPURenderPipelineDescriptor,
		callbackInfo: GPUCreateRenderPipelineAsyncCallbackInfo
	) -> GPUFuture {
		return descriptor.withWGPUPointer { descriptor in
			callbackInfo.withWGPUStruct { callbackInfo in
				return createRenderPipelineAsync(descriptor: descriptor, callbackInfo: callbackInfo)
			}
		}
	}

	public func createRenderBundleEncoder(descriptor: GPURenderBundleEncoderDescriptor) -> GPURenderBundleEncoder {
		return descriptor.withWGPUPointer { descriptor in
			createRenderBundleEncoder(descriptor: descriptor)
		}
	}

	public func createRenderPipeline(descriptor: GPURenderPipelineDescriptor) -> GPURenderPipeline {
		return descriptor.withWGPUPointer { descriptor in
			createRenderPipeline(descriptor: descriptor)
		}
	}

	public func createSampler(descriptor: GPUSamplerDescriptor?) -> GPUSampler {
		return descriptor.withWGPUPointer { descriptor in
			createSampler(descriptor: descriptor)
		}
	}

	public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
		return descriptor.withWGPUPointer { descriptor in
			createShaderModule(descriptor: descriptor)
		}
	}

	public func createErrorShaderModule(descriptor: GPUShaderModuleDescriptor, errorMessage: String) -> GPUShaderModule {
		return descriptor.withWGPUPointer { descriptor in
			errorMessage.withWGPUStruct { errorMessage in
				createErrorShaderModule(descriptor: descriptor, errorMessage: errorMessage)
			}
		}
	}

	public func createTexture(descriptor: GPUTextureDescriptor) -> GPUTexture {
		return descriptor.withWGPUPointer { descriptor in
			createTexture(descriptor: descriptor)
		}
	}

	public func createResourceTable(descriptor: GPUResourceTableDescriptor) -> GPUResourceTable {
		return descriptor.withWGPUPointer { descriptor in
			createResourceTable(descriptor: descriptor)
		}
	}

	public func importSharedBufferMemory(descriptor: GPUSharedBufferMemoryDescriptor) -> GPUSharedBufferMemory {
		return descriptor.withWGPUPointer { descriptor in
			importSharedBufferMemory(descriptor: descriptor)
		}
	}

	public func importSharedTextureMemory(descriptor: GPUSharedTextureMemoryDescriptor) -> GPUSharedTextureMemory {
		return descriptor.withWGPUPointer { descriptor in
			importSharedTextureMemory(descriptor: descriptor)
		}
	}

	public func importSharedFence(descriptor: GPUSharedFenceDescriptor) -> GPUSharedFence {
		return descriptor.withWGPUPointer { descriptor in
			importSharedFence(descriptor: descriptor)
		}
	}

	public func createErrorTexture(descriptor: GPUTextureDescriptor) -> GPUTexture {
		return descriptor.withWGPUPointer { descriptor in
			createErrorTexture(descriptor: descriptor)
		}
	}

	public func getAHardwareBufferProperties(
		handle: UnsafeMutableRawPointer?,
		properties: inout GPUAHardwareBufferProperties
	) -> GPUStatus {
		return properties.withWGPUMutablePointer { properties in
			getAHardwareBufferProperties(handle: handle, properties: properties)
		}
	}

	public func getLimits(limits: inout GPULimits) -> GPUStatus {
		return limits.withWGPUMutablePointer { limits in
			getLimits(limits: limits)
		}
	}

	public func hasFeature(feature: GPUFeatureName) -> Bool {
		let result: WGPUBool = hasFeature(feature: feature)
		return Bool(result != 0)
	}

	public func getFeatures(features: inout GPUSupportedFeatures) -> Void {
		features.withWGPUMutablePointer { features in
			getFeatures(features: features)
		}
	}

	public func getAdapterInfo(adapterInfo: inout GPUAdapterInfo) -> GPUStatus {
		return adapterInfo.withWGPUMutablePointer { adapterInfo in
			getAdapterInfo(adapterInfo: adapterInfo)
		}
	}

	public func injectError(type: GPUErrorType, message: String) -> Void {
		message.withWGPUStruct { message in
			injectError(type: type, message: message)
		}
	}

	public func forceLoss(type: GPUDeviceLostReason, message: String) -> Void {
		message.withWGPUStruct { message in
			forceLoss(type: type, message: message)
		}
	}

	public func setLoggingCallback(callbackInfo: GPULoggingCallbackInfo) -> Void {
		callbackInfo.withWGPUStruct { callbackInfo in
			return setLoggingCallback(callbackInfo: callbackInfo)
		}
	}

	public func popErrorScope(callbackInfo: GPUPopErrorScopeCallbackInfo) -> GPUFuture {
		return callbackInfo.withWGPUStruct { callbackInfo in
			return popErrorScope(callbackInfo: callbackInfo)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func validateTextureDescriptor(descriptor: GPUTextureDescriptor) -> Void {
		descriptor.withWGPUPointer { descriptor in
			validateTextureDescriptor(descriptor: descriptor)
		}
	}

}

public typealias GPUExternalTexture = WGPUExternalTexture

extension GPUExternalTexture {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUInstance = WGPUInstance

extension GPUInstance {
	public func createSurface(descriptor: GPUSurfaceDescriptor) -> GPUSurface {
		return descriptor.withWGPUPointer { descriptor in
			createSurface(descriptor: descriptor)
		}
	}

	public func waitAny(futures: inout [GPUFutureWaitInfo]?, timeoutNS: UInt64) -> GPUWaitStatus {
		let futureCount = futures?.count ?? 0
		return withWGPUMutableArrayPointer(futures) { futures in
			waitAny(futureCount: futureCount, futures: futures, timeoutNS: timeoutNS)
		}
	}

	public func requestAdapter(options: GPURequestAdapterOptions?, callbackInfo: GPURequestAdapterCallbackInfo) -> GPUFuture {
		return options.withWGPUPointer { options in
			callbackInfo.withWGPUStruct { callbackInfo in
				return requestAdapter(options: options, callbackInfo: callbackInfo)
			}
		}
	}

	public func hasWGSLLanguageFeature(feature: GPUWGSLLanguageFeatureName) -> Bool {
		let result: WGPUBool = hasWGSLLanguageFeature(feature: feature)
		return Bool(result != 0)
	}

	public func getWGSLLanguageFeatures(features: inout GPUSupportedWGSLLanguageFeatures) -> Void {
		features.withWGPUMutablePointer { features in
			getWGSLLanguageFeatures(features: features)
		}
	}

}

public typealias GPUPipelineLayout = WGPUPipelineLayout

extension GPUPipelineLayout {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUQuerySet = WGPUQuerySet

extension GPUQuerySet {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUQueue = WGPUQueue

extension GPUQueue {
	public func submit(commands: [GPUCommandBuffer]) -> Void {
		let commandCount = commands.count
		commands.unwrapWGPUObjectArray { commands in
			submit(commandCount: commandCount, commands: commands)
		}
	}

	public func onSubmittedWorkDone(callbackInfo: GPUQueueWorkDoneCallbackInfo) -> GPUFuture {
		return callbackInfo.withWGPUStruct { callbackInfo in
			return onSubmittedWorkDone(callbackInfo: callbackInfo)
		}
	}

	public func writeBuffer(buffer: GPUBuffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) -> Void {
		let size = data.count
		let data = data.baseAddress
		writeBuffer(buffer: buffer, bufferOffset: bufferOffset, data: data, size: size)
	}

	public func writeTexture(
		destination: GPUTexelCopyTextureInfo,
		data: UnsafeRawBufferPointer,
		dataLayout: GPUTexelCopyBufferLayout,
		writeSize: GPUExtent3D
	) -> Void {
		let dataSize = data.count
		let data = data.baseAddress
		destination.withWGPUPointer() { destination in
			dataLayout.withWGPUPointer() { dataLayout in
				writeSize.withWGPUPointer() { writeSize in
					writeTexture(
						destination: destination,
						data: data,
						dataSize: dataSize,
						dataLayout: dataLayout,
						writeSize: writeSize
					)
				}
			}
		}
	}

	public func copyTextureForBrowser(
		source: GPUTexelCopyTextureInfo,
		destination: GPUTexelCopyTextureInfo,
		copySize: GPUExtent3D,
		options: GPUCopyTextureForBrowserOptions
	) -> Void {
		source.withWGPUPointer() { source in
			destination.withWGPUPointer() { destination in
				copySize.withWGPUPointer() { copySize in
					options.withWGPUPointer { options in
						copyTextureForBrowser(
							source: source,
							destination: destination,
							copySize: copySize,
							options: options
						)
					}
				}
			}
		}
	}

	public func copyExternalTextureForBrowser(
		source: GPUImageCopyExternalTexture,
		destination: GPUTexelCopyTextureInfo,
		copySize: GPUExtent3D,
		options: GPUCopyTextureForBrowserOptions
	) -> Void {
		source.withWGPUPointer { source in
			destination.withWGPUPointer() { destination in
				copySize.withWGPUPointer() { copySize in
					options.withWGPUPointer { options in
						copyExternalTextureForBrowser(
							source: source,
							destination: destination,
							copySize: copySize,
							options: options
						)
					}
				}
			}
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPURenderBundle = WGPURenderBundle

extension GPURenderBundle {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPURenderBundleEncoder = WGPURenderBundleEncoder

extension GPURenderBundleEncoder {
	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup?, dynamicOffsets: [UInt32]?) -> Void {
		let dynamicOffsetCount = dynamicOffsets?.count ?? 0
		withWGPUArrayPointer(dynamicOffsets) { dynamicOffsets in
			setBindGroup(
				groupIndex: groupIndex,
				group: group,
				dynamicOffsetCount: dynamicOffsetCount,
				dynamicOffsets: dynamicOffsets
			)
		}
	}

	public func insertDebugMarker(markerLabel: String) -> Void {
		markerLabel.withWGPUStruct { markerLabel in
			insertDebugMarker(markerLabel: markerLabel)
		}
	}

	public func pushDebugGroup(groupLabel: String) -> Void {
		groupLabel.withWGPUStruct { groupLabel in
			pushDebugGroup(groupLabel: groupLabel)
		}
	}

	public func finish(descriptor: GPURenderBundleDescriptor?) -> GPURenderBundle {
		return descriptor.withWGPUPointer { descriptor in
			finish(descriptor: descriptor)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func setImmediates(offset: UInt32, data: UnsafeRawBufferPointer) -> Void {
		let size = data.count
		let data = data.baseAddress
		setImmediates(offset: offset, data: data, size: size)
	}

}

public typealias GPURenderPassEncoder = WGPURenderPassEncoder

extension GPURenderPassEncoder {
	public func setBindGroup(groupIndex: UInt32, group: GPUBindGroup?, dynamicOffsets: [UInt32]?) -> Void {
		let dynamicOffsetCount = dynamicOffsets?.count ?? 0
		withWGPUArrayPointer(dynamicOffsets) { dynamicOffsets in
			setBindGroup(
				groupIndex: groupIndex,
				group: group,
				dynamicOffsetCount: dynamicOffsetCount,
				dynamicOffsets: dynamicOffsets
			)
		}
	}

	public func executeBundles(bundles: [GPURenderBundle]) -> Void {
		let bundleCount = bundles.count
		bundles.unwrapWGPUObjectArray { bundles in
			executeBundles(bundleCount: bundleCount, bundles: bundles)
		}
	}

	public func insertDebugMarker(markerLabel: String) -> Void {
		markerLabel.withWGPUStruct { markerLabel in
			insertDebugMarker(markerLabel: markerLabel)
		}
	}

	public func pushDebugGroup(groupLabel: String) -> Void {
		groupLabel.withWGPUStruct { groupLabel in
			pushDebugGroup(groupLabel: groupLabel)
		}
	}

	public func setBlendConstant(color: GPUColor) -> Void {
		color.withWGPUPointer() { color in
			setBlendConstant(color: color)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func setImmediates(offset: UInt32, data: UnsafeRawBufferPointer) -> Void {
		let size = data.count
		let data = data.baseAddress
		setImmediates(offset: offset, data: data, size: size)
	}

}

public typealias GPURenderPipeline = WGPURenderPipeline

extension GPURenderPipeline {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUResourceTable = WGPUResourceTable

extension GPUResourceTable {
	public func update(slot: UInt32, resource: GPUBindingResource) -> GPUStatus {
		return resource.withWGPUPointer { resource in
			update(slot: slot, resource: resource)
		}
	}

	public func insertBinding(resource: GPUBindingResource) -> UInt32 {
		return resource.withWGPUPointer { resource in
			insertBinding(resource: resource)
		}
	}

}

public typealias GPUSampler = WGPUSampler

extension GPUSampler {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUShaderModule = WGPUShaderModule

extension GPUShaderModule {
	public func getCompilationInfo(callbackInfo: GPUCompilationInfoCallbackInfo) -> GPUFuture {
		return callbackInfo.withWGPUStruct { callbackInfo in
			return getCompilationInfo(callbackInfo: callbackInfo)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUSharedBufferMemory = WGPUSharedBufferMemory

extension GPUSharedBufferMemory {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func getProperties(properties: inout GPUSharedBufferMemoryProperties) -> GPUStatus {
		return properties.withWGPUMutablePointer { properties in
			getProperties(properties: properties)
		}
	}

	public func createBuffer(descriptor: GPUBufferDescriptor?) -> GPUBuffer {
		return descriptor.withWGPUPointer { descriptor in
			createBuffer(descriptor: descriptor)
		}
	}

	public func beginAccess(buffer: GPUBuffer, descriptor: GPUSharedBufferMemoryBeginAccessDescriptor) -> GPUStatus {
		return descriptor.withWGPUPointer { descriptor in
			beginAccess(buffer: buffer, descriptor: descriptor)
		}
	}

	public func endAccess(buffer: GPUBuffer, descriptor: inout GPUSharedBufferMemoryEndAccessState) -> GPUStatus {
		return descriptor.withWGPUMutablePointer { descriptor in
			endAccess(buffer: buffer, descriptor: descriptor)
		}
	}

	public func isDeviceLost() -> Bool {
		let result: WGPUBool = isDeviceLost()
		return Bool(result != 0)
	}

}

public typealias GPUSharedFence = WGPUSharedFence

extension GPUSharedFence {
	public func exportInfo(info: inout GPUSharedFenceExportInfo) -> Void {
		info.withWGPUMutablePointer { info in
			exportInfo(info: info)
		}
	}

}

public typealias GPUSharedTextureMemory = WGPUSharedTextureMemory

extension GPUSharedTextureMemory {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

	public func getProperties(properties: inout GPUSharedTextureMemoryProperties) -> GPUStatus {
		return properties.withWGPUMutablePointer { properties in
			getProperties(properties: properties)
		}
	}

	public func createTexture(descriptor: GPUTextureDescriptor?) -> GPUTexture {
		return descriptor.withWGPUPointer { descriptor in
			createTexture(descriptor: descriptor)
		}
	}

	public func beginAccess(texture: GPUTexture, descriptor: GPUSharedTextureMemoryBeginAccessDescriptor) -> GPUStatus {
		return descriptor.withWGPUPointer { descriptor in
			beginAccess(texture: texture, descriptor: descriptor)
		}
	}

	public func endAccess(texture: GPUTexture, descriptor: inout GPUSharedTextureMemoryEndAccessState) -> GPUStatus {
		return descriptor.withWGPUMutablePointer { descriptor in
			endAccess(texture: texture, descriptor: descriptor)
		}
	}

	public func isDeviceLost() -> Bool {
		let result: WGPUBool = isDeviceLost()
		return Bool(result != 0)
	}

}

public typealias GPUSurface = WGPUSurface

extension GPUSurface {
	public func configure(config: GPUSurfaceConfiguration) -> Void {
		config.withWGPUPointer { config in
			configure(config: config)
		}
	}

	public func getCapabilities(adapter: GPUAdapter, capabilities: inout GPUSurfaceCapabilities) -> GPUStatus {
		return capabilities.withWGPUMutablePointer { capabilities in
			getCapabilities(adapter: adapter, capabilities: capabilities)
		}
	}

	public func getCurrentTexture(surfaceTexture: inout GPUSurfaceTexture) -> Void {
		surfaceTexture.withWGPUMutablePointer { surfaceTexture in
			getCurrentTexture(surfaceTexture: surfaceTexture)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUTexelBufferView = WGPUTexelBufferView

extension GPUTexelBufferView {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUTexture = WGPUTexture

extension GPUTexture {
	public func createView(descriptor: GPUTextureViewDescriptor?) -> GPUTextureView {
		return descriptor.withWGPUPointer { descriptor in
			createView(descriptor: descriptor)
		}
	}

	public func createErrorView(descriptor: GPUTextureViewDescriptor?) -> GPUTextureView {
		return descriptor.withWGPUPointer { descriptor in
			createErrorView(descriptor: descriptor)
		}
	}

	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}

public typealias GPUTextureView = WGPUTextureView

extension GPUTextureView {
	public func setLabel(label: String) -> Void {
		label.withWGPUStruct { label in
			setLabel(label: label)
		}
	}

}
