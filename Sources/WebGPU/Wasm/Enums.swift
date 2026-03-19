// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

import JavaScriptKit

@JS public enum GPUCanvasAlphaMode: String, Sendable {
	case opaque = "opaque"
	case premultiplied = "premultiplied"
}

@JS public enum GPUPrimitiveTopology: String, Sendable {
	case pointList = "point-list"
	case lineList = "line-list"
	case lineStrip = "line-strip"
	case triangleList = "triangle-list"
	case triangleStrip = "triangle-strip"
}

@JS public enum GPUVertexFormat: String, Sendable {
	case uint8x2 = "uint8x2"
	case uint8x4 = "uint8x4"
	case sint8x2 = "sint8x2"
	case sint8x4 = "sint8x4"
	case unorm8x2 = "unorm8x2"
	case unorm8x4 = "unorm8x4"
	case snorm8x2 = "snorm8x2"
	case snorm8x4 = "snorm8x4"
	case float16x2 = "float16x2"
	case float16x4 = "float16x4"
	case float32 = "float32"
	case float32x2 = "float32x2"
	case float32x3 = "float32x3"
	case float32x4 = "float32x4"
	case uint32 = "uint32"
	case uint32x2 = "uint32x2"
	case uint32x3 = "uint32x3"
	case uint32x4 = "uint32x4"
	case sint32 = "sint32"
	case sint32x2 = "sint32x2"
	case sint32x3 = "sint32x3"
	case sint32x4 = "sint32x4"
}

@JS public enum GPUVertexStepMode: String, Sendable {
	case vertex = "vertex"
	case instance = "instance"
}

