# Swan – Swift WebGPU bindings
# Common build commands for native (Dawn) and WASM platforms

WASM_SDK ?= DEVELOPMENT-SNAPSHOT-2026-02-19-a-wasm32-unknown-wasip1

.PHONY: setup build build-wasm build-wasm-demo test clean format \
        generate-apinotes demo-gameoflife demo-bitonic help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

setup: ## Install and activate the required Swift toolchain
	swiftly install
	swiftly use

# ---------------------------------------------------------------------------
# Native builds (macOS / Windows via Dawn)
# ---------------------------------------------------------------------------

build: ## Build all targets (native)
	swift build

build-release: ## Build all targets in release mode (native)
	swift build -c release

# ---------------------------------------------------------------------------
# WASM builds
# ---------------------------------------------------------------------------

wasm-build: ## Build the WebGPU library for WASM
	SWAN_WASM=1 swift build --target WebGPU --swift-sdk $(WASM_SDK)

wasm-demo-bitonic: ## Build the BitonicSortWasm demo for WASM
	SWAN_WASM=1 swift package --swift-sdk $(WASM_SDK) js --product BitonicSortWasm
	python3 -m http.server 3000

# ---------------------------------------------------------------------------
# Testing
# ---------------------------------------------------------------------------

test: ## Run all tests
	swift test

# ---------------------------------------------------------------------------
# Code generation
# ---------------------------------------------------------------------------

generate-apinotes: ## Generate Dawn API notes from dawn.json
	swift package --allow-writing-to-package-directory generate-dawn-apinotes

# ---------------------------------------------------------------------------
# Demos (native)
# ---------------------------------------------------------------------------

demo-gameoflife: ## Build and run the GameOfLife demo
	swift run GameOfLife

demo-bitonic: ## Build and run the BitonicSort demo
	swift run BitonicSort

# ---------------------------------------------------------------------------
# Code quality
# ---------------------------------------------------------------------------

format: ## Format all Swift source files
	swift format --in-place --recursive Sources Tests Demos

# ---------------------------------------------------------------------------
# Housekeeping
# ---------------------------------------------------------------------------

clean: ## Remove build artifacts
	swift package clean

resolve: ## Resolve package dependencies
	swift package resolve
