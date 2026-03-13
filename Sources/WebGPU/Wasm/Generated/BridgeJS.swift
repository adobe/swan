// bridge-js: skip
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension GPUPrimitiveTopology: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUVertexFormat: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUVertexStepMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUTextureFormat: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPULoadOp: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUStoreOp: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUFrontFace: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUCullMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUIndexFormat: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUBufferBindingType: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUTextureViewDimension: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUTextureSampleType: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUStorageTextureAccess: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUSamplerBindingType: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUQueryType: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUAddressMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUFilterMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUMipmapFilterMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUCompareFunction: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUBlendFactor: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUBlendOperation: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUTextureAspect: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUTextureDimension: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUStencilOperation: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension GPUBufferDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBufferDescriptor {
        let mappedAtCreation = Bool.bridgeJSStackPop()
        let size = Int.bridgeJSStackPop()
        let usage = Int.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUBufferDescriptor(label: label, usage: usage, size: size, mappedAtCreation: mappedAtCreation)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.usage.bridgeJSStackPush()
        self.size.bridgeJSStackPush()
        self.mappedAtCreation.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBufferDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBufferDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBufferDescriptor")
fileprivate func _bjs_struct_lower_GPUBufferDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBufferDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBufferDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBufferDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferDescriptor")
fileprivate func _bjs_struct_lift_GPUBufferDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBufferDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUBufferDescriptor_extern()
}

extension GPUShaderModuleDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUShaderModuleDescriptor {
        let code = String.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUShaderModuleDescriptor(label: label, code: code)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.code.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUShaderModuleDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUShaderModuleDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUShaderModuleDescriptor")
fileprivate func _bjs_struct_lower_GPUShaderModuleDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUShaderModuleDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUShaderModuleDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUShaderModuleDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUShaderModuleDescriptor")
fileprivate func _bjs_struct_lift_GPUShaderModuleDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUShaderModuleDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUShaderModuleDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUShaderModuleDescriptor_extern()
}

