# Environment variables with defaults
SWIFT_TC   ?= $(shell cat .swift-version)
SWIFT_MODE ?= full
DEBUG      ?= true

# SDK presets
SWIFT_SDK_6_3_WASM      := swift-6.3-DEVELOPMENT-SNAPSHOT-2026-02-27-a_wasm
SWIFT_SDK_6_3_EMBEDDED  := swift-6.3-DEVELOPMENT-SNAPSHOT-2026-02-27-a_wasm-embedded
SWIFT_SDK_MAIN_WASM     := swift-DEVELOPMENT-SNAPSHOT-2026-03-09-a_wasm
SWIFT_SDK_MAIN_EMBEDDED := swift-DEVELOPMENT-SNAPSHOT-2026-03-09-a_wasm-embedded

# Derive SDK from toolchain (1) and mode (2)
# Returns empty for mode=full (native build needs no SDK)
_sdk = $(if $(filter wasm,$(2)),\
         $(if $(findstring 6.3-snapshot,$(1)),$(SWIFT_SDK_6_3_WASM),$(SWIFT_SDK_MAIN_WASM)),\
       $(if $(filter embedded,$(2)),\
         $(if $(findstring 6.3-snapshot,$(1)),$(SWIFT_SDK_6_3_EMBEDDED),$(SWIFT_SDK_MAIN_EMBEDDED)),))

# Remember whether SWIFT_SDK was explicitly provided before applying defaults
_SDK_EXPLICIT := $(if $(SWIFT_SDK),true,)

# Wasm targets treat SWIFT_MODE=full as wasm
_WASM_MODE := $(if $(filter full,$(SWIFT_MODE)),wasm,$(SWIFT_MODE))

# SDK for wasm targets: explicit override wins, otherwise derived from TC + wasm mode
_WASM_SDK = $(strip $(if $(_SDK_EXPLICIT),$(SWIFT_SDK),$(call _sdk,$(SWIFT_TC),$(_WASM_MODE))))

# SDK for native build: derived from TC + SWIFT_MODE (empty when full)
SWIFT_SDK ?= $(strip $(call _sdk,$(SWIFT_TC),$(SWIFT_MODE)))

BUILD_CONFIG  := $(if $(filter false,$(DEBUG)),release,debug)
SWIFT_TC_USE  := $(if $(SWIFT_TC),swiftly use $(SWIFT_TC) &&)
SWIFT_SDK_USE := $(if $(strip $(SWIFT_SDK)),--swift-sdk $(SWIFT_SDK))

.PHONY: help
help: ## Show this help
	@echo "Current Swift toolchain: '$(SWIFT_TC_CURRENT)'"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Environment variables:"
	@echo "  SWIFT_TC    Toolchain (from .swift-version)               Default: $$(cat .swift-version)"
	@echo "  SWIFT_MODE  full | wasm | embedded                        Default: full"
	@echo "              (wasm-* targets default to wasm when SWIFT_MODE is not set)"
	@echo "  SWIFT_SDK   Override derived SDK (optional)"
	@echo "  DEBUG       true = debug, false = release                 Default: true"
	@echo ""
	@echo "SWIFT_SDK is derived from SWIFT_TC + SWIFT_MODE:"
	@echo "  6.3-snapshot  + wasm     -> $(SWIFT_SDK_6_3_WASM)"
	@echo "  6.3-snapshot  + embedded -> $(SWIFT_SDK_6_3_EMBEDDED)"
	@echo "  main-snapshot + wasm     -> $(SWIFT_SDK_MAIN_WASM)"
	@echo "  main-snapshot + embedded -> $(SWIFT_SDK_MAIN_EMBEDDED)"
	@echo "  *             + full     -> (none, native build)"
	@echo ""
	@echo "Examples:"
	@echo "  make build                                     # native debug build"
	@echo "  make build DEBUG=false                         # native release build"
	@echo "  make wasm-build                                # WASM build (default mode: wasm)"
	@echo "  make wasm-build SWIFT_MODE=embedded            # embedded WASM build"
	@echo "  make wasm-build SWIFT_TC=6.3-snapshot          # WASM build (6.3 toolchain)"
	@echo "  make wasm-all DEBUG=false                      # clean + release WASM build"
	@echo "  make wasm-all SWIFT_MODE=embedded DEBUG=false  # clean + release embedded build"

.PHONY: swift-setup
swift-setup: ## Install and activate Swift toolchain (SWIFT_TC)
	swiftly install $(SWIFT_TC) && swiftly use $(SWIFT_TC)

.PHONY: serve
serve: ## Start local dev server
	pnpx serve .

.PHONY: build
build: ## Native Swift build (SWIFT_TC, DEBUG)
	$(SWIFT_TC_USE) swift build $(SWIFT_SDK_USE) -c $(BUILD_CONFIG)

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

.PHONY: demo-gameoflife
demo-gameoflife: ## Run GameOfLife demo
	swift run GameOfLife

.PHONY: demo-bitonic
demo-bitonic: ## Run BitonicSort demo
	swift run BitonicSort

.PHONY: wasm-build-bridgejs
wasm-build-bridgejs: ## Generate BridgeJS bindings (SWIFT_MODE, SWIFT_TC)
	$(SWIFT_TC_USE) SWAN_WASM=1 swift package --swift-sdk $(_WASM_SDK) plugin --allow-writing-to-package-directory bridge-js

.PHONY: wasm-build
wasm-build: wasm-build-bridgejs ## WASM build, depends on bridgejs (SWIFT_MODE, SWIFT_TC, DEBUG)
	$(SWIFT_TC_USE) SWAN_WASM=1 swift build --swift-sdk $(_WASM_SDK) --target WebGPU -c $(BUILD_CONFIG)

.PHONY: wasm-all
wasm-all: clean wasm-build ## Clean + full WASM build

.PHONY: wasm-demo-bitonic
wasm-demo-bitonic: wasm-build ## Build and serve BitonicSort WASM demo (SWIFT_MODE, SWIFT_TC)
	$(SWIFT_TC_USE) SWAN_WASM=1 swift package --swift-sdk $(_WASM_SDK) js --product BitonicSort -c $(BUILD_CONFIG) && pnpx serve .
