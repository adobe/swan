# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Swan is a Swift WebGPU binding library that provides Swift APIs for using WebGPU across multiple platforms. The initial implementation is a Swift binding to Google's Dawn library. This is currently a work-in-progress project not ready for production use.

## Architecture

### Core Components

- **Dawn**: Swift wrapper around Google's Dawn WebGPU implementation
- **CDawn**: C bindings layer for Dawn
- **DawnData**: Data structures and utilities for Dawn integration
- **WebGPU**: High-level Swift WebGPU API built on Dawn
- **WebGPULife**: Demo/example applications

### Code Generation

The project uses Swift Package Manager plugins for code generation:

- **GenerateDawnBindingsPlugin**: Generates Swift bindings from Dawn's C API
- **GenerateDawnAPINotesPlugin**: Generates API notes for better Swift integration

Both plugins depend on executable targets that process `dawn.json` to generate appropriate Swift code.

### Binary Dependencies

The project uses a binary target `DawnLib` that contains pre-built Dawn WebGPU libraries for multiple platforms (macOS, iOS, Linux, Windows). These are built via GitHub Actions and distributed as releases.

## Development Commands

### Building
```bash
swift build
```

### Testing
```bash
swift test
```

### Code Generation Plugins
```bash
# Generate Dawn API notes
swift package generate-dawn-apinotes

# Bindings are generated automatically during build via GenerateDawnBindingsPlugin
```

### Code Formatting
The project uses swift-format with configuration in `.swift-format`:
- Line length: 140 characters
- Uses tabs for indentation
- Ordered imports enabled

## Platform Requirements

- macOS 15+ 
- iOS 18+
- Swift 6.1+
- Uses development snapshot toolchain (swift-DEVELOPMENT-SNAPSHOT-2025-08-16-a)

## Dependencies

- swift-testing (for tests)
- swift-log (for logging)
- swift-syntax (for code generation)

## Key Files

- `Package.swift`: Swift Package Manager configuration
- `Dawn/ci_build_dawn.py`: Python script for building dawn in CI
- `.swift-format`: Code formatting configuration
- `.vscode/settings.json`: VS Code configuration with specific Swift toolchain path

## Dawn Integration

The project maintains its own Dawn builds through GitHub Actions workflows that:
1. Fetch specific Chromium/Dawn versions
2. Build Dawn for multiple platforms
3. Package as binary releases
4. Update Package.swift with new binary target URLs

The Dawn source management and building is handled by Python scripts in the `Dawn/` directory.
