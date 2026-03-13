// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.

// Stub implementations for Unicode normalization symbols missing from the
// Embedded Swift WASM runtime. The full Swift String type pulls in NFC/NFD
// normalization code via its Equatable conformance. Since all strings used
// in this project are pure ASCII, the normalization slow path is never
// reached at runtime — these stubs just satisfy the linker.

#include <stddef.h>
#include <stdint.h>

uint16_t _swift_stdlib_getNormData(uint32_t scalar) { return 0; }

int32_t _swift_stdlib_getComposition(uint32_t x, uint32_t y) { return -1; }

int32_t _swift_stdlib_getDecompositionEntry(uint32_t scalar) { return 0; }

const uint8_t *_swift_stdlib_nfd_decompositions = NULL;
