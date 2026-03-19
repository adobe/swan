extension WGPUAHardwareBufferProperties: WGPUStruct {
}

public struct GPUAHardwareBufferProperties: GPUStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUAHardwareBufferProperties

	public var yCbCrInfo: GPUYCbCrVkDescriptor

	public init(yCbCrInfo: GPUYCbCrVkDescriptor) {
		self.yCbCrInfo = yCbCrInfo
	}

	public init(wgpuStruct: WGPUAHardwareBufferProperties) {
		self.yCbCrInfo = GPUYCbCrVkDescriptor(wgpuStruct: wgpuStruct.yCbCrInfo)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAHardwareBufferProperties) -> R
	) -> R {
		return yCbCrInfo.withWGPUStruct() { yCbCrInfo in
			{
				var wgpuStruct = WGPUAHardwareBufferProperties(yCbCrInfo: yCbCrInfo)
				return lambda(&wgpuStruct)
			}()
		}
	}
}

extension WGPUAdapterInfo: RootStruct {
}

public struct GPUAdapterInfo: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUAdapterInfo

	public var vendor: String
	public var architecture: String
	public var device: String
	public var description: String
	public var backendType: GPUBackendType
	public var adapterType: GPUAdapterType
	public var vendorID: UInt32
	public var deviceID: UInt32
	public var subgroupMinSize: UInt32
	public var subgroupMaxSize: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		vendor: String = "",
		architecture: String = "",
		device: String = "",
		description: String = "",
		backendType: GPUBackendType = .undefined,
		adapterType: GPUAdapterType = .discreteGPU,
		vendorID: UInt32 = 0,
		deviceID: UInt32 = 0,
		subgroupMinSize: UInt32 = 0,
		subgroupMaxSize: UInt32 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.vendor = vendor
		self.architecture = architecture
		self.device = device
		self.description = description
		self.backendType = backendType
		self.adapterType = adapterType
		self.vendorID = vendorID
		self.deviceID = deviceID
		self.subgroupMinSize = subgroupMinSize
		self.subgroupMaxSize = subgroupMaxSize
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUAdapterInfo) {
		self.vendor = String(wgpuStringView: wgpuStruct.vendor)
		self.architecture = String(wgpuStringView: wgpuStruct.architecture)
		self.device = String(wgpuStringView: wgpuStruct.device)
		self.description = String(wgpuStringView: wgpuStruct.description)
		self.backendType = wgpuStruct.backendType
		self.adapterType = wgpuStruct.adapterType
		self.vendorID = wgpuStruct.vendorID
		self.deviceID = wgpuStruct.deviceID
		self.subgroupMinSize = wgpuStruct.subgroupMinSize
		self.subgroupMaxSize = wgpuStruct.subgroupMaxSize
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterInfo) -> R
	) -> R {
		return vendor.withWGPUStruct { vendor in
			architecture.withWGPUStruct { architecture in
				device.withWGPUStruct { device in
					description.withWGPUStruct { description in
						withWGPUStructChain { pointer in
							var wgpuStruct = WGPUAdapterInfo(
								nextInChain: pointer,
								vendor: vendor,
								architecture: architecture,
								device: device,
								description: description,
								backendType: backendType,
								adapterType: adapterType,
								vendorID: vendorID,
								deviceID: deviceID,
								subgroupMinSize: subgroupMinSize,
								subgroupMaxSize: subgroupMaxSize
							)
							return lambda(&wgpuStruct)
						}
					}
				}
			}
		}
	}
}

extension WGPUAdapterPropertiesD3D: ChainedStruct {
}

