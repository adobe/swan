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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBufferDescriptor {
        let mappedAtCreation = Bool.bridgeJSLiftParameter()
        let usage = Int.bridgeJSLiftParameter()
        let size = Int.bridgeJSLiftParameter()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUBufferDescriptor(label: label, size: size, usage: usage, mappedAtCreation: mappedAtCreation)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.size.bridgeJSLowerStackReturn()
        self.usage.bridgeJSLowerStackReturn()
        self.mappedAtCreation.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUShaderModuleDescriptor {
        let code = String.bridgeJSLiftParameter()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUShaderModuleDescriptor(label: label, code: code)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.code.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUShaderModuleDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUVertexAttribute {
        let shaderLocation = Int.bridgeJSLiftParameter()
        let offset = Int.bridgeJSLiftParameter()
        let format = GPUVertexFormat.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        return GPUVertexAttribute(format: format, offset: offset, shaderLocation: shaderLocation)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.format.bridgeJSLowerStackReturn()
        self.offset.bridgeJSLowerStackReturn()
        self.shaderLocation.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexAttribute(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUVertexBufferLayout {
        let attributes = [GPUVertexAttribute].bridgeJSLiftParameter()
        let stepMode = GPUVertexStepMode.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let arrayStride = Int.bridgeJSLiftParameter()
        return GPUVertexBufferLayout(arrayStride: arrayStride, stepMode: stepMode, attributes: attributes)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.arrayStride.bridgeJSLowerStackReturn()
        self.stepMode.bridgeJSLowerStackReturn()
        self.attributes.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexBufferLayout(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUPrimitiveState {
        let cullMode = GPUCullMode.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let frontFace = GPUFrontFace.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let topology = GPUPrimitiveTopology.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        return GPUPrimitiveState(topology: topology, frontFace: frontFace, cullMode: cullMode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.topology.bridgeJSLowerStackReturn()
        self.frontFace.bridgeJSLowerStackReturn()
        self.cullMode.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUPrimitiveState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUColorTargetState {
        let writeMask = Int.bridgeJSLiftParameter()
        let format = GPUTextureFormat.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        return GPUColorTargetState(format: format, writeMask: writeMask)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.format.bridgeJSLowerStackReturn()
        self.writeMask.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUColorTargetState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUColor {
        let a = Double.bridgeJSLiftParameter()
        let b = Double.bridgeJSLiftParameter()
        let g = Double.bridgeJSLiftParameter()
        let r = Double.bridgeJSLiftParameter()
        return GPUColor(r: r, g: g, b: b, a: a)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.r.bridgeJSLowerStackReturn()
        self.g.bridgeJSLowerStackReturn()
        self.b.bridgeJSLowerStackReturn()
        self.a.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUColor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUCommandEncoderDescriptor {
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUCommandEncoderDescriptor(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUCommandEncoderDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBufferBinding {
        let size = Optional<Int>.bridgeJSLiftParameter()
        let offset = Optional<Int>.bridgeJSLiftParameter()
        let buffer = GPUBuffer(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPUBufferBinding(buffer: buffer, offset: offset, size: size)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.buffer.jsObject.bridgeJSLowerStackReturn()
        let __bjs_isSome_offset = self.offset != nil
        if let __bjs_unwrapped_offset = self.offset {
            __bjs_unwrapped_offset.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_offset ? 1 : 0)
        let __bjs_isSome_size = self.size != nil
        if let __bjs_unwrapped_size = self.size {
            __bjs_unwrapped_size.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_size ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferBinding(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBindGroupEntry {
        let resource = GPUBufferBinding.bridgeJSLiftParameter()
        let binding = Int.bridgeJSLiftParameter()
        return GPUBindGroupEntry(binding: binding, resource: resource)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.binding.bridgeJSLowerStackReturn()
        self.resource.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupEntry(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBindGroupDescriptor {
        let entries = [GPUBindGroupEntry].bridgeJSLiftParameter()
        let layout = GPUBindGroupLayout(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUBindGroupDescriptor(label: label, layout: layout, entries: entries)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.jsObject.bridgeJSLowerStackReturn()
        self.entries.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBufferBindingLayout {
        let type = GPUBufferBindingType.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        return GPUBufferBindingLayout(type: type)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.type.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBufferBindingLayout(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBindGroupLayoutEntry {
        let buffer = Optional<GPUBufferBindingLayout>.bridgeJSLiftParameter()
        let visibility = Int.bridgeJSLiftParameter()
        let binding = Int.bridgeJSLiftParameter()
        return GPUBindGroupLayoutEntry(binding: binding, visibility: visibility, buffer: buffer)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.binding.bridgeJSLowerStackReturn()
        self.visibility.bridgeJSLowerStackReturn()
        let __bjs_isSome_buffer = self.buffer != nil
        if let __bjs_unwrapped_buffer = self.buffer {
            __bjs_unwrapped_buffer.bridgeJSLowerReturn()
        }
        _swift_js_push_i32(__bjs_isSome_buffer ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupLayoutEntry(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUBindGroupLayoutDescriptor {
        let entries = [GPUBindGroupLayoutEntry].bridgeJSLiftParameter()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUBindGroupLayoutDescriptor(label: label, entries: entries)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.entries.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUBindGroupLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUCanvasConfiguration {
        let alphaMode = String.bridgeJSLiftParameter()
        let format = GPUTextureFormat.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let device = GPUDevice(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPUCanvasConfiguration(device: device, format: format, alphaMode: alphaMode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.device.jsObject.bridgeJSLowerStackReturn()
        self.format.bridgeJSLowerStackReturn()
        self.alphaMode.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUCanvasConfiguration(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPURenderPassColorAttachment {
        let clearValue = Optional<GPUColor>.bridgeJSLiftParameter()
        let storeOp = GPUStoreOp.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let loadOp = GPULoadOp.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let view = GPUTextureView(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPURenderPassColorAttachment(view: view, loadOp: loadOp, storeOp: storeOp, clearValue: clearValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.view.jsObject.bridgeJSLowerStackReturn()
        self.loadOp.bridgeJSLowerStackReturn()
        self.storeOp.bridgeJSLowerStackReturn()
        let __bjs_isSome_clearValue = self.clearValue != nil
        if let __bjs_unwrapped_clearValue = self.clearValue {
            __bjs_unwrapped_clearValue.bridgeJSLowerReturn()
        }
        _swift_js_push_i32(__bjs_isSome_clearValue ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPassColorAttachment(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPURenderPassDescriptor {
        let colorAttachments = [GPURenderPassColorAttachment].bridgeJSLiftParameter()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPURenderPassDescriptor(label: label, colorAttachments: colorAttachments)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.colorAttachments.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPassDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUComputePassDescriptor {
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUComputePassDescriptor(label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputePassDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUComputeState {
        let entryPoint = String.bridgeJSLiftParameter()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPUComputeState(module: module, entryPoint: entryPoint)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.module.jsObject.bridgeJSLowerStackReturn()
        self.entryPoint.bridgeJSLowerStackReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputeState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUComputePipelineDescriptor {
        let compute = GPUComputeState.bridgeJSLiftParameter()
        let layout = GPUPipelineLayout(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUComputePipelineDescriptor(label: label, layout: layout, compute: compute)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.jsObject.bridgeJSLowerStackReturn()
        self.compute.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUComputePipelineDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUVertexState {
        let buffers = [GPUVertexBufferLayout].bridgeJSLiftParameter()
        let entryPoint = String.bridgeJSLiftParameter()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPUVertexState(module: module, entryPoint: entryPoint, buffers: buffers)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.module.jsObject.bridgeJSLowerStackReturn()
        self.entryPoint.bridgeJSLowerStackReturn()
        self.buffers.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUVertexState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUFragmentState {
        let targets = [GPUColorTargetState].bridgeJSLiftParameter()
        let entryPoint = String.bridgeJSLiftParameter()
        let module = GPUShaderModule(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return GPUFragmentState(module: module, entryPoint: entryPoint, targets: targets)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.module.jsObject.bridgeJSLowerStackReturn()
        self.entryPoint.bridgeJSLowerStackReturn()
        self.targets.bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUFragmentState(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPURenderPipelineDescriptor {
        let fragment = Optional<GPUFragmentState>.bridgeJSLiftParameter()
        let primitive = Optional<GPUPrimitiveState>.bridgeJSLiftParameter()
        let vertex = GPUVertexState.bridgeJSLiftParameter()
        let layout = String.bridgeJSLiftParameter()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPURenderPipelineDescriptor(label: label, layout: layout, vertex: vertex, primitive: primitive, fragment: fragment)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.layout.bridgeJSLowerStackReturn()
        self.vertex.bridgeJSLowerReturn()
        let __bjs_isSome_primitive = self.primitive != nil
        if let __bjs_unwrapped_primitive = self.primitive {
            __bjs_unwrapped_primitive.bridgeJSLowerReturn()
        }
        _swift_js_push_i32(__bjs_isSome_primitive ? 1 : 0)
        let __bjs_isSome_fragment = self.fragment != nil
        if let __bjs_unwrapped_fragment = self.fragment {
            __bjs_unwrapped_fragment.bridgeJSLowerReturn()
        }
        _swift_js_push_i32(__bjs_isSome_fragment ? 1 : 0)
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPURenderPipelineDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> GPUPipelineLayoutDescriptor {
        let bindGroupLayouts = {
    let __count = Int(_swift_js_pop_i32())
    var __result: [GPUBindGroupLayout] = []
    __result.reserveCapacity(__count)
    for _ in 0 ..< __count {
        __result.append(GPUBindGroupLayout(unsafelyWrapping: JSObject.bridgeJSLiftParameter()))
    }
    __result.reverse()
    return __result
        }()
        let label = Optional<String>.bridgeJSLiftParameter()
        return GPUPipelineLayoutDescriptor(label: label, bindGroupLayouts: bindGroupLayouts)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        let __bjs_isSome_label = self.label != nil
        if let __bjs_unwrapped_label = self.label {
            __bjs_unwrapped_label.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_label ? 1 : 0)
        self.bindGroupLayouts.map {
            $0.jsObject
        } .bridgeJSLowerReturn()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_GPUPipelineLayoutDescriptor(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
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