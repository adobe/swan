// Copyright 2025 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// WebGPU - Unified Swift WebGPU API
//
// This module provides a cross-platform WebGPU API for Swift.

// TODO: Re-export the core types (if applicable)

#if !arch(wasm32)
// Re-export the Dawn backend (native platforms only)
@_exported import WebGPUDawn
#else
// Re-export the WebAssembly backend (WASM only)
@_exported import WebGPUWasm
#endif
