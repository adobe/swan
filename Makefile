SWIFT_MODE ?=
DEBUG      ?= 1

# Load WASM SDK configuration (WASM_SDK, WASM_SDK_EMBEDDED, WASM_SDK_URL)
include .swan-config

SWIFT_SDK ?= $(if $(filter embedded,$(SWIFT_MODE)),$(WASM_SDK_EMBEDDED),$(WASM_SDK))

BUILD_CONFIG := $(if $(filter 0 false,$(DEBUG)),release,debug)

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(firstword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Environment variables:"
	@echo "  SWIFT_MODE  embedded (use embedded SDK)                      Default: (none)"
	@echo "  SWIFT_SDK   Override derived SDK                             Default: $(SWIFT_SDK)"
	@echo "  DEBUG       1 or true = debug, 0 or false = release          Default: 1"
	@echo ""
	@echo "Derived SDK:       $(SWIFT_SDK)"
	@echo ""
	@echo "Examples:"
	@echo "  make build                                     # native debug build"
	@echo "  make build DEBUG=0                             # native release build"
	@echo "  make wasm-build                                # WASM build"
	@echo "  make wasm-build SWIFT_MODE=embedded            # embedded WASM build"
	@echo "  make wasm-all DEBUG=0                          # clean + release WASM build"
	@echo "  make wasm-all SWIFT_MODE=embedded DEBUG=0      # clean + release embedded build"

.PHONY: debug
debug: ## Echo all Make variables
	@echo "CI: $(CI)"
	@echo "DEBUG: $(DEBUG)"
	@echo "BUILD_CONFIG: $(BUILD_CONFIG)"
	@echo "SWIFT_MODE: $(SWIFT_MODE)"
	@echo "SWIFT_SDK: $(SWIFT_SDK)"

.PHONY: swift-setup
swift-setup: ## Install and activate Swift toolchain
	swiftly install && swiftly use

.PHONY: sdk-install
sdk-install: ## Download and install the WASM SDK
	node Scripts/sdk-install.mjs "$(WASM_SDK_URL)" "$(WASM_SDK_CHECKSUM)"

.PHONY: sdk-install-embedded
sdk-install-embedded: ## Download and install the embedded WASM SDK (main-snapshot)
	node Scripts/sdk-install.mjs "$(WASM_SDK_URL_EMBEDDED)" "$(WASM_SDK_CHECKSUM_EMBEDDED)"

.PHONY: build
build: ## Native Swift build (DEBUG)
	swift build -c $(BUILD_CONFIG)

.PHONY: test
test: ## Run Swift tests
	swift test

.PHONY: clean
clean: ## Clean build artifacts
	swift package clean

.PHONY: resolve
resolve: ## Resolve Swift package dependencies
	swift package resolve

.PHONY: format
format: ## Format Swift source code
	swift format --in-place --recursive Sources Tests Demos

.PHONY: generate-apinotes
generate-apinotes: ## Generate Dawn API notes
	swift package --allow-writing-to-package-directory generate-dawn-apinotes

.PHONY: run-gameoflife
run-gameoflife: ## Run GameOfLife demo
	swift run GameOfLife

.PHONY: run-bitonic
run-bitonic: ## Run BitonicSort demo
	swift run BitonicSort

.PHONY: wasm-build-bridgejs
wasm-build-bridgejs: ## Generate BridgeJS bindings (SWIFT_MODE)
	SWAN_WASM=1 swift package --swift-sdk $(SWIFT_SDK) plugin --allow-writing-to-package-directory bridge-js

.PHONY: wasm-build
wasm-build: wasm-build-bridgejs ## WASM build, depends on bridgejs (SWIFT_MODE, DEBUG)
	SWAN_WASM=1 swift build --swift-sdk $(SWIFT_SDK) --target WebGPU -c $(BUILD_CONFIG)

.PHONY: wasm-all
wasm-all: clean wasm-build ## Clean + full WASM build

.PHONY: wasm-build-bitonic
wasm-build-bitonic: wasm-build-bridgejs ## WASM build BitonicSort, depends on bridgejs (SWIFT_MODE, DEBUG)
	SWAN_WASM=1 swift build --swift-sdk $(SWIFT_SDK) --target BitonicSort -c $(BUILD_CONFIG)

.PHONY: wasm-run-bitonic
wasm-run-bitonic: wasm-build-bitonic ## Build and serve BitonicSort WASM demo (SWIFT_MODE)
	SWAN_WASM=1 swift package --swift-sdk $(SWIFT_SDK) js --product BitonicSort -c $(BUILD_CONFIG) && pnpx serve .
