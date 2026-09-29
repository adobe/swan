// bridge-js: skip
// swift-format-ignore-file
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_initializeBitonicSort")
@_cdecl("bjs_initializeBitonicSort")
public func _bjs_initializeBitonicSort(_ deviceJS: Int32, _ contextJS: Int32, _ formatStringBytes: Int32, _ formatStringLength: Int32) -> Void {
    #if arch(wasm32)
    initializeBitonicSort(device: JSObject.bridgeJSLiftParameter(deviceJS), context: JSObject.bridgeJSLiftParameter(contextJS), format: String.bridgeJSLiftParameter(formatStringBytes, formatStringLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_renderFrame")
@_cdecl("bjs_renderFrame")
public func _bjs_renderFrame(_ time: Float64) -> Void {
    #if arch(wasm32)
    renderFrame(time: Double.bridgeJSLiftParameter(time))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_keyPressed")
@_cdecl("bjs_keyPressed")
public func _bjs_keyPressed(_ keyBytes: Int32, _ keyLength: Int32) -> Void {
    #if arch(wasm32)
    keyPressed(key: String.bridgeJSLiftParameter(keyBytes, keyLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}