@JS public enum GPUTextureFormat: String, Sendable {
	case Undefined = ""
	case R8Unorm = "r8unorm"
	case R8Snorm = "r8snorm"
	case R8Uint = "r8uint"
	case R8Sint = "r8sint"
	case R16Unorm = "r16unorm"
	case R16Snorm = "r16snorm"
	case R16Uint = "r16uint"
	case R16Sint = "r16sint"
	case R16Float = "r16float"
	case RG8Unorm = "rg8unorm"
	case RG8Snorm = "rg8snorm"
	case RG8Uint = "rg8uint"
	case RG8Sint = "rg8sint"
	case R32Float = "r32float"
	case R32Uint = "r32uint"
	case R32Sint = "r32sint"
	case RG16Unorm = "rg16unorm"
	case RG16Snorm = "rg16snorm"
	case RG16Uint = "rg16uint"
	case RG16Sint = "rg16sint"
	case RG16Float = "rg16float"
	case RGBA8Unorm = "rgba8unorm"
	case RGBA8UnormSrgb = "rgba8unorm-srgb"
	case RGBA8Snorm = "rgba8snorm"
	case RGBA8Uint = "rgba8uint"
	case RGBA8Sint = "rgba8sint"
	case BGRA8Unorm = "bgra8unorm"
	case BGRA8UnormSrgb = "bgra8unorm-srgb"
	case RGB10A2Uint = "rgb10a2uint"
	case RGB10A2Unorm = "rgb10a2unorm"
	case RG11B10Ufloat = "rg11b10ufloat"
	case RGB9E5Ufloat = "rgb9e5ufloat"
	case RG32Float = "rg32float"
	case RG32Uint = "rg32uint"
	case RG32Sint = "rg32sint"
	case RGBA16Unorm = "rgba16unorm"
	case RGBA16Snorm = "rgba16snorm"
	case RGBA16Uint = "rgba16uint"
	case RGBA16Sint = "rgba16sint"
	case RGBA16Float = "rgba16float"
	case RGBA32Float = "rgba32float"
	case RGBA32Uint = "rgba32uint"
	case RGBA32Sint = "rgba32sint"
	case Stencil8 = "stencil8"
	case Depth16Unorm = "depth16unorm"
	case Depth24Plus = "depth24plus"
	case Depth24PlusStencil8 = "depth24plus-stencil8"
	case Depth32Float = "depth32float"
	case Depth32FloatStencil8 = "depth32float-stencil8"
	case BC1RGBAUnorm = "bc1-rgba-unorm"
	case BC1RGBAUnormSrgb = "bc1-rgba-unorm-srgb"
	case BC2RGBAUnorm = "bc2-rgba-unorm"
	case BC2RGBAUnormSrgb = "bc2-rgba-unorm-srgb"
	case BC3RGBAUnorm = "bc3-rgba-unorm"
	case BC3RGBAUnormSrgb = "bc3-rgba-unorm-srgb"
	case BC4RUnorm = "bc4-r-unorm"
	case BC4RSnorm = "bc4-r-snorm"
	case BC5RGUnorm = "bc5-rg-unorm"
	case BC5RGSnorm = "bc5-rg-snorm"
	case BC6HRGBUfloat = "bc6h-rgb-ufloat"
	case BC6HRGBFloat = "bc6h-rgb-float"
	case BC7RGBAUnorm = "bc7-rgba-unorm"
	case BC7RGBAUnormSrgb = "bc7-rgba-unorm-srgb"
	case ETC2RGB8Unorm = "etc2-rgb8unorm"
	case ETC2RGB8UnormSrgb = "etc2-rgb8unorm-srgb"
	case ETC2RGB8A1Unorm = "etc2-rgb8a1unorm"
	case ETC2RGB8A1UnormSrgb = "etc2-rgb8a1unorm-srgb"
	case ETC2RGBA8Unorm = "etc2-rgba8unorm"
	case ETC2RGBA8UnormSrgb = "etc2-rgba8unorm-srgb"
	case EACR11Unorm = "eac-r11unorm"
	case EACR11Snorm = "eac-r11snorm"
	case EACRG11Unorm = "eac-rg11unorm"
	case EACRG11Snorm = "eac-rg11snorm"
	case ASTC4x4Unorm = "astc-4x4-unorm"
	case ASTC4x4UnormSrgb = "astc-4x4-unorm-srgb"
	case ASTC5x4Unorm = "astc-5x4-unorm"
	case ASTC5x4UnormSrgb = "astc-5x4-unorm-srgb"
	case ASTC5x5Unorm = "astc-5x5-unorm"
	case ASTC5x5UnormSrgb = "astc-5x5-unorm-srgb"
	case ASTC6x5Unorm = "astc-6x5-unorm"
	case ASTC6x5UnormSrgb = "astc-6x5-unorm-srgb"
	case ASTC6x6Unorm = "astc-6x6-unorm"
	case ASTC6x6UnormSrgb = "astc-6x6-unorm-srgb"
	case ASTC8x5Unorm = "astc-8x5-unorm"
	case ASTC8x5UnormSrgb = "astc-8x5-unorm-srgb"
	case ASTC8x6Unorm = "astc-8x6-unorm"
	case ASTC8x6UnormSrgb = "astc-8x6-unorm-srgb"
	case ASTC8x8Unorm = "astc-8x8-unorm"
	case ASTC8x8UnormSrgb = "astc-8x8-unorm-srgb"
	case ASTC10x5Unorm = "astc-10x5-unorm"
	case ASTC10x5UnormSrgb = "astc-10x5-unorm-srgb"
	case ASTC10x6Unorm = "astc-10x6-unorm"
	case ASTC10x6UnormSrgb = "astc-10x6-unorm-srgb"
	case ASTC10x8Unorm = "astc-10x8-unorm"
	case ASTC10x8UnormSrgb = "astc-10x8-unorm-srgb"
	case ASTC10x10Unorm = "astc-10x10-unorm"
	case ASTC10x10UnormSrgb = "astc-10x10-unorm-srgb"
	case ASTC12x10Unorm = "astc-12x10-unorm"
	case ASTC12x10UnormSrgb = "astc-12x10-unorm-srgb"
	case ASTC12x12Unorm = "astc-12x12-unorm"
	case ASTC12x12UnormSrgb = "astc-12x12-unorm-srgb"
	case Force32 = "force32"