extension GPUVertexAttribute: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUVertexAttribute {
        let shaderLocation = Int.bridgeJSStackPop()
        let offset = Int.bridgeJSStackPop()
        let format = GPUVertexFormat.bridgeJSStackPop()
        return GPUVertexAttribute(format: format, offset: offset, shaderLocation: shaderLocation)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.format.bridgeJSStackPush()
        self.offset.bridgeJSStackPush()
        self.shaderLocation.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUVertexAttribute(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUVertexAttribute()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUVertexAttribute")
fileprivate func _bjs_struct_lower_GPUVertexAttribute_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUVertexAttribute_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUVertexAttribute(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUVertexAttribute_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexAttribute")
fileprivate func _bjs_struct_lift_GPUVertexAttribute_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexAttribute_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUVertexAttribute() -> Int32 {
    return _bjs_struct_lift_GPUVertexAttribute_extern()
}

extension GPUVertexBufferLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUVertexBufferLayout {
        let attributes = [GPUVertexAttribute].bridgeJSStackPop()
        let stepMode = GPUVertexStepMode.bridgeJSStackPop()
        let arrayStride = Int.bridgeJSStackPop()
        return GPUVertexBufferLayout(arrayStride: arrayStride, stepMode: stepMode, attributes: attributes)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.arrayStride.bridgeJSStackPush()
        self.stepMode.bridgeJSStackPush()
        self.attributes.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUVertexBufferLayout(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUVertexBufferLayout()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUVertexBufferLayout")
fileprivate func _bjs_struct_lower_GPUVertexBufferLayout_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUVertexBufferLayout_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUVertexBufferLayout(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUVertexBufferLayout_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexBufferLayout")
fileprivate func _bjs_struct_lift_GPUVertexBufferLayout_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexBufferLayout_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUVertexBufferLayout() -> Int32 {
    return _bjs_struct_lift_GPUVertexBufferLayout_extern()
}

extension GPUPrimitiveState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUPrimitiveState {
        let cullMode = GPUCullMode.bridgeJSStackPop()
        let frontFace = GPUFrontFace.bridgeJSStackPop()
        let stripIndexFormat = GPUIndexFormat.bridgeJSStackPop()
        let topology = GPUPrimitiveTopology.bridgeJSStackPop()
        return GPUPrimitiveState(topology: topology, stripIndexFormat: stripIndexFormat, frontFace: frontFace, cullMode: cullMode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.topology.bridgeJSStackPush()
        self.stripIndexFormat.bridgeJSStackPush()
        self.frontFace.bridgeJSStackPush()
        self.cullMode.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUPrimitiveState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUPrimitiveState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUPrimitiveState")
fileprivate func _bjs_struct_lower_GPUPrimitiveState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUPrimitiveState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUPrimitiveState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUPrimitiveState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUPrimitiveState")
fileprivate func _bjs_struct_lift_GPUPrimitiveState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUPrimitiveState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUPrimitiveState() -> Int32 {
    return _bjs_struct_lift_GPUPrimitiveState_extern()
}

extension GPUBlendComponent: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBlendComponent {
        let dstFactor = GPUBlendFactor.bridgeJSStackPop()
        let srcFactor = GPUBlendFactor.bridgeJSStackPop()
        let operation = GPUBlendOperation.bridgeJSStackPop()
        return GPUBlendComponent(operation: operation, srcFactor: srcFactor, dstFactor: dstFactor)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.operation.bridgeJSStackPush()
        self.srcFactor.bridgeJSStackPush()
        self.dstFactor.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBlendComponent(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBlendComponent()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBlendComponent")
fileprivate func _bjs_struct_lower_GPUBlendComponent_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBlendComponent_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBlendComponent(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBlendComponent_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBlendComponent")
fileprivate func _bjs_struct_lift_GPUBlendComponent_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBlendComponent_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBlendComponent() -> Int32 {
    return _bjs_struct_lift_GPUBlendComponent_extern()
}

extension GPUBlendState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBlendState {
        let alpha = GPUBlendComponent.bridgeJSStackPop()
        let color = GPUBlendComponent.bridgeJSStackPop()
        return GPUBlendState(color: color, alpha: alpha)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.color.bridgeJSStackPush()
        self.alpha.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBlendState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBlendState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBlendState")
fileprivate func _bjs_struct_lower_GPUBlendState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBlendState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBlendState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBlendState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBlendState")
fileprivate func _bjs_struct_lift_GPUBlendState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBlendState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBlendState() -> Int32 {
    return _bjs_struct_lift_GPUBlendState_extern()
}

extension GPUColorTargetState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUColorTargetState {
        let writeMask = Int.bridgeJSStackPop()
        let blend = Optional<GPUBlendState>.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        return GPUColorTargetState(format: format, blend: blend, writeMask: writeMask)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.format.bridgeJSStackPush()
        self.blend.bridgeJSStackPush()
        self.writeMask.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUColorTargetState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUColorTargetState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUColorTargetState")
fileprivate func _bjs_struct_lower_GPUColorTargetState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUColorTargetState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUColorTargetState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUColorTargetState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUColorTargetState")
fileprivate func _bjs_struct_lift_GPUColorTargetState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUColorTargetState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUColorTargetState() -> Int32 {
    return _bjs_struct_lift_GPUColorTargetState_extern()
}

extension GPUColor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUColor {
        let a = Double.bridgeJSStackPop()
        let b = Double.bridgeJSStackPop()
        let g = Double.bridgeJSStackPop()
        let r = Double.bridgeJSStackPop()
        return GPUColor(r: r, g: g, b: b, a: a)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.r.bridgeJSStackPush()
        self.g.bridgeJSStackPush()
        self.b.bridgeJSStackPush()
        self.a.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUColor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUColor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUColor")
fileprivate func _bjs_struct_lower_GPUColor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUColor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUColor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUColor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUColor")
fileprivate func _bjs_struct_lift_GPUColor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUColor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUColor() -> Int32 {
    return _bjs_struct_lift_GPUColor_extern()
}

extension GPUCommandEncoderDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUCommandEncoderDescriptor {
        let label = Optional<String>.bridgeJSStackPop()
        return GPUCommandEncoderDescriptor(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUCommandEncoderDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUCommandEncoderDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUCommandEncoderDescriptor")
fileprivate func _bjs_struct_lower_GPUCommandEncoderDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUCommandEncoderDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUCommandEncoderDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUCommandEncoderDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUCommandEncoderDescriptor")
fileprivate func _bjs_struct_lift_GPUCommandEncoderDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUCommandEncoderDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUCommandEncoderDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUCommandEncoderDescriptor_extern()
}

extension GPUCommandBufferDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUCommandBufferDescriptor {
        let label = Optional<String>.bridgeJSStackPop()
        return GPUCommandBufferDescriptor(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUCommandBufferDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUCommandBufferDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUCommandBufferDescriptor")
fileprivate func _bjs_struct_lower_GPUCommandBufferDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUCommandBufferDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUCommandBufferDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUCommandBufferDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUCommandBufferDescriptor")
fileprivate func _bjs_struct_lift_GPUCommandBufferDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUCommandBufferDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUCommandBufferDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUCommandBufferDescriptor_extern()
}

extension GPURenderPassColorAttachment: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPassColorAttachment {
        let clearValue = Optional<GPUColor>.bridgeJSStackPop()
        let storeOp = GPUStoreOp.bridgeJSStackPop()
        let loadOp = GPULoadOp.bridgeJSStackPop()
        let view = GPUTextureView(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPURenderPassColorAttachment(view: view, loadOp: loadOp, storeOp: storeOp, clearValue: clearValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.view.jsObject.bridgeJSStackPush()
        self.loadOp.bridgeJSStackPush()
        self.storeOp.bridgeJSStackPush()
        self.clearValue.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPURenderPassColorAttachment(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPURenderPassColorAttachment()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPURenderPassColorAttachment")
fileprivate func _bjs_struct_lower_GPURenderPassColorAttachment_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPURenderPassColorAttachment_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPURenderPassColorAttachment(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPURenderPassColorAttachment_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPassColorAttachment")
fileprivate func _bjs_struct_lift_GPURenderPassColorAttachment_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPassColorAttachment_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPURenderPassColorAttachment() -> Int32 {
    return _bjs_struct_lift_GPURenderPassColorAttachment_extern()
}

extension GPURenderPassDepthStencilAttachment: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPassDepthStencilAttachment {
        let stencilReadOnly = Bool.bridgeJSStackPop()
        let stencilClearValue = Int.bridgeJSStackPop()
        let stencilStoreOp = Optional<GPUStoreOp>.bridgeJSStackPop()
        let stencilLoadOp = Optional<GPULoadOp>.bridgeJSStackPop()
        let depthReadOnly = Bool.bridgeJSStackPop()
        let depthClearValue = Double.bridgeJSStackPop()
        let depthStoreOp = Optional<GPUStoreOp>.bridgeJSStackPop()
        let depthLoadOp = Optional<GPULoadOp>.bridgeJSStackPop()
        let view = GPUTextureView(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPURenderPassDepthStencilAttachment(view: view, depthLoadOp: depthLoadOp, depthStoreOp: depthStoreOp, depthClearValue: depthClearValue, depthReadOnly: depthReadOnly, stencilLoadOp: stencilLoadOp, stencilStoreOp: stencilStoreOp, stencilClearValue: stencilClearValue, stencilReadOnly: stencilReadOnly)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.view.jsObject.bridgeJSStackPush()
        let __bjs_isSome_depthLoadOp = self.depthLoadOp != nil
        if let __bjs_unwrapped_depthLoadOp = self.depthLoadOp {
        __bjs_unwrapped_depthLoadOp.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_depthLoadOp ? 1 : 0)
        let __bjs_isSome_depthStoreOp = self.depthStoreOp != nil
        if let __bjs_unwrapped_depthStoreOp = self.depthStoreOp {
        __bjs_unwrapped_depthStoreOp.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_depthStoreOp ? 1 : 0)
        self.depthClearValue.bridgeJSStackPush()
        self.depthReadOnly.bridgeJSStackPush()
        let __bjs_isSome_stencilLoadOp = self.stencilLoadOp != nil
        if let __bjs_unwrapped_stencilLoadOp = self.stencilLoadOp {
        __bjs_unwrapped_stencilLoadOp.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_stencilLoadOp ? 1 : 0)
        let __bjs_isSome_stencilStoreOp = self.stencilStoreOp != nil
        if let __bjs_unwrapped_stencilStoreOp = self.stencilStoreOp {
        __bjs_unwrapped_stencilStoreOp.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_stencilStoreOp ? 1 : 0)
        self.stencilClearValue.bridgeJSStackPush()
        self.stencilReadOnly.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPURenderPassDepthStencilAttachment(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPURenderPassDepthStencilAttachment()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPURenderPassDepthStencilAttachment")
fileprivate func _bjs_struct_lower_GPURenderPassDepthStencilAttachment_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPURenderPassDepthStencilAttachment_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPURenderPassDepthStencilAttachment(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPURenderPassDepthStencilAttachment_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPassDepthStencilAttachment")
fileprivate func _bjs_struct_lift_GPURenderPassDepthStencilAttachment_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPassDepthStencilAttachment_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPURenderPassDepthStencilAttachment() -> Int32 {
    return _bjs_struct_lift_GPURenderPassDepthStencilAttachment_extern()
}

extension GPURenderPassDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPassDescriptor {
        let timestampWrites = Optional<GPUPassTimestampWrites>.bridgeJSStackPop()
        let depthStencilAttachment = Optional<GPURenderPassDepthStencilAttachment>.bridgeJSStackPop()
        let colorAttachments = [GPURenderPassColorAttachment].bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPURenderPassDescriptor(label: label, colorAttachments: colorAttachments, depthStencilAttachment: depthStencilAttachment, timestampWrites: timestampWrites)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.colorAttachments.bridgeJSStackPush()
        self.depthStencilAttachment.bridgeJSStackPush()
        self.timestampWrites.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPURenderPassDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPURenderPassDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPURenderPassDescriptor")
fileprivate func _bjs_struct_lower_GPURenderPassDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPURenderPassDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPURenderPassDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPURenderPassDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPassDescriptor")
fileprivate func _bjs_struct_lift_GPURenderPassDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPassDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPURenderPassDescriptor() -> Int32 {
    return _bjs_struct_lift_GPURenderPassDescriptor_extern()
}

extension GPUComputePassDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUComputePassDescriptor {
        let timestampWrites = Optional<GPUPassTimestampWrites>.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUComputePassDescriptor(label: label, timestampWrites: timestampWrites)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.timestampWrites.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUComputePassDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUComputePassDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUComputePassDescriptor")
fileprivate func _bjs_struct_lower_GPUComputePassDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUComputePassDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUComputePassDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUComputePassDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputePassDescriptor")
fileprivate func _bjs_struct_lift_GPUComputePassDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputePassDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUComputePassDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUComputePassDescriptor_extern()
}

extension GPUStencilFaceState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUStencilFaceState {
        let passOp = GPUStencilOperation.bridgeJSStackPop()
        let depthFailOp = GPUStencilOperation.bridgeJSStackPop()
        let failOp = GPUStencilOperation.bridgeJSStackPop()
        let compare = GPUCompareFunction.bridgeJSStackPop()
        return GPUStencilFaceState(compare: compare, failOp: failOp, depthFailOp: depthFailOp, passOp: passOp)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.compare.bridgeJSStackPush()
        self.failOp.bridgeJSStackPush()
        self.depthFailOp.bridgeJSStackPush()
        self.passOp.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUStencilFaceState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUStencilFaceState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUStencilFaceState")
fileprivate func _bjs_struct_lower_GPUStencilFaceState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUStencilFaceState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUStencilFaceState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUStencilFaceState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUStencilFaceState")
fileprivate func _bjs_struct_lift_GPUStencilFaceState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUStencilFaceState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUStencilFaceState() -> Int32 {
    return _bjs_struct_lift_GPUStencilFaceState_extern()
}

extension GPUDepthStencilState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUDepthStencilState {
        let depthBiasClamp = Double.bridgeJSStackPop()
        let depthBiasSlopeScale = Double.bridgeJSStackPop()
        let depthBias = Int.bridgeJSStackPop()
        let stencilWriteMask = Int.bridgeJSStackPop()
        let stencilReadMask = Int.bridgeJSStackPop()
        let stencilBack = GPUStencilFaceState.bridgeJSStackPop()
        let stencilFront = GPUStencilFaceState.bridgeJSStackPop()
        let depthCompare = GPUCompareFunction.bridgeJSStackPop()
        let depthWriteEnabled = Bool.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        return GPUDepthStencilState(format: format, depthWriteEnabled: depthWriteEnabled, depthCompare: depthCompare, stencilFront: stencilFront, stencilBack: stencilBack, stencilReadMask: stencilReadMask, stencilWriteMask: stencilWriteMask, depthBias: depthBias, depthBiasSlopeScale: depthBiasSlopeScale, depthBiasClamp: depthBiasClamp)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.format.bridgeJSStackPush()
        self.depthWriteEnabled.bridgeJSStackPush()
        self.depthCompare.bridgeJSStackPush()
        self.stencilFront.bridgeJSStackPush()
        self.stencilBack.bridgeJSStackPush()
        self.stencilReadMask.bridgeJSStackPush()
        self.stencilWriteMask.bridgeJSStackPush()
        self.depthBias.bridgeJSStackPush()
        self.depthBiasSlopeScale.bridgeJSStackPush()
        self.depthBiasClamp.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUDepthStencilState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUDepthStencilState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUDepthStencilState")
fileprivate func _bjs_struct_lower_GPUDepthStencilState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUDepthStencilState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUDepthStencilState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUDepthStencilState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUDepthStencilState")
fileprivate func _bjs_struct_lift_GPUDepthStencilState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUDepthStencilState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUDepthStencilState() -> Int32 {
    return _bjs_struct_lift_GPUDepthStencilState_extern()
}

extension GPUExtent3D: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUExtent3D {
        let depthOrArrayLayers = Int.bridgeJSStackPop()
        let height = Int.bridgeJSStackPop()
        let width = Int.bridgeJSStackPop()
        return GPUExtent3D(width: width, height: height, depthOrArrayLayers: depthOrArrayLayers)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.width.bridgeJSStackPush()
        self.height.bridgeJSStackPush()
        self.depthOrArrayLayers.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUExtent3D(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUExtent3D()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUExtent3D")
fileprivate func _bjs_struct_lower_GPUExtent3D_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUExtent3D_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUExtent3D(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUExtent3D_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUExtent3D")
fileprivate func _bjs_struct_lift_GPUExtent3D_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUExtent3D_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUExtent3D() -> Int32 {
    return _bjs_struct_lift_GPUExtent3D_extern()
}

extension GPUOrigin3D: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUOrigin3D {
        let z = Int.bridgeJSStackPop()
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return GPUOrigin3D(x: x, y: y, z: z)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
        self.z.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUOrigin3D(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUOrigin3D()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUOrigin3D")
fileprivate func _bjs_struct_lower_GPUOrigin3D_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUOrigin3D_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUOrigin3D(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUOrigin3D_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUOrigin3D")
fileprivate func _bjs_struct_lift_GPUOrigin3D_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUOrigin3D_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUOrigin3D() -> Int32 {
    return _bjs_struct_lift_GPUOrigin3D_extern()
}

extension GPUTextureDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUTextureDescriptor {
        let usage = Int.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        let dimension = GPUTextureDimension.bridgeJSStackPop()
        let sampleCount = Int.bridgeJSStackPop()
        let mipLevelCount = Int.bridgeJSStackPop()
        let size = GPUExtent3D.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUTextureDescriptor(label: label, size: size, mipLevelCount: mipLevelCount, sampleCount: sampleCount, dimension: dimension, format: format, usage: usage)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.size.bridgeJSStackPush()
        self.mipLevelCount.bridgeJSStackPush()
        self.sampleCount.bridgeJSStackPush()
        self.dimension.bridgeJSStackPush()
        self.format.bridgeJSStackPush()
        self.usage.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUTextureDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUTextureDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUTextureDescriptor")
fileprivate func _bjs_struct_lower_GPUTextureDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUTextureDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUTextureDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUTextureDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUTextureDescriptor")
fileprivate func _bjs_struct_lift_GPUTextureDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUTextureDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUTextureDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUTextureDescriptor_extern()
}

extension GPUTextureViewDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUTextureViewDescriptor {
        let arrayLayerCount = Optional<Int>.bridgeJSStackPop()
        let baseArrayLayer = Int.bridgeJSStackPop()
        let mipLevelCount = Optional<Int>.bridgeJSStackPop()
        let baseMipLevel = Int.bridgeJSStackPop()
        let aspect = GPUTextureAspect.bridgeJSStackPop()
        let dimension = Optional<GPUTextureViewDimension>.bridgeJSStackPop()
        let format = Optional<GPUTextureFormat>.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUTextureViewDescriptor(label: label, format: format, dimension: dimension, aspect: aspect, baseMipLevel: baseMipLevel, mipLevelCount: mipLevelCount, baseArrayLayer: baseArrayLayer, arrayLayerCount: arrayLayerCount)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        let __bjs_isSome_format = self.format != nil
        if let __bjs_unwrapped_format = self.format {
        __bjs_unwrapped_format.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_format ? 1 : 0)
        let __bjs_isSome_dimension = self.dimension != nil
        if let __bjs_unwrapped_dimension = self.dimension {
        __bjs_unwrapped_dimension.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_dimension ? 1 : 0)
        self.aspect.bridgeJSStackPush()
        self.baseMipLevel.bridgeJSStackPush()
        let __bjs_isSome_mipLevelCount = self.mipLevelCount != nil
        if let __bjs_unwrapped_mipLevelCount = self.mipLevelCount {
        __bjs_unwrapped_mipLevelCount.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_mipLevelCount ? 1 : 0)
        self.baseArrayLayer.bridgeJSStackPush()
        let __bjs_isSome_arrayLayerCount = self.arrayLayerCount != nil
        if let __bjs_unwrapped_arrayLayerCount = self.arrayLayerCount {
        __bjs_unwrapped_arrayLayerCount.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_arrayLayerCount ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUTextureViewDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUTextureViewDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUTextureViewDescriptor")
fileprivate func _bjs_struct_lower_GPUTextureViewDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUTextureViewDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUTextureViewDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUTextureViewDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUTextureViewDescriptor")
fileprivate func _bjs_struct_lift_GPUTextureViewDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUTextureViewDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUTextureViewDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUTextureViewDescriptor_extern()
}

extension GPUSamplerDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUSamplerDescriptor {
        let maxAnisotropy = Int.bridgeJSStackPop()
        let compare = Optional<GPUCompareFunction>.bridgeJSStackPop()
        let lodMaxClamp = Double.bridgeJSStackPop()
        let lodMinClamp = Double.bridgeJSStackPop()
        let mipmapFilter = GPUMipmapFilterMode.bridgeJSStackPop()
        let minFilter = GPUFilterMode.bridgeJSStackPop()
        let magFilter = GPUFilterMode.bridgeJSStackPop()
        let addressModeW = GPUAddressMode.bridgeJSStackPop()
        let addressModeV = GPUAddressMode.bridgeJSStackPop()
        let addressModeU = GPUAddressMode.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUSamplerDescriptor(label: label, addressModeU: addressModeU, addressModeV: addressModeV, addressModeW: addressModeW, magFilter: magFilter, minFilter: minFilter, mipmapFilter: mipmapFilter, lodMinClamp: lodMinClamp, lodMaxClamp: lodMaxClamp, compare: compare, maxAnisotropy: maxAnisotropy)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.addressModeU.bridgeJSStackPush()
        self.addressModeV.bridgeJSStackPush()
        self.addressModeW.bridgeJSStackPush()
        self.magFilter.bridgeJSStackPush()
        self.minFilter.bridgeJSStackPush()
        self.mipmapFilter.bridgeJSStackPush()
        self.lodMinClamp.bridgeJSStackPush()
        self.lodMaxClamp.bridgeJSStackPush()
        let __bjs_isSome_compare = self.compare != nil
        if let __bjs_unwrapped_compare = self.compare {
        __bjs_unwrapped_compare.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_compare ? 1 : 0)
        self.maxAnisotropy.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUSamplerDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUSamplerDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUSamplerDescriptor")
fileprivate func _bjs_struct_lower_GPUSamplerDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUSamplerDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUSamplerDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUSamplerDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUSamplerDescriptor")
fileprivate func _bjs_struct_lift_GPUSamplerDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUSamplerDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUSamplerDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUSamplerDescriptor_extern()
}

extension GPUQuerySetDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUQuerySetDescriptor {
        let count = Int.bridgeJSStackPop()
        let type = GPUQueryType.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUQuerySetDescriptor(label: label, type: type, count: count)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.type.bridgeJSStackPush()
        self.count.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUQuerySetDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUQuerySetDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUQuerySetDescriptor")
fileprivate func _bjs_struct_lower_GPUQuerySetDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUQuerySetDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUQuerySetDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUQuerySetDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUQuerySetDescriptor")
fileprivate func _bjs_struct_lift_GPUQuerySetDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUQuerySetDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUQuerySetDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUQuerySetDescriptor_extern()
}

extension GPUPassTimestampWrites: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUPassTimestampWrites {
        let endOfPassWriteIndex = Int.bridgeJSStackPop()
        let beginningOfPassWriteIndex = Int.bridgeJSStackPop()
        let querySet = GPUQuerySet(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUPassTimestampWrites(querySet: querySet, beginningOfPassWriteIndex: beginningOfPassWriteIndex, endOfPassWriteIndex: endOfPassWriteIndex)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.querySet.jsObject.bridgeJSStackPush()
        self.beginningOfPassWriteIndex.bridgeJSStackPush()
        self.endOfPassWriteIndex.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUPassTimestampWrites(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUPassTimestampWrites()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUPassTimestampWrites")
fileprivate func _bjs_struct_lower_GPUPassTimestampWrites_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUPassTimestampWrites_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUPassTimestampWrites(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUPassTimestampWrites_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUPassTimestampWrites")
fileprivate func _bjs_struct_lift_GPUPassTimestampWrites_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUPassTimestampWrites_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUPassTimestampWrites() -> Int32 {
    return _bjs_struct_lift_GPUPassTimestampWrites_extern()
}

extension GPUBufferBindingLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBufferBindingLayout {
        let minBindingSize = Int.bridgeJSStackPop()
        let hasDynamicOffset = Bool.bridgeJSStackPop()
        let type = GPUBufferBindingType.bridgeJSStackPop()
        return GPUBufferBindingLayout(type: type, hasDynamicOffset: hasDynamicOffset, minBindingSize: minBindingSize)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.type.bridgeJSStackPush()
        self.hasDynamicOffset.bridgeJSStackPush()
        self.minBindingSize.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBufferBindingLayout(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBufferBindingLayout()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBufferBindingLayout")
fileprivate func _bjs_struct_lower_GPUBufferBindingLayout_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBufferBindingLayout_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBufferBindingLayout(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBufferBindingLayout_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferBindingLayout")
fileprivate func _bjs_struct_lift_GPUBufferBindingLayout_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferBindingLayout_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBufferBindingLayout() -> Int32 {
    return _bjs_struct_lift_GPUBufferBindingLayout_extern()
}

extension GPUSamplerBindingLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUSamplerBindingLayout {
        let type = GPUSamplerBindingType.bridgeJSStackPop()
        return GPUSamplerBindingLayout(type: type)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.type.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUSamplerBindingLayout(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUSamplerBindingLayout()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUSamplerBindingLayout")
fileprivate func _bjs_struct_lower_GPUSamplerBindingLayout_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUSamplerBindingLayout_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUSamplerBindingLayout(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUSamplerBindingLayout_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUSamplerBindingLayout")
fileprivate func _bjs_struct_lift_GPUSamplerBindingLayout_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUSamplerBindingLayout_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUSamplerBindingLayout() -> Int32 {
    return _bjs_struct_lift_GPUSamplerBindingLayout_extern()
}

extension GPUTextureBindingLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUTextureBindingLayout {
        let multisampled = Bool.bridgeJSStackPop()
        let viewDimension = GPUTextureViewDimension.bridgeJSStackPop()
        let sampleType = GPUTextureSampleType.bridgeJSStackPop()
        return GPUTextureBindingLayout(sampleType: sampleType, viewDimension: viewDimension, multisampled: multisampled)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.sampleType.bridgeJSStackPush()
        self.viewDimension.bridgeJSStackPush()
        self.multisampled.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUTextureBindingLayout(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUTextureBindingLayout()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUTextureBindingLayout")
fileprivate func _bjs_struct_lower_GPUTextureBindingLayout_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUTextureBindingLayout_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUTextureBindingLayout(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUTextureBindingLayout_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUTextureBindingLayout")
fileprivate func _bjs_struct_lift_GPUTextureBindingLayout_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUTextureBindingLayout_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUTextureBindingLayout() -> Int32 {
    return _bjs_struct_lift_GPUTextureBindingLayout_extern()
}

extension GPUStorageTextureBindingLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUStorageTextureBindingLayout {
        let viewDimension = GPUTextureViewDimension.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        let access = GPUStorageTextureAccess.bridgeJSStackPop()
        return GPUStorageTextureBindingLayout(access: access, format: format, viewDimension: viewDimension)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.access.bridgeJSStackPush()
        self.format.bridgeJSStackPush()
        self.viewDimension.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUStorageTextureBindingLayout(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUStorageTextureBindingLayout()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUStorageTextureBindingLayout")
fileprivate func _bjs_struct_lower_GPUStorageTextureBindingLayout_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUStorageTextureBindingLayout_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUStorageTextureBindingLayout(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUStorageTextureBindingLayout_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUStorageTextureBindingLayout")
fileprivate func _bjs_struct_lift_GPUStorageTextureBindingLayout_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUStorageTextureBindingLayout_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUStorageTextureBindingLayout() -> Int32 {
    return _bjs_struct_lift_GPUStorageTextureBindingLayout_extern()
}

extension GPUBindGroupLayoutEntry: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBindGroupLayoutEntry {
        let storageTexture = Optional<GPUStorageTextureBindingLayout>.bridgeJSStackPop()
        let texture = Optional<GPUTextureBindingLayout>.bridgeJSStackPop()
        let sampler = Optional<GPUSamplerBindingLayout>.bridgeJSStackPop()
        let buffer = Optional<GPUBufferBindingLayout>.bridgeJSStackPop()
        let visibility = Int.bridgeJSStackPop()
        let binding = Int.bridgeJSStackPop()
        return GPUBindGroupLayoutEntry(binding: binding, visibility: visibility, buffer: buffer, sampler: sampler, texture: texture, storageTexture: storageTexture)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.binding.bridgeJSStackPush()
        self.visibility.bridgeJSStackPush()
        self.buffer.bridgeJSStackPush()
        self.sampler.bridgeJSStackPush()
        self.texture.bridgeJSStackPush()
        self.storageTexture.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBindGroupLayoutEntry(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBindGroupLayoutEntry()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBindGroupLayoutEntry")
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutEntry_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutEntry_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBindGroupLayoutEntry(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBindGroupLayoutEntry_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupLayoutEntry")
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutEntry_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutEntry_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBindGroupLayoutEntry() -> Int32 {
    return _bjs_struct_lift_GPUBindGroupLayoutEntry_extern()
}

extension GPUBindGroupLayoutDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBindGroupLayoutDescriptor {
        let entries = [GPUBindGroupLayoutEntry].bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUBindGroupLayoutDescriptor(label: label, entries: entries)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.entries.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBindGroupLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBindGroupLayoutDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBindGroupLayoutDescriptor")
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBindGroupLayoutDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBindGroupLayoutDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupLayoutDescriptor")
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBindGroupLayoutDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUBindGroupLayoutDescriptor_extern()
}

extension GPUMultisampleState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUMultisampleState {
        let alphaToCoverageEnabled = Bool.bridgeJSStackPop()
        let mask = Int.bridgeJSStackPop()
        let count = Int.bridgeJSStackPop()
        return GPUMultisampleState(count: count, mask: mask, alphaToCoverageEnabled: alphaToCoverageEnabled)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.count.bridgeJSStackPush()
        self.mask.bridgeJSStackPush()
        self.alphaToCoverageEnabled.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUMultisampleState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUMultisampleState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUMultisampleState")
fileprivate func _bjs_struct_lower_GPUMultisampleState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUMultisampleState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUMultisampleState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUMultisampleState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUMultisampleState")
fileprivate func _bjs_struct_lift_GPUMultisampleState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUMultisampleState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUMultisampleState() -> Int32 {
    return _bjs_struct_lift_GPUMultisampleState_extern()
}

extension GPUVertexState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUVertexState {
        let buffers = [GPUVertexBufferLayout].bridgeJSStackPop()
        let entryPoint = Optional<String>.bridgeJSStackPop()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUVertexState(module: module, entryPoint: entryPoint, buffers: buffers)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.module.jsObject.bridgeJSStackPush()
        let __bjs_isSome_entryPoint = self.entryPoint != nil
        if let __bjs_unwrapped_entryPoint = self.entryPoint {
        __bjs_unwrapped_entryPoint.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_entryPoint ? 1 : 0)
        self.buffers.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUVertexState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUVertexState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUVertexState")
fileprivate func _bjs_struct_lower_GPUVertexState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUVertexState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUVertexState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUVertexState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexState")
fileprivate func _bjs_struct_lift_GPUVertexState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUVertexState() -> Int32 {
    return _bjs_struct_lift_GPUVertexState_extern()
}

extension GPUFragmentState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUFragmentState {
        let targets = [GPUColorTargetState].bridgeJSStackPop()
        let entryPoint = Optional<String>.bridgeJSStackPop()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUFragmentState(module: module, entryPoint: entryPoint, targets: targets)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.module.jsObject.bridgeJSStackPush()
        let __bjs_isSome_entryPoint = self.entryPoint != nil
        if let __bjs_unwrapped_entryPoint = self.entryPoint {
        __bjs_unwrapped_entryPoint.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_entryPoint ? 1 : 0)
        self.targets.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUFragmentState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUFragmentState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUFragmentState")
fileprivate func _bjs_struct_lower_GPUFragmentState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUFragmentState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUFragmentState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUFragmentState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUFragmentState")
fileprivate func _bjs_struct_lift_GPUFragmentState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUFragmentState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUFragmentState() -> Int32 {
    return _bjs_struct_lift_GPUFragmentState_extern()
}

extension GPURenderPipelineDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPipelineDescriptor {
        let fragment = Optional<GPUFragmentState>.bridgeJSStackPop()
        let multisample = GPUMultisampleState.bridgeJSStackPop()
        let depthStencil = Optional<GPUDepthStencilState>.bridgeJSStackPop()
        let primitive = GPUPrimitiveState.bridgeJSStackPop()
        let vertex = GPUVertexState.bridgeJSStackPop()
        let layout = Optional<JSObject>.bridgeJSStackPop().map { GPUPipelineLayout(unsafelyWrapping: $0) }
        let label = Optional<String>.bridgeJSStackPop()
        return GPURenderPipelineDescriptor(label: label, layout: layout, vertex: vertex, primitive: primitive, depthStencil: depthStencil, multisample: multisample, fragment: fragment)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        let __bjs_isSome_layout = self.layout != nil
        if let __bjs_unwrapped_layout = self.layout {
        __bjs_unwrapped_layout.jsObject.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_layout ? 1 : 0)
        self.vertex.bridgeJSStackPush()
        self.primitive.bridgeJSStackPush()
        self.depthStencil.bridgeJSStackPush()
        self.multisample.bridgeJSStackPush()
        self.fragment.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPURenderPipelineDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPURenderPipelineDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPURenderPipelineDescriptor")
fileprivate func _bjs_struct_lower_GPURenderPipelineDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPURenderPipelineDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPURenderPipelineDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPURenderPipelineDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPipelineDescriptor")
fileprivate func _bjs_struct_lift_GPURenderPipelineDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPipelineDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPURenderPipelineDescriptor() -> Int32 {
    return _bjs_struct_lift_GPURenderPipelineDescriptor_extern()
}

extension GPUBufferBinding: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBufferBinding {
        let size = Optional<Int>.bridgeJSStackPop()
        let offset = Optional<Int>.bridgeJSStackPop()
        let buffer = GPUBuffer(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUBufferBinding(buffer: buffer, offset: offset, size: size)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.buffer.jsObject.bridgeJSStackPush()
        let __bjs_isSome_offset = self.offset != nil
        if let __bjs_unwrapped_offset = self.offset {
        __bjs_unwrapped_offset.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_offset ? 1 : 0)
        let __bjs_isSome_size = self.size != nil
        if let __bjs_unwrapped_size = self.size {
        __bjs_unwrapped_size.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_size ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBufferBinding(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBufferBinding()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBufferBinding")
fileprivate func _bjs_struct_lower_GPUBufferBinding_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBufferBinding_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBufferBinding(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBufferBinding_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferBinding")
fileprivate func _bjs_struct_lift_GPUBufferBinding_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferBinding_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBufferBinding() -> Int32 {
    return _bjs_struct_lift_GPUBufferBinding_extern()
}

extension GPUBindGroupEntry: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBindGroupEntry {
        let resource = GPUBufferBinding.bridgeJSStackPop()
        let binding = Int.bridgeJSStackPop()
        return GPUBindGroupEntry(binding: binding, resource: resource)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.binding.bridgeJSStackPush()
        self.resource.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBindGroupEntry(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBindGroupEntry()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBindGroupEntry")
fileprivate func _bjs_struct_lower_GPUBindGroupEntry_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBindGroupEntry_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBindGroupEntry(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBindGroupEntry_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupEntry")
fileprivate func _bjs_struct_lift_GPUBindGroupEntry_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupEntry_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBindGroupEntry() -> Int32 {
    return _bjs_struct_lift_GPUBindGroupEntry_extern()
}

extension GPUBindGroupDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBindGroupDescriptor {
        let entries = [GPUBindGroupEntry].bridgeJSStackPop()
        let layout = GPUBindGroupLayout(unsafelyWrapping: JSObject.bridgeJSStackPop())
        let label = Optional<String>.bridgeJSStackPop()
        return GPUBindGroupDescriptor(label: label, layout: layout, entries: entries)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.jsObject.bridgeJSStackPush()
        self.entries.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUBindGroupDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUBindGroupDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUBindGroupDescriptor")
fileprivate func _bjs_struct_lower_GPUBindGroupDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUBindGroupDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUBindGroupDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUBindGroupDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupDescriptor")
fileprivate func _bjs_struct_lift_GPUBindGroupDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUBindGroupDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUBindGroupDescriptor_extern()
}

extension GPUCanvasConfiguration: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUCanvasConfiguration {
        let alphaMode = String.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        let device = GPUDevice(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUCanvasConfiguration(device: device, format: format, alphaMode: alphaMode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.device.jsObject.bridgeJSStackPush()
        self.format.bridgeJSStackPush()
        self.alphaMode.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUCanvasConfiguration(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUCanvasConfiguration()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUCanvasConfiguration")
fileprivate func _bjs_struct_lower_GPUCanvasConfiguration_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUCanvasConfiguration_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUCanvasConfiguration(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUCanvasConfiguration_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUCanvasConfiguration")
fileprivate func _bjs_struct_lift_GPUCanvasConfiguration_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUCanvasConfiguration_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUCanvasConfiguration() -> Int32 {
    return _bjs_struct_lift_GPUCanvasConfiguration_extern()
}

extension GPUComputeState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUComputeState {
        let entryPoint = String.bridgeJSStackPop()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUComputeState(module: module, entryPoint: entryPoint)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.module.jsObject.bridgeJSStackPush()
        self.entryPoint.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUComputeState(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUComputeState()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUComputeState")
fileprivate func _bjs_struct_lower_GPUComputeState_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUComputeState_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUComputeState(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUComputeState_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputeState")
fileprivate func _bjs_struct_lift_GPUComputeState_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputeState_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUComputeState() -> Int32 {
    return _bjs_struct_lift_GPUComputeState_extern()
}

extension GPUComputePipelineDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUComputePipelineDescriptor {
        let compute = GPUComputeState.bridgeJSStackPop()
        let layout = GPUPipelineLayout(unsafelyWrapping: JSObject.bridgeJSStackPop())
        let label = Optional<String>.bridgeJSStackPop()
        return GPUComputePipelineDescriptor(label: label, layout: layout, compute: compute)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.jsObject.bridgeJSStackPush()
        self.compute.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUComputePipelineDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUComputePipelineDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUComputePipelineDescriptor")
fileprivate func _bjs_struct_lower_GPUComputePipelineDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUComputePipelineDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUComputePipelineDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUComputePipelineDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputePipelineDescriptor")
fileprivate func _bjs_struct_lift_GPUComputePipelineDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputePipelineDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUComputePipelineDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUComputePipelineDescriptor_extern()
}

extension GPUPipelineLayoutDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUPipelineLayoutDescriptor {
        let bindGroupLayouts = [JSObject].bridgeJSStackPop().map { GPUBindGroupLayout(unsafelyWrapping: $0) }
        let label = Optional<String>.bridgeJSStackPop()
        return GPUPipelineLayoutDescriptor(label: label, bindGroupLayouts: bindGroupLayouts)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.bindGroupLayouts.map { $0.jsObject }.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GPUPipelineLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GPUPipelineLayoutDescriptor()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GPUPipelineLayoutDescriptor")
fileprivate func _bjs_struct_lower_GPUPipelineLayoutDescriptor_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GPUPipelineLayoutDescriptor_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GPUPipelineLayoutDescriptor(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GPUPipelineLayoutDescriptor_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUPipelineLayoutDescriptor")
fileprivate func _bjs_struct_lift_GPUPipelineLayoutDescriptor_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUPipelineLayoutDescriptor_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GPUPipelineLayoutDescriptor() -> Int32 {
    return _bjs_struct_lift_GPUPipelineLayoutDescriptor_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUAdapter_label__set")
fileprivate func bjs_GPUAdapter_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUAdapter_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUAdapter_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUAdapter_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUAdapter__hasFeature")
fileprivate func bjs_GPUAdapter__hasFeature_extern(_ self: Int32, _ feature: Int32) -> Int32
#else
fileprivate func bjs_GPUAdapter__hasFeature_extern(_ self: Int32, _ feature: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUAdapter__hasFeature(_ self: Int32, _ feature: Int32) -> Int32 {
    return bjs_GPUAdapter__hasFeature_extern(self, feature)
}

func _$GPUAdapter_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUAdapter_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUAdapter__hasFeature(_ self: JSObject, _ feature: String) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let featureValue = feature.bridgeJSLowerParameter()
    let ret = bjs_GPUAdapter__hasFeature(selfValue, featureValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBindGroup_label__set")
fileprivate func bjs_GPUBindGroup_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUBindGroup_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBindGroup_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUBindGroup_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUBindGroup_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUBindGroup_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBindGroupLayout_label__set")
fileprivate func bjs_GPUBindGroupLayout_label__set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_GPUBindGroupLayout_label__set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBindGroupLayout_label__set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_GPUBindGroupLayout_label__set_extern(self, newValue)
}

func _$GPUBindGroupLayout_label__set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_GPUBindGroupLayout_label__set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__size_get")
fileprivate func bjs_GPUBuffer__size_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer__size_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__size_get(_ self: Int32) -> Int32 {
    return bjs_GPUBuffer__size_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__usage_get")
fileprivate func bjs_GPUBuffer__usage_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer__usage_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__usage_get(_ self: Int32) -> Int32 {
    return bjs_GPUBuffer__usage_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__mapState_get")
fileprivate func bjs_GPUBuffer__mapState_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer__mapState_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__mapState_get(_ self: Int32) -> Int32 {
    return bjs_GPUBuffer__mapState_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer_label__set")
fileprivate func bjs_GPUBuffer_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUBuffer_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUBuffer_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__destroy")
fileprivate func bjs_GPUBuffer__destroy_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBuffer__destroy_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__destroy(_ self: Int32) -> Void {
    return bjs_GPUBuffer__destroy_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__mapAsync")
fileprivate func bjs_GPUBuffer__mapAsync_extern(_ self: Int32, _ mode: Int32, _ offset: Int32, _ size: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer__mapAsync_extern(_ self: Int32, _ mode: Int32, _ offset: Int32, _ size: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__mapAsync(_ self: Int32, _ mode: Int32, _ offset: Int32, _ size: Int32) -> Int32 {
    return bjs_GPUBuffer__mapAsync_extern(self, mode, offset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__getMappedRange")
fileprivate func bjs_GPUBuffer__getMappedRange_extern(_ self: Int32, _ offset: Int32, _ size: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer__getMappedRange_extern(_ self: Int32, _ offset: Int32, _ size: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__getMappedRange(_ self: Int32, _ offset: Int32, _ size: Int32) -> Int32 {
    return bjs_GPUBuffer__getMappedRange_extern(self, offset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer__unmap")
fileprivate func bjs_GPUBuffer__unmap_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBuffer__unmap_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUBuffer__unmap(_ self: Int32) -> Void {
    return bjs_GPUBuffer__unmap_extern(self)
}

func _$GPUBuffer__size_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer__size_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer__usage_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer__usage_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer__mapState_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer__mapState_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUBuffer_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUBuffer__destroy(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBuffer__destroy(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUBuffer__mapAsync(_ self: JSObject, _ mode: Int, _ offset: Int, _ size: Int) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let modeValue = mode.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer__mapAsync(selfValue, modeValue, offsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer__getMappedRange(_ self: JSObject, _ offset: Int, _ size: Int) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer__getMappedRange(selfValue, offsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer__unmap(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBuffer__unmap(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCanvasContext__configure")
fileprivate func bjs_GPUCanvasContext__configure_extern(_ self: Int32, _ configuration: Int32) -> Void
#else
fileprivate func bjs_GPUCanvasContext__configure_extern(_ self: Int32, _ configuration: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCanvasContext__configure(_ self: Int32, _ configuration: Int32) -> Void {
    return bjs_GPUCanvasContext__configure_extern(self, configuration)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCanvasContext__getCurrentTexture")
fileprivate func bjs_GPUCanvasContext__getCurrentTexture_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUCanvasContext__getCurrentTexture_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCanvasContext__getCurrentTexture(_ self: Int32) -> Int32 {
    return bjs_GPUCanvasContext__getCurrentTexture_extern(self)
}

func _$GPUCanvasContext__configure(_ self: JSObject, _ configuration: GPUCanvasConfiguration) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let configurationObjectId = configuration.bridgeJSLowerParameter()
    bjs_GPUCanvasContext__configure(selfValue, configurationObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCanvasContext__getCurrentTexture(_ self: JSObject) throws(JSException) -> GPUTexture {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUCanvasContext__getCurrentTexture(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTexture.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandBuffer_label__set")
fileprivate func bjs_GPUCommandBuffer_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUCommandBuffer_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandBuffer_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUCommandBuffer_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUCommandBuffer_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUCommandBuffer_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder_label__set")
fileprivate func bjs_GPUCommandEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUCommandEncoder_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__beginRenderPass")
fileprivate func bjs_GPUCommandEncoder__beginRenderPass_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder__beginRenderPass_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__beginRenderPass(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUCommandEncoder__beginRenderPass_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__beginComputePass")
fileprivate func bjs_GPUCommandEncoder__beginComputePass_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder__beginComputePass_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__beginComputePass(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUCommandEncoder__beginComputePass_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__finish")
fileprivate func bjs_GPUCommandEncoder__finish_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder__finish_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__finish(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUCommandEncoder__finish_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__copyBufferToBuffer")
fileprivate func bjs_GPUCommandEncoder__copyBufferToBuffer_extern(_ self: Int32, _ source: Int32, _ sourceOffset: Int32, _ destination: Int32, _ destinationOffset: Int32, _ size: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__copyBufferToBuffer_extern(_ self: Int32, _ source: Int32, _ sourceOffset: Int32, _ destination: Int32, _ destinationOffset: Int32, _ size: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__copyBufferToBuffer(_ self: Int32, _ source: Int32, _ sourceOffset: Int32, _ destination: Int32, _ destinationOffset: Int32, _ size: Int32) -> Void {
    return bjs_GPUCommandEncoder__copyBufferToBuffer_extern(self, source, sourceOffset, destination, destinationOffset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__copyBufferToTexture")
fileprivate func bjs_GPUCommandEncoder__copyBufferToTexture_extern(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__copyBufferToTexture_extern(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__copyBufferToTexture(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void {
    return bjs_GPUCommandEncoder__copyBufferToTexture_extern(self, source, destination, copySize)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__copyTextureToBuffer")
fileprivate func bjs_GPUCommandEncoder__copyTextureToBuffer_extern(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__copyTextureToBuffer_extern(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__copyTextureToBuffer(_ self: Int32, _ source: Int32, _ destination: Int32, _ copySize: Int32) -> Void {
    return bjs_GPUCommandEncoder__copyTextureToBuffer_extern(self, source, destination, copySize)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__resolveQuerySet")
fileprivate func bjs_GPUCommandEncoder__resolveQuerySet_extern(_ self: Int32, _ querySet: Int32, _ firstQuery: Int32, _ queryCount: Int32, _ destination: Int32, _ destinationOffset: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__resolveQuerySet_extern(_ self: Int32, _ querySet: Int32, _ firstQuery: Int32, _ queryCount: Int32, _ destination: Int32, _ destinationOffset: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__resolveQuerySet(_ self: Int32, _ querySet: Int32, _ firstQuery: Int32, _ queryCount: Int32, _ destination: Int32, _ destinationOffset: Int32) -> Void {
    return bjs_GPUCommandEncoder__resolveQuerySet_extern(self, querySet, firstQuery, queryCount, destination, destinationOffset)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__clearBuffer")
fileprivate func bjs_GPUCommandEncoder__clearBuffer_extern(_ self: Int32, _ buffer: Int32, _ offset: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__clearBuffer_extern(_ self: Int32, _ buffer: Int32, _ offset: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__clearBuffer(_ self: Int32, _ buffer: Int32, _ offset: Int32) -> Void {
    return bjs_GPUCommandEncoder__clearBuffer_extern(self, buffer, offset)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__clearBufferWithSize")
fileprivate func bjs_GPUCommandEncoder__clearBufferWithSize_extern(_ self: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__clearBufferWithSize_extern(_ self: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__clearBufferWithSize(_ self: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void {
    return bjs_GPUCommandEncoder__clearBufferWithSize_extern(self, buffer, offset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder__writeTimestamp")
fileprivate func bjs_GPUCommandEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUCommandEncoder__writeTimestamp(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    return bjs_GPUCommandEncoder__writeTimestamp_extern(self, querySet, queryIndex)
}

func _$GPUCommandEncoder_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__beginRenderPass(_ self: JSObject, _ descriptor: GPURenderPassDescriptor) throws(JSException) -> GPURenderPassEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder__beginRenderPass(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPURenderPassEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUCommandEncoder__beginComputePass(_ self: JSObject, _ descriptor: GPUComputePassDescriptor) throws(JSException) -> GPUComputePassEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder__beginComputePass(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUComputePassEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUCommandEncoder__finish(_ self: JSObject, _ descriptor: GPUCommandBufferDescriptor) throws(JSException) -> GPUCommandBuffer {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder__finish(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUCommandBuffer.bridgeJSLiftReturn(ret)
}

func _$GPUCommandEncoder__copyBufferToBuffer(_ self: JSObject, _ source: GPUBuffer, _ sourceOffset: Int, _ destination: GPUBuffer, _ destinationOffset: Int, _ size: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let sourceValue = source.bridgeJSLowerParameter()
    let sourceOffsetValue = sourceOffset.bridgeJSLowerParameter()
    let destinationValue = destination.bridgeJSLowerParameter()
    let destinationOffsetValue = destinationOffset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__copyBufferToBuffer(selfValue, sourceValue, sourceOffsetValue, destinationValue, destinationOffsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__copyBufferToTexture(_ self: JSObject, _ source: JSObject, _ destination: JSObject, _ copySize: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let sourceValue = source.bridgeJSLowerParameter()
    let destinationValue = destination.bridgeJSLowerParameter()
    let copySizeValue = copySize.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__copyBufferToTexture(selfValue, sourceValue, destinationValue, copySizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__copyTextureToBuffer(_ self: JSObject, _ source: JSObject, _ destination: JSObject, _ copySize: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let sourceValue = source.bridgeJSLowerParameter()
    let destinationValue = destination.bridgeJSLowerParameter()
    let copySizeValue = copySize.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__copyTextureToBuffer(selfValue, sourceValue, destinationValue, copySizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__resolveQuerySet(_ self: JSObject, _ querySet: GPUQuerySet, _ firstQuery: Int, _ queryCount: Int, _ destination: GPUBuffer, _ destinationOffset: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let querySetValue = querySet.bridgeJSLowerParameter()
    let firstQueryValue = firstQuery.bridgeJSLowerParameter()
    let queryCountValue = queryCount.bridgeJSLowerParameter()
    let destinationValue = destination.bridgeJSLowerParameter()
    let destinationOffsetValue = destinationOffset.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__resolveQuerySet(selfValue, querySetValue, firstQueryValue, queryCountValue, destinationValue, destinationOffsetValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__clearBuffer(_ self: JSObject, _ buffer: GPUBuffer, _ offset: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__clearBuffer(selfValue, bufferValue, offsetValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__clearBufferWithSize(_ self: JSObject, _ buffer: GPUBuffer, _ offset: Int, _ size: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__clearBufferWithSize(selfValue, bufferValue, offsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCommandEncoder__writeTimestamp(_ self: JSObject, _ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let querySetValue = querySet.bridgeJSLowerParameter()
    let queryIndexValue = queryIndex.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder__writeTimestamp(selfValue, querySetValue, queryIndexValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_label__set")
fileprivate func bjs_GPUComputePassEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUComputePassEncoder_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__setPipeline")
fileprivate func bjs_GPUComputePassEncoder__setPipeline_extern(_ self: Int32, _ pipeline: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__setPipeline_extern(_ self: Int32, _ pipeline: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__setPipeline(_ self: Int32, _ pipeline: Int32) -> Void {
    return bjs_GPUComputePassEncoder__setPipeline_extern(self, pipeline)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__setBindGroup")
fileprivate func bjs_GPUComputePassEncoder__setBindGroup_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__setBindGroup_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void {
    return bjs_GPUComputePassEncoder__setBindGroup_extern(self, groupIndex, group)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__setBindGroupWithOffsets")
fileprivate func bjs_GPUComputePassEncoder__setBindGroupWithOffsets_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__setBindGroupWithOffsets_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__setBindGroupWithOffsets(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void {
    return bjs_GPUComputePassEncoder__setBindGroupWithOffsets_extern(self, groupIndex, group, dynamicOffsets)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__dispatchWorkgroups")
fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroups_extern(_ self: Int32, _ workgroupCountX: Int32, _ workgroupCountY: Int32, _ workgroupCountZ: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroups_extern(_ self: Int32, _ workgroupCountX: Int32, _ workgroupCountY: Int32, _ workgroupCountZ: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroups(_ self: Int32, _ workgroupCountX: Int32, _ workgroupCountY: Int32, _ workgroupCountZ: Int32) -> Void {
    return bjs_GPUComputePassEncoder__dispatchWorkgroups_extern(self, workgroupCountX, workgroupCountY, workgroupCountZ)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect")
fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect_extern(_ self: Int32, _ indirectBuffer: Int32, _ indirectOffset: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect_extern(_ self: Int32, _ indirectBuffer: Int32, _ indirectOffset: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect(_ self: Int32, _ indirectBuffer: Int32, _ indirectOffset: Int32) -> Void {
    return bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect_extern(self, indirectBuffer, indirectOffset)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__writeTimestamp")
fileprivate func bjs_GPUComputePassEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__writeTimestamp(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    return bjs_GPUComputePassEncoder__writeTimestamp_extern(self, querySet, queryIndex)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder__end")
fileprivate func bjs_GPUComputePassEncoder__end_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder__end_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePassEncoder__end(_ self: Int32) -> Void {
    return bjs_GPUComputePassEncoder__end_extern(self)
}

func _$GPUComputePassEncoder_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__setPipeline(_ self: JSObject, _ pipeline: GPUComputePipeline) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let pipelineValue = pipeline.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__setPipeline(selfValue, pipelineValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__setBindGroup(_ self: JSObject, _ groupIndex: Int, _ group: GPUBindGroup) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let groupIndexValue = groupIndex.bridgeJSLowerParameter()
    let groupValue = group.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__setBindGroup(selfValue, groupIndexValue, groupValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__setBindGroupWithOffsets(_ self: JSObject, _ groupIndex: Int, _ group: GPUBindGroup, _ dynamicOffsets: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let groupIndexValue = groupIndex.bridgeJSLowerParameter()
    let groupValue = group.bridgeJSLowerParameter()
    let dynamicOffsetsValue = dynamicOffsets.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__setBindGroupWithOffsets(selfValue, groupIndexValue, groupValue, dynamicOffsetsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__dispatchWorkgroups(_ self: JSObject, _ workgroupCountX: Int, _ workgroupCountY: Int, _ workgroupCountZ: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let workgroupCountXValue = workgroupCountX.bridgeJSLowerParameter()
    let workgroupCountYValue = workgroupCountY.bridgeJSLowerParameter()
    let workgroupCountZValue = workgroupCountZ.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__dispatchWorkgroups(selfValue, workgroupCountXValue, workgroupCountYValue, workgroupCountZValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__dispatchWorkgroupsIndirect(_ self: JSObject, _ indirectBuffer: GPUBuffer, _ indirectOffset: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let indirectBufferValue = indirectBuffer.bridgeJSLowerParameter()
    let indirectOffsetValue = indirectOffset.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__dispatchWorkgroupsIndirect(selfValue, indirectBufferValue, indirectOffsetValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__writeTimestamp(_ self: JSObject, _ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let querySetValue = querySet.bridgeJSLowerParameter()
    let queryIndexValue = queryIndex.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__writeTimestamp(selfValue, querySetValue, queryIndexValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder__end(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder__end(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePipeline_label__set")
fileprivate func bjs_GPUComputePipeline_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUComputePipeline_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUComputePipeline_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUComputePipeline_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUComputePipeline_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUComputePipeline_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__queue_get")
fileprivate func bjs_GPUDevice__queue_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__queue_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__queue_get(_ self: Int32) -> Int32 {
    return bjs_GPUDevice__queue_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_label__set")
fileprivate func bjs_GPUDevice_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUDevice_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUDevice_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createBuffer")
fileprivate func bjs_GPUDevice__createBuffer_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createBuffer_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createBuffer(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createBuffer_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createTexture")
fileprivate func bjs_GPUDevice__createTexture_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createTexture_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createTexture(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createTexture_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createSampler")
fileprivate func bjs_GPUDevice__createSampler_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createSampler_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createSampler(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createSampler_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createQuerySet")
fileprivate func bjs_GPUDevice__createQuerySet_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createQuerySet_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createQuerySet(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createQuerySet_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createShaderModule")
fileprivate func bjs_GPUDevice__createShaderModule_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createShaderModule_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createShaderModule(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createShaderModule_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createRenderPipeline")
fileprivate func bjs_GPUDevice__createRenderPipeline_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createRenderPipeline_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createRenderPipeline(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createRenderPipeline_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createCommandEncoder")
fileprivate func bjs_GPUDevice__createCommandEncoder_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createCommandEncoder_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createCommandEncoder(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createCommandEncoder_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createBindGroupLayout")
fileprivate func bjs_GPUDevice__createBindGroupLayout_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createBindGroupLayout_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createBindGroupLayout(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createBindGroupLayout_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createBindGroup")
fileprivate func bjs_GPUDevice__createBindGroup_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createBindGroup_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createBindGroup(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createBindGroup_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createBindGroupRaw")
fileprivate func bjs_GPUDevice__createBindGroupRaw_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createBindGroupRaw_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createBindGroupRaw(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createBindGroupRaw_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createPipelineLayout")
fileprivate func bjs_GPUDevice__createPipelineLayout_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createPipelineLayout_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createPipelineLayout(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createPipelineLayout_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__createComputePipeline")
fileprivate func bjs_GPUDevice__createComputePipeline_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__createComputePipeline_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__createComputePipeline(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUDevice__createComputePipeline_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__pushErrorScope")
fileprivate func bjs_GPUDevice__pushErrorScope_extern(_ self: Int32, _ filter: Int32) -> Void
#else
fileprivate func bjs_GPUDevice__pushErrorScope_extern(_ self: Int32, _ filter: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__pushErrorScope(_ self: Int32, _ filter: Int32) -> Void {
    return bjs_GPUDevice__pushErrorScope_extern(self, filter)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice__popErrorScope")
fileprivate func bjs_GPUDevice__popErrorScope_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice__popErrorScope_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUDevice__popErrorScope(_ self: Int32) -> Int32 {
    return bjs_GPUDevice__popErrorScope_extern(self)
}

func _$GPUDevice__queue_get(_ self: JSObject) throws(JSException) -> GPUQueue {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__queue_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUQueue.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUDevice_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUDevice__createBuffer(_ self: JSObject, _ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createBuffer(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBuffer.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createTexture(_ self: JSObject, _ descriptor: GPUTextureDescriptor) throws(JSException) -> GPUTexture {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createTexture(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTexture.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createSampler(_ self: JSObject, _ descriptor: GPUSamplerDescriptor) throws(JSException) -> GPUSampler {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createSampler(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUSampler.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createQuerySet(_ self: JSObject, _ descriptor: GPUQuerySetDescriptor) throws(JSException) -> GPUQuerySet {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createQuerySet(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUQuerySet.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createShaderModule(_ self: JSObject, _ descriptor: GPUShaderModuleDescriptor) throws(JSException) -> GPUShaderModule {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createShaderModule(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUShaderModule.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createRenderPipeline(_ self: JSObject, _ descriptor: GPURenderPipelineDescriptor) throws(JSException) -> GPURenderPipeline {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createRenderPipeline(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPURenderPipeline.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createCommandEncoder(_ self: JSObject, _ descriptor: GPUCommandEncoderDescriptor) throws(JSException) -> GPUCommandEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createCommandEncoder(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUCommandEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createBindGroupLayout(_ self: JSObject, _ descriptor: GPUBindGroupLayoutDescriptor) throws(JSException) -> GPUBindGroupLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createBindGroupLayout(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroupLayout.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createBindGroup(_ self: JSObject, _ descriptor: GPUBindGroupDescriptor) throws(JSException) -> GPUBindGroup {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createBindGroup(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroup.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createBindGroupRaw(_ self: JSObject, _ descriptor: JSObject) throws(JSException) -> GPUBindGroup {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorValue = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createBindGroupRaw(selfValue, descriptorValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroup.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createPipelineLayout(_ self: JSObject, _ descriptor: GPUPipelineLayoutDescriptor) throws(JSException) -> GPUPipelineLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createPipelineLayout(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUPipelineLayout.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__createComputePipeline(_ self: JSObject, _ descriptor: GPUComputePipelineDescriptor) throws(JSException) -> GPUComputePipeline {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__createComputePipeline(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUComputePipeline.bridgeJSLiftReturn(ret)
}

func _$GPUDevice__pushErrorScope(_ self: JSObject, _ filter: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let filterValue = filter.bridgeJSLowerParameter()
    bjs_GPUDevice__pushErrorScope(selfValue, filterValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUDevice__popErrorScope(_ self: JSObject) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice__popErrorScope(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUPipelineLayout_label__set")
fileprivate func bjs_GPUPipelineLayout_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUPipelineLayout_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUPipelineLayout_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUPipelineLayout_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUPipelineLayout_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUPipelineLayout_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQuerySet__type_get")
fileprivate func bjs_GPUQuerySet__type_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUQuerySet__type_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQuerySet__type_get(_ self: Int32) -> Int32 {
    return bjs_GPUQuerySet__type_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQuerySet__count_get")
fileprivate func bjs_GPUQuerySet__count_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUQuerySet__count_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQuerySet__count_get(_ self: Int32) -> Int32 {
    return bjs_GPUQuerySet__count_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQuerySet_label__set")
fileprivate func bjs_GPUQuerySet_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUQuerySet_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQuerySet_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUQuerySet_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQuerySet__destroy")
fileprivate func bjs_GPUQuerySet__destroy_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUQuerySet__destroy_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQuerySet__destroy(_ self: Int32) -> Void {
    return bjs_GPUQuerySet__destroy_extern(self)
}

func _$GPUQuerySet__type_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUQuerySet__type_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$GPUQuerySet__count_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUQuerySet__count_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUQuerySet_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUQuerySet_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUQuerySet__destroy(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUQuerySet__destroy(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue_label__set")
fileprivate func bjs_GPUQueue_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUQueue_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQueue_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUQueue_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue__submit")
fileprivate func bjs_GPUQueue__submit_extern(_ self: Int32, _ commandBuffers: Int32) -> Void
#else
fileprivate func bjs_GPUQueue__submit_extern(_ self: Int32, _ commandBuffers: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQueue__submit(_ self: Int32, _ commandBuffers: Int32) -> Void {
    return bjs_GPUQueue__submit_extern(self, commandBuffers)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue__writeBuffer")
fileprivate func bjs_GPUQueue__writeBuffer_extern(_ self: Int32, _ buffer: Int32, _ bufferOffset: Int32, _ data: Int32) -> Void
#else
fileprivate func bjs_GPUQueue__writeBuffer_extern(_ self: Int32, _ buffer: Int32, _ bufferOffset: Int32, _ data: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQueue__writeBuffer(_ self: Int32, _ buffer: Int32, _ bufferOffset: Int32, _ data: Int32) -> Void {
    return bjs_GPUQueue__writeBuffer_extern(self, buffer, bufferOffset, data)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue__writeTexture")
fileprivate func bjs_GPUQueue__writeTexture_extern(_ self: Int32, _ destination: Int32, _ data: Int32, _ dataLayout: Int32, _ size: Int32) -> Void
#else
fileprivate func bjs_GPUQueue__writeTexture_extern(_ self: Int32, _ destination: Int32, _ data: Int32, _ dataLayout: Int32, _ size: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUQueue__writeTexture(_ self: Int32, _ destination: Int32, _ data: Int32, _ dataLayout: Int32, _ size: Int32) -> Void {
    return bjs_GPUQueue__writeTexture_extern(self, destination, data, dataLayout, size)
}

func _$GPUQueue_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUQueue_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUQueue__submit(_ self: JSObject, _ commandBuffers: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let commandBuffersValue = commandBuffers.bridgeJSLowerParameter()
    bjs_GPUQueue__submit(selfValue, commandBuffersValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUQueue__writeBuffer(_ self: JSObject, _ buffer: GPUBuffer, _ bufferOffset: Int, _ data: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let bufferOffsetValue = bufferOffset.bridgeJSLowerParameter()
    let dataValue = data.bridgeJSLowerParameter()
    bjs_GPUQueue__writeBuffer(selfValue, bufferValue, bufferOffsetValue, dataValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUQueue__writeTexture(_ self: JSObject, _ destination: JSObject, _ data: JSObject, _ dataLayout: JSObject, _ size: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let destinationValue = destination.bridgeJSLowerParameter()
    let dataValue = data.bridgeJSLowerParameter()
    let dataLayoutValue = dataLayout.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    bjs_GPUQueue__writeTexture(selfValue, destinationValue, dataValue, dataLayoutValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_label__set")
fileprivate func bjs_GPURenderPassEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPURenderPassEncoder_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__setPipeline")
fileprivate func bjs_GPURenderPassEncoder__setPipeline_extern(_ self: Int32, _ pipeline: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__setPipeline_extern(_ self: Int32, _ pipeline: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__setPipeline(_ self: Int32, _ pipeline: Int32) -> Void {
    return bjs_GPURenderPassEncoder__setPipeline_extern(self, pipeline)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__setVertexBuffer")
fileprivate func bjs_GPURenderPassEncoder__setVertexBuffer_extern(_ self: Int32, _ slot: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__setVertexBuffer_extern(_ self: Int32, _ slot: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__setVertexBuffer(_ self: Int32, _ slot: Int32, _ buffer: Int32, _ offset: Int32, _ size: Int32) -> Void {
    return bjs_GPURenderPassEncoder__setVertexBuffer_extern(self, slot, buffer, offset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__setIndexBuffer")
fileprivate func bjs_GPURenderPassEncoder__setIndexBuffer_extern(_ self: Int32, _ buffer: Int32, _ indexFormat: Int32, _ offset: Int32, _ size: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__setIndexBuffer_extern(_ self: Int32, _ buffer: Int32, _ indexFormat: Int32, _ offset: Int32, _ size: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__setIndexBuffer(_ self: Int32, _ buffer: Int32, _ indexFormat: Int32, _ offset: Int32, _ size: Int32) -> Void {
    return bjs_GPURenderPassEncoder__setIndexBuffer_extern(self, buffer, indexFormat, offset, size)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__draw")
fileprivate func bjs_GPURenderPassEncoder__draw_extern(_ self: Int32, _ vertexCount: Int32, _ instanceCount: Int32, _ firstVertex: Int32, _ firstInstance: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__draw_extern(_ self: Int32, _ vertexCount: Int32, _ instanceCount: Int32, _ firstVertex: Int32, _ firstInstance: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__draw(_ self: Int32, _ vertexCount: Int32, _ instanceCount: Int32, _ firstVertex: Int32, _ firstInstance: Int32) -> Void {
    return bjs_GPURenderPassEncoder__draw_extern(self, vertexCount, instanceCount, firstVertex, firstInstance)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__drawIndexed")
fileprivate func bjs_GPURenderPassEncoder__drawIndexed_extern(_ self: Int32, _ indexCount: Int32, _ instanceCount: Int32, _ firstIndex: Int32, _ baseVertex: Int32, _ firstInstance: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__drawIndexed_extern(_ self: Int32, _ indexCount: Int32, _ instanceCount: Int32, _ firstIndex: Int32, _ baseVertex: Int32, _ firstInstance: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__drawIndexed(_ self: Int32, _ indexCount: Int32, _ instanceCount: Int32, _ firstIndex: Int32, _ baseVertex: Int32, _ firstInstance: Int32) -> Void {
    return bjs_GPURenderPassEncoder__drawIndexed_extern(self, indexCount, instanceCount, firstIndex, baseVertex, firstInstance)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__setBindGroup")
fileprivate func bjs_GPURenderPassEncoder__setBindGroup_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__setBindGroup_extern(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32, _ dynamicOffsets: Int32) -> Void {
    return bjs_GPURenderPassEncoder__setBindGroup_extern(self, groupIndex, group, dynamicOffsets)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__setScissorRect")
fileprivate func bjs_GPURenderPassEncoder__setScissorRect_extern(_ self: Int32, _ x: Int32, _ y: Int32, _ width: Int32, _ height: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__setScissorRect_extern(_ self: Int32, _ x: Int32, _ y: Int32, _ width: Int32, _ height: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__setScissorRect(_ self: Int32, _ x: Int32, _ y: Int32, _ width: Int32, _ height: Int32) -> Void {
    return bjs_GPURenderPassEncoder__setScissorRect_extern(self, x, y, width, height)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__writeTimestamp")
fileprivate func bjs_GPURenderPassEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__writeTimestamp_extern(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__writeTimestamp(_ self: Int32, _ querySet: Int32, _ queryIndex: Int32) -> Void {
    return bjs_GPURenderPassEncoder__writeTimestamp_extern(self, querySet, queryIndex)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder__end")
fileprivate func bjs_GPURenderPassEncoder__end_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder__end_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPassEncoder__end(_ self: Int32) -> Void {
    return bjs_GPURenderPassEncoder__end_extern(self)
}

func _$GPURenderPassEncoder_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__setPipeline(_ self: JSObject, _ pipeline: GPURenderPipeline) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let pipelineValue = pipeline.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__setPipeline(selfValue, pipelineValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__setVertexBuffer(_ self: JSObject, _ slot: Int, _ buffer: GPUBuffer, _ offset: Int, _ size: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let slotValue = slot.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__setVertexBuffer(selfValue, slotValue, bufferValue, offsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__setIndexBuffer(_ self: JSObject, _ buffer: GPUBuffer, _ indexFormat: String, _ offset: Int, _ size: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let indexFormatValue = indexFormat.bridgeJSLowerParameter()
    let offsetValue = offset.bridgeJSLowerParameter()
    let sizeValue = size.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__setIndexBuffer(selfValue, bufferValue, indexFormatValue, offsetValue, sizeValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__draw(_ self: JSObject, _ vertexCount: Int, _ instanceCount: Int, _ firstVertex: Int, _ firstInstance: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let vertexCountValue = vertexCount.bridgeJSLowerParameter()
    let instanceCountValue = instanceCount.bridgeJSLowerParameter()
    let firstVertexValue = firstVertex.bridgeJSLowerParameter()
    let firstInstanceValue = firstInstance.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__draw(selfValue, vertexCountValue, instanceCountValue, firstVertexValue, firstInstanceValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__drawIndexed(_ self: JSObject, _ indexCount: Int, _ instanceCount: Int, _ firstIndex: Int, _ baseVertex: Int, _ firstInstance: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let indexCountValue = indexCount.bridgeJSLowerParameter()
    let instanceCountValue = instanceCount.bridgeJSLowerParameter()
    let firstIndexValue = firstIndex.bridgeJSLowerParameter()
    let baseVertexValue = baseVertex.bridgeJSLowerParameter()
    let firstInstanceValue = firstInstance.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__drawIndexed(selfValue, indexCountValue, instanceCountValue, firstIndexValue, baseVertexValue, firstInstanceValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__setBindGroup(_ self: JSObject, _ groupIndex: Int, _ group: GPUBindGroup, _ dynamicOffsets: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let groupIndexValue = groupIndex.bridgeJSLowerParameter()
    let groupValue = group.bridgeJSLowerParameter()
    let dynamicOffsetsValue = dynamicOffsets.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__setBindGroup(selfValue, groupIndexValue, groupValue, dynamicOffsetsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__setScissorRect(_ self: JSObject, _ x: Int, _ y: Int, _ width: Int, _ height: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let xValue = x.bridgeJSLowerParameter()
    let yValue = y.bridgeJSLowerParameter()
    let widthValue = width.bridgeJSLowerParameter()
    let heightValue = height.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__setScissorRect(selfValue, xValue, yValue, widthValue, heightValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__writeTimestamp(_ self: JSObject, _ querySet: GPUQuerySet, _ queryIndex: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let querySetValue = querySet.bridgeJSLowerParameter()
    let queryIndexValue = queryIndex.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__writeTimestamp(selfValue, querySetValue, queryIndexValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder__end(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder__end(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPipeline_label__set")
fileprivate func bjs_GPURenderPipeline_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPURenderPipeline_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPipeline_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPURenderPipeline_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPipeline__getBindGroupLayout")
fileprivate func bjs_GPURenderPipeline__getBindGroupLayout_extern(_ self: Int32, _ index: Int32) -> Int32
#else
fileprivate func bjs_GPURenderPipeline__getBindGroupLayout_extern(_ self: Int32, _ index: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPURenderPipeline__getBindGroupLayout(_ self: Int32, _ index: Int32) -> Int32 {
    return bjs_GPURenderPipeline__getBindGroupLayout_extern(self, index)
}

func _$GPURenderPipeline_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPURenderPipeline_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPipeline__getBindGroupLayout(_ self: JSObject, _ index: Int) throws(JSException) -> GPUBindGroupLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let indexValue = index.bridgeJSLowerParameter()
    let ret = bjs_GPURenderPipeline__getBindGroupLayout(selfValue, indexValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroupLayout.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUSampler_label__set")
fileprivate func bjs_GPUSampler_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUSampler_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUSampler_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUSampler_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUSampler_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUSampler_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUShaderModule_label__set")
fileprivate func bjs_GPUShaderModule_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUShaderModule_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUShaderModule_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUShaderModule_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUShaderModule_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUShaderModule_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__format_get")
fileprivate func bjs_GPUTexture__format_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__format_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__format_get(_ self: Int32) -> Int32 {
    return bjs_GPUTexture__format_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__width_get")
fileprivate func bjs_GPUTexture__width_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__width_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__width_get(_ self: Int32) -> Int32 {
    return bjs_GPUTexture__width_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__height_get")
fileprivate func bjs_GPUTexture__height_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__height_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__height_get(_ self: Int32) -> Int32 {
    return bjs_GPUTexture__height_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__depthOrArrayLayers_get")
fileprivate func bjs_GPUTexture__depthOrArrayLayers_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__depthOrArrayLayers_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__depthOrArrayLayers_get(_ self: Int32) -> Int32 {
    return bjs_GPUTexture__depthOrArrayLayers_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture_label__set")
fileprivate func bjs_GPUTexture_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUTexture_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUTexture_label__set_extern(self, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__createView")
fileprivate func bjs_GPUTexture__createView_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__createView_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__createView(_ self: Int32) -> Int32 {
    return bjs_GPUTexture__createView_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__createViewWithDescriptor")
fileprivate func bjs_GPUTexture__createViewWithDescriptor_extern(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture__createViewWithDescriptor_extern(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__createViewWithDescriptor(_ self: Int32, _ descriptor: Int32) -> Int32 {
    return bjs_GPUTexture__createViewWithDescriptor_extern(self, descriptor)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture__destroy")
fileprivate func bjs_GPUTexture__destroy_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUTexture__destroy_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTexture__destroy(_ self: Int32) -> Void {
    return bjs_GPUTexture__destroy_extern(self)
}

func _$GPUTexture__format_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__format_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$GPUTexture__width_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__width_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUTexture__height_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__height_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUTexture__depthOrArrayLayers_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__depthOrArrayLayers_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUTexture_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUTexture_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUTexture__createView(_ self: JSObject) throws(JSException) -> GPUTextureView {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__createView(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTextureView.bridgeJSLiftReturn(ret)
}

func _$GPUTexture__createViewWithDescriptor(_ self: JSObject, _ descriptor: GPUTextureViewDescriptor) throws(JSException) -> GPUTextureView {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture__createViewWithDescriptor(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTextureView.bridgeJSLiftReturn(ret)
}

func _$GPUTexture__destroy(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUTexture__destroy(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTextureView_label__set")
fileprivate func bjs_GPUTextureView_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_GPUTextureView_label__set_extern(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_GPUTextureView_label__set(_ self: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_GPUTextureView_label__set_extern(self, newValueIsSome, newValueValue)
}

func _$GPUTextureView_label__set(_ self: JSObject, _ newValue: Optional<String>) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
    bjs_GPUTextureView_label__set(selfValue, newValueIsSome, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}