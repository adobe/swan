/*
 * Copyright 2025 Adobe
 * All Rights Reserved.
 *
 * NOTICE: Adobe permits you to use, modify, and distribute this file in
 * accordance with the terms of the Adobe license agreement accompanying
 * it.
 */
#if defined(__APPLE__)
#include "dawn/native/MetalBackend.h"
#endif

void WaitForCommandsToBeScheduled(WGPUDevice device) {
#if defined(__APPLE__)
    dawn::native::metal::WaitForCommandsToBeScheduled(device);
#endif
}