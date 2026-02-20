.PHONY: clean build build-wasm bridgejs-wasm bitonic-sort-wasm bitonic-sort test

WASM_SDK=swift-6.3-DEVELOPMENT-SNAPSHOT-2026-01-09-a_wasm

clean:
	swift package clean

build:
	swift build

build-wasm:
	JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 SWAN_WASM=1 swift build --swift-sdk $(WASM_SDK)

bridgejs-wasm:
	JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 SWAN_WASM=1 swift package plugin --allow-writing-to-package-directory bridge-js

bitonic-sort-wasm:
	JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 SWAN_WASM=1 swift package --swift-sdk $(WASM_SDK) js --product BitonicSortWasm
	npx serve .
#	python3 -m http.server 3000

bitonic-sort:
	swift run BitonicSort

test:
	swift test
