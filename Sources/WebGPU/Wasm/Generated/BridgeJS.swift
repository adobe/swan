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

extension GPUBufferDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBufferDescriptor {
        let mappedAtCreation = Bool.bridgeJSStackPop()
        let usage = Int.bridgeJSStackPop()
        let size = Int.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPUBufferDescriptor(label: label, size: size, usage: usage, mappedAtCreation: mappedAtCreation)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.size.bridgeJSStackPush()
        self.usage.bridgeJSStackPush()
        self.mappedAtCreation.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBufferDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBufferDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferDescriptor")
fileprivate func _bjs_struct_lift_GPUBufferDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUShaderModuleDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUShaderModuleDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUShaderModuleDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUShaderModuleDescriptor")
fileprivate func _bjs_struct_lift_GPUShaderModuleDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUShaderModuleDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexAttribute(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUVertexAttribute(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUVertexAttribute(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexAttribute")
fileprivate func _bjs_struct_lift_GPUVertexAttribute() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexAttribute() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexBufferLayout(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUVertexBufferLayout(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUVertexBufferLayout(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexBufferLayout")
fileprivate func _bjs_struct_lift_GPUVertexBufferLayout() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexBufferLayout() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUPrimitiveState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUPrimitiveState {
        let cullMode = GPUCullMode.bridgeJSStackPop()
        let frontFace = GPUFrontFace.bridgeJSStackPop()
        let topology = GPUPrimitiveTopology.bridgeJSStackPop()
        return GPUPrimitiveState(topology: topology, frontFace: frontFace, cullMode: cullMode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.topology.bridgeJSStackPush()
        self.frontFace.bridgeJSStackPush()
        self.cullMode.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUPrimitiveState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUPrimitiveState(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUPrimitiveState(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUPrimitiveState")
fileprivate func _bjs_struct_lift_GPUPrimitiveState() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUPrimitiveState() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUColorTargetState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUColorTargetState {
        let writeMask = Int.bridgeJSStackPop()
        let format = GPUTextureFormat.bridgeJSStackPop()
        return GPUColorTargetState(format: format, writeMask: writeMask)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.format.bridgeJSStackPush()
        self.writeMask.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUColorTargetState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUColorTargetState(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUColorTargetState(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUColorTargetState")
fileprivate func _bjs_struct_lift_GPUColorTargetState() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUColorTargetState() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUColor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUColor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUColor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUColor")
fileprivate func _bjs_struct_lift_GPUColor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUColor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUCommandEncoderDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUCommandEncoderDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUCommandEncoderDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUCommandEncoderDescriptor")
fileprivate func _bjs_struct_lift_GPUCommandEncoderDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUCommandEncoderDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferBinding(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBufferBinding(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBufferBinding(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferBinding")
fileprivate func _bjs_struct_lift_GPUBufferBinding() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferBinding() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupEntry(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBindGroupEntry(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBindGroupEntry(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupEntry")
fileprivate func _bjs_struct_lift_GPUBindGroupEntry() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupEntry() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBindGroupDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBindGroupDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupDescriptor")
fileprivate func _bjs_struct_lift_GPUBindGroupDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUBufferBindingLayout: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBufferBindingLayout {
        let type = GPUBufferBindingType.bridgeJSStackPop()
        return GPUBufferBindingLayout(type: type)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.type.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferBindingLayout(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBufferBindingLayout(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBufferBindingLayout(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBufferBindingLayout")
fileprivate func _bjs_struct_lift_GPUBufferBindingLayout() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBufferBindingLayout() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUBindGroupLayoutEntry: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUBindGroupLayoutEntry {
        let buffer = Optional<GPUBufferBindingLayout>.bridgeJSStackPop()
        let visibility = Int.bridgeJSStackPop()
        let binding = Int.bridgeJSStackPop()
        return GPUBindGroupLayoutEntry(binding: binding, visibility: visibility, buffer: buffer)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.binding.bridgeJSStackPush()
        self.visibility.bridgeJSStackPush()
        self.buffer.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupLayoutEntry(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutEntry(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutEntry(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupLayoutEntry")
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutEntry() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutEntry() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUBindGroupLayoutDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUBindGroupLayoutDescriptor")
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUBindGroupLayoutDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUCanvasConfiguration(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUCanvasConfiguration(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUCanvasConfiguration(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUCanvasConfiguration")
fileprivate func _bjs_struct_lift_GPUCanvasConfiguration() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUCanvasConfiguration() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPassColorAttachment(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPURenderPassColorAttachment(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPURenderPassColorAttachment(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPassColorAttachment")
fileprivate func _bjs_struct_lift_GPURenderPassColorAttachment() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPassColorAttachment() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPURenderPassDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPassDescriptor {
        let colorAttachments = [GPURenderPassColorAttachment].bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPURenderPassDescriptor(label: label, colorAttachments: colorAttachments)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.colorAttachments.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPassDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPURenderPassDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPURenderPassDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPassDescriptor")
fileprivate func _bjs_struct_lift_GPURenderPassDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPassDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUComputePassDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUComputePassDescriptor {
        let label = Optional<String>.bridgeJSStackPop()
        return GPUComputePassDescriptor(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputePassDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUComputePassDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUComputePassDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputePassDescriptor")
fileprivate func _bjs_struct_lift_GPUComputePassDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputePassDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputeState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUComputeState(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUComputeState(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputeState")
fileprivate func _bjs_struct_lift_GPUComputeState() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputeState() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputePipelineDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUComputePipelineDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUComputePipelineDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUComputePipelineDescriptor")
fileprivate func _bjs_struct_lift_GPUComputePipelineDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUComputePipelineDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUVertexState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUVertexState {
        let buffers = [GPUVertexBufferLayout].bridgeJSStackPop()
        let entryPoint = String.bridgeJSStackPop()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUVertexState(module: module, entryPoint: entryPoint, buffers: buffers)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.module.jsObject.bridgeJSStackPush()
        self.entryPoint.bridgeJSStackPush()
        self.buffers.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUVertexState(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUVertexState(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUVertexState")
fileprivate func _bjs_struct_lift_GPUVertexState() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUVertexState() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPUFragmentState: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPUFragmentState {
        let targets = [GPUColorTargetState].bridgeJSStackPop()
        let entryPoint = String.bridgeJSStackPop()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return GPUFragmentState(module: module, entryPoint: entryPoint, targets: targets)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.module.jsObject.bridgeJSStackPush()
        self.entryPoint.bridgeJSStackPush()
        self.targets.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUFragmentState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUFragmentState(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUFragmentState(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUFragmentState")
fileprivate func _bjs_struct_lift_GPUFragmentState() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUFragmentState() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension GPURenderPipelineDescriptor: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GPURenderPipelineDescriptor {
        let fragment = Optional<GPUFragmentState>.bridgeJSStackPop()
        let primitive = Optional<GPUPrimitiveState>.bridgeJSStackPop()
        let vertex = GPUVertexState.bridgeJSStackPop()
        let layout = String.bridgeJSStackPop()
        let label = Optional<String>.bridgeJSStackPop()
        return GPURenderPipelineDescriptor(label: label, layout: layout, vertex: vertex, primitive: primitive, fragment: fragment)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
        __bjs_unwrapped_label.bridgeJSStackPush()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.bridgeJSStackPush()
        self.vertex.bridgeJSStackPush()
        self.primitive.bridgeJSStackPush()
        self.fragment.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPipelineDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPURenderPipelineDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPURenderPipelineDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPURenderPipelineDescriptor")
fileprivate func _bjs_struct_lift_GPURenderPipelineDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPURenderPipelineDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
        let __bjs_cleanupId = _bjs_struct_lower_GPUPipelineLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
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
fileprivate func _bjs_struct_lower_GPUPipelineLayoutDescriptor(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_GPUPipelineLayoutDescriptor(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GPUPipelineLayoutDescriptor")
fileprivate func _bjs_struct_lift_GPUPipelineLayoutDescriptor() -> Int32
#else
fileprivate func _bjs_struct_lift_GPUPipelineLayoutDescriptor() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBindGroup_label_get")
fileprivate func bjs_GPUBindGroup_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBindGroup_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUBindGroup_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBindGroup_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBindGroupLayout_label_get")
fileprivate func bjs_GPUBindGroupLayout_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBindGroupLayout_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUBindGroupLayout_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBindGroupLayout_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer_size_get")
fileprivate func bjs_GPUBuffer_size_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer_size_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer_usage_get")
fileprivate func bjs_GPUBuffer_usage_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUBuffer_usage_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer_label_get")
fileprivate func bjs_GPUBuffer_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBuffer_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUBuffer_destroy")
fileprivate func bjs_GPUBuffer_destroy(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUBuffer_destroy(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUBuffer_size_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer_size_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer_usage_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUBuffer_usage_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$GPUBuffer_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBuffer_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUBuffer_destroy(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUBuffer_destroy(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCanvasContext_configure")
fileprivate func bjs_GPUCanvasContext_configure(_ self: Int32, _ configuration: Int32) -> Void
#else
fileprivate func bjs_GPUCanvasContext_configure(_ self: Int32, _ configuration: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCanvasContext_getCurrentTexture")
fileprivate func bjs_GPUCanvasContext_getCurrentTexture(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUCanvasContext_getCurrentTexture(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUCanvasContext_configure(_ self: JSObject, _ configuration: GPUCanvasConfiguration) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let configurationObjectId = configuration.bridgeJSLowerParameter()
    bjs_GPUCanvasContext_configure(selfValue, configurationObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUCanvasContext_getCurrentTexture(_ self: JSObject) throws(JSException) -> GPUTexture {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUCanvasContext_getCurrentTexture(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTexture.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandBuffer_label_get")
fileprivate func bjs_GPUCommandBuffer_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUCommandBuffer_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUCommandBuffer_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUCommandBuffer_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder_label_get")
fileprivate func bjs_GPUCommandEncoder_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUCommandEncoder_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder_beginRenderPass")
fileprivate func bjs_GPUCommandEncoder_beginRenderPass(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder_beginRenderPass(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder_beginComputePass")
fileprivate func bjs_GPUCommandEncoder_beginComputePass(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder_beginComputePass(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUCommandEncoder_finish")
fileprivate func bjs_GPUCommandEncoder_finish(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUCommandEncoder_finish(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUCommandEncoder_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUCommandEncoder_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUCommandEncoder_beginRenderPass(_ self: JSObject, _ descriptor: GPURenderPassDescriptor) throws(JSException) -> GPURenderPassEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder_beginRenderPass(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPURenderPassEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUCommandEncoder_beginComputePass(_ self: JSObject, _ descriptor: GPUComputePassDescriptor) throws(JSException) -> GPUComputePassEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder_beginComputePass(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUComputePassEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUCommandEncoder_finish(_ self: JSObject) throws(JSException) -> GPUCommandBuffer {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUCommandEncoder_finish(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUCommandBuffer.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_label_get")
fileprivate func bjs_GPUComputePassEncoder_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_setPipeline")
fileprivate func bjs_GPUComputePassEncoder_setPipeline(_ self: Int32, _ pipeline: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_setPipeline(_ self: Int32, _ pipeline: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_setBindGroup")
fileprivate func bjs_GPUComputePassEncoder_setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_dispatchWorkgroups")
fileprivate func bjs_GPUComputePassEncoder_dispatchWorkgroups(_ self: Int32, _ workgroupCountX: Int32, _ workgroupCountY: Int32, _ workgroupCountZ: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_dispatchWorkgroups(_ self: Int32, _ workgroupCountX: Int32, _ workgroupCountY: Int32, _ workgroupCountZ: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePassEncoder_end")
fileprivate func bjs_GPUComputePassEncoder_end(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUComputePassEncoder_end(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUComputePassEncoder_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUComputePassEncoder_setPipeline(_ self: JSObject, _ pipeline: GPUComputePipeline) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let pipelineValue = pipeline.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_setPipeline(selfValue, pipelineValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder_setBindGroup(_ self: JSObject, _ groupIndex: Int, _ group: GPUBindGroup) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let groupIndexValue = groupIndex.bridgeJSLowerParameter()
    let groupValue = group.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_setBindGroup(selfValue, groupIndexValue, groupValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder_dispatchWorkgroups(_ self: JSObject, _ workgroupCountX: Int, _ workgroupCountY: Int, _ workgroupCountZ: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let workgroupCountXValue = workgroupCountX.bridgeJSLowerParameter()
    let workgroupCountYValue = workgroupCountY.bridgeJSLowerParameter()
    let workgroupCountZValue = workgroupCountZ.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_dispatchWorkgroups(selfValue, workgroupCountXValue, workgroupCountYValue, workgroupCountZValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUComputePassEncoder_end(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUComputePassEncoder_end(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUComputePipeline_label_get")
fileprivate func bjs_GPUComputePipeline_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUComputePipeline_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUComputePipeline_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUComputePipeline_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_queue_get")
fileprivate func bjs_GPUDevice_queue_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_queue_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_label_get")
fileprivate func bjs_GPUDevice_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUDevice_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createBuffer")
fileprivate func bjs_GPUDevice_createBuffer(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createBuffer(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createShaderModule")
fileprivate func bjs_GPUDevice_createShaderModule(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createShaderModule(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createRenderPipeline")
fileprivate func bjs_GPUDevice_createRenderPipeline(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createRenderPipeline(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createCommandEncoder")
fileprivate func bjs_GPUDevice_createCommandEncoder(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createCommandEncoder(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createBindGroupLayout")
fileprivate func bjs_GPUDevice_createBindGroupLayout(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createBindGroupLayout(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createBindGroup")
fileprivate func bjs_GPUDevice_createBindGroup(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createBindGroup(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createPipelineLayout")
fileprivate func bjs_GPUDevice_createPipelineLayout(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createPipelineLayout(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUDevice_createComputePipeline")
fileprivate func bjs_GPUDevice_createComputePipeline(_ self: Int32, _ descriptor: Int32) -> Int32
#else
fileprivate func bjs_GPUDevice_createComputePipeline(_ self: Int32, _ descriptor: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUDevice_queue_get(_ self: JSObject) throws(JSException) -> GPUQueue {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_queue_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUQueue.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUDevice_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUDevice_createBuffer(_ self: JSObject, _ descriptor: GPUBufferDescriptor) throws(JSException) -> GPUBuffer {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createBuffer(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBuffer.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createShaderModule(_ self: JSObject, _ descriptor: GPUShaderModuleDescriptor) throws(JSException) -> GPUShaderModule {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createShaderModule(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUShaderModule.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createRenderPipeline(_ self: JSObject, _ descriptor: GPURenderPipelineDescriptor) throws(JSException) -> GPURenderPipeline {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createRenderPipeline(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPURenderPipeline.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createCommandEncoder(_ self: JSObject, _ descriptor: GPUCommandEncoderDescriptor) throws(JSException) -> GPUCommandEncoder {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createCommandEncoder(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUCommandEncoder.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createBindGroupLayout(_ self: JSObject, _ descriptor: GPUBindGroupLayoutDescriptor) throws(JSException) -> GPUBindGroupLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createBindGroupLayout(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroupLayout.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createBindGroup(_ self: JSObject, _ descriptor: GPUBindGroupDescriptor) throws(JSException) -> GPUBindGroup {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createBindGroup(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroup.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createPipelineLayout(_ self: JSObject, _ descriptor: GPUPipelineLayoutDescriptor) throws(JSException) -> GPUPipelineLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createPipelineLayout(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUPipelineLayout.bridgeJSLiftReturn(ret)
}

func _$GPUDevice_createComputePipeline(_ self: JSObject, _ descriptor: GPUComputePipelineDescriptor) throws(JSException) -> GPUComputePipeline {
    let selfValue = self.bridgeJSLowerParameter()
    let descriptorObjectId = descriptor.bridgeJSLowerParameter()
    let ret = bjs_GPUDevice_createComputePipeline(selfValue, descriptorObjectId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUComputePipeline.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUPipelineLayout_label_get")
fileprivate func bjs_GPUPipelineLayout_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUPipelineLayout_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUPipelineLayout_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUPipelineLayout_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue_label_get")
fileprivate func bjs_GPUQueue_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUQueue_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue_submit")
fileprivate func bjs_GPUQueue_submit(_ self: Int32, _ commandBuffers: Int32) -> Void
#else
fileprivate func bjs_GPUQueue_submit(_ self: Int32, _ commandBuffers: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUQueue_writeBuffer")
fileprivate func bjs_GPUQueue_writeBuffer(_ self: Int32, _ buffer: Int32, _ bufferOffset: Int32, _ data: Int32) -> Void
#else
fileprivate func bjs_GPUQueue_writeBuffer(_ self: Int32, _ buffer: Int32, _ bufferOffset: Int32, _ data: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUQueue_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUQueue_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUQueue_submit(_ self: JSObject, _ commandBuffers: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let commandBuffersValue = commandBuffers.bridgeJSLowerParameter()
    bjs_GPUQueue_submit(selfValue, commandBuffersValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPUQueue_writeBuffer(_ self: JSObject, _ buffer: GPUBuffer, _ bufferOffset: Int, _ data: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    let bufferOffsetValue = bufferOffset.bridgeJSLowerParameter()
    let dataValue = data.bridgeJSLowerParameter()
    bjs_GPUQueue_writeBuffer(selfValue, bufferValue, bufferOffsetValue, dataValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_label_get")
fileprivate func bjs_GPURenderPassEncoder_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_setPipeline")
fileprivate func bjs_GPURenderPassEncoder_setPipeline(_ self: Int32, _ pipeline: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_setPipeline(_ self: Int32, _ pipeline: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_setVertexBuffer")
fileprivate func bjs_GPURenderPassEncoder_setVertexBuffer(_ self: Int32, _ slot: Int32, _ buffer: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_setVertexBuffer(_ self: Int32, _ slot: Int32, _ buffer: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_draw")
fileprivate func bjs_GPURenderPassEncoder_draw(_ self: Int32, _ vertexCount: Int32, _ instanceCount: Int32, _ firstVertex: Int32, _ firstInstance: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_draw(_ self: Int32, _ vertexCount: Int32, _ instanceCount: Int32, _ firstVertex: Int32, _ firstInstance: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_setBindGroup")
fileprivate func bjs_GPURenderPassEncoder_setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_setBindGroup(_ self: Int32, _ groupIndex: Int32, _ group: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPassEncoder_end")
fileprivate func bjs_GPURenderPassEncoder_end(_ self: Int32) -> Void
#else
fileprivate func bjs_GPURenderPassEncoder_end(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPURenderPassEncoder_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPURenderPassEncoder_setPipeline(_ self: JSObject, _ pipeline: GPURenderPipeline) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let pipelineValue = pipeline.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_setPipeline(selfValue, pipelineValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder_setVertexBuffer(_ self: JSObject, _ slot: Int, _ buffer: GPUBuffer) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let slotValue = slot.bridgeJSLowerParameter()
    let bufferValue = buffer.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_setVertexBuffer(selfValue, slotValue, bufferValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder_draw(_ self: JSObject, _ vertexCount: Int, _ instanceCount: Int, _ firstVertex: Int, _ firstInstance: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let vertexCountValue = vertexCount.bridgeJSLowerParameter()
    let instanceCountValue = instanceCount.bridgeJSLowerParameter()
    let firstVertexValue = firstVertex.bridgeJSLowerParameter()
    let firstInstanceValue = firstInstance.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_draw(selfValue, vertexCountValue, instanceCountValue, firstVertexValue, firstInstanceValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder_setBindGroup(_ self: JSObject, _ groupIndex: Int, _ group: GPUBindGroup) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let groupIndexValue = groupIndex.bridgeJSLowerParameter()
    let groupValue = group.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_setBindGroup(selfValue, groupIndexValue, groupValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$GPURenderPassEncoder_end(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPURenderPassEncoder_end(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPipeline_label_get")
fileprivate func bjs_GPURenderPipeline_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPURenderPipeline_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPURenderPipeline_getBindGroupLayout")
fileprivate func bjs_GPURenderPipeline_getBindGroupLayout(_ self: Int32, _ index: Int32) -> Int32
#else
fileprivate func bjs_GPURenderPipeline_getBindGroupLayout(_ self: Int32, _ index: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPURenderPipeline_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPURenderPipeline_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPURenderPipeline_getBindGroupLayout(_ self: JSObject, _ index: Int) throws(JSException) -> GPUBindGroupLayout {
    let selfValue = self.bridgeJSLowerParameter()
    let indexValue = index.bridgeJSLowerParameter()
    let ret = bjs_GPURenderPipeline_getBindGroupLayout(selfValue, indexValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUBindGroupLayout.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUShaderModule_label_get")
fileprivate func bjs_GPUShaderModule_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUShaderModule_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUShaderModule_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUShaderModule_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture_label_get")
fileprivate func bjs_GPUTexture_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUTexture_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture_format_get")
fileprivate func bjs_GPUTexture_format_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture_format_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture_createView")
fileprivate func bjs_GPUTexture_createView(_ self: Int32) -> Int32
#else
fileprivate func bjs_GPUTexture_createView(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTexture_destroy")
fileprivate func bjs_GPUTexture_destroy(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUTexture_destroy(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUTexture_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUTexture_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$GPUTexture_format_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture_format_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$GPUTexture_createView(_ self: JSObject) throws(JSException) -> GPUTextureView {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_GPUTexture_createView(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return GPUTextureView.bridgeJSLiftReturn(ret)
}

func _$GPUTexture_destroy(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUTexture_destroy(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "WebGPUWasm", name: "bjs_GPUTextureView_label_get")
fileprivate func bjs_GPUTextureView_label_get(_ self: Int32) -> Void
#else
fileprivate func bjs_GPUTextureView_label_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$GPUTextureView_label_get(_ self: JSObject) throws(JSException) -> Optional<String> {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_GPUTextureView_label_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}