	// Dawn-specific multi-plane formats (stubs for source compatibility)
	public static let R8BG8Biplanar420Unorm = GPUTextureFormat.Undefined
	public static let R10X6BG10X6Biplanar420Unorm = GPUTextureFormat.Undefined
	public static let R8BG8A8Triplanar420Unorm = GPUTextureFormat.Undefined
	public static let R8BG8Biplanar422Unorm = GPUTextureFormat.Undefined
	public static let R8BG8Biplanar444Unorm = GPUTextureFormat.Undefined
	public static let R10X6BG10X6Biplanar422Unorm = GPUTextureFormat.Undefined
	public static let R10X6BG10X6Biplanar444Unorm = GPUTextureFormat.Undefined
	public static let OpaqueYCbCrAndroid = GPUTextureFormat.Undefined
}

@JS public enum GPULoadOp: String, Sendable {
	case load = "load"
	case clear = "clear"
}

@JS public enum GPUStoreOp: String, Sendable {
	case store = "store"
	case discard = "discard"
}

@JS public enum GPUFrontFace: String, Sendable {
	case ccw = "ccw"
	case cw = "cw"
}

@JS public enum GPUCullMode: String, Sendable {
	case none = "none"
	case front = "front"
	case back = "back"
}

@JS public enum GPUIndexFormat: String, Sendable {
	case undefined = "undefined"
	case uint16 = "uint16"
	case uint32 = "uint32"
	case force32 = "force32"
}

@JS public enum GPUBufferBindingType: String, Sendable {
	case uniform = "uniform"
	case storage = "storage"
	case readOnlyStorage = "read-only-storage"
}

@JS public enum GPUTextureViewDimension: String, Sendable {
	case _1D = "1d"
	case _2D = "2d"
	case _2DArray = "2d-array"
	case cube = "cube"
	case cubeArray = "cube-array"
	case _3D = "3d"
}

@JS public enum GPUTextureSampleType: String, Sendable {
	case float = "float"
	case unfilterableFloat = "unfilterable-float"
	case depth = "depth"
	case sint = "sint"
	case uint = "uint"
}

@JS public enum GPUStorageTextureAccess: String, Sendable {
	case writeOnly = "write-only"
	case readOnly = "read-only"
	case readWrite = "read-write"
}

@JS public enum GPUSamplerBindingType: String, Sendable {
	case filtering = "filtering"
	case nonFiltering = "non-filtering"
	case comparison = "comparison"
}

@JS public enum GPUQueryType: String, Sendable {
	case occlusion = "occlusion"
	case timestamp = "timestamp"
}

@JS public enum GPUAddressMode: String, Sendable {
	case clampToEdge = "clamp-to-edge"
	case repeatMode = "repeat"
	case mirrorRepeat = "mirror-repeat"
}

@JS public enum GPUFilterMode: String, Sendable {
	case nearest = "nearest"
	case linear = "linear"
}

@JS public enum GPUMipmapFilterMode: String, Sendable {
	case nearest = "nearest"
	case linear = "linear"
}

@JS public enum GPUCompareFunction: String, Sendable {
	case never = "never"
	case less = "less"
	case equal = "equal"
	case lessEqual = "less-equal"
	case greater = "greater"
	case notEqual = "not-equal"
	case greaterEqual = "greater-equal"
	case always = "always"
}

