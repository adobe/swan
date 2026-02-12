# WASM Demo

## Generating BridgeJS Code (optional, also done by build via plugin definition)
```bash
swift package plugin --allow-writing-to-package-directory bridge-js --target WebGPUMinimalWasm --verbose
```

## Build
```bash
env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package --swift-sdk swift-6.3-DEVELOPMENT-SNAPSHOT-2026-01-09-a_wasm js --use-cdn --product WebGPUMinimalWasm
```

## Manually fix bridge-js.js
You need to fix two duplicate definitions in [bridge-js.js](../../.build/plugins/PackageToJS/outputs/Package/bridge-js.js)
Approx. lines 68 and 395

## Run
```bash
npx serve .
open http://localhost:3000/Demos/WebGPUMinimalWasm/
```