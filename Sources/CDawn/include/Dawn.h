/*
 * Copyright 2025 Adobe
 * All Rights Reserved.
 *
 * NOTICE: Adobe permits you to use, modify, and distribute this file in
 * accordance with the terms of the Adobe license agreement accompanying
 * it.
 */

#if defined(_WIN32)
#include <windows.h>  // For LUID (via winnt.h)
#endif

#include "dawn/webgpu.h"

#ifdef __cplusplus
extern "C" {
#endif

void WaitForCommandsToBeScheduled(WGPUDevice device);

#if defined(_WIN32)
// Forward declarations for D3D12 types
struct ID3D12Resource;

// C-compatible wrapper for RequestAdapterOptionsLUID
// This wraps dawn::native::d3d::RequestAdapterOptionsLUID for use from Swift
typedef struct WGPURequestAdapterOptionsLUID {
    WGPUChainedStruct chain;
    LUID adapterLUID;
} WGPURequestAdapterOptionsLUID;

// C-compatible wrapper for SharedBufferMemoryD3D12ResourceDescriptor
// This wraps dawn::native::d3d12::SharedBufferMemoryD3D12ResourceDescriptor for use from Swift
typedef struct WGPUSharedBufferMemoryD3D12ResourceDescriptor {
    WGPUChainedStruct chain;
    struct ID3D12Resource* resource;
} WGPUSharedBufferMemoryD3D12ResourceDescriptor;

// C-compatible wrapper for SharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor
// This wraps dawn::native::d3d12::SharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor for use from Swift
typedef struct WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor {
    WGPUChainedStruct chain;
    void* handle;
    uint64_t size;
} WGPUSharedBufferMemoryD3D12SharedMemoryFileHandleDescriptor;

// C-compatible wrapper for SharedTextureMemoryD3D12ResourceDescriptor
// This wraps dawn::native::d3d12::SharedTextureMemoryD3D12ResourceDescriptor for use from Swift
typedef struct WGPUSharedTextureMemoryD3D12ResourceDescriptor {
    WGPUChainedStruct chain;
    struct ID3D12Resource* resource;
} WGPUSharedTextureMemoryD3D12ResourceDescriptor;
#endif

#ifdef __cplusplus
}
#endif