public struct GPUAdapterPropertiesD3D: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesD3D
	public let sType: GPUSType = .adapterPropertiesD3D
	public var shaderModel: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(shaderModel: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.shaderModel = shaderModel
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesD3D) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUAdapterPropertiesD3D(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					shaderModel: shaderModel
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUAdapterPropertiesD3D(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						shaderModel: shaderModel
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUAdapterPropertiesWGPU: ChainedStruct {
}

public struct GPUAdapterPropertiesWGPU: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesWGPU
	public let sType: GPUSType = .adapterPropertiesWGPU
	public var backendType: GPUBackendType

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(backendType: GPUBackendType = .undefined, nextInChain: (any GPUChainedStruct)? = nil) {
		self.backendType = backendType
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesWGPU) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUAdapterPropertiesWGPU(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					backendType: backendType
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUAdapterPropertiesWGPU(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						backendType: backendType
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs: ChainedStruct {
}

public struct GPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs
	public let sType: GPUSType = .adapterPropertiesExplicitComputeSubgroupSizeConfigs
	public var minExplicitComputeSubgroupSize: UInt32
	public var maxExplicitComputeSubgroupSize: UInt32
	public var maxComputeWorkgroupSubgroups: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		minExplicitComputeSubgroupSize: UInt32 = 0,
		maxExplicitComputeSubgroupSize: UInt32 = 0,
		maxComputeWorkgroupSubgroups: UInt32 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.minExplicitComputeSubgroupSize = minExplicitComputeSubgroupSize
		self.maxExplicitComputeSubgroupSize = maxExplicitComputeSubgroupSize
		self.maxComputeWorkgroupSubgroups = maxComputeWorkgroupSubgroups
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					minExplicitComputeSubgroupSize: minExplicitComputeSubgroupSize,
					maxExplicitComputeSubgroupSize: maxExplicitComputeSubgroupSize,
					maxComputeWorkgroupSubgroups: maxComputeWorkgroupSubgroups
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUAdapterPropertiesExplicitComputeSubgroupSizeConfigs(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						minExplicitComputeSubgroupSize: minExplicitComputeSubgroupSize,
						maxExplicitComputeSubgroupSize: maxExplicitComputeSubgroupSize,
						maxComputeWorkgroupSubgroups: maxComputeWorkgroupSubgroups
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUAdapterPropertiesMemoryHeaps: ChainedStruct {
}

public struct GPUAdapterPropertiesMemoryHeaps: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesMemoryHeaps
	public let sType: GPUSType = .adapterPropertiesMemoryHeaps
	public var heapInfo: [GPUMemoryHeapInfo]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(heapInfo: [GPUMemoryHeapInfo] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.heapInfo = heapInfo
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesMemoryHeaps) -> R
	) -> R {
		let heapCount = heapInfo.count
		return withWGPUArrayPointer(heapInfo) { heapInfo in
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUAdapterPropertiesMemoryHeaps(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						heapCount: heapCount,
						heapInfo: heapInfo
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUAdapterPropertiesMemoryHeaps(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							heapCount: heapCount,
							heapInfo: heapInfo
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUAdapterPropertiesSubgroupMatrixConfigs: ChainedStruct {
}

public struct GPUAdapterPropertiesSubgroupMatrixConfigs: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesSubgroupMatrixConfigs
	public let sType: GPUSType = .adapterPropertiesSubgroupMatrixConfigs
	public var configs: [GPUSubgroupMatrixConfig]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(configs: [GPUSubgroupMatrixConfig] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.configs = configs
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesSubgroupMatrixConfigs) -> R
	) -> R {
		let configCount = configs.count
		return withWGPUArrayPointer(configs) { configs in
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUAdapterPropertiesSubgroupMatrixConfigs(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						configCount: configCount,
						configs: configs
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUAdapterPropertiesSubgroupMatrixConfigs(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							configCount: configCount,
							configs: configs
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUAdapterPropertiesVk: ChainedStruct {
}

public struct GPUAdapterPropertiesVk: GPUChainedStruct {
	public typealias WGPUType = WGPUAdapterPropertiesVk
	public let sType: GPUSType = .adapterPropertiesVk
	public var driverVersion: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(driverVersion: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.driverVersion = driverVersion
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUAdapterPropertiesVk) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUAdapterPropertiesVk(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					driverVersion: driverVersion
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUAdapterPropertiesVk(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						driverVersion: driverVersion
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUBindGroupDescriptor: RootStruct {
}

public struct GPUBindGroupDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUBindGroupDescriptor

	public var label: String?
	public var layout: GPUBindGroupLayout
	public var entries: [GPUBindGroupEntry]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		layout: GPUBindGroupLayout,
		entries: [GPUBindGroupEntry] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.layout = layout
		self.entries = entries
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBindGroupDescriptor) -> R
	) -> R {
		let entryCount = entries.count
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(entries) { entries in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUBindGroupDescriptor(
						nextInChain: pointer,
						label: label,
						layout: layout,
						entryCount: entryCount,
						entries: entries
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUBindGroupEntry: RootStruct {
}

public struct GPUBindGroupEntry: GPURootStruct {
	public typealias WGPUType = WGPUBindGroupEntry

	public var binding: UInt32
	public var buffer: GPUBuffer?
	public var offset: UInt64
	public var size: UInt64
	public var sampler: GPUSampler?
	public var textureView: GPUTextureView?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		binding: UInt32 = 0,
		buffer: GPUBuffer? = nil,
		offset: UInt64 = 0,
		size: UInt64 = UInt64.max,
		sampler: GPUSampler? = nil,
		textureView: GPUTextureView? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.binding = binding
		self.buffer = buffer
		self.offset = offset
		self.size = size
		self.sampler = sampler
		self.textureView = textureView
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBindGroupEntry) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUBindGroupEntry(
				nextInChain: pointer,
				binding: binding,
				buffer: buffer,
				offset: offset,
				size: size,
				sampler: sampler,
				textureView: textureView
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUBindGroupLayoutDescriptor: RootStruct {
}

public struct GPUBindGroupLayoutDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUBindGroupLayoutDescriptor

	public var label: String?
	public var entries: [GPUBindGroupLayoutEntry]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, entries: [GPUBindGroupLayoutEntry] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.entries = entries
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBindGroupLayoutDescriptor) -> R
	) -> R {
		let entryCount = entries.count
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(entries) { entries in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUBindGroupLayoutDescriptor(
						nextInChain: pointer,
						label: label,
						entryCount: entryCount,
						entries: entries
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUBindGroupLayoutEntry: RootStruct {
}

public struct GPUBindGroupLayoutEntry: GPURootStruct {
	public typealias WGPUType = WGPUBindGroupLayoutEntry

	public var binding: UInt32
	public var visibility: GPUShaderStage
	public var bindingArraySize: UInt32
	public var buffer: GPUBufferBindingLayout
	public var sampler: GPUSamplerBindingLayout
	public var texture: GPUTextureBindingLayout
	public var storageTexture: GPUStorageTextureBindingLayout

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		binding: UInt32 = 0,
		visibility: GPUShaderStage = GPUShaderStage(),
		bindingArraySize: UInt32 = 0,
		buffer: GPUBufferBindingLayout = GPUBufferBindingLayout(type: .bindingNotUsed),
		sampler: GPUSamplerBindingLayout = GPUSamplerBindingLayout(type: .bindingNotUsed),
		texture: GPUTextureBindingLayout = GPUTextureBindingLayout(sampleType: .bindingNotUsed),
		storageTexture: GPUStorageTextureBindingLayout = GPUStorageTextureBindingLayout(access: .bindingNotUsed),
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.binding = binding
		self.visibility = visibility
		self.bindingArraySize = bindingArraySize
		self.buffer = buffer
		self.sampler = sampler
		self.texture = texture
		self.storageTexture = storageTexture
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBindGroupLayoutEntry) -> R
	) -> R {
		return buffer.withWGPUStruct() { buffer in
			sampler.withWGPUStruct() { sampler in
				texture.withWGPUStruct() { texture in
					storageTexture.withWGPUStruct() { storageTexture in
						withWGPUStructChain { pointer in
							var wgpuStruct = WGPUBindGroupLayoutEntry(
								nextInChain: pointer,
								binding: binding,
								visibility: visibility,
								bindingArraySize: bindingArraySize,
								buffer: buffer,
								sampler: sampler,
								texture: texture,
								storageTexture: storageTexture
							)
							return lambda(&wgpuStruct)
						}
					}
				}
			}
		}
	}
}

extension WGPUBindingResource: RootStruct {
}

public struct GPUBindingResource: GPURootStruct {
	public typealias WGPUType = WGPUBindingResource

	public var buffer: GPUBuffer?
	public var offset: UInt64
	public var size: UInt64
	public var sampler: GPUSampler?
	public var textureView: GPUTextureView?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		buffer: GPUBuffer? = nil,
		offset: UInt64 = 0,
		size: UInt64 = UInt64.max,
		sampler: GPUSampler? = nil,
		textureView: GPUTextureView? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.buffer = buffer
		self.offset = offset
		self.size = size
		self.sampler = sampler
		self.textureView = textureView
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBindingResource) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUBindingResource(
				nextInChain: pointer,
				buffer: buffer,
				offset: offset,
				size: size,
				sampler: sampler,
				textureView: textureView
			)
			return lambda(&wgpuStruct)
		}
	}
}

public typealias GPUBlendComponent = WGPUBlendComponent

extension GPUBlendComponent: GPUSimpleStruct {
	public typealias WGPUType = Self
}

public typealias GPUBlendState = WGPUBlendState

extension GPUBlendState: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUBufferBindingLayout: RootStruct {
}

public struct GPUBufferBindingLayout: GPURootStruct {
	public typealias WGPUType = WGPUBufferBindingLayout

	public var type: GPUBufferBindingType
	public var hasDynamicOffset: Bool
	public var minBindingSize: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		type: GPUBufferBindingType = .uniform,
		hasDynamicOffset: Bool = false,
		minBindingSize: UInt64 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.type = type
		self.hasDynamicOffset = hasDynamicOffset
		self.minBindingSize = minBindingSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBufferBindingLayout) -> R
	) -> R {
		return {
			let hasDynamicOffset: WGPUBool = hasDynamicOffset ? 1 : 0
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPUBufferBindingLayout(
					nextInChain: pointer,
					type: type,
					hasDynamicOffset: hasDynamicOffset,
					minBindingSize: minBindingSize
				)
				return lambda(&wgpuStruct)
			}
		}()
	}
}

extension WGPUBufferDescriptor: RootStruct {
}

public struct GPUBufferDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUBufferDescriptor

	public var label: String?
	public var usage: GPUBufferUsage
	public var size: UInt64
	public var mappedAtCreation: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		usage: GPUBufferUsage = GPUBufferUsage(),
		size: UInt64 = 0,
		mappedAtCreation: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.usage = usage
		self.size = size
		self.mappedAtCreation = mappedAtCreation
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBufferDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			{
				let mappedAtCreation: WGPUBool = mappedAtCreation ? 1 : 0
				return withWGPUStructChain { pointer in
					var wgpuStruct = WGPUBufferDescriptor(
						nextInChain: pointer,
						label: label,
						usage: usage,
						size: size,
						mappedAtCreation: mappedAtCreation
					)
					return lambda(&wgpuStruct)
				}
			}()
		}
	}
}

extension WGPUBufferHostMappedPointer: ChainedStruct {
}

public struct GPUBufferHostMappedPointer: GPUChainedStruct {
	public typealias WGPUType = WGPUBufferHostMappedPointer
	public let sType: GPUSType = .bufferHostMappedPointer
	public var pointer: UnsafeMutableRawPointer?
	public var disposeCallback: GPUCallback?
	public var userdata: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		pointer: UnsafeMutableRawPointer?,
		disposeCallback: GPUCallback?,
		userdata: UnsafeMutableRawPointer?,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.pointer = pointer
		self.disposeCallback = disposeCallback
		self.userdata = userdata
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUBufferHostMappedPointer) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUBufferHostMappedPointer(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					pointer: pointer,
					disposeCallback: disposeCallback,
					userdata: userdata
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUBufferHostMappedPointer(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						pointer: pointer,
						disposeCallback: disposeCallback,
						userdata: userdata
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

public typealias GPUColor = WGPUColor

extension GPUColor: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUColorTargetState: RootStruct {
}

public struct GPUColorTargetState: GPURootStruct {
	public typealias WGPUType = WGPUColorTargetState

	public var format: GPUTextureFormat
	public var blend: GPUBlendState?
	public var writeMask: GPUColorWriteMask

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		format: GPUTextureFormat = .undefined,
		blend: GPUBlendState? = nil,
		writeMask: GPUColorWriteMask = [.all],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.format = format
		self.blend = blend
		self.writeMask = writeMask
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUColorTargetState) -> R
	) -> R {
		return blend.withWGPUPointer() { blend in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUColorTargetState(
					nextInChain: pointer,
					format: format,
					blend: blend,
					writeMask: writeMask
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUColorTargetStateExpandResolveTextureDawn: ChainedStruct {
}

public struct GPUColorTargetStateExpandResolveTextureDawn: GPUChainedStruct {
	public typealias WGPUType = WGPUColorTargetStateExpandResolveTextureDawn
	public let sType: GPUSType = .colorTargetStateExpandResolveTextureDawn
	public var enabled: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(enabled: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.enabled = enabled
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUColorTargetStateExpandResolveTextureDawn) -> R
	) -> R {
		return {
			let enabled: WGPUBool = enabled ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUColorTargetStateExpandResolveTextureDawn(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						enabled: enabled
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUColorTargetStateExpandResolveTextureDawn(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							enabled: enabled
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUCommandBufferDescriptor: RootStruct {
}

public struct GPUCommandBufferDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUCommandBufferDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCommandBufferDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUCommandBufferDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUCommandEncoderDescriptor: RootStruct {
}

public struct GPUCommandEncoderDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUCommandEncoderDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCommandEncoderDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUCommandEncoderDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUCompatibilityModeLimits: ChainedStruct {
}

public struct GPUCompatibilityModeLimits: GPUChainedStruct {
	public typealias WGPUType = WGPUCompatibilityModeLimits
	public let sType: GPUSType = .compatibilityModeLimits
	public var maxStorageBuffersInVertexStage: UInt32
	public var maxStorageTexturesInVertexStage: UInt32
	public var maxStorageBuffersInFragmentStage: UInt32
	public var maxStorageTexturesInFragmentStage: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		maxStorageBuffersInVertexStage: UInt32 = UInt32.max,
		maxStorageTexturesInVertexStage: UInt32 = UInt32.max,
		maxStorageBuffersInFragmentStage: UInt32 = UInt32.max,
		maxStorageTexturesInFragmentStage: UInt32 = UInt32.max,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.maxStorageBuffersInVertexStage = maxStorageBuffersInVertexStage
		self.maxStorageTexturesInVertexStage = maxStorageTexturesInVertexStage
		self.maxStorageBuffersInFragmentStage = maxStorageBuffersInFragmentStage
		self.maxStorageTexturesInFragmentStage = maxStorageTexturesInFragmentStage
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCompatibilityModeLimits) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUCompatibilityModeLimits(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					maxStorageBuffersInVertexStage: maxStorageBuffersInVertexStage,
					maxStorageTexturesInVertexStage: maxStorageTexturesInVertexStage,
					maxStorageBuffersInFragmentStage: maxStorageBuffersInFragmentStage,
					maxStorageTexturesInFragmentStage: maxStorageTexturesInFragmentStage
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUCompatibilityModeLimits(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						maxStorageBuffersInVertexStage: maxStorageBuffersInVertexStage,
						maxStorageTexturesInVertexStage: maxStorageTexturesInVertexStage,
						maxStorageBuffersInFragmentStage: maxStorageBuffersInFragmentStage,
						maxStorageTexturesInFragmentStage: maxStorageTexturesInFragmentStage
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUCompilationInfo: RootStruct {
}

public struct GPUCompilationInfo: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUCompilationInfo

	public var messages: [GPUCompilationMessage]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(messages: [GPUCompilationMessage] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.messages = messages
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUCompilationInfo) {
		self.messages = wgpuStruct.messages.wrapArrayWithCount(wgpuStruct.messageCount) as [GPUCompilationMessage]
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCompilationInfo) -> R
	) -> R {
		let messageCount = messages.count
		return withWGPUArrayPointer(messages) { messages in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUCompilationInfo(nextInChain: pointer, messageCount: messageCount, messages: messages)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUCompilationMessage: RootStruct {
}

public struct GPUCompilationMessage: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUCompilationMessage

	public var message: String
	public var type: GPUCompilationMessageType
	public var lineNum: UInt64
	public var linePos: UInt64
	public var offset: UInt64
	public var length: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		message: String = "",
		type: GPUCompilationMessageType = .error,
		lineNum: UInt64 = 0,
		linePos: UInt64 = 0,
		offset: UInt64 = 0,
		length: UInt64 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.message = message
		self.type = type
		self.lineNum = lineNum
		self.linePos = linePos
		self.offset = offset
		self.length = length
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUCompilationMessage) {
		self.message = String(wgpuStringView: wgpuStruct.message)
		self.type = wgpuStruct.type
		self.lineNum = wgpuStruct.lineNum
		self.linePos = wgpuStruct.linePos
		self.offset = wgpuStruct.offset
		self.length = wgpuStruct.length
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCompilationMessage) -> R
	) -> R {
		return message.withWGPUStruct { message in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUCompilationMessage(
					nextInChain: pointer,
					message: message,
					type: type,
					lineNum: lineNum,
					linePos: linePos,
					offset: offset,
					length: length
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUComputePassDescriptor: RootStruct {
}

public struct GPUComputePassDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUComputePassDescriptor

	public var label: String?
	public var timestampWrites: GPUPassTimestampWrites?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, timestampWrites: GPUPassTimestampWrites? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.timestampWrites = timestampWrites
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUComputePassDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			timestampWrites.withWGPUPointer { timestampWrites in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUComputePassDescriptor(
						nextInChain: pointer,
						label: label,
						timestampWrites: timestampWrites
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUComputePipelineDescriptor: RootStruct {
}

public struct GPUComputePipelineDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUComputePipelineDescriptor

	public var label: String?
	public var layout: GPUPipelineLayout?
	public var compute: GPUComputeState

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		layout: GPUPipelineLayout? = nil,
		compute: GPUComputeState,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.layout = layout
		self.compute = compute
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUComputePipelineDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			compute.withWGPUStruct() { compute in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUComputePipelineDescriptor(
						nextInChain: pointer,
						label: label,
						layout: layout,
						compute: compute
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUComputeState: RootStruct {
}

public struct GPUComputeState: GPURootStruct {
	public typealias WGPUType = WGPUComputeState

	public var module: GPUShaderModule
	public var entryPoint: String?
	public var constants: [GPUConstantEntry]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		module: GPUShaderModule,
		entryPoint: String? = nil,
		constants: [GPUConstantEntry] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.constants = constants
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUComputeState) -> R
	) -> R {
		let constantCount = constants.count
		return entryPoint.withWGPUStruct { entryPoint in
			withWGPUArrayPointer(constants) { constants in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUComputeState(
						nextInChain: pointer,
						module: module,
						entryPoint: entryPoint,
						constantCount: constantCount,
						constants: constants
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUConstantEntry: RootStruct {
}

public struct GPUConstantEntry: GPURootStruct {
	public typealias WGPUType = WGPUConstantEntry

	public var key: String
	public var value: Double

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(key: String = "", value: Double = 0.0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.key = key
		self.value = value
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUConstantEntry) -> R
	) -> R {
		return key.withWGPUStruct { key in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUConstantEntry(nextInChain: pointer, key: key, value: value)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUCopyTextureForBrowserOptions: RootStruct {
}

public struct GPUCopyTextureForBrowserOptions: GPURootStruct {
	public typealias WGPUType = WGPUCopyTextureForBrowserOptions

	public var flipY: Bool
	public var needsColorSpaceConversion: Bool
	public var srcAlphaMode: GPUAlphaMode
	public var srcTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)?
	public var conversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)?
	public var dstTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)?
	public var dstAlphaMode: GPUAlphaMode
	public var internalUsage: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		flipY: Bool = false,
		needsColorSpaceConversion: Bool = false,
		srcAlphaMode: GPUAlphaMode = .unpremultiplied,
		srcTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)? = nil,
		conversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)? = nil,
		dstTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)? = nil,
		dstAlphaMode: GPUAlphaMode = .unpremultiplied,
		internalUsage: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.flipY = flipY
		self.needsColorSpaceConversion = needsColorSpaceConversion
		self.srcAlphaMode = srcAlphaMode
		self.srcTransferFunctionParameters = srcTransferFunctionParameters
		self.conversionMatrix = conversionMatrix
		self.dstTransferFunctionParameters = dstTransferFunctionParameters
		self.dstAlphaMode = dstAlphaMode
		self.internalUsage = internalUsage
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUCopyTextureForBrowserOptions) -> R
	) -> R {
		return {
			let flipY: WGPUBool = flipY ? 1 : 0
			return {
				let needsColorSpaceConversion: WGPUBool = needsColorSpaceConversion ? 1 : 0
				return withWGPUArrayPointer(srcTransferFunctionParameters) { srcTransferFunctionParameters in
					withWGPUArrayPointer(conversionMatrix) { conversionMatrix in
						withWGPUArrayPointer(dstTransferFunctionParameters) { dstTransferFunctionParameters in
							{
								let internalUsage: WGPUBool = internalUsage ? 1 : 0
								return withWGPUStructChain { pointer in
									var wgpuStruct = WGPUCopyTextureForBrowserOptions(
										nextInChain: pointer,
										flipY: flipY,
										needsColorSpaceConversion: needsColorSpaceConversion,
										srcAlphaMode: srcAlphaMode,
										srcTransferFunctionParameters:
											srcTransferFunctionParameters,
										conversionMatrix: conversionMatrix,
										dstTransferFunctionParameters:
											dstTransferFunctionParameters,
										dstAlphaMode: dstAlphaMode,
										internalUsage: internalUsage
									)
									return lambda(&wgpuStruct)
								}
							}()
						}
					}
				}
			}()
		}()
	}
}

extension WGPUDawnWGSLBlocklist: ChainedStruct {
}

public struct DawnWGSLBlocklist: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnWGSLBlocklist
	public let sType: GPUSType = .dawnWGSLBlocklist
	public var blocklistedFeatures: [String]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(blocklistedFeatures: [String] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.blocklistedFeatures = blocklistedFeatures
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnWGSLBlocklist) -> R
	) -> R {
		let blocklistedFeatureCount = blocklistedFeatures.count
		return withWGPUArrayPointer(blocklistedFeatures) { blocklistedFeatures in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnWGSLBlocklist(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						blocklistedFeatureCount: blocklistedFeatureCount,
						blocklistedFeatures: blocklistedFeatures
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnWGSLBlocklist(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							blocklistedFeatureCount: blocklistedFeatureCount,
							blocklistedFeatures: blocklistedFeatures
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUDawnAdapterPropertiesPowerPreference: ChainedStruct {
}

public struct DawnAdapterPropertiesPowerPreference: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnAdapterPropertiesPowerPreference
	public let sType: GPUSType = .dawnAdapterPropertiesPowerPreference
	public var powerPreference: GPUPowerPreference

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(powerPreference: GPUPowerPreference = .undefined, nextInChain: (any GPUChainedStruct)? = nil) {
		self.powerPreference = powerPreference
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnAdapterPropertiesPowerPreference) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnAdapterPropertiesPowerPreference(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					powerPreference: powerPreference
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnAdapterPropertiesPowerPreference(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						powerPreference: powerPreference
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnBufferDescriptorErrorInfoFromWireClient: ChainedStruct {
}

public struct DawnBufferDescriptorErrorInfoFromWireClient: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnBufferDescriptorErrorInfoFromWireClient
	public let sType: GPUSType = .dawnBufferDescriptorErrorInfoFromWireClient
	public var outOfMemory: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(outOfMemory: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.outOfMemory = outOfMemory
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnBufferDescriptorErrorInfoFromWireClient) -> R
	) -> R {
		return {
			let outOfMemory: WGPUBool = outOfMemory ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnBufferDescriptorErrorInfoFromWireClient(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						outOfMemory: outOfMemory
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnBufferDescriptorErrorInfoFromWireClient(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							outOfMemory: outOfMemory
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUDawnCacheDeviceDescriptor: ChainedStruct {
}

public struct DawnCacheDeviceDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnCacheDeviceDescriptor
	public let sType: GPUSType = .dawnCacheDeviceDescriptor
	public var isolationKey: String
	public var loadDataFunction: DawnLoadCacheDataFunction?
	public var storeDataFunction: DawnStoreCacheDataFunction?
	public var functionUserdata: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		isolationKey: String = "",
		loadDataFunction: DawnLoadCacheDataFunction? = nil,
		storeDataFunction: DawnStoreCacheDataFunction? = nil,
		functionUserdata: UnsafeMutableRawPointer? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.isolationKey = isolationKey
		self.loadDataFunction = loadDataFunction
		self.storeDataFunction = storeDataFunction
		self.functionUserdata = functionUserdata
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnCacheDeviceDescriptor) -> R
	) -> R {
		return isolationKey.withWGPUStruct { isolationKey in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnCacheDeviceDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						isolationKey: isolationKey,
						loadDataFunction: loadDataFunction,
						storeDataFunction: storeDataFunction,
						functionUserdata: functionUserdata
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnCacheDeviceDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							isolationKey: isolationKey,
							loadDataFunction: loadDataFunction,
							storeDataFunction: storeDataFunction,
							functionUserdata: functionUserdata
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUDawnConsumeAdapterDescriptor: ChainedStruct {
}

public struct DawnConsumeAdapterDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnConsumeAdapterDescriptor
	public let sType: GPUSType = .dawnConsumeAdapterDescriptor
	public var consumeAdapter: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(consumeAdapter: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.consumeAdapter = consumeAdapter
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnConsumeAdapterDescriptor) -> R
	) -> R {
		return {
			let consumeAdapter: WGPUBool = consumeAdapter ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnConsumeAdapterDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						consumeAdapter: consumeAdapter
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnConsumeAdapterDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							consumeAdapter: consumeAdapter
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUDawnDeviceAllocatorControl: ChainedStruct {
}

public struct DawnDeviceAllocatorControl: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnDeviceAllocatorControl
	public let sType: GPUSType = .dawnDeviceAllocatorControl
	public var allocatorHeapBlockSize: Int

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(allocatorHeapBlockSize: Int = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.allocatorHeapBlockSize = allocatorHeapBlockSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnDeviceAllocatorControl) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnDeviceAllocatorControl(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					allocatorHeapBlockSize: allocatorHeapBlockSize
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnDeviceAllocatorControl(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						allocatorHeapBlockSize: allocatorHeapBlockSize
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnDrmFormatCapabilities: ChainedStruct {
}

public struct DawnDrmFormatCapabilities: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnDrmFormatCapabilities
	public let sType: GPUSType = .dawnDrmFormatCapabilities
	public var properties: [DawnDrmFormatProperties]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(properties: [DawnDrmFormatProperties] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.properties = properties
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnDrmFormatCapabilities) -> R
	) -> R {
		let propertiesCount = properties.count
		return withWGPUArrayPointer(properties) { properties in
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnDrmFormatCapabilities(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						propertiesCount: propertiesCount,
						properties: properties
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnDrmFormatCapabilities(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							propertiesCount: propertiesCount,
							properties: properties
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

public typealias DawnDrmFormatProperties = WGPUDawnDrmFormatProperties

extension DawnDrmFormatProperties: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUDawnEncoderInternalUsageDescriptor: ChainedStruct {
}

public struct DawnEncoderInternalUsageDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnEncoderInternalUsageDescriptor
	public let sType: GPUSType = .dawnEncoderInternalUsageDescriptor
	public var useInternalUsages: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(useInternalUsages: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.useInternalUsages = useInternalUsages
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnEncoderInternalUsageDescriptor) -> R
	) -> R {
		return {
			let useInternalUsages: WGPUBool = useInternalUsages ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnEncoderInternalUsageDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						useInternalUsages: useInternalUsages
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnEncoderInternalUsageDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							useInternalUsages: useInternalUsages
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUDawnFakeBufferOOMForTesting: ChainedStruct {
}

public struct DawnFakeBufferOOMForTesting: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnFakeBufferOOMForTesting
	public let sType: GPUSType = .dawnFakeBufferOOMForTesting
	public var fakeOOMAtWireClientMap: Bool
	public var fakeOOMAtNativeMap: Bool
	public var fakeOOMAtDevice: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		fakeOOMAtWireClientMap: Bool = false,
		fakeOOMAtNativeMap: Bool = false,
		fakeOOMAtDevice: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.fakeOOMAtWireClientMap = fakeOOMAtWireClientMap
		self.fakeOOMAtNativeMap = fakeOOMAtNativeMap
		self.fakeOOMAtDevice = fakeOOMAtDevice
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnFakeBufferOOMForTesting) -> R
	) -> R {
		return {
			let fakeOOMAtWireClientMap: WGPUBool = fakeOOMAtWireClientMap ? 1 : 0
			return {
				let fakeOOMAtNativeMap: WGPUBool = fakeOOMAtNativeMap ? 1 : 0
				return {
					let fakeOOMAtDevice: WGPUBool = fakeOOMAtDevice ? 1 : 0
					return {
						if nextInChain == nil {
							var wgpuStruct = WGPUDawnFakeBufferOOMForTesting(
								chain: WGPUChainedStruct(next: nil, sType: sType),
								fakeOOMAtWireClientMap: fakeOOMAtWireClientMap,
								fakeOOMAtNativeMap: fakeOOMAtNativeMap,
								fakeOOMAtDevice: fakeOOMAtDevice
							)
							return lambda(&wgpuStruct)
						} else {
							return nextInChain!.withNextInChain() { pointer in
								var wgpuStruct = WGPUDawnFakeBufferOOMForTesting(
									chain: WGPUChainedStruct(next: pointer, sType: sType),
									fakeOOMAtWireClientMap: fakeOOMAtWireClientMap,
									fakeOOMAtNativeMap: fakeOOMAtNativeMap,
									fakeOOMAtDevice: fakeOOMAtDevice
								)
								return lambda(&wgpuStruct)
							}
						}
					}()
				}()
			}()
		}()
	}
}

extension WGPUDawnFakeDeviceInitializeErrorForTesting: ChainedStruct {
}

public struct DawnFakeDeviceInitializeErrorForTesting: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnFakeDeviceInitializeErrorForTesting
	public let sType: GPUSType = .dawnFakeDeviceInitializeErrorForTesting

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(nextInChain: (any GPUChainedStruct)? = nil) {
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnFakeDeviceInitializeErrorForTesting) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnFakeDeviceInitializeErrorForTesting(
					chain: WGPUChainedStruct(next: nil, sType: sType),
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnFakeDeviceInitializeErrorForTesting(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnFormatCapabilities: RootStruct {
}

public struct DawnFormatCapabilities: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUDawnFormatCapabilities

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(nextInChain: (any GPUChainedStruct)? = nil) {
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUDawnFormatCapabilities) {

	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnFormatCapabilities) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUDawnFormatCapabilities(nextInChain: pointer, )
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUDawnHostMappedPointerLimits: ChainedStruct {
}

public struct DawnHostMappedPointerLimits: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnHostMappedPointerLimits
	public let sType: GPUSType = .dawnHostMappedPointerLimits
	public var hostMappedPointerAlignment: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(hostMappedPointerAlignment: UInt32 = UInt32.max, nextInChain: (any GPUChainedStruct)? = nil) {
		self.hostMappedPointerAlignment = hostMappedPointerAlignment
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnHostMappedPointerLimits) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnHostMappedPointerLimits(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					hostMappedPointerAlignment: hostMappedPointerAlignment
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnHostMappedPointerLimits(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						hostMappedPointerAlignment: hostMappedPointerAlignment
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnInjectedInvalidSType: ChainedStruct {
}

public struct DawnInjectedInvalidSType: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnInjectedInvalidSType
	public let sType: GPUSType = .dawnInjectedInvalidSType
	public var invalidSType: GPUSType

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(invalidSType: GPUSType = .shaderSourceSPIRV, nextInChain: (any GPUChainedStruct)? = nil) {
		self.invalidSType = invalidSType
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnInjectedInvalidSType) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnInjectedInvalidSType(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					invalidSType: invalidSType
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnInjectedInvalidSType(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						invalidSType: invalidSType
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnRenderPassColorAttachmentRenderToSingleSampled: ChainedStruct {
}

public struct DawnRenderPassColorAttachmentRenderToSingleSampled: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnRenderPassColorAttachmentRenderToSingleSampled
	public let sType: GPUSType = .dawnRenderPassColorAttachmentRenderToSingleSampled
	public var implicitSampleCount: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(implicitSampleCount: UInt32 = 1, nextInChain: (any GPUChainedStruct)? = nil) {
		self.implicitSampleCount = implicitSampleCount
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnRenderPassColorAttachmentRenderToSingleSampled) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnRenderPassColorAttachmentRenderToSingleSampled(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					implicitSampleCount: implicitSampleCount
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnRenderPassColorAttachmentRenderToSingleSampled(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						implicitSampleCount: implicitSampleCount
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnRenderPassSampleCount: ChainedStruct {
}

public struct DawnRenderPassSampleCount: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnRenderPassSampleCount
	public let sType: GPUSType = .dawnRenderPassSampleCount
	public var sampleCount: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sampleCount: UInt32 = 1, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sampleCount = sampleCount
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnRenderPassSampleCount) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnRenderPassSampleCount(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sampleCount: sampleCount
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnRenderPassSampleCount(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sampleCount: sampleCount
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnShaderModuleSPIRVOptionsDescriptor: ChainedStruct {
}

public struct DawnShaderModuleSPIRVOptionsDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnShaderModuleSPIRVOptionsDescriptor
	public let sType: GPUSType = .dawnShaderModuleSPIRVOptionsDescriptor
	public var allowNonUniformDerivatives: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(allowNonUniformDerivatives: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.allowNonUniformDerivatives = allowNonUniformDerivatives
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnShaderModuleSPIRVOptionsDescriptor) -> R
	) -> R {
		return {
			let allowNonUniformDerivatives: WGPUBool = allowNonUniformDerivatives ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUDawnShaderModuleSPIRVOptionsDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						allowNonUniformDerivatives: allowNonUniformDerivatives
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUDawnShaderModuleSPIRVOptionsDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							allowNonUniformDerivatives: allowNonUniformDerivatives
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUDawnTexelCopyBufferRowAlignmentLimits: ChainedStruct {
}

public struct DawnTexelCopyBufferRowAlignmentLimits: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnTexelCopyBufferRowAlignmentLimits
	public let sType: GPUSType = .dawnTexelCopyBufferRowAlignmentLimits
	public var minTexelCopyBufferRowAlignment: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(minTexelCopyBufferRowAlignment: UInt32 = UInt32.max, nextInChain: (any GPUChainedStruct)? = nil) {
		self.minTexelCopyBufferRowAlignment = minTexelCopyBufferRowAlignment
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnTexelCopyBufferRowAlignmentLimits) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnTexelCopyBufferRowAlignmentLimits(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					minTexelCopyBufferRowAlignment: minTexelCopyBufferRowAlignment
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnTexelCopyBufferRowAlignmentLimits(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						minTexelCopyBufferRowAlignment: minTexelCopyBufferRowAlignment
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnTextureInternalUsageDescriptor: ChainedStruct {
}

public struct DawnTextureInternalUsageDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnTextureInternalUsageDescriptor
	public let sType: GPUSType = .dawnTextureInternalUsageDescriptor
	public var internalUsage: GPUTextureUsage

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(internalUsage: GPUTextureUsage = GPUTextureUsage(), nextInChain: (any GPUChainedStruct)? = nil) {
		self.internalUsage = internalUsage
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnTextureInternalUsageDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUDawnTextureInternalUsageDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					internalUsage: internalUsage
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUDawnTextureInternalUsageDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						internalUsage: internalUsage
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUDawnTogglesDescriptor: ChainedStruct {
}

public struct DawnTogglesDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnTogglesDescriptor
	public let sType: GPUSType = .dawnTogglesDescriptor
	public var enabledToggles: [String]
	public var disabledToggles: [String]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(enabledToggles: [String] = [], disabledToggles: [String] = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.enabledToggles = enabledToggles
		self.disabledToggles = disabledToggles
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnTogglesDescriptor) -> R
	) -> R {
		let enabledToggleCount = enabledToggles.count
		let disabledToggleCount = disabledToggles.count
		return withWGPUArrayPointer(enabledToggles) { enabledToggles in
			withWGPUArrayPointer(disabledToggles) { disabledToggles in
				{
					if nextInChain == nil {
						var wgpuStruct = WGPUDawnTogglesDescriptor(
							chain: WGPUChainedStruct(next: nil, sType: sType),
							enabledToggleCount: enabledToggleCount,
							enabledToggles: enabledToggles,
							disabledToggleCount: disabledToggleCount,
							disabledToggles: disabledToggles
						)
						return lambda(&wgpuStruct)
					} else {
						return nextInChain!.withNextInChain() { pointer in
							var wgpuStruct = WGPUDawnTogglesDescriptor(
								chain: WGPUChainedStruct(next: pointer, sType: sType),
								enabledToggleCount: enabledToggleCount,
								enabledToggles: enabledToggles,
								disabledToggleCount: disabledToggleCount,
								disabledToggles: disabledToggles
							)
							return lambda(&wgpuStruct)
						}
					}
				}()
			}
		}
	}
}

extension WGPUDawnWireWGSLControl: ChainedStruct {
}

public struct DawnWireWGSLControl: GPUChainedStruct {
	public typealias WGPUType = WGPUDawnWireWGSLControl
	public let sType: GPUSType = .dawnWireWGSLControl
	public var enableExperimental: Bool
	public var enableUnsafe: Bool
	public var enableTesting: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		enableExperimental: Bool = false,
		enableUnsafe: Bool = false,
		enableTesting: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.enableExperimental = enableExperimental
		self.enableUnsafe = enableUnsafe
		self.enableTesting = enableTesting
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDawnWireWGSLControl) -> R
	) -> R {
		return {
			let enableExperimental: WGPUBool = enableExperimental ? 1 : 0
			return {
				let enableUnsafe: WGPUBool = enableUnsafe ? 1 : 0
				return {
					let enableTesting: WGPUBool = enableTesting ? 1 : 0
					return {
						if nextInChain == nil {
							var wgpuStruct = WGPUDawnWireWGSLControl(
								chain: WGPUChainedStruct(next: nil, sType: sType),
								enableExperimental: enableExperimental,
								enableUnsafe: enableUnsafe,
								enableTesting: enableTesting
							)
							return lambda(&wgpuStruct)
						} else {
							return nextInChain!.withNextInChain() { pointer in
								var wgpuStruct = WGPUDawnWireWGSLControl(
									chain: WGPUChainedStruct(next: pointer, sType: sType),
									enableExperimental: enableExperimental,
									enableUnsafe: enableUnsafe,
									enableTesting: enableTesting
								)
								return lambda(&wgpuStruct)
							}
						}
					}()
				}()
			}()
		}()
	}
}

extension WGPUDepthStencilState: RootStruct {
}

public struct GPUDepthStencilState: GPURootStruct {
	public typealias WGPUType = WGPUDepthStencilState

	public var format: GPUTextureFormat
	public var depthWriteEnabled: GPUOptionalBool
	public var depthCompare: GPUCompareFunction
	public var stencilFront: GPUStencilFaceState
	public var stencilBack: GPUStencilFaceState
	public var stencilReadMask: UInt32
	public var stencilWriteMask: UInt32
	public var depthBias: Int32
	public var depthBiasSlopeScale: Float
	public var depthBiasClamp: Float

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		format: GPUTextureFormat = .undefined,
		depthWriteEnabled: GPUOptionalBool = .false,
		depthCompare: GPUCompareFunction = .undefined,
		stencilFront: GPUStencilFaceState,
		stencilBack: GPUStencilFaceState,
		stencilReadMask: UInt32 = 0xFFFFFFFF,
		stencilWriteMask: UInt32 = 0xFFFFFFFF,
		depthBias: Int32 = 0,
		depthBiasSlopeScale: Float = 0.0,
		depthBiasClamp: Float = 0.0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.format = format
		self.depthWriteEnabled = depthWriteEnabled
		self.depthCompare = depthCompare
		self.stencilFront = stencilFront
		self.stencilBack = stencilBack
		self.stencilReadMask = stencilReadMask
		self.stencilWriteMask = stencilWriteMask
		self.depthBias = depthBias
		self.depthBiasSlopeScale = depthBiasSlopeScale
		self.depthBiasClamp = depthBiasClamp
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDepthStencilState) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUDepthStencilState(
				nextInChain: pointer,
				format: format,
				depthWriteEnabled: depthWriteEnabled,
				depthCompare: depthCompare,
				stencilFront: stencilFront,
				stencilBack: stencilBack,
				stencilReadMask: stencilReadMask,
				stencilWriteMask: stencilWriteMask,
				depthBias: depthBias,
				depthBiasSlopeScale: depthBiasSlopeScale,
				depthBiasClamp: depthBiasClamp
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUDeviceDescriptor: RootStruct {
}

public struct GPUDeviceDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUDeviceDescriptor

	public var label: String?
	public var requiredFeatures: [GPUFeatureName]?
	public var requiredLimits: GPULimits?
	public var defaultQueue: GPUQueueDescriptor
	public var deviceLostCallbackInfo: GPUDeviceLostCallbackInfo
	public var uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		requiredFeatures: [GPUFeatureName]? = nil,
		requiredLimits: GPULimits? = nil,
		defaultQueue: GPUQueueDescriptor,
		deviceLostCallbackInfo: GPUDeviceLostCallbackInfo,
		uncapturedErrorCallbackInfo: GPUUncapturedErrorCallbackInfo,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.requiredFeatures = requiredFeatures
		self.requiredLimits = requiredLimits
		self.defaultQueue = defaultQueue
		self.deviceLostCallbackInfo = deviceLostCallbackInfo
		self.uncapturedErrorCallbackInfo = uncapturedErrorCallbackInfo
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUDeviceDescriptor) -> R
	) -> R {
		let requiredFeatureCount = requiredFeatures?.count ?? 0
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(requiredFeatures) { (requiredFeatures: UnsafePointer<WGPUFeatureName>?) in
				return requiredLimits.withWGPUPointer { requiredLimits in
					defaultQueue.withWGPUStruct() { defaultQueue in
						deviceLostCallbackInfo.withWGPUStruct { deviceLostCallbackInfo in
							return uncapturedErrorCallbackInfo.withWGPUStruct { uncapturedErrorCallbackInfo in
								return withWGPUStructChain { pointer in
									var wgpuStruct = WGPUDeviceDescriptor(
										nextInChain: pointer,
										label: label,
										requiredFeatureCount: requiredFeatureCount,
										requiredFeatures: requiredFeatures,
										requiredLimits: requiredLimits,
										defaultQueue: defaultQueue,
										deviceLostCallbackInfo: deviceLostCallbackInfo,
										uncapturedErrorCallbackInfo: uncapturedErrorCallbackInfo
									)
									return lambda(&wgpuStruct)
								}
							}
						}
					}
				}
			}
		}
	}
}

public typealias GPUExtent2D = WGPUExtent2D

extension GPUExtent2D: GPUSimpleStruct {
	public typealias WGPUType = Self
}

public typealias GPUExtent3D = WGPUExtent3D

extension GPUExtent3D: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUExternalTextureDescriptor: RootStruct {
}

public struct GPUExternalTextureDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUExternalTextureDescriptor

	public var label: String?
	public var plane0: GPUTextureView
	public var plane1: GPUTextureView?
	public var cropOrigin: GPUOrigin2D
	public var cropSize: GPUExtent2D
	public var apparentSize: GPUExtent2D
	public var doYuvToRgbConversionOnly: Bool
	public var yuvToRgbConversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)?
	public var srcTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)?
	public var dstTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)?
	public var gamutConversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)?
	public var mirrored: Bool
	public var rotation: GPUExternalTextureRotation

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		plane0: GPUTextureView,
		plane1: GPUTextureView? = nil,
		cropOrigin: GPUOrigin2D,
		cropSize: GPUExtent2D,
		apparentSize: GPUExtent2D,
		doYuvToRgbConversionOnly: Bool = false,
		yuvToRgbConversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)? = nil,
		srcTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)? = nil,
		dstTransferFunctionParameters: (Float, Float, Float, Float, Float, Float, Float)? = nil,
		gamutConversionMatrix: (Float, Float, Float, Float, Float, Float, Float, Float, Float)? = nil,
		mirrored: Bool = false,
		rotation: GPUExternalTextureRotation = .rotate0Degrees,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.plane0 = plane0
		self.plane1 = plane1
		self.cropOrigin = cropOrigin
		self.cropSize = cropSize
		self.apparentSize = apparentSize
		self.doYuvToRgbConversionOnly = doYuvToRgbConversionOnly
		self.yuvToRgbConversionMatrix = yuvToRgbConversionMatrix
		self.srcTransferFunctionParameters = srcTransferFunctionParameters
		self.dstTransferFunctionParameters = dstTransferFunctionParameters
		self.gamutConversionMatrix = gamutConversionMatrix
		self.mirrored = mirrored
		self.rotation = rotation
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUExternalTextureDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			{
				let doYuvToRgbConversionOnly: WGPUBool = doYuvToRgbConversionOnly ? 1 : 0
				return withWGPUArrayPointer(yuvToRgbConversionMatrix) { yuvToRgbConversionMatrix in
					withWGPUArrayPointer(srcTransferFunctionParameters) { srcTransferFunctionParameters in
						withWGPUArrayPointer(dstTransferFunctionParameters) { dstTransferFunctionParameters in
							withWGPUArrayPointer(gamutConversionMatrix) { gamutConversionMatrix in
								{
									let mirrored: WGPUBool = mirrored ? 1 : 0
									return withWGPUStructChain { pointer in
										var wgpuStruct = WGPUExternalTextureDescriptor(
											nextInChain: pointer,
											label: label,
											plane0: plane0,
											plane1: plane1,
											cropOrigin: cropOrigin,
											cropSize: cropSize,
											apparentSize: apparentSize,
											doYuvToRgbConversionOnly: doYuvToRgbConversionOnly,
											yuvToRgbConversionMatrix: yuvToRgbConversionMatrix,
											srcTransferFunctionParameters:
												srcTransferFunctionParameters,
											dstTransferFunctionParameters:
												dstTransferFunctionParameters,
											gamutConversionMatrix: gamutConversionMatrix,
											mirrored: mirrored,
											rotation: rotation
										)
										return lambda(&wgpuStruct)
									}
								}()
							}
						}
					}
				}
			}()
		}
	}
}

extension WGPUFragmentState: RootStruct {
}

public struct GPUFragmentState: GPURootStruct {
	public typealias WGPUType = WGPUFragmentState

	public var module: GPUShaderModule
	public var entryPoint: String?
	public var constants: [GPUConstantEntry]
	public var targets: [GPUColorTargetState]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		module: GPUShaderModule,
		entryPoint: String? = nil,
		constants: [GPUConstantEntry] = [],
		targets: [GPUColorTargetState] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.constants = constants
		self.targets = targets
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUFragmentState) -> R
	) -> R {
		let constantCount = constants.count
		let targetCount = targets.count
		return entryPoint.withWGPUStruct { entryPoint in
			withWGPUArrayPointer(constants) { constants in
				withWGPUArrayPointer(targets) { targets in
					withWGPUStructChain { pointer in
						var wgpuStruct = WGPUFragmentState(
							nextInChain: pointer,
							module: module,
							entryPoint: entryPoint,
							constantCount: constantCount,
							constants: constants,
							targetCount: targetCount,
							targets: targets
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}
	}
}

public typealias GPUFuture = WGPUFuture

extension GPUFuture: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUFutureWaitInfo: WGPUStruct {
}

public struct GPUFutureWaitInfo: GPUStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUFutureWaitInfo

	public var future: GPUFuture
	public var completed: Bool

	public init(future: GPUFuture, completed: Bool = false) {
		self.future = future
		self.completed = completed
	}

	public init(wgpuStruct: WGPUFutureWaitInfo) {
		self.future = wgpuStruct.future
		self.completed = Bool(wgpuStruct.completed != 0)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUFutureWaitInfo) -> R
	) -> R {
		return {
			let completed: WGPUBool = completed ? 1 : 0
			return {
				var wgpuStruct = WGPUFutureWaitInfo(future: future, completed: completed)
				return lambda(&wgpuStruct)
			}()
		}()
	}
}

extension WGPUImageCopyExternalTexture: RootStruct {
}

public struct GPUImageCopyExternalTexture: GPURootStruct {
	public typealias WGPUType = WGPUImageCopyExternalTexture

	public var externalTexture: GPUExternalTexture
	public var origin: GPUOrigin3D
	public var naturalSize: GPUExtent2D

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		externalTexture: GPUExternalTexture,
		origin: GPUOrigin3D,
		naturalSize: GPUExtent2D,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.externalTexture = externalTexture
		self.origin = origin
		self.naturalSize = naturalSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUImageCopyExternalTexture) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUImageCopyExternalTexture(
				nextInChain: pointer,
				externalTexture: externalTexture,
				origin: origin,
				naturalSize: naturalSize
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUInstanceDescriptor: RootStruct {
}

public struct GPUInstanceDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUInstanceDescriptor

	public var requiredFeatures: [GPUInstanceFeatureName]?
	public var requiredLimits: GPUInstanceLimits?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		requiredFeatures: [GPUInstanceFeatureName]? = nil,
		requiredLimits: GPUInstanceLimits? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.requiredFeatures = requiredFeatures
		self.requiredLimits = requiredLimits
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUInstanceDescriptor) -> R
	) -> R {
		let requiredFeatureCount = requiredFeatures?.count ?? 0
		return withWGPUArrayPointer(requiredFeatures) { (requiredFeatures: UnsafePointer<WGPUInstanceFeatureName>?) in
			return requiredLimits.withWGPUPointer { requiredLimits in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUInstanceDescriptor(
						nextInChain: pointer,
						requiredFeatureCount: requiredFeatureCount,
						requiredFeatures: requiredFeatures,
						requiredLimits: requiredLimits
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUInstanceLimits: RootStruct {
}

public struct GPUInstanceLimits: GPURootStruct {
	public typealias WGPUType = WGPUInstanceLimits

	public var timedWaitAnyMaxCount: Int

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(timedWaitAnyMaxCount: Int = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.timedWaitAnyMaxCount = timedWaitAnyMaxCount
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUInstanceLimits) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUInstanceLimits(nextInChain: pointer, timedWaitAnyMaxCount: timedWaitAnyMaxCount)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPULimits: RootStruct {
}

public struct GPULimits: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPULimits

	public var maxTextureDimension1D: UInt32
	public var maxTextureDimension2D: UInt32
	public var maxTextureDimension3D: UInt32
	public var maxTextureArrayLayers: UInt32
	public var maxBindGroups: UInt32
	public var maxBindGroupsPlusVertexBuffers: UInt32
	public var maxBindingsPerBindGroup: UInt32
	public var maxDynamicUniformBuffersPerPipelineLayout: UInt32
	public var maxDynamicStorageBuffersPerPipelineLayout: UInt32
	public var maxSampledTexturesPerShaderStage: UInt32
	public var maxSamplersPerShaderStage: UInt32
	public var maxStorageBuffersPerShaderStage: UInt32
	public var maxStorageTexturesPerShaderStage: UInt32
	public var maxUniformBuffersPerShaderStage: UInt32
	public var maxUniformBufferBindingSize: UInt64
	public var maxStorageBufferBindingSize: UInt64
	public var minUniformBufferOffsetAlignment: UInt32
	public var minStorageBufferOffsetAlignment: UInt32
	public var maxVertexBuffers: UInt32
	public var maxBufferSize: UInt64
	public var maxVertexAttributes: UInt32
	public var maxVertexBufferArrayStride: UInt32
	public var maxInterStageShaderVariables: UInt32
	public var maxColorAttachments: UInt32
	public var maxColorAttachmentBytesPerSample: UInt32
	public var maxComputeWorkgroupStorageSize: UInt32
	public var maxComputeInvocationsPerWorkgroup: UInt32
	public var maxComputeWorkgroupSizeX: UInt32
	public var maxComputeWorkgroupSizeY: UInt32
	public var maxComputeWorkgroupSizeZ: UInt32
	public var maxComputeWorkgroupsPerDimension: UInt32
	public var maxImmediateSize: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		maxTextureDimension1D: UInt32 = UInt32.max,
		maxTextureDimension2D: UInt32 = UInt32.max,
		maxTextureDimension3D: UInt32 = UInt32.max,
		maxTextureArrayLayers: UInt32 = UInt32.max,
		maxBindGroups: UInt32 = UInt32.max,
		maxBindGroupsPlusVertexBuffers: UInt32 = UInt32.max,
		maxBindingsPerBindGroup: UInt32 = UInt32.max,
		maxDynamicUniformBuffersPerPipelineLayout: UInt32 = UInt32.max,
		maxDynamicStorageBuffersPerPipelineLayout: UInt32 = UInt32.max,
		maxSampledTexturesPerShaderStage: UInt32 = UInt32.max,
		maxSamplersPerShaderStage: UInt32 = UInt32.max,
		maxStorageBuffersPerShaderStage: UInt32 = UInt32.max,
		maxStorageTexturesPerShaderStage: UInt32 = UInt32.max,
		maxUniformBuffersPerShaderStage: UInt32 = UInt32.max,
		maxUniformBufferBindingSize: UInt64 = UInt64.max,
		maxStorageBufferBindingSize: UInt64 = UInt64.max,
		minUniformBufferOffsetAlignment: UInt32 = UInt32.max,
		minStorageBufferOffsetAlignment: UInt32 = UInt32.max,
		maxVertexBuffers: UInt32 = UInt32.max,
		maxBufferSize: UInt64 = UInt64.max,
		maxVertexAttributes: UInt32 = UInt32.max,
		maxVertexBufferArrayStride: UInt32 = UInt32.max,
		maxInterStageShaderVariables: UInt32 = UInt32.max,
		maxColorAttachments: UInt32 = UInt32.max,
		maxColorAttachmentBytesPerSample: UInt32 = UInt32.max,
		maxComputeWorkgroupStorageSize: UInt32 = UInt32.max,
		maxComputeInvocationsPerWorkgroup: UInt32 = UInt32.max,
		maxComputeWorkgroupSizeX: UInt32 = UInt32.max,
		maxComputeWorkgroupSizeY: UInt32 = UInt32.max,
		maxComputeWorkgroupSizeZ: UInt32 = UInt32.max,
		maxComputeWorkgroupsPerDimension: UInt32 = UInt32.max,
		maxImmediateSize: UInt32 = UInt32.max,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.maxTextureDimension1D = maxTextureDimension1D
		self.maxTextureDimension2D = maxTextureDimension2D
		self.maxTextureDimension3D = maxTextureDimension3D
		self.maxTextureArrayLayers = maxTextureArrayLayers
		self.maxBindGroups = maxBindGroups
		self.maxBindGroupsPlusVertexBuffers = maxBindGroupsPlusVertexBuffers
		self.maxBindingsPerBindGroup = maxBindingsPerBindGroup
		self.maxDynamicUniformBuffersPerPipelineLayout = maxDynamicUniformBuffersPerPipelineLayout
		self.maxDynamicStorageBuffersPerPipelineLayout = maxDynamicStorageBuffersPerPipelineLayout
		self.maxSampledTexturesPerShaderStage = maxSampledTexturesPerShaderStage
		self.maxSamplersPerShaderStage = maxSamplersPerShaderStage
		self.maxStorageBuffersPerShaderStage = maxStorageBuffersPerShaderStage
		self.maxStorageTexturesPerShaderStage = maxStorageTexturesPerShaderStage
		self.maxUniformBuffersPerShaderStage = maxUniformBuffersPerShaderStage
		self.maxUniformBufferBindingSize = maxUniformBufferBindingSize
		self.maxStorageBufferBindingSize = maxStorageBufferBindingSize
		self.minUniformBufferOffsetAlignment = minUniformBufferOffsetAlignment
		self.minStorageBufferOffsetAlignment = minStorageBufferOffsetAlignment
		self.maxVertexBuffers = maxVertexBuffers
		self.maxBufferSize = maxBufferSize
		self.maxVertexAttributes = maxVertexAttributes
		self.maxVertexBufferArrayStride = maxVertexBufferArrayStride
		self.maxInterStageShaderVariables = maxInterStageShaderVariables
		self.maxColorAttachments = maxColorAttachments
		self.maxColorAttachmentBytesPerSample = maxColorAttachmentBytesPerSample
		self.maxComputeWorkgroupStorageSize = maxComputeWorkgroupStorageSize
		self.maxComputeInvocationsPerWorkgroup = maxComputeInvocationsPerWorkgroup
		self.maxComputeWorkgroupSizeX = maxComputeWorkgroupSizeX
		self.maxComputeWorkgroupSizeY = maxComputeWorkgroupSizeY
		self.maxComputeWorkgroupSizeZ = maxComputeWorkgroupSizeZ
		self.maxComputeWorkgroupsPerDimension = maxComputeWorkgroupsPerDimension
		self.maxImmediateSize = maxImmediateSize
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPULimits) {
		self.maxTextureDimension1D = wgpuStruct.maxTextureDimension1D
		self.maxTextureDimension2D = wgpuStruct.maxTextureDimension2D
		self.maxTextureDimension3D = wgpuStruct.maxTextureDimension3D
		self.maxTextureArrayLayers = wgpuStruct.maxTextureArrayLayers
		self.maxBindGroups = wgpuStruct.maxBindGroups
		self.maxBindGroupsPlusVertexBuffers = wgpuStruct.maxBindGroupsPlusVertexBuffers
		self.maxBindingsPerBindGroup = wgpuStruct.maxBindingsPerBindGroup
		self.maxDynamicUniformBuffersPerPipelineLayout = wgpuStruct.maxDynamicUniformBuffersPerPipelineLayout
		self.maxDynamicStorageBuffersPerPipelineLayout = wgpuStruct.maxDynamicStorageBuffersPerPipelineLayout
		self.maxSampledTexturesPerShaderStage = wgpuStruct.maxSampledTexturesPerShaderStage
		self.maxSamplersPerShaderStage = wgpuStruct.maxSamplersPerShaderStage
		self.maxStorageBuffersPerShaderStage = wgpuStruct.maxStorageBuffersPerShaderStage
		self.maxStorageTexturesPerShaderStage = wgpuStruct.maxStorageTexturesPerShaderStage
		self.maxUniformBuffersPerShaderStage = wgpuStruct.maxUniformBuffersPerShaderStage
		self.maxUniformBufferBindingSize = wgpuStruct.maxUniformBufferBindingSize
		self.maxStorageBufferBindingSize = wgpuStruct.maxStorageBufferBindingSize
		self.minUniformBufferOffsetAlignment = wgpuStruct.minUniformBufferOffsetAlignment
		self.minStorageBufferOffsetAlignment = wgpuStruct.minStorageBufferOffsetAlignment
		self.maxVertexBuffers = wgpuStruct.maxVertexBuffers
		self.maxBufferSize = wgpuStruct.maxBufferSize
		self.maxVertexAttributes = wgpuStruct.maxVertexAttributes
		self.maxVertexBufferArrayStride = wgpuStruct.maxVertexBufferArrayStride
		self.maxInterStageShaderVariables = wgpuStruct.maxInterStageShaderVariables
		self.maxColorAttachments = wgpuStruct.maxColorAttachments
		self.maxColorAttachmentBytesPerSample = wgpuStruct.maxColorAttachmentBytesPerSample
		self.maxComputeWorkgroupStorageSize = wgpuStruct.maxComputeWorkgroupStorageSize
		self.maxComputeInvocationsPerWorkgroup = wgpuStruct.maxComputeInvocationsPerWorkgroup
		self.maxComputeWorkgroupSizeX = wgpuStruct.maxComputeWorkgroupSizeX
		self.maxComputeWorkgroupSizeY = wgpuStruct.maxComputeWorkgroupSizeY
		self.maxComputeWorkgroupSizeZ = wgpuStruct.maxComputeWorkgroupSizeZ
		self.maxComputeWorkgroupsPerDimension = wgpuStruct.maxComputeWorkgroupsPerDimension
		self.maxImmediateSize = wgpuStruct.maxImmediateSize
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPULimits) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPULimits(
				nextInChain: pointer,
				maxTextureDimension1D: maxTextureDimension1D,
				maxTextureDimension2D: maxTextureDimension2D,
				maxTextureDimension3D: maxTextureDimension3D,
				maxTextureArrayLayers: maxTextureArrayLayers,
				maxBindGroups: maxBindGroups,
				maxBindGroupsPlusVertexBuffers: maxBindGroupsPlusVertexBuffers,
				maxBindingsPerBindGroup: maxBindingsPerBindGroup,
				maxDynamicUniformBuffersPerPipelineLayout: maxDynamicUniformBuffersPerPipelineLayout,
				maxDynamicStorageBuffersPerPipelineLayout: maxDynamicStorageBuffersPerPipelineLayout,
				maxSampledTexturesPerShaderStage: maxSampledTexturesPerShaderStage,
				maxSamplersPerShaderStage: maxSamplersPerShaderStage,
				maxStorageBuffersPerShaderStage: maxStorageBuffersPerShaderStage,
				maxStorageTexturesPerShaderStage: maxStorageTexturesPerShaderStage,
				maxUniformBuffersPerShaderStage: maxUniformBuffersPerShaderStage,
				maxUniformBufferBindingSize: maxUniformBufferBindingSize,
				maxStorageBufferBindingSize: maxStorageBufferBindingSize,
				minUniformBufferOffsetAlignment: minUniformBufferOffsetAlignment,
				minStorageBufferOffsetAlignment: minStorageBufferOffsetAlignment,
				maxVertexBuffers: maxVertexBuffers,
				maxBufferSize: maxBufferSize,
				maxVertexAttributes: maxVertexAttributes,
				maxVertexBufferArrayStride: maxVertexBufferArrayStride,
				maxInterStageShaderVariables: maxInterStageShaderVariables,
				maxColorAttachments: maxColorAttachments,
				maxColorAttachmentBytesPerSample: maxColorAttachmentBytesPerSample,
				maxComputeWorkgroupStorageSize: maxComputeWorkgroupStorageSize,
				maxComputeInvocationsPerWorkgroup: maxComputeInvocationsPerWorkgroup,
				maxComputeWorkgroupSizeX: maxComputeWorkgroupSizeX,
				maxComputeWorkgroupSizeY: maxComputeWorkgroupSizeY,
				maxComputeWorkgroupSizeZ: maxComputeWorkgroupSizeZ,
				maxComputeWorkgroupsPerDimension: maxComputeWorkgroupsPerDimension,
				maxImmediateSize: maxImmediateSize
			)
			return lambda(&wgpuStruct)
		}
	}
}

public typealias GPUMemoryHeapInfo = WGPUMemoryHeapInfo

extension GPUMemoryHeapInfo: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUMultisampleState: RootStruct {
}

public struct GPUMultisampleState: GPURootStruct {
	public typealias WGPUType = WGPUMultisampleState

	public var count: UInt32
	public var mask: UInt32
	public var alphaToCoverageEnabled: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		count: UInt32 = 1,
		mask: UInt32 = 0xFFFFFFFF,
		alphaToCoverageEnabled: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.count = count
		self.mask = mask
		self.alphaToCoverageEnabled = alphaToCoverageEnabled
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUMultisampleState) -> R
	) -> R {
		return {
			let alphaToCoverageEnabled: WGPUBool = alphaToCoverageEnabled ? 1 : 0
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPUMultisampleState(
					nextInChain: pointer,
					count: count,
					mask: mask,
					alphaToCoverageEnabled: alphaToCoverageEnabled
				)
				return lambda(&wgpuStruct)
			}
		}()
	}
}

public typealias GPUOrigin2D = WGPUOrigin2D

extension GPUOrigin2D: GPUSimpleStruct {
	public typealias WGPUType = Self
}

public typealias GPUOrigin3D = WGPUOrigin3D

extension GPUOrigin3D: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUPassTimestampWrites: RootStruct {
}

public struct GPUPassTimestampWrites: GPURootStruct {
	public typealias WGPUType = WGPUPassTimestampWrites

	public var querySet: GPUQuerySet
	public var beginningOfPassWriteIndex: UInt32
	public var endOfPassWriteIndex: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		querySet: GPUQuerySet,
		beginningOfPassWriteIndex: UInt32 = UInt32.max,
		endOfPassWriteIndex: UInt32 = UInt32.max,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.querySet = querySet
		self.beginningOfPassWriteIndex = beginningOfPassWriteIndex
		self.endOfPassWriteIndex = endOfPassWriteIndex
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPassTimestampWrites) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUPassTimestampWrites(
				nextInChain: pointer,
				querySet: querySet,
				beginningOfPassWriteIndex: beginningOfPassWriteIndex,
				endOfPassWriteIndex: endOfPassWriteIndex
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUPipelineLayoutDescriptor: RootStruct {
}

public struct GPUPipelineLayoutDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUPipelineLayoutDescriptor

	public var label: String?
	public var bindGroupLayouts: [GPUBindGroupLayout]
	public var immediateSize: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		bindGroupLayouts: [GPUBindGroupLayout] = [],
		immediateSize: UInt32 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.bindGroupLayouts = bindGroupLayouts
		self.immediateSize = immediateSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPipelineLayoutDescriptor) -> R
	) -> R {
		let bindGroupLayoutCount = bindGroupLayouts.count
		return label.withWGPUStruct { label in
			bindGroupLayouts.unwrapWGPUObjectArray { bindGroupLayouts in
				withWGPUStructChain { pointer in
					var wgpuStruct = WGPUPipelineLayoutDescriptor(
						nextInChain: pointer,
						label: label,
						bindGroupLayoutCount: bindGroupLayoutCount,
						bindGroupLayouts: bindGroupLayouts,
						immediateSize: immediateSize
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUPipelineLayoutPixelLocalStorage: ChainedStruct {
}

public struct GPUPipelineLayoutPixelLocalStorage: GPUChainedStruct {
	public typealias WGPUType = WGPUPipelineLayoutPixelLocalStorage
	public let sType: GPUSType = .pipelineLayoutPixelLocalStorage
	public var totalPixelLocalStorageSize: UInt64
	public var storageAttachments: [GPUPipelineLayoutStorageAttachment]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		totalPixelLocalStorageSize: UInt64 = 0,
		storageAttachments: [GPUPipelineLayoutStorageAttachment] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.totalPixelLocalStorageSize = totalPixelLocalStorageSize
		self.storageAttachments = storageAttachments
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPipelineLayoutPixelLocalStorage) -> R
	) -> R {
		let storageAttachmentCount = storageAttachments.count
		return withWGPUArrayPointer(storageAttachments) { storageAttachments in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUPipelineLayoutPixelLocalStorage(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						totalPixelLocalStorageSize: totalPixelLocalStorageSize,
						storageAttachmentCount: storageAttachmentCount,
						storageAttachments: storageAttachments
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUPipelineLayoutPixelLocalStorage(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							totalPixelLocalStorageSize: totalPixelLocalStorageSize,
							storageAttachmentCount: storageAttachmentCount,
							storageAttachments: storageAttachments
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUPipelineLayoutResourceTable: ChainedStruct {
}

public struct GPUPipelineLayoutResourceTable: GPUChainedStruct {
	public typealias WGPUType = WGPUPipelineLayoutResourceTable
	public let sType: GPUSType = .pipelineLayoutResourceTable
	public var usesResourceTable: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(usesResourceTable: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.usesResourceTable = usesResourceTable
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPipelineLayoutResourceTable) -> R
	) -> R {
		return {
			let usesResourceTable: WGPUBool = usesResourceTable ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUPipelineLayoutResourceTable(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						usesResourceTable: usesResourceTable
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUPipelineLayoutResourceTable(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							usesResourceTable: usesResourceTable
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUPipelineLayoutStorageAttachment: RootStruct {
}

public struct GPUPipelineLayoutStorageAttachment: GPURootStruct {
	public typealias WGPUType = WGPUPipelineLayoutStorageAttachment

	public var offset: UInt64
	public var format: GPUTextureFormat

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(offset: UInt64 = 0, format: GPUTextureFormat = .undefined, nextInChain: (any GPUChainedStruct)? = nil) {
		self.offset = offset
		self.format = format
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPipelineLayoutStorageAttachment) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUPipelineLayoutStorageAttachment(nextInChain: pointer, offset: offset, format: format)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUPrimitiveState: RootStruct {
}

public struct GPUPrimitiveState: GPURootStruct {
	public typealias WGPUType = WGPUPrimitiveState

	public var topology: GPUPrimitiveTopology
	public var stripIndexFormat: GPUIndexFormat
	public var frontFace: GPUFrontFace
	public var cullMode: GPUCullMode
	public var unclippedDepth: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		topology: GPUPrimitiveTopology = .triangleList,
		stripIndexFormat: GPUIndexFormat = .undefined,
		frontFace: GPUFrontFace = .CCW,
		cullMode: GPUCullMode = .none,
		unclippedDepth: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.topology = topology
		self.stripIndexFormat = stripIndexFormat
		self.frontFace = frontFace
		self.cullMode = cullMode
		self.unclippedDepth = unclippedDepth
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUPrimitiveState) -> R
	) -> R {
		return {
			let unclippedDepth: WGPUBool = unclippedDepth ? 1 : 0
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPUPrimitiveState(
					nextInChain: pointer,
					topology: topology,
					stripIndexFormat: stripIndexFormat,
					frontFace: frontFace,
					cullMode: cullMode,
					unclippedDepth: unclippedDepth
				)
				return lambda(&wgpuStruct)
			}
		}()
	}
}

extension WGPUQuerySetDescriptor: RootStruct {
}

public struct GPUQuerySetDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUQuerySetDescriptor

	public var label: String?
	public var type: GPUQueryType
	public var count: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, type: GPUQueryType = .occlusion, count: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.type = type
		self.count = count
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUQuerySetDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUQuerySetDescriptor(nextInChain: pointer, label: label, type: type, count: count)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUQueueDescriptor: RootStruct {
}

public struct GPUQueueDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUQueueDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUQueueDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUQueueDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPURenderBundleDescriptor: RootStruct {
}

public struct GPURenderBundleDescriptor: GPURootStruct {
	public typealias WGPUType = WGPURenderBundleDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderBundleDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPURenderBundleDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPURenderBundleEncoderDescriptor: RootStruct {
}

public struct GPURenderBundleEncoderDescriptor: GPURootStruct {
	public typealias WGPUType = WGPURenderBundleEncoderDescriptor

	public var label: String?
	public var colorFormats: [GPUTextureFormat]
	public var depthStencilFormat: GPUTextureFormat
	public var sampleCount: UInt32
	public var depthReadOnly: Bool
	public var stencilReadOnly: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		colorFormats: [GPUTextureFormat] = [],
		depthStencilFormat: GPUTextureFormat = .undefined,
		sampleCount: UInt32 = 1,
		depthReadOnly: Bool = false,
		stencilReadOnly: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.colorFormats = colorFormats
		self.depthStencilFormat = depthStencilFormat
		self.sampleCount = sampleCount
		self.depthReadOnly = depthReadOnly
		self.stencilReadOnly = stencilReadOnly
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderBundleEncoderDescriptor) -> R
	) -> R {
		let colorFormatCount = colorFormats.count
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(colorFormats) { (colorFormats: UnsafePointer<WGPUTextureFormat>) in
				return {
					let depthReadOnly: WGPUBool = depthReadOnly ? 1 : 0
					return {
						let stencilReadOnly: WGPUBool = stencilReadOnly ? 1 : 0
						return withWGPUStructChain { pointer in
							var wgpuStruct = WGPURenderBundleEncoderDescriptor(
								nextInChain: pointer,
								label: label,
								colorFormatCount: colorFormatCount,
								colorFormats: colorFormats,
								depthStencilFormat: depthStencilFormat,
								sampleCount: sampleCount,
								depthReadOnly: depthReadOnly,
								stencilReadOnly: stencilReadOnly
							)
							return lambda(&wgpuStruct)
						}
					}()
				}()
			}
		}
	}
}

extension WGPURenderPassColorAttachment: RootStruct {
}

public struct GPURenderPassColorAttachment: GPURootStruct {
	public typealias WGPUType = WGPURenderPassColorAttachment

	public var view: GPUTextureView?
	public var depthSlice: UInt32
	public var resolveTarget: GPUTextureView?
	public var loadOp: GPULoadOp
	public var storeOp: GPUStoreOp
	public var clearValue: GPUColor

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		view: GPUTextureView? = nil,
		depthSlice: UInt32 = UInt32.max,
		resolveTarget: GPUTextureView? = nil,
		loadOp: GPULoadOp = .undefined,
		storeOp: GPUStoreOp = .undefined,
		clearValue: GPUColor,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.view = view
		self.depthSlice = depthSlice
		self.resolveTarget = resolveTarget
		self.loadOp = loadOp
		self.storeOp = storeOp
		self.clearValue = clearValue
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassColorAttachment) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPURenderPassColorAttachment(
				nextInChain: pointer,
				view: view,
				depthSlice: depthSlice,
				resolveTarget: resolveTarget,
				loadOp: loadOp,
				storeOp: storeOp,
				clearValue: clearValue
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPURenderPassDepthStencilAttachment: RootStruct {
}

public struct GPURenderPassDepthStencilAttachment: GPURootStruct {
	public typealias WGPUType = WGPURenderPassDepthStencilAttachment

	public var view: GPUTextureView
	public var depthLoadOp: GPULoadOp
	public var depthStoreOp: GPUStoreOp
	public var depthClearValue: Float
	public var depthReadOnly: Bool
	public var stencilLoadOp: GPULoadOp
	public var stencilStoreOp: GPUStoreOp
	public var stencilClearValue: UInt32
	public var stencilReadOnly: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		view: GPUTextureView,
		depthLoadOp: GPULoadOp = .undefined,
		depthStoreOp: GPUStoreOp = .undefined,
		depthClearValue: Float = Float.nan,
		depthReadOnly: Bool = false,
		stencilLoadOp: GPULoadOp = .undefined,
		stencilStoreOp: GPUStoreOp = .undefined,
		stencilClearValue: UInt32 = 0,
		stencilReadOnly: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.view = view
		self.depthLoadOp = depthLoadOp
		self.depthStoreOp = depthStoreOp
		self.depthClearValue = depthClearValue
		self.depthReadOnly = depthReadOnly
		self.stencilLoadOp = stencilLoadOp
		self.stencilStoreOp = stencilStoreOp
		self.stencilClearValue = stencilClearValue
		self.stencilReadOnly = stencilReadOnly
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassDepthStencilAttachment) -> R
	) -> R {
		return {
			let depthReadOnly: WGPUBool = depthReadOnly ? 1 : 0
			return {
				let stencilReadOnly: WGPUBool = stencilReadOnly ? 1 : 0
				return withWGPUStructChain { pointer in
					var wgpuStruct = WGPURenderPassDepthStencilAttachment(
						nextInChain: pointer,
						view: view,
						depthLoadOp: depthLoadOp,
						depthStoreOp: depthStoreOp,
						depthClearValue: depthClearValue,
						depthReadOnly: depthReadOnly,
						stencilLoadOp: stencilLoadOp,
						stencilStoreOp: stencilStoreOp,
						stencilClearValue: stencilClearValue,
						stencilReadOnly: stencilReadOnly
					)
					return lambda(&wgpuStruct)
				}
			}()
		}()
	}
}

extension WGPURenderPassDescriptor: RootStruct {
}

public struct GPURenderPassDescriptor: GPURootStruct {
	public typealias WGPUType = WGPURenderPassDescriptor

	public var label: String?
	public var colorAttachments: [GPURenderPassColorAttachment]
	public var depthStencilAttachment: GPURenderPassDepthStencilAttachment?
	public var occlusionQuerySet: GPUQuerySet?
	public var timestampWrites: GPUPassTimestampWrites?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		colorAttachments: [GPURenderPassColorAttachment] = [],
		depthStencilAttachment: GPURenderPassDepthStencilAttachment? = nil,
		occlusionQuerySet: GPUQuerySet? = nil,
		timestampWrites: GPUPassTimestampWrites? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.colorAttachments = colorAttachments
		self.depthStencilAttachment = depthStencilAttachment
		self.occlusionQuerySet = occlusionQuerySet
		self.timestampWrites = timestampWrites
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassDescriptor) -> R
	) -> R {
		let colorAttachmentCount = colorAttachments.count
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(colorAttachments) { colorAttachments in
				depthStencilAttachment.withWGPUPointer { depthStencilAttachment in
					timestampWrites.withWGPUPointer { timestampWrites in
						withWGPUStructChain { pointer in
							var wgpuStruct = WGPURenderPassDescriptor(
								nextInChain: pointer,
								label: label,
								colorAttachmentCount: colorAttachmentCount,
								colorAttachments: colorAttachments,
								depthStencilAttachment: depthStencilAttachment,
								occlusionQuerySet: occlusionQuerySet,
								timestampWrites: timestampWrites
							)
							return lambda(&wgpuStruct)
						}
					}
				}
			}
		}
	}
}

extension WGPURenderPassDescriptorExpandResolveRect: ChainedStruct {
}

public struct GPURenderPassDescriptorExpandResolveRect: GPUChainedStruct {
	public typealias WGPUType = WGPURenderPassDescriptorExpandResolveRect
	public let sType: GPUSType = .renderPassDescriptorExpandResolveRect
	public var x: UInt32
	public var y: UInt32
	public var width: UInt32
	public var height: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(x: UInt32 = 0, y: UInt32 = 0, width: UInt32 = 0, height: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassDescriptorExpandResolveRect) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPURenderPassDescriptorExpandResolveRect(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					x: x,
					y: y,
					width: width,
					height: height
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPURenderPassDescriptorExpandResolveRect(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						x: x,
						y: y,
						width: width,
						height: height
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPURenderPassDescriptorResolveRect: ChainedStruct {
}

public struct GPURenderPassDescriptorResolveRect: GPUChainedStruct {
	public typealias WGPUType = WGPURenderPassDescriptorResolveRect
	public let sType: GPUSType = .renderPassDescriptorResolveRect
	public var colorOffsetX: UInt32
	public var colorOffsetY: UInt32
	public var resolveOffsetX: UInt32
	public var resolveOffsetY: UInt32
	public var width: UInt32
	public var height: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		colorOffsetX: UInt32 = 0,
		colorOffsetY: UInt32 = 0,
		resolveOffsetX: UInt32 = 0,
		resolveOffsetY: UInt32 = 0,
		width: UInt32 = 0,
		height: UInt32 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.colorOffsetX = colorOffsetX
		self.colorOffsetY = colorOffsetY
		self.resolveOffsetX = resolveOffsetX
		self.resolveOffsetY = resolveOffsetY
		self.width = width
		self.height = height
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassDescriptorResolveRect) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPURenderPassDescriptorResolveRect(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					colorOffsetX: colorOffsetX,
					colorOffsetY: colorOffsetY,
					resolveOffsetX: resolveOffsetX,
					resolveOffsetY: resolveOffsetY,
					width: width,
					height: height
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPURenderPassDescriptorResolveRect(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						colorOffsetX: colorOffsetX,
						colorOffsetY: colorOffsetY,
						resolveOffsetX: resolveOffsetX,
						resolveOffsetY: resolveOffsetY,
						width: width,
						height: height
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPURenderPassMaxDrawCount: ChainedStruct {
}

public struct GPURenderPassMaxDrawCount: GPUChainedStruct {
	public typealias WGPUType = WGPURenderPassMaxDrawCount
	public let sType: GPUSType = .renderPassMaxDrawCount
	public var maxDrawCount: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(maxDrawCount: UInt64 = 50000000, nextInChain: (any GPUChainedStruct)? = nil) {
		self.maxDrawCount = maxDrawCount
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassMaxDrawCount) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPURenderPassMaxDrawCount(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					maxDrawCount: maxDrawCount
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPURenderPassMaxDrawCount(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						maxDrawCount: maxDrawCount
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPURenderPassPixelLocalStorage: ChainedStruct {
}

public struct GPURenderPassPixelLocalStorage: GPUChainedStruct {
	public typealias WGPUType = WGPURenderPassPixelLocalStorage
	public let sType: GPUSType = .renderPassPixelLocalStorage
	public var totalPixelLocalStorageSize: UInt64
	public var storageAttachments: [GPURenderPassStorageAttachment]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		totalPixelLocalStorageSize: UInt64 = 0,
		storageAttachments: [GPURenderPassStorageAttachment] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.totalPixelLocalStorageSize = totalPixelLocalStorageSize
		self.storageAttachments = storageAttachments
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassPixelLocalStorage) -> R
	) -> R {
		let storageAttachmentCount = storageAttachments.count
		return withWGPUArrayPointer(storageAttachments) { storageAttachments in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPURenderPassPixelLocalStorage(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						totalPixelLocalStorageSize: totalPixelLocalStorageSize,
						storageAttachmentCount: storageAttachmentCount,
						storageAttachments: storageAttachments
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPURenderPassPixelLocalStorage(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							totalPixelLocalStorageSize: totalPixelLocalStorageSize,
							storageAttachmentCount: storageAttachmentCount,
							storageAttachments: storageAttachments
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPURenderPassStorageAttachment: RootStruct {
}

public struct GPURenderPassStorageAttachment: GPURootStruct {
	public typealias WGPUType = WGPURenderPassStorageAttachment

	public var offset: UInt64
	public var storage: GPUTextureView
	public var loadOp: GPULoadOp
	public var storeOp: GPUStoreOp
	public var clearValue: GPUColor

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		offset: UInt64 = 0,
		storage: GPUTextureView,
		loadOp: GPULoadOp = .undefined,
		storeOp: GPUStoreOp = .undefined,
		clearValue: GPUColor,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.offset = offset
		self.storage = storage
		self.loadOp = loadOp
		self.storeOp = storeOp
		self.clearValue = clearValue
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPassStorageAttachment) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPURenderPassStorageAttachment(
				nextInChain: pointer,
				offset: offset,
				storage: storage,
				loadOp: loadOp,
				storeOp: storeOp,
				clearValue: clearValue
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPURenderPipelineDescriptor: RootStruct {
}

public struct GPURenderPipelineDescriptor: GPURootStruct {
	public typealias WGPUType = WGPURenderPipelineDescriptor

	public var label: String?
	public var layout: GPUPipelineLayout?
	public var vertex: GPUVertexState
	public var primitive: GPUPrimitiveState
	public var depthStencil: GPUDepthStencilState?
	public var multisample: GPUMultisampleState
	public var fragment: GPUFragmentState?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		layout: GPUPipelineLayout? = nil,
		vertex: GPUVertexState,
		primitive: GPUPrimitiveState,
		depthStencil: GPUDepthStencilState? = nil,
		multisample: GPUMultisampleState,
		fragment: GPUFragmentState? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.layout = layout
		self.vertex = vertex
		self.primitive = primitive
		self.depthStencil = depthStencil
		self.multisample = multisample
		self.fragment = fragment
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURenderPipelineDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			vertex.withWGPUStruct() { vertex in
				primitive.withWGPUStruct() { primitive in
					depthStencil.withWGPUPointer { depthStencil in
						multisample.withWGPUStruct() { multisample in
							fragment.withWGPUPointer { fragment in
								withWGPUStructChain { pointer in
									var wgpuStruct = WGPURenderPipelineDescriptor(
										nextInChain: pointer,
										label: label,
										layout: layout,
										vertex: vertex,
										primitive: primitive,
										depthStencil: depthStencil,
										multisample: multisample,
										fragment: fragment
									)
									return lambda(&wgpuStruct)
								}
							}
						}
					}
				}
			}
		}
	}
}

extension WGPURequestAdapterWebGPUBackendOptions: ChainedStruct {
}

public struct GPURequestAdapterWebGPUBackendOptions: GPUChainedStruct {
	public typealias WGPUType = WGPURequestAdapterWebGPUBackendOptions
	public let sType: GPUSType = .requestAdapterWebGPUBackendOptions

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(nextInChain: (any GPUChainedStruct)? = nil) {
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestAdapterWebGPUBackendOptions) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPURequestAdapterWebGPUBackendOptions(chain: WGPUChainedStruct(next: nil, sType: sType), )
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPURequestAdapterWebGPUBackendOptions(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPURequestAdapterWebXROptions: ChainedStruct {
}

public struct GPURequestAdapterWebXROptions: GPUChainedStruct {
	public typealias WGPUType = WGPURequestAdapterWebXROptions
	public let sType: GPUSType = .requestAdapterWebXROptions
	public var xrCompatible: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(xrCompatible: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.xrCompatible = xrCompatible
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestAdapterWebXROptions) -> R
	) -> R {
		return {
			let xrCompatible: WGPUBool = xrCompatible ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPURequestAdapterWebXROptions(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						xrCompatible: xrCompatible
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPURequestAdapterWebXROptions(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							xrCompatible: xrCompatible
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPURequestAdapterOptions: RootStruct {
}

public struct GPURequestAdapterOptions: GPURootStruct {
	public typealias WGPUType = WGPURequestAdapterOptions

	public var featureLevel: GPUFeatureLevel
	public var powerPreference: GPUPowerPreference
	public var forceFallbackAdapter: Bool
	public var backendType: GPUBackendType
	public var compatibleSurface: GPUSurface?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		featureLevel: GPUFeatureLevel = .core,
		powerPreference: GPUPowerPreference = .undefined,
		forceFallbackAdapter: Bool = false,
		backendType: GPUBackendType = .undefined,
		compatibleSurface: GPUSurface? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.featureLevel = featureLevel
		self.powerPreference = powerPreference
		self.forceFallbackAdapter = forceFallbackAdapter
		self.backendType = backendType
		self.compatibleSurface = compatibleSurface
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPURequestAdapterOptions) -> R
	) -> R {
		return {
			let forceFallbackAdapter: WGPUBool = forceFallbackAdapter ? 1 : 0
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPURequestAdapterOptions(
					nextInChain: pointer,
					featureLevel: featureLevel,
					powerPreference: powerPreference,
					forceFallbackAdapter: forceFallbackAdapter,
					backendType: backendType,
					compatibleSurface: compatibleSurface
				)
				return lambda(&wgpuStruct)
			}
		}()
	}
}

extension WGPUResourceTableDescriptor: RootStruct {
}

public struct GPUResourceTableDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUResourceTableDescriptor

	public var label: String?
	public var size: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, size: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.size = size
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUResourceTableDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUResourceTableDescriptor(nextInChain: pointer, label: label, size: size)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUResourceTableLimits: ChainedStruct {
}

public struct GPUResourceTableLimits: GPUChainedStruct {
	public typealias WGPUType = WGPUResourceTableLimits
	public let sType: GPUSType = .resourceTableLimits
	public var maxResourceTableSize: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(maxResourceTableSize: UInt32 = UInt32.max, nextInChain: (any GPUChainedStruct)? = nil) {
		self.maxResourceTableSize = maxResourceTableSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUResourceTableLimits) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUResourceTableLimits(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					maxResourceTableSize: maxResourceTableSize
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUResourceTableLimits(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						maxResourceTableSize: maxResourceTableSize
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSamplerBindingLayout: RootStruct {
}

public struct GPUSamplerBindingLayout: GPURootStruct {
	public typealias WGPUType = WGPUSamplerBindingLayout

	public var type: GPUSamplerBindingType

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(type: GPUSamplerBindingType = .filtering, nextInChain: (any GPUChainedStruct)? = nil) {
		self.type = type
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSamplerBindingLayout) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUSamplerBindingLayout(nextInChain: pointer, type: type)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUSamplerDescriptor: RootStruct {
}

public struct GPUSamplerDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSamplerDescriptor

	public var label: String?
	public var addressModeU: GPUAddressMode
	public var addressModeV: GPUAddressMode
	public var addressModeW: GPUAddressMode
	public var magFilter: GPUFilterMode
	public var minFilter: GPUFilterMode
	public var mipmapFilter: GPUMipmapFilterMode
	public var lodMinClamp: Float
	public var lodMaxClamp: Float
	public var compare: GPUCompareFunction
	public var maxAnisotropy: UInt16

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		addressModeU: GPUAddressMode = .clampToEdge,
		addressModeV: GPUAddressMode = .clampToEdge,
		addressModeW: GPUAddressMode = .clampToEdge,
		magFilter: GPUFilterMode = .nearest,
		minFilter: GPUFilterMode = .nearest,
		mipmapFilter: GPUMipmapFilterMode = .nearest,
		lodMinClamp: Float = 0.0,
		lodMaxClamp: Float = 32.0,
		compare: GPUCompareFunction = .undefined,
		maxAnisotropy: UInt16 = 1,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.addressModeU = addressModeU
		self.addressModeV = addressModeV
		self.addressModeW = addressModeW
		self.magFilter = magFilter
		self.minFilter = minFilter
		self.mipmapFilter = mipmapFilter
		self.lodMinClamp = lodMinClamp
		self.lodMaxClamp = lodMaxClamp
		self.compare = compare
		self.maxAnisotropy = maxAnisotropy
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSamplerDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSamplerDescriptor(
					nextInChain: pointer,
					label: label,
					addressModeU: addressModeU,
					addressModeV: addressModeV,
					addressModeW: addressModeW,
					magFilter: magFilter,
					minFilter: minFilter,
					mipmapFilter: mipmapFilter,
					lodMinClamp: lodMinClamp,
					lodMaxClamp: lodMaxClamp,
					compare: compare,
					maxAnisotropy: maxAnisotropy
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUShaderModuleCompilationOptions: ChainedStruct {
}

public struct GPUShaderModuleCompilationOptions: GPUChainedStruct {
	public typealias WGPUType = WGPUShaderModuleCompilationOptions
	public let sType: GPUSType = .shaderModuleCompilationOptions
	public var strictMath: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(strictMath: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.strictMath = strictMath
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUShaderModuleCompilationOptions) -> R
	) -> R {
		return {
			let strictMath: WGPUBool = strictMath ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUShaderModuleCompilationOptions(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						strictMath: strictMath
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUShaderModuleCompilationOptions(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							strictMath: strictMath
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUShaderModuleDescriptor: RootStruct {
}

public struct GPUShaderModuleDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUShaderModuleDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUShaderModuleDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUShaderModuleDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUShaderSourceSPIRV: ChainedStruct {
}

public struct GPUShaderSourceSPIRV: GPUChainedStruct {
	public typealias WGPUType = WGPUShaderSourceSPIRV
	public let sType: GPUSType = .shaderSourceSPIRV
	public var code: [UInt32]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(code: [UInt32]? = [], nextInChain: (any GPUChainedStruct)? = nil) {
		self.code = code
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUShaderSourceSPIRV) -> R
	) -> R {
		let codeSize = UInt32(code?.count ?? 0)
		return withWGPUArrayPointer(code) { code in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUShaderSourceSPIRV(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						codeSize: codeSize,
						code: code
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUShaderSourceSPIRV(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							codeSize: codeSize,
							code: code
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUShaderSourceWGSL: ChainedStruct {
}

public struct GPUShaderSourceWGSL: GPUChainedStruct {
	public typealias WGPUType = WGPUShaderSourceWGSL
	public let sType: GPUSType = .shaderSourceWGSL
	public var code: String

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(code: String = "", nextInChain: (any GPUChainedStruct)? = nil) {
		self.code = code
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUShaderSourceWGSL) -> R
	) -> R {
		return code.withWGPUStruct { code in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUShaderSourceWGSL(chain: WGPUChainedStruct(next: nil, sType: sType), code: code)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUShaderSourceWGSL(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							code: code
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUSharedBufferMemoryBeginAccessDescriptor: RootStruct {
}

public struct GPUSharedBufferMemoryBeginAccessDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSharedBufferMemoryBeginAccessDescriptor

	public var initialized: Bool
	public var fences: [GPUSharedFence]
	public var signaledValues: [UInt64]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		initialized: Bool = false,
		fences: [GPUSharedFence] = [],
		signaledValues: [UInt64]? = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.initialized = initialized
		self.fences = fences
		self.signaledValues = signaledValues
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryBeginAccessDescriptor) -> R
	) -> R {
		let fenceCount = fences.count
		return {
			let initialized: WGPUBool = initialized ? 1 : 0
			return fences.unwrapWGPUObjectArray { fences in
				withWGPUArrayPointer(signaledValues) { signaledValues in
					withWGPUStructChain { pointer in
						var wgpuStruct = WGPUSharedBufferMemoryBeginAccessDescriptor(
							nextInChain: pointer,
							initialized: initialized,
							fenceCount: fenceCount,
							fences: fences,
							signaledValues: signaledValues
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}()
	}
}

extension WGPUSharedBufferMemoryDescriptor: RootStruct {
}

public struct GPUSharedBufferMemoryDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSharedBufferMemoryDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSharedBufferMemoryDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUSharedBufferMemoryEndAccessState: RootStruct {
}

public struct GPUSharedBufferMemoryEndAccessState: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSharedBufferMemoryEndAccessState

	public var initialized: Bool
	public var fences: [GPUSharedFence]
	public var signaledValues: [UInt64]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		initialized: Bool = false,
		fences: [GPUSharedFence] = [],
		signaledValues: [UInt64]? = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.initialized = initialized
		self.fences = fences
		self.signaledValues = signaledValues
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSharedBufferMemoryEndAccessState) {
		self.initialized = Bool(wgpuStruct.initialized != 0)
		self.fences = wgpuStruct.fences.wrapWGPUArrayWithCount(wgpuStruct.fenceCount)
		self.signaledValues = wgpuStruct.signaledValues.wrapArrayWithCount(wgpuStruct.fenceCount)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryEndAccessState) -> R
	) -> R {
		let fenceCount = fences.count
		return {
			let initialized: WGPUBool = initialized ? 1 : 0
			return fences.unwrapWGPUObjectArray { fences in
				withWGPUArrayPointer(signaledValues) { signaledValues in
					withWGPUStructChain { pointer in
						var wgpuStruct = WGPUSharedBufferMemoryEndAccessState(
							nextInChain: pointer,
							initialized: initialized,
							fenceCount: fenceCount,
							fences: fences,
							signaledValues: signaledValues
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}()
	}
}

extension WGPUSharedBufferMemoryProperties: RootStruct {
}

public struct GPUSharedBufferMemoryProperties: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSharedBufferMemoryProperties

	public var usage: GPUBufferUsage
	public var size: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(usage: GPUBufferUsage = GPUBufferUsage(), size: UInt64 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.usage = usage
		self.size = size
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSharedBufferMemoryProperties) {
		self.usage = wgpuStruct.usage
		self.size = wgpuStruct.size
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedBufferMemoryProperties) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUSharedBufferMemoryProperties(nextInChain: pointer, usage: usage, size: size)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUSharedFenceDXGISharedHandleDescriptor: ChainedStruct {
}

public struct GPUSharedFenceDXGISharedHandleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceDXGISharedHandleDescriptor
	public let sType: GPUSType = .sharedFenceDXGISharedHandleDescriptor
	public var handle: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceDXGISharedHandleDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceDXGISharedHandleDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceDXGISharedHandleDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceDXGISharedHandleExportInfo: ChainedStruct {
}

public struct GPUSharedFenceDXGISharedHandleExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceDXGISharedHandleExportInfo
	public let sType: GPUSType = .sharedFenceDXGISharedHandleExportInfo
	public var handle: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceDXGISharedHandleExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceDXGISharedHandleExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceDXGISharedHandleExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceEGLSyncDescriptor: ChainedStruct {
}

public struct GPUSharedFenceEGLSyncDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceEGLSyncDescriptor
	public let sType: GPUSType = .sharedFenceEGLSyncDescriptor
	public var sync: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sync: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sync = sync
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceEGLSyncDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceEGLSyncDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sync: sync
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceEGLSyncDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sync: sync
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceEGLSyncExportInfo: ChainedStruct {
}

public struct GPUSharedFenceEGLSyncExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceEGLSyncExportInfo
	public let sType: GPUSType = .sharedFenceEGLSyncExportInfo
	public var sync: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sync: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sync = sync
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceEGLSyncExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceEGLSyncExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sync: sync
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceEGLSyncExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sync: sync
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceMTLSharedEventDescriptor: ChainedStruct {
}

public struct GPUSharedFenceMTLSharedEventDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceMTLSharedEventDescriptor
	public let sType: GPUSType = .sharedFenceMTLSharedEventDescriptor
	public var sharedEvent: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sharedEvent: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sharedEvent = sharedEvent
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceMTLSharedEventDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceMTLSharedEventDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sharedEvent: sharedEvent
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceMTLSharedEventDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sharedEvent: sharedEvent
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceMTLSharedEventExportInfo: ChainedStruct {
}

public struct GPUSharedFenceMTLSharedEventExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceMTLSharedEventExportInfo
	public let sType: GPUSType = .sharedFenceMTLSharedEventExportInfo
	public var sharedEvent: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sharedEvent: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sharedEvent = sharedEvent
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceMTLSharedEventExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceMTLSharedEventExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sharedEvent: sharedEvent
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceMTLSharedEventExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sharedEvent: sharedEvent
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceDescriptor: RootStruct {
}

public struct GPUSharedFenceDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSharedFenceDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSharedFenceDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUSharedFenceExportInfo: RootStruct {
}

public struct GPUSharedFenceExportInfo: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSharedFenceExportInfo

	public var type: GPUSharedFenceType

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(type: GPUSharedFenceType = .vkSemaphoreOpaqueFD, nextInChain: (any GPUChainedStruct)? = nil) {
		self.type = type
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSharedFenceExportInfo) {
		self.type = wgpuStruct.type
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceExportInfo) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUSharedFenceExportInfo(nextInChain: pointer, type: type)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUSharedFenceSyncFDDescriptor: ChainedStruct {
}

public struct GPUSharedFenceSyncFDDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceSyncFDDescriptor
	public let sType: GPUSType = .sharedFenceSyncFDDescriptor
	public var handle: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceSyncFDDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceSyncFDDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceSyncFDDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceSyncFDExportInfo: ChainedStruct {
}

public struct GPUSharedFenceSyncFDExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceSyncFDExportInfo
	public let sType: GPUSType = .sharedFenceSyncFDExportInfo
	public var handle: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceSyncFDExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceSyncFDExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceSyncFDExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceVkSemaphoreOpaqueFDDescriptor: ChainedStruct {
}

public struct GPUSharedFenceVkSemaphoreOpaqueFDDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceVkSemaphoreOpaqueFDDescriptor
	public let sType: GPUSType = .sharedFenceVkSemaphoreOpaqueFDDescriptor
	public var handle: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceVkSemaphoreOpaqueFDDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceVkSemaphoreOpaqueFDDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceVkSemaphoreOpaqueFDDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceVkSemaphoreOpaqueFDExportInfo: ChainedStruct {
}

public struct GPUSharedFenceVkSemaphoreOpaqueFDExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceVkSemaphoreOpaqueFDExportInfo
	public let sType: GPUSType = .sharedFenceVkSemaphoreOpaqueFDExportInfo
	public var handle: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceVkSemaphoreOpaqueFDExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceVkSemaphoreOpaqueFDExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceVkSemaphoreOpaqueFDExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceVkSemaphoreZirconHandleDescriptor: ChainedStruct {
}

public struct GPUSharedFenceVkSemaphoreZirconHandleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceVkSemaphoreZirconHandleDescriptor
	public let sType: GPUSType = .sharedFenceVkSemaphoreZirconHandleDescriptor
	public var handle: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceVkSemaphoreZirconHandleDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceVkSemaphoreZirconHandleDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceVkSemaphoreZirconHandleDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedFenceVkSemaphoreZirconHandleExportInfo: ChainedStruct {
}

public struct GPUSharedFenceVkSemaphoreZirconHandleExportInfo: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedFenceVkSemaphoreZirconHandleExportInfo
	public let sType: GPUSType = .sharedFenceVkSemaphoreZirconHandleExportInfo
	public var handle: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedFenceVkSemaphoreZirconHandleExportInfo) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedFenceVkSemaphoreZirconHandleExportInfo(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					handle: handle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedFenceVkSemaphoreZirconHandleExportInfo(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						handle: handle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryD3DSwapchainBeginState: ChainedStruct {
}

public struct GPUSharedTextureMemoryD3DSwapchainBeginState: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryD3DSwapchainBeginState
	public let sType: GPUSType = .sharedTextureMemoryD3DSwapchainBeginState
	public var isSwapchain: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(isSwapchain: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.isSwapchain = isSwapchain
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryD3DSwapchainBeginState) -> R
	) -> R {
		return {
			let isSwapchain: WGPUBool = isSwapchain ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryD3DSwapchainBeginState(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						isSwapchain: isSwapchain
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryD3DSwapchainBeginState(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							isSwapchain: isSwapchain
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryD3D11BeginState: ChainedStruct {
}

public struct GPUSharedTextureMemoryD3D11BeginState: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryD3D11BeginState
	public let sType: GPUSType = .sharedTextureMemoryD3D11BeginState
	public var requiresEndAccessFence: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(requiresEndAccessFence: Bool = true, nextInChain: (any GPUChainedStruct)? = nil) {
		self.requiresEndAccessFence = requiresEndAccessFence
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryD3D11BeginState) -> R
	) -> R {
		return {
			let requiresEndAccessFence: WGPUBool = requiresEndAccessFence ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryD3D11BeginState(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						requiresEndAccessFence: requiresEndAccessFence
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryD3D11BeginState(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							requiresEndAccessFence: requiresEndAccessFence
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryDXGISharedHandleDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryDXGISharedHandleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryDXGISharedHandleDescriptor
	public let sType: GPUSType = .sharedTextureMemoryDXGISharedHandleDescriptor
	public var handle: UnsafeMutableRawPointer?
	public var useKeyedMutex: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UnsafeMutableRawPointer?, useKeyedMutex: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.useKeyedMutex = useKeyedMutex
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryDXGISharedHandleDescriptor) -> R
	) -> R {
		return {
			let useKeyedMutex: WGPUBool = useKeyedMutex ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryDXGISharedHandleDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						handle: handle,
						useKeyedMutex: useKeyedMutex
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryDXGISharedHandleDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							handle: handle,
							useKeyedMutex: useKeyedMutex
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryEGLImageDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryEGLImageDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryEGLImageDescriptor
	public let sType: GPUSType = .sharedTextureMemoryEGLImageDescriptor
	public var image: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(image: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.image = image
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryEGLImageDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryEGLImageDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					image: image
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryEGLImageDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						image: image
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryIOSurfaceDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryIOSurfaceDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryIOSurfaceDescriptor
	public let sType: GPUSType = .sharedTextureMemoryIOSurfaceDescriptor
	public var ioSurface: UnsafeMutableRawPointer?
	public var allowStorageBinding: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(ioSurface: UnsafeMutableRawPointer?, allowStorageBinding: Bool = true, nextInChain: (any GPUChainedStruct)? = nil) {
		self.ioSurface = ioSurface
		self.allowStorageBinding = allowStorageBinding
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryIOSurfaceDescriptor) -> R
	) -> R {
		return {
			let allowStorageBinding: WGPUBool = allowStorageBinding ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryIOSurfaceDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						ioSurface: ioSurface,
						allowStorageBinding: allowStorageBinding
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryIOSurfaceDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							ioSurface: ioSurface,
							allowStorageBinding: allowStorageBinding
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryAHardwareBufferDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryAHardwareBufferDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryAHardwareBufferDescriptor
	public let sType: GPUSType = .sharedTextureMemoryAHardwareBufferDescriptor
	public var handle: UnsafeMutableRawPointer?
	public var useExternalFormat: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(handle: UnsafeMutableRawPointer?, useExternalFormat: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.handle = handle
		self.useExternalFormat = useExternalFormat
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryAHardwareBufferDescriptor) -> R
	) -> R {
		return {
			let useExternalFormat: WGPUBool = useExternalFormat ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryAHardwareBufferDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						handle: handle,
						useExternalFormat: useExternalFormat
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryAHardwareBufferDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							handle: handle,
							useExternalFormat: useExternalFormat
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryAHardwareBufferProperties: ChainedStruct {
}

public struct GPUSharedTextureMemoryAHardwareBufferProperties: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryAHardwareBufferProperties
	public let sType: GPUSType = .sharedTextureMemoryAHardwareBufferProperties
	public var yCbCrInfo: GPUYCbCrVkDescriptor

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(yCbCrInfo: GPUYCbCrVkDescriptor, nextInChain: (any GPUChainedStruct)? = nil) {
		self.yCbCrInfo = yCbCrInfo
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryAHardwareBufferProperties) -> R
	) -> R {
		return yCbCrInfo.withWGPUStruct() { yCbCrInfo in
			{
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryAHardwareBufferProperties(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						yCbCrInfo: yCbCrInfo
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryAHardwareBufferProperties(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							yCbCrInfo: yCbCrInfo
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

extension WGPUSharedTextureMemoryBeginAccessDescriptor: RootStruct {
}

public struct GPUSharedTextureMemoryBeginAccessDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryBeginAccessDescriptor

	public var concurrentRead: Bool
	public var initialized: Bool
	public var fences: [GPUSharedFence]
	public var signaledValues: [UInt64]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		concurrentRead: Bool = false,
		initialized: Bool = false,
		fences: [GPUSharedFence] = [],
		signaledValues: [UInt64]? = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.concurrentRead = concurrentRead
		self.initialized = initialized
		self.fences = fences
		self.signaledValues = signaledValues
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryBeginAccessDescriptor) -> R
	) -> R {
		let fenceCount = fences.count
		return {
			let concurrentRead: WGPUBool = concurrentRead ? 1 : 0
			return {
				let initialized: WGPUBool = initialized ? 1 : 0
				return fences.unwrapWGPUObjectArray { fences in
					withWGPUArrayPointer(signaledValues) { signaledValues in
						withWGPUStructChain { pointer in
							var wgpuStruct = WGPUSharedTextureMemoryBeginAccessDescriptor(
								nextInChain: pointer,
								concurrentRead: concurrentRead,
								initialized: initialized,
								fenceCount: fenceCount,
								fences: fences,
								signaledValues: signaledValues
							)
							return lambda(&wgpuStruct)
						}
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryDescriptor: RootStruct {
}

public struct GPUSharedTextureMemoryDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSharedTextureMemoryDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUSharedTextureMemoryDmaBufDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryDmaBufDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryDmaBufDescriptor
	public let sType: GPUSType = .sharedTextureMemoryDmaBufDescriptor
	public var size: GPUExtent3D
	public var drmFormat: UInt32
	public var drmModifier: UInt64
	public var planes: [GPUSharedTextureMemoryDmaBufPlane]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		size: GPUExtent3D,
		drmFormat: UInt32 = 0,
		drmModifier: UInt64 = 0,
		planes: [GPUSharedTextureMemoryDmaBufPlane] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.size = size
		self.drmFormat = drmFormat
		self.drmModifier = drmModifier
		self.planes = planes
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryDmaBufDescriptor) -> R
	) -> R {
		let planeCount = planes.count
		return withWGPUArrayPointer(planes) { planes in
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryDmaBufDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						size: size,
						drmFormat: drmFormat,
						drmModifier: drmModifier,
						planeCount: planeCount,
						planes: planes
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryDmaBufDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							size: size,
							drmFormat: drmFormat,
							drmModifier: drmModifier,
							planeCount: planeCount,
							planes: planes
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}
	}
}

public typealias GPUSharedTextureMemoryDmaBufPlane = WGPUSharedTextureMemoryDmaBufPlane

extension GPUSharedTextureMemoryDmaBufPlane: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUSharedTextureMemoryEndAccessState: RootStruct {
}

public struct GPUSharedTextureMemoryEndAccessState: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSharedTextureMemoryEndAccessState

	public var initialized: Bool
	public var fences: [GPUSharedFence]
	public var signaledValues: [UInt64]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		initialized: Bool = false,
		fences: [GPUSharedFence] = [],
		signaledValues: [UInt64]? = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.initialized = initialized
		self.fences = fences
		self.signaledValues = signaledValues
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSharedTextureMemoryEndAccessState) {
		self.initialized = Bool(wgpuStruct.initialized != 0)
		self.fences = wgpuStruct.fences.wrapWGPUArrayWithCount(wgpuStruct.fenceCount)
		self.signaledValues = wgpuStruct.signaledValues.wrapArrayWithCount(wgpuStruct.fenceCount)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryEndAccessState) -> R
	) -> R {
		let fenceCount = fences.count
		return {
			let initialized: WGPUBool = initialized ? 1 : 0
			return fences.unwrapWGPUObjectArray { fences in
				withWGPUArrayPointer(signaledValues) { signaledValues in
					withWGPUStructChain { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryEndAccessState(
							nextInChain: pointer,
							initialized: initialized,
							fenceCount: fenceCount,
							fences: fences,
							signaledValues: signaledValues
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryMetalEndAccessState: ChainedStruct {
}

public struct GPUSharedTextureMemoryMetalEndAccessState: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryMetalEndAccessState
	public let sType: GPUSType = .sharedTextureMemoryMetalEndAccessState
	public var commandsScheduledFuture: GPUFuture

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(commandsScheduledFuture: GPUFuture, nextInChain: (any GPUChainedStruct)? = nil) {
		self.commandsScheduledFuture = commandsScheduledFuture
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryMetalEndAccessState) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryMetalEndAccessState(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					commandsScheduledFuture: commandsScheduledFuture
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryMetalEndAccessState(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						commandsScheduledFuture: commandsScheduledFuture
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryOpaqueFDDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryOpaqueFDDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryOpaqueFDDescriptor
	public let sType: GPUSType = .sharedTextureMemoryOpaqueFDDescriptor
	public var vkImageCreateInfo: UnsafeRawPointer
	public var memoryFD: Int32
	public var memoryTypeIndex: UInt32
	public var allocationSize: UInt64
	public var dedicatedAllocation: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		vkImageCreateInfo: UnsafeRawPointer,
		memoryFD: Int32 = 0,
		memoryTypeIndex: UInt32 = 0,
		allocationSize: UInt64 = 0,
		dedicatedAllocation: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.vkImageCreateInfo = vkImageCreateInfo
		self.memoryFD = memoryFD
		self.memoryTypeIndex = memoryTypeIndex
		self.allocationSize = allocationSize
		self.dedicatedAllocation = dedicatedAllocation
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryOpaqueFDDescriptor) -> R
	) -> R {
		return {
			let dedicatedAllocation: WGPUBool = dedicatedAllocation ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryOpaqueFDDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						vkImageCreateInfo: vkImageCreateInfo,
						memoryFD: memoryFD,
						memoryTypeIndex: memoryTypeIndex,
						allocationSize: allocationSize,
						dedicatedAllocation: dedicatedAllocation
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryOpaqueFDDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							vkImageCreateInfo: vkImageCreateInfo,
							memoryFD: memoryFD,
							memoryTypeIndex: memoryTypeIndex,
							allocationSize: allocationSize,
							dedicatedAllocation: dedicatedAllocation
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryProperties: RootStruct {
}

public struct GPUSharedTextureMemoryProperties: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSharedTextureMemoryProperties

	public var usage: GPUTextureUsage
	public var size: GPUExtent3D
	public var format: GPUTextureFormat

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		usage: GPUTextureUsage = GPUTextureUsage(),
		size: GPUExtent3D,
		format: GPUTextureFormat = .undefined,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.usage = usage
		self.size = size
		self.format = format
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSharedTextureMemoryProperties) {
		self.usage = wgpuStruct.usage
		self.size = wgpuStruct.size
		self.format = wgpuStruct.format
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryProperties) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUSharedTextureMemoryProperties(nextInChain: pointer, usage: usage, size: size, format: format)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUSharedTextureMemoryVkDedicatedAllocationDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryVkDedicatedAllocationDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryVkDedicatedAllocationDescriptor
	public let sType: GPUSType = .sharedTextureMemoryVkDedicatedAllocationDescriptor
	public var dedicatedAllocation: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(dedicatedAllocation: Bool = false, nextInChain: (any GPUChainedStruct)? = nil) {
		self.dedicatedAllocation = dedicatedAllocation
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryVkDedicatedAllocationDescriptor) -> R
	) -> R {
		return {
			let dedicatedAllocation: WGPUBool = dedicatedAllocation ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUSharedTextureMemoryVkDedicatedAllocationDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						dedicatedAllocation: dedicatedAllocation
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUSharedTextureMemoryVkDedicatedAllocationDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							dedicatedAllocation: dedicatedAllocation
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}

extension WGPUSharedTextureMemoryVkImageLayoutBeginState: ChainedStruct {
}

public struct GPUSharedTextureMemoryVkImageLayoutBeginState: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryVkImageLayoutBeginState
	public let sType: GPUSType = .sharedTextureMemoryVkImageLayoutBeginState
	public var oldLayout: Int32
	public var newLayout: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(oldLayout: Int32 = 0, newLayout: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.oldLayout = oldLayout
		self.newLayout = newLayout
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryVkImageLayoutBeginState) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryVkImageLayoutBeginState(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					oldLayout: oldLayout,
					newLayout: newLayout
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryVkImageLayoutBeginState(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						oldLayout: oldLayout,
						newLayout: newLayout
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryVkImageLayoutEndState: ChainedStruct {
}

public struct GPUSharedTextureMemoryVkImageLayoutEndState: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryVkImageLayoutEndState
	public let sType: GPUSType = .sharedTextureMemoryVkImageLayoutEndState
	public var oldLayout: Int32
	public var newLayout: Int32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(oldLayout: Int32 = 0, newLayout: Int32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.oldLayout = oldLayout
		self.newLayout = newLayout
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryVkImageLayoutEndState) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryVkImageLayoutEndState(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					oldLayout: oldLayout,
					newLayout: newLayout
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryVkImageLayoutEndState(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						oldLayout: oldLayout,
						newLayout: newLayout
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSharedTextureMemoryZirconHandleDescriptor: ChainedStruct {
}

public struct GPUSharedTextureMemoryZirconHandleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUSharedTextureMemoryZirconHandleDescriptor
	public let sType: GPUSType = .sharedTextureMemoryZirconHandleDescriptor
	public var memoryFD: UInt32
	public var allocationSize: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(memoryFD: UInt32 = 0, allocationSize: UInt64 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.memoryFD = memoryFD
		self.allocationSize = allocationSize
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSharedTextureMemoryZirconHandleDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSharedTextureMemoryZirconHandleDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					memoryFD: memoryFD,
					allocationSize: allocationSize
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSharedTextureMemoryZirconHandleDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						memoryFD: memoryFD,
						allocationSize: allocationSize
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUStaticSamplerBindingLayout: ChainedStruct {
}

public struct GPUStaticSamplerBindingLayout: GPUChainedStruct {
	public typealias WGPUType = WGPUStaticSamplerBindingLayout
	public let sType: GPUSType = .staticSamplerBindingLayout
	public var sampler: GPUSampler
	public var sampledTextureBinding: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(sampler: GPUSampler, sampledTextureBinding: UInt32 = UInt32.max, nextInChain: (any GPUChainedStruct)? = nil) {
		self.sampler = sampler
		self.sampledTextureBinding = sampledTextureBinding
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUStaticSamplerBindingLayout) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUStaticSamplerBindingLayout(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					sampler: sampler,
					sampledTextureBinding: sampledTextureBinding
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUStaticSamplerBindingLayout(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						sampler: sampler,
						sampledTextureBinding: sampledTextureBinding
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

public typealias GPUStencilFaceState = WGPUStencilFaceState

extension GPUStencilFaceState: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUStorageTextureBindingLayout: RootStruct {
}

public struct GPUStorageTextureBindingLayout: GPURootStruct {
	public typealias WGPUType = WGPUStorageTextureBindingLayout

	public var access: GPUStorageTextureAccess
	public var format: GPUTextureFormat
	public var viewDimension: GPUTextureViewDimension

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		access: GPUStorageTextureAccess = .writeOnly,
		format: GPUTextureFormat = .undefined,
		viewDimension: GPUTextureViewDimension = ._2D,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.access = access
		self.format = format
		self.viewDimension = viewDimension
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUStorageTextureBindingLayout) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUStorageTextureBindingLayout(
				nextInChain: pointer,
				access: access,
				format: format,
				viewDimension: viewDimension
			)
			return lambda(&wgpuStruct)
		}
	}
}

public typealias GPUSubgroupMatrixConfig = WGPUSubgroupMatrixConfig

extension GPUSubgroupMatrixConfig: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUSupportedWGSLLanguageFeatures: WGPUStruct {
}

public struct GPUSupportedWGSLLanguageFeatures: GPUStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSupportedWGSLLanguageFeatures

	public var features: [GPUWGSLLanguageFeatureName]

	public init(features: [GPUWGSLLanguageFeatureName] = []) {
		self.features = features
	}

	public init(wgpuStruct: WGPUSupportedWGSLLanguageFeatures) {
		self.features = wgpuStruct.features.wrapArrayWithCount(wgpuStruct.featureCount)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSupportedWGSLLanguageFeatures) -> R
	) -> R {
		let featureCount = features.count
		return withWGPUArrayPointer(features) { (features: UnsafePointer<WGPUWGSLLanguageFeatureName>) in
			return {
				var wgpuStruct = WGPUSupportedWGSLLanguageFeatures(featureCount: featureCount, features: features)
				return lambda(&wgpuStruct)
			}()
		}
	}
}

extension WGPUSupportedFeatures: WGPUStruct {
}

public struct GPUSupportedFeatures: GPUStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSupportedFeatures

	public var features: [GPUFeatureName]

	public init(features: [GPUFeatureName] = []) {
		self.features = features
	}

	public init(wgpuStruct: WGPUSupportedFeatures) {
		self.features = wgpuStruct.features.wrapArrayWithCount(wgpuStruct.featureCount)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSupportedFeatures) -> R
	) -> R {
		let featureCount = features.count
		return withWGPUArrayPointer(features) { (features: UnsafePointer<WGPUFeatureName>) in
			return {
				var wgpuStruct = WGPUSupportedFeatures(featureCount: featureCount, features: features)
				return lambda(&wgpuStruct)
			}()
		}
	}
}

extension WGPUSupportedInstanceFeatures: WGPUStruct {
}

public struct GPUSupportedInstanceFeatures: GPUStruct {
	public typealias WGPUType = WGPUSupportedInstanceFeatures

	public var features: [GPUInstanceFeatureName]

	public init(features: [GPUInstanceFeatureName] = []) {
		self.features = features
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSupportedInstanceFeatures) -> R
	) -> R {
		let featureCount = features.count
		return withWGPUArrayPointer(features) { (features: UnsafePointer<WGPUInstanceFeatureName>) in
			return {
				var wgpuStruct = WGPUSupportedInstanceFeatures(featureCount: featureCount, features: features)
				return lambda(&wgpuStruct)
			}()
		}
	}
}

extension WGPUSurfaceCapabilities: RootStruct {
}

public struct GPUSurfaceCapabilities: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSurfaceCapabilities

	public var usages: GPUTextureUsage
	public var formats: [GPUTextureFormat]
	public var presentModes: [GPUPresentMode]
	public var alphaModes: [GPUCompositeAlphaMode]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		usages: GPUTextureUsage = GPUTextureUsage(),
		formats: [GPUTextureFormat] = [],
		presentModes: [GPUPresentMode] = [],
		alphaModes: [GPUCompositeAlphaMode] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.usages = usages
		self.formats = formats
		self.presentModes = presentModes
		self.alphaModes = alphaModes
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSurfaceCapabilities) {
		self.usages = wgpuStruct.usages
		self.formats = wgpuStruct.formats.wrapArrayWithCount(wgpuStruct.formatCount)
		self.presentModes = wgpuStruct.presentModes.wrapArrayWithCount(wgpuStruct.presentModeCount)
		self.alphaModes = wgpuStruct.alphaModes.wrapArrayWithCount(wgpuStruct.alphaModeCount)
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceCapabilities) -> R
	) -> R {
		let formatCount = formats.count
		let presentModeCount = presentModes.count
		let alphaModeCount = alphaModes.count
		return withWGPUArrayPointer(formats) { (formats: UnsafePointer<WGPUTextureFormat>) in
			return withWGPUArrayPointer(presentModes) { (presentModes: UnsafePointer<WGPUPresentMode>) in
				return withWGPUArrayPointer(alphaModes) { (alphaModes: UnsafePointer<WGPUCompositeAlphaMode>) in
					return withWGPUStructChain { pointer in
						var wgpuStruct = WGPUSurfaceCapabilities(
							nextInChain: pointer,
							usages: usages,
							formatCount: formatCount,
							formats: formats,
							presentModeCount: presentModeCount,
							presentModes: presentModes,
							alphaModeCount: alphaModeCount,
							alphaModes: alphaModes
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}
	}
}

extension WGPUSurfaceColorManagement: ChainedStruct {
}

public struct GPUSurfaceColorManagement: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceColorManagement
	public let sType: GPUSType = .surfaceColorManagement
	public var colorSpace: GPUPredefinedColorSpace
	public var toneMappingMode: GPUToneMappingMode

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		colorSpace: GPUPredefinedColorSpace = .sRGB,
		toneMappingMode: GPUToneMappingMode = .standard,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.colorSpace = colorSpace
		self.toneMappingMode = toneMappingMode
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceColorManagement) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceColorManagement(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					colorSpace: colorSpace,
					toneMappingMode: toneMappingMode
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceColorManagement(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						colorSpace: colorSpace,
						toneMappingMode: toneMappingMode
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceConfiguration: RootStruct {
}

public struct GPUSurfaceConfiguration: GPURootStruct {
	public typealias WGPUType = WGPUSurfaceConfiguration

	public var device: GPUDevice
	public var format: GPUTextureFormat
	public var usage: GPUTextureUsage
	public var width: UInt32
	public var height: UInt32
	public var viewFormats: [GPUTextureFormat]?
	public var alphaMode: GPUCompositeAlphaMode
	public var presentMode: GPUPresentMode

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		device: GPUDevice,
		format: GPUTextureFormat = .undefined,
		usage: GPUTextureUsage = [.renderAttachment],
		width: UInt32 = 0,
		height: UInt32 = 0,
		viewFormats: [GPUTextureFormat]? = nil,
		alphaMode: GPUCompositeAlphaMode = .auto,
		presentMode: GPUPresentMode = .fifo,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.device = device
		self.format = format
		self.usage = usage
		self.width = width
		self.height = height
		self.viewFormats = viewFormats
		self.alphaMode = alphaMode
		self.presentMode = presentMode
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceConfiguration) -> R
	) -> R {
		let viewFormatCount = viewFormats?.count ?? 0
		return withWGPUArrayPointer(viewFormats) { (viewFormats: UnsafePointer<WGPUTextureFormat>?) in
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSurfaceConfiguration(
					nextInChain: pointer,
					device: device,
					format: format,
					usage: usage,
					width: width,
					height: height,
					viewFormatCount: viewFormatCount,
					viewFormats: viewFormats,
					alphaMode: alphaMode,
					presentMode: presentMode
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUSurfaceDescriptor: RootStruct {
}

public struct GPUSurfaceDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUSurfaceDescriptor

	public var label: String?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(label: String? = nil, nextInChain: (any GPUChainedStruct)? = nil) {
		self.label = label
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUSurfaceDescriptor(nextInChain: pointer, label: label)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUSurfaceDescriptorFromWindowsUWPSwapChainPanel: ChainedStruct {
}

public struct GPUSurfaceDescriptorFromWindowsUWPSwapChainPanel: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceDescriptorFromWindowsUWPSwapChainPanel
	public let sType: GPUSType = .surfaceDescriptorFromWindowsUWPSwapChainPanel
	public var swapChainPanel: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(swapChainPanel: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.swapChainPanel = swapChainPanel
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceDescriptorFromWindowsUWPSwapChainPanel) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceDescriptorFromWindowsUWPSwapChainPanel(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					swapChainPanel: swapChainPanel
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceDescriptorFromWindowsUWPSwapChainPanel(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						swapChainPanel: swapChainPanel
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceDescriptorFromWindowsWinUISwapChainPanel: ChainedStruct {
}

public struct GPUSurfaceDescriptorFromWindowsWinUISwapChainPanel: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceDescriptorFromWindowsWinUISwapChainPanel
	public let sType: GPUSType = .surfaceDescriptorFromWindowsWinUISwapChainPanel
	public var swapChainPanel: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(swapChainPanel: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.swapChainPanel = swapChainPanel
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceDescriptorFromWindowsWinUISwapChainPanel) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceDescriptorFromWindowsWinUISwapChainPanel(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					swapChainPanel: swapChainPanel
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceDescriptorFromWindowsWinUISwapChainPanel(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						swapChainPanel: swapChainPanel
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceDescriptorFromWindowsCoreWindow: ChainedStruct {
}

public struct GPUSurfaceDescriptorFromWindowsCoreWindow: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceDescriptorFromWindowsCoreWindow
	public let sType: GPUSType = .surfaceDescriptorFromWindowsCoreWindow
	public var coreWindow: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(coreWindow: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.coreWindow = coreWindow
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceDescriptorFromWindowsCoreWindow) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceDescriptorFromWindowsCoreWindow(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					coreWindow: coreWindow
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceDescriptorFromWindowsCoreWindow(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						coreWindow: coreWindow
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceXCBWindow: ChainedStruct {
}

public struct GPUSurfaceSourceXCBWindow: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceXCBWindow
	public let sType: GPUSType = .surfaceSourceXCBWindow
	public var connection: UnsafeMutableRawPointer?
	public var window: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(connection: UnsafeMutableRawPointer?, window: UInt32 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.connection = connection
		self.window = window
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceXCBWindow) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceXCBWindow(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					connection: connection,
					window: window
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceXCBWindow(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						connection: connection,
						window: window
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceAndroidNativeWindow: ChainedStruct {
}

public struct GPUSurfaceSourceAndroidNativeWindow: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceAndroidNativeWindow
	public let sType: GPUSType = .surfaceSourceAndroidNativeWindow
	public var window: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(window: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.window = window
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceAndroidNativeWindow) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceAndroidNativeWindow(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					window: window
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceAndroidNativeWindow(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						window: window
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceMetalLayer: ChainedStruct {
}

public struct GPUSurfaceSourceMetalLayer: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceMetalLayer
	public let sType: GPUSType = .surfaceSourceMetalLayer
	public var layer: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(layer: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.layer = layer
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceMetalLayer) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceMetalLayer(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					layer: layer
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceMetalLayer(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						layer: layer
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceWaylandSurface: ChainedStruct {
}

public struct GPUSurfaceSourceWaylandSurface: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceWaylandSurface
	public let sType: GPUSType = .surfaceSourceWaylandSurface
	public var display: UnsafeMutableRawPointer?
	public var surface: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(display: UnsafeMutableRawPointer?, surface: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.display = display
		self.surface = surface
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceWaylandSurface) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceWaylandSurface(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					display: display,
					surface: surface
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceWaylandSurface(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						display: display,
						surface: surface
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceWindowsHWND: ChainedStruct {
}

public struct GPUSurfaceSourceWindowsHWND: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceWindowsHWND
	public let sType: GPUSType = .surfaceSourceWindowsHWND
	public var hinstance: UnsafeMutableRawPointer?
	public var hwnd: UnsafeMutableRawPointer?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(hinstance: UnsafeMutableRawPointer?, hwnd: UnsafeMutableRawPointer?, nextInChain: (any GPUChainedStruct)? = nil) {
		self.hinstance = hinstance
		self.hwnd = hwnd
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceWindowsHWND) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceWindowsHWND(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					hinstance: hinstance,
					hwnd: hwnd
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceWindowsHWND(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						hinstance: hinstance,
						hwnd: hwnd
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceSourceXlibWindow: ChainedStruct {
}

public struct GPUSurfaceSourceXlibWindow: GPUChainedStruct {
	public typealias WGPUType = WGPUSurfaceSourceXlibWindow
	public let sType: GPUSType = .surfaceSourceXlibWindow
	public var display: UnsafeMutableRawPointer?
	public var window: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(display: UnsafeMutableRawPointer?, window: UInt64 = 0, nextInChain: (any GPUChainedStruct)? = nil) {
		self.display = display
		self.window = window
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceSourceXlibWindow) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUSurfaceSourceXlibWindow(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					display: display,
					window: window
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUSurfaceSourceXlibWindow(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						display: display,
						window: window
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUSurfaceTexture: RootStruct {
}

public struct GPUSurfaceTexture: GPURootStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUSurfaceTexture

	public var texture: GPUTexture
	public var status: GPUSurfaceGetCurrentTextureStatus

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		texture: GPUTexture,
		status: GPUSurfaceGetCurrentTextureStatus = .successOptimal,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.texture = texture
		self.status = status
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUSurfaceTexture) {
		self.texture = wgpuStruct.texture
		self.status = wgpuStruct.status
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUSurfaceTexture) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUSurfaceTexture(nextInChain: pointer, texture: texture, status: status)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUTexelBufferBindingEntry: ChainedStruct {
}

public struct GPUTexelBufferBindingEntry: GPUChainedStruct {
	public typealias WGPUType = WGPUTexelBufferBindingEntry
	public let sType: GPUSType = .texelBufferBindingEntry
	public var texelBufferView: GPUTexelBufferView

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(texelBufferView: GPUTexelBufferView, nextInChain: (any GPUChainedStruct)? = nil) {
		self.texelBufferView = texelBufferView
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTexelBufferBindingEntry) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUTexelBufferBindingEntry(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					texelBufferView: texelBufferView
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUTexelBufferBindingEntry(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						texelBufferView: texelBufferView
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUTexelBufferBindingLayout: ChainedStruct {
}

public struct GPUTexelBufferBindingLayout: GPUChainedStruct {
	public typealias WGPUType = WGPUTexelBufferBindingLayout
	public let sType: GPUSType = .texelBufferBindingLayout
	public var access: GPUTexelBufferAccess
	public var format: GPUTextureFormat

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		access: GPUTexelBufferAccess = .readWrite,
		format: GPUTextureFormat = .undefined,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.access = access
		self.format = format
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTexelBufferBindingLayout) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUTexelBufferBindingLayout(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					access: access,
					format: format
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUTexelBufferBindingLayout(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						access: access,
						format: format
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUTexelBufferViewDescriptor: RootStruct {
}

public struct GPUTexelBufferViewDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUTexelBufferViewDescriptor

	public var label: String?
	public var format: GPUTextureFormat
	public var offset: UInt64
	public var size: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		format: GPUTextureFormat = .undefined,
		offset: UInt64 = 0,
		size: UInt64 = UInt64.max,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.format = format
		self.offset = offset
		self.size = size
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTexelBufferViewDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUTexelBufferViewDescriptor(
					nextInChain: pointer,
					label: label,
					format: format,
					offset: offset,
					size: size
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

public typealias GPUTexelCopyBufferInfo = WGPUTexelCopyBufferInfo

extension GPUTexelCopyBufferInfo: GPUSimpleStruct {
	public typealias WGPUType = Self
}

public typealias GPUTexelCopyBufferLayout = WGPUTexelCopyBufferLayout

extension GPUTexelCopyBufferLayout: GPUSimpleStruct {
	public typealias WGPUType = Self
}

public typealias GPUTexelCopyTextureInfo = WGPUTexelCopyTextureInfo

extension GPUTexelCopyTextureInfo: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUTextureBindingLayout: RootStruct {
}

public struct GPUTextureBindingLayout: GPURootStruct {
	public typealias WGPUType = WGPUTextureBindingLayout

	public var sampleType: GPUTextureSampleType
	public var viewDimension: GPUTextureViewDimension
	public var multisampled: Bool

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		sampleType: GPUTextureSampleType = .float,
		viewDimension: GPUTextureViewDimension = ._2D,
		multisampled: Bool = false,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.sampleType = sampleType
		self.viewDimension = viewDimension
		self.multisampled = multisampled
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTextureBindingLayout) -> R
	) -> R {
		return {
			let multisampled: WGPUBool = multisampled ? 1 : 0
			return withWGPUStructChain { pointer in
				var wgpuStruct = WGPUTextureBindingLayout(
					nextInChain: pointer,
					sampleType: sampleType,
					viewDimension: viewDimension,
					multisampled: multisampled
				)
				return lambda(&wgpuStruct)
			}
		}()
	}
}

extension WGPUTextureBindingViewDimensionDescriptor: ChainedStruct {
}

public struct GPUTextureBindingViewDimensionDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUTextureBindingViewDimensionDescriptor
	public let sType: GPUSType = .textureBindingViewDimensionDescriptor
	public var textureBindingViewDimension: GPUTextureViewDimension

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(textureBindingViewDimension: GPUTextureViewDimension = .undefined, nextInChain: (any GPUChainedStruct)? = nil) {
		self.textureBindingViewDimension = textureBindingViewDimension
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTextureBindingViewDimensionDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUTextureBindingViewDimensionDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					textureBindingViewDimension: textureBindingViewDimension
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUTextureBindingViewDimensionDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						textureBindingViewDimension: textureBindingViewDimension
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

public typealias GPUTextureComponentSwizzle = WGPUTextureComponentSwizzle

extension GPUTextureComponentSwizzle: GPUSimpleStruct {
	public typealias WGPUType = Self
}

extension WGPUTextureComponentSwizzleDescriptor: ChainedStruct {
}

public struct GPUTextureComponentSwizzleDescriptor: GPUChainedStruct {
	public typealias WGPUType = WGPUTextureComponentSwizzleDescriptor
	public let sType: GPUSType = .textureComponentSwizzleDescriptor
	public var swizzle: GPUTextureComponentSwizzle

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(swizzle: GPUTextureComponentSwizzle, nextInChain: (any GPUChainedStruct)? = nil) {
		self.swizzle = swizzle
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTextureComponentSwizzleDescriptor) -> R
	) -> R {
		return {
			if nextInChain == nil {
				var wgpuStruct = WGPUTextureComponentSwizzleDescriptor(
					chain: WGPUChainedStruct(next: nil, sType: sType),
					swizzle: swizzle
				)
				return lambda(&wgpuStruct)
			} else {
				return nextInChain!.withNextInChain() { pointer in
					var wgpuStruct = WGPUTextureComponentSwizzleDescriptor(
						chain: WGPUChainedStruct(next: pointer, sType: sType),
						swizzle: swizzle
					)
					return lambda(&wgpuStruct)
				}
			}
		}()
	}
}

extension WGPUTextureDescriptor: RootStruct {
}

public struct GPUTextureDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUTextureDescriptor

	public var label: String?
	public var usage: GPUTextureUsage
	public var dimension: GPUTextureDimension
	public var size: GPUExtent3D
	public var format: GPUTextureFormat
	public var mipLevelCount: UInt32
	public var sampleCount: UInt32
	public var viewFormats: [GPUTextureFormat]?

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		usage: GPUTextureUsage = GPUTextureUsage(),
		dimension: GPUTextureDimension = ._2D,
		size: GPUExtent3D,
		format: GPUTextureFormat = .undefined,
		mipLevelCount: UInt32 = 1,
		sampleCount: UInt32 = 1,
		viewFormats: [GPUTextureFormat]? = nil,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.usage = usage
		self.dimension = dimension
		self.size = size
		self.format = format
		self.mipLevelCount = mipLevelCount
		self.sampleCount = sampleCount
		self.viewFormats = viewFormats
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTextureDescriptor) -> R
	) -> R {
		let viewFormatCount = viewFormats?.count ?? 0
		return label.withWGPUStruct { label in
			withWGPUArrayPointer(viewFormats) { (viewFormats: UnsafePointer<WGPUTextureFormat>?) in
				return withWGPUStructChain { pointer in
					var wgpuStruct = WGPUTextureDescriptor(
						nextInChain: pointer,
						label: label,
						usage: usage,
						dimension: dimension,
						size: size,
						format: format,
						mipLevelCount: mipLevelCount,
						sampleCount: sampleCount,
						viewFormatCount: viewFormatCount,
						viewFormats: viewFormats
					)
					return lambda(&wgpuStruct)
				}
			}
		}
	}
}

extension WGPUTextureViewDescriptor: RootStruct {
}

public struct GPUTextureViewDescriptor: GPURootStruct {
	public typealias WGPUType = WGPUTextureViewDescriptor

	public var label: String?
	public var format: GPUTextureFormat
	public var dimension: GPUTextureViewDimension
	public var baseMipLevel: UInt32
	public var mipLevelCount: UInt32
	public var baseArrayLayer: UInt32
	public var arrayLayerCount: UInt32
	public var aspect: GPUTextureAspect
	public var usage: GPUTextureUsage

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		label: String? = nil,
		format: GPUTextureFormat = .undefined,
		dimension: GPUTextureViewDimension = .undefined,
		baseMipLevel: UInt32 = 0,
		mipLevelCount: UInt32 = UInt32.max,
		baseArrayLayer: UInt32 = 0,
		arrayLayerCount: UInt32 = UInt32.max,
		aspect: GPUTextureAspect = .all,
		usage: GPUTextureUsage = GPUTextureUsage(),
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.label = label
		self.format = format
		self.dimension = dimension
		self.baseMipLevel = baseMipLevel
		self.mipLevelCount = mipLevelCount
		self.baseArrayLayer = baseArrayLayer
		self.arrayLayerCount = arrayLayerCount
		self.aspect = aspect
		self.usage = usage
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUTextureViewDescriptor) -> R
	) -> R {
		return label.withWGPUStruct { label in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUTextureViewDescriptor(
					nextInChain: pointer,
					label: label,
					format: format,
					dimension: dimension,
					baseMipLevel: baseMipLevel,
					mipLevelCount: mipLevelCount,
					baseArrayLayer: baseArrayLayer,
					arrayLayerCount: arrayLayerCount,
					aspect: aspect,
					usage: usage
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUVertexAttribute: RootStruct {
}

public struct GPUVertexAttribute: GPURootStruct {
	public typealias WGPUType = WGPUVertexAttribute

	public var format: GPUVertexFormat
	public var offset: UInt64
	public var shaderLocation: UInt32

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		format: GPUVertexFormat = .uint8,
		offset: UInt64 = 0,
		shaderLocation: UInt32 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.format = format
		self.offset = offset
		self.shaderLocation = shaderLocation
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUVertexAttribute) -> R
	) -> R {
		return withWGPUStructChain { pointer in
			var wgpuStruct = WGPUVertexAttribute(
				nextInChain: pointer,
				format: format,
				offset: offset,
				shaderLocation: shaderLocation
			)
			return lambda(&wgpuStruct)
		}
	}
}

extension WGPUVertexBufferLayout: RootStruct {
}

public struct GPUVertexBufferLayout: GPURootStruct {
	public typealias WGPUType = WGPUVertexBufferLayout

	public var stepMode: GPUVertexStepMode
	public var arrayStride: UInt64
	public var attributes: [GPUVertexAttribute]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		stepMode: GPUVertexStepMode = .undefined,
		arrayStride: UInt64 = 0,
		attributes: [GPUVertexAttribute] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.stepMode = stepMode
		self.arrayStride = arrayStride
		self.attributes = attributes
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUVertexBufferLayout) -> R
	) -> R {
		let attributeCount = attributes.count
		return withWGPUArrayPointer(attributes) { attributes in
			withWGPUStructChain { pointer in
				var wgpuStruct = WGPUVertexBufferLayout(
					nextInChain: pointer,
					stepMode: stepMode,
					arrayStride: arrayStride,
					attributeCount: attributeCount,
					attributes: attributes
				)
				return lambda(&wgpuStruct)
			}
		}
	}
}

extension WGPUVertexState: RootStruct {
}

public struct GPUVertexState: GPURootStruct {
	public typealias WGPUType = WGPUVertexState

	public var module: GPUShaderModule
	public var entryPoint: String?
	public var constants: [GPUConstantEntry]
	public var buffers: [GPUVertexBufferLayout]

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		module: GPUShaderModule,
		entryPoint: String? = nil,
		constants: [GPUConstantEntry] = [],
		buffers: [GPUVertexBufferLayout] = [],
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.module = module
		self.entryPoint = entryPoint
		self.constants = constants
		self.buffers = buffers
		self.nextInChain = nextInChain
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUVertexState) -> R
	) -> R {
		let constantCount = constants.count
		let bufferCount = buffers.count
		return entryPoint.withWGPUStruct { entryPoint in
			withWGPUArrayPointer(constants) { constants in
				withWGPUArrayPointer(buffers) { buffers in
					withWGPUStructChain { pointer in
						var wgpuStruct = WGPUVertexState(
							nextInChain: pointer,
							module: module,
							entryPoint: entryPoint,
							constantCount: constantCount,
							constants: constants,
							bufferCount: bufferCount,
							buffers: buffers
						)
						return lambda(&wgpuStruct)
					}
				}
			}
		}
	}
}

extension WGPUYCbCrVkDescriptor: ChainedStruct {
}

public struct GPUYCbCrVkDescriptor: GPUChainedStruct, GPUStructWrappable {
	public typealias WGPUType = WGPUYCbCrVkDescriptor
	public let sType: GPUSType = .yCbCrVkDescriptor
	public var vkFormat: UInt32
	public var vkYCbCrModel: UInt32
	public var vkYCbCrRange: UInt32
	public var vkComponentSwizzleRed: UInt32
	public var vkComponentSwizzleGreen: UInt32
	public var vkComponentSwizzleBlue: UInt32
	public var vkComponentSwizzleAlpha: UInt32
	public var vkXChromaOffset: UInt32
	public var vkYChromaOffset: UInt32
	public var vkChromaFilter: GPUFilterMode
	public var forceExplicitReconstruction: Bool
	public var externalFormat: UInt64

	public var nextInChain: (any GPUChainedStruct)? = nil

	public init(
		vkFormat: UInt32 = 0,
		vkYCbCrModel: UInt32 = 0,
		vkYCbCrRange: UInt32 = 0,
		vkComponentSwizzleRed: UInt32 = 0,
		vkComponentSwizzleGreen: UInt32 = 0,
		vkComponentSwizzleBlue: UInt32 = 0,
		vkComponentSwizzleAlpha: UInt32 = 0,
		vkXChromaOffset: UInt32 = 0,
		vkYChromaOffset: UInt32 = 0,
		vkChromaFilter: GPUFilterMode = .nearest,
		forceExplicitReconstruction: Bool = false,
		externalFormat: UInt64 = 0,
		nextInChain: (any GPUChainedStruct)? = nil
	) {
		self.vkFormat = vkFormat
		self.vkYCbCrModel = vkYCbCrModel
		self.vkYCbCrRange = vkYCbCrRange
		self.vkComponentSwizzleRed = vkComponentSwizzleRed
		self.vkComponentSwizzleGreen = vkComponentSwizzleGreen
		self.vkComponentSwizzleBlue = vkComponentSwizzleBlue
		self.vkComponentSwizzleAlpha = vkComponentSwizzleAlpha
		self.vkXChromaOffset = vkXChromaOffset
		self.vkYChromaOffset = vkYChromaOffset
		self.vkChromaFilter = vkChromaFilter
		self.forceExplicitReconstruction = forceExplicitReconstruction
		self.externalFormat = externalFormat
		self.nextInChain = nextInChain
	}

	public init(wgpuStruct: WGPUYCbCrVkDescriptor) {
		self.vkFormat = wgpuStruct.vkFormat
		self.vkYCbCrModel = wgpuStruct.vkYCbCrModel
		self.vkYCbCrRange = wgpuStruct.vkYCbCrRange
		self.vkComponentSwizzleRed = wgpuStruct.vkComponentSwizzleRed
		self.vkComponentSwizzleGreen = wgpuStruct.vkComponentSwizzleGreen
		self.vkComponentSwizzleBlue = wgpuStruct.vkComponentSwizzleBlue
		self.vkComponentSwizzleAlpha = wgpuStruct.vkComponentSwizzleAlpha
		self.vkXChromaOffset = wgpuStruct.vkXChromaOffset
		self.vkYChromaOffset = wgpuStruct.vkYChromaOffset
		self.vkChromaFilter = wgpuStruct.vkChromaFilter
		self.forceExplicitReconstruction = Bool(wgpuStruct.forceExplicitReconstruction != 0)
		self.externalFormat = wgpuStruct.externalFormat
	}

	public func withWGPUStruct<R>(
		_ lambda: (inout WGPUYCbCrVkDescriptor) -> R
	) -> R {
		return {
			let forceExplicitReconstruction: WGPUBool = forceExplicitReconstruction ? 1 : 0
			return {
				if nextInChain == nil {
					var wgpuStruct = WGPUYCbCrVkDescriptor(
						chain: WGPUChainedStruct(next: nil, sType: sType),
						vkFormat: vkFormat,
						vkYCbCrModel: vkYCbCrModel,
						vkYCbCrRange: vkYCbCrRange,
						vkComponentSwizzleRed: vkComponentSwizzleRed,
						vkComponentSwizzleGreen: vkComponentSwizzleGreen,
						vkComponentSwizzleBlue: vkComponentSwizzleBlue,
						vkComponentSwizzleAlpha: vkComponentSwizzleAlpha,
						vkXChromaOffset: vkXChromaOffset,
						vkYChromaOffset: vkYChromaOffset,
						vkChromaFilter: vkChromaFilter,
						forceExplicitReconstruction: forceExplicitReconstruction,
						externalFormat: externalFormat
					)
					return lambda(&wgpuStruct)
				} else {
					return nextInChain!.withNextInChain() { pointer in
						var wgpuStruct = WGPUYCbCrVkDescriptor(
							chain: WGPUChainedStruct(next: pointer, sType: sType),
							vkFormat: vkFormat,
							vkYCbCrModel: vkYCbCrModel,
							vkYCbCrRange: vkYCbCrRange,
							vkComponentSwizzleRed: vkComponentSwizzleRed,
							vkComponentSwizzleGreen: vkComponentSwizzleGreen,
							vkComponentSwizzleBlue: vkComponentSwizzleBlue,
							vkComponentSwizzleAlpha: vkComponentSwizzleAlpha,
							vkXChromaOffset: vkXChromaOffset,
							vkYChromaOffset: vkYChromaOffset,
							vkChromaFilter: vkChromaFilter,
							forceExplicitReconstruction: forceExplicitReconstruction,
							externalFormat: externalFormat
						)
						return lambda(&wgpuStruct)
					}
				}
			}()
		}()
	}
}