@JS public enum GPUBlendFactor: String, Sendable {
	case zero = "zero"
	case one = "one"
	case src = "src"
	case oneMinusSrc = "one-minus-src"
	case srcAlpha = "src-alpha"
	case oneMinusSrcAlpha = "one-minus-src-alpha"
	case dst = "dst"
	case oneMinusDst = "one-minus-dst"
	case dstAlpha = "dst-alpha"
	case oneMinusDstAlpha = "one-minus-dst-alpha"
	case srcAlphaSaturated = "src-alpha-saturated"
	case constant = "constant"
	case oneMinusConstant = "one-minus-constant"
	case src1 = "src1"
	case oneMinusSrc1 = "one-minus-src1"
	case src1Alpha = "src1-alpha"
	case oneMinusSrc1Alpha = "one-minus-src1-alpha"

}

@JS public enum GPUBlendOperation: String, Sendable {
	case add = "add"
	case subtract = "subtract"
	case reverseSubtract = "reverse-subtract"
	case min = "min"
	case max = "max"

}

@JS public enum GPUTextureAspect: String, Sendable {
	case all = "all"
	case stencilOnly = "stencil-only"
	case depthOnly = "depth-only"

}

@JS public enum GPUTextureDimension: String, Sendable {
	case _1D = "1d"
	case _2D = "2d"
	case _3D = "3d"
}

@JS public enum GPUStencilOperation: String, Sendable {
	case keep = "keep"
	case zero = "zero"
	case replace = "replace"
	case invert = "invert"
	case incrementClamp = "increment-clamp"
	case decrementClamp = "decrement-clamp"
	case incrementWrap = "increment-wrap"
	case decrementWrap = "decrement-wrap"
}

public enum GPUFeatureName: String, Sendable, Hashable {
	case depthClipControl = "depth-clip-control"
	case depth32FloatStencil8 = "depth32float-stencil8"
	case textureCompressionBC = "texture-compression-bc"
	case textureCompressionETC2 = "texture-compression-etc2"
	case textureCompressionASTC = "texture-compression-astc"
	case timestampQuery = "timestamp-query"
	case indirectFirstInstance = "indirect-first-instance"
	case shaderF16 = "shader-f16"
	case rg11b10ufloatRenderable = "rg11b10ufloat-renderable"
	case bgra8unormStorage = "bgra8unorm-storage"
	case float32Filterable = "float32-filterable"
}

public enum GPUPowerPreference: String, Sendable {
	case highPerformance = "high-performance"
	case lowPower = "low-power"
}

public enum GPUCompilationMessageType: String, Sendable {
	case error = "error"
	case warning = "warning"
	case info = "info"
}

// The following enums are stubs for Dawn API compatibility. On WASM they only
// appear in callback signatures and are never passed to JavaScript. They exist
// so that shared client code written against Dawn's native API compiles unchanged.

public enum GPUErrorType: Sendable {
	case noError
	case outOfMemory
	case validation
	case `internal`
	case unknown
}

public enum GPUBufferMapState: String, Sendable {
	case unmapped = "unmapped"
	case pending = "pending"
	case mapped = "mapped"
}

public enum GPUMapAsyncStatus: Sendable {
	case success
	case callbackCancelled
	case error
	case aborted
	case unknown
	case unmapped
}

public enum GPURequestAdapterStatus: Sendable {
	case success
	case callbackCancelled
	case unavailable
	case error
	case unknown
}

public enum GPURequestDeviceStatus: Sendable {
	case success
	case callbackCancelled
	case error
	case unknown
}

public enum GPUPopErrorScopeStatus: Sendable {
	case success
	case callbackCancelled
	case error
}

public enum GPUDeviceLostReason: Sendable {
	case unknown
	case destroyed
	case callbackCancelled
	case failedCreation
}

public enum GPUMapMode: Sendable {
	case read
	case write
}

public enum GPUCallbackMode: Sendable {
	case waitAnyOnly
	case allowProcessEvents
	case allowSpontaneous
}

public enum GPUBackendType: Sendable {
	case undefined
	case null
	case webGPU
	case d3D11
	case d3D12
	case metal
	case vulkan
	case openGL
	case openGLES
}

public enum GPUStatus: Sendable {
	case success
	case error
}

