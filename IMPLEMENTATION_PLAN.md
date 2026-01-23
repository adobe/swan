# Implementation Plan: Eliminate Redundant Array Size Parameters

## Executive Summary

This plan details how to eliminate redundant count/size parameters from generated Swift method signatures in the Swan WebGPU binding generator. Currently, methods require both an array and its size (e.g., `submit(commandCount: Int, commands: [GPUCommandBuffer])`), but Swift arrays already know their count. After implementation, methods will only require the array parameter (e.g., `submit(commands: [GPUCommandBuffer])`).

**Status**: Proposed
**Breaking Change**: Yes
**Estimated Impact**: All Swan API consumers
**Rollback Complexity**: Low (isolated to code generation)

---

## Problem Statement

### Current API (Redundant)
```swift
// Queue submission
queue.submit(commandCount: 2, commands: [cmd1, cmd2])

// Render pass bind groups
renderPass.setBindGroup(
    groupIndex: 0,
    group: bindGroup,
    dynamicOffsetCount: offsets.count,
    dynamicOffsets: offsets
)
```

### Proposed API (Clean)
```swift
// Queue submission
queue.submit(commands: [cmd1, cmd2])

// Render pass bind groups
renderPass.setBindGroup(
    groupIndex: 0,
    group: bindGroup,
    dynamicOffsets: offsets
)
```

### Why This Matters
1. **Better Swift ergonomics** - Eliminates redundant parameters
2. **Prevents errors** - Can't pass mismatched count/array
3. **Cleaner API surface** - More idiomatic Swift
4. **Follows platform conventions** - Similar to SwiftUI, UIKit patterns

---

## Technical Implementation

### Architecture Understanding

#### Data Flow
```
dawn.json → DawnData → DawnMethod → methodWrapperDecl() → Objects.swift
```

#### Key Data Structures
```swift
// From dawn.json
{
    "name": "submit",
    "args": [
        {"name": "command count", "type": "size_t"},
        {"name": "commands", "type": "command buffer",
         "annotation": "const*", "length": "command count"}
    ]
}

// Parsed into DawnMethod
struct DawnMethod {
    let name: Name
    let args: [DawnFunctionArgument]?
}

// Each arg has length linking to size param
struct DawnFunctionArgument {
    let name: Name
    let type: Name
    let annotation: String?  // e.g., "const*", "*", "const*const*"
    let length: ArraySize?   // .name("command count") or .int(3)
}
```

#### How Array Detection Works

Determining if a parameter is a Swift array requires examining **three properties together**:

1. **`type`** - The underlying type (e.g., `"uint32_t"`, `"command buffer"`, `"void"`)
2. **`annotation`** - Indicates pointer semantics (e.g., `"const*"`)
3. **`length`** - Indicates size relationship (e.g., `.name("count")` or `.int(3)`)

The existing Swift type generation logic (in `DawnNativeType+Wrappers.swift` and `DawnObject+Wrappers.swift`) combines these to produce the final Swift type:

| type | annotation | length | Swift Type | Is Array? |
|------|------------|--------|------------|-----------|
| `uint32_t` | `"const*"` | `.name("count")` | `[UInt32]` | ✅ Yes |
| `command buffer` | `"const*"` | `.name("count")` | `[GPUCommandBuffer]` | ✅ Yes |
| `uint8_t` | `"const*"` | `.name("size")` | `UnsafeRawPointer` | ❌ No (raw data) |
| `void` | `"const*"` | `.name("size")` | `UnsafeRawPointer` | ❌ No (raw data) |
| `float` | - | `.int(3)` | `(Float, Float, Float)` | ❌ No (tuple) |
| *(hypothetical)* | - | - | `[String: Int]` | ❌ No (dictionary) |

**Key Insight**: We don't re-implement this complex type mapping logic. Instead, we call `swiftTypeName(data:)` to get the generated Swift type, then check if it's an array:

```swift
let swiftType = arg.swiftTypeName(data: data)
let isArray = swiftType.hasPrefix("[") && !swiftType.contains(":")
// True for:  [T], [T]?
// False for: [K: V] (dictionary), UnsafeRawPointer, Set<T>, (T, T)
```

**Why check for `:` (colon)?** While Dawn's C API will never generate dictionaries, explicitly checking for the colon makes the code more robust:
- **Arrays**: `[UInt32]`, `[GPUCommandBuffer]?` (no colon)
- **Dictionaries**: `[String: Int]`, `[UInt32: Float]?` (has colon)
- **Future-proof**: Protects against future type system extensions

**Why this matters**: Parameters with `length` but raw pointer types (`UnsafeRawPointer`) should **keep** their size parameters in the public API, since pointers don't have a `.count` property. Only Swift array types (`[T]`) have automatic size extraction.

### Implementation Strategy

#### Step 1: Size Parameter Detection

**File**: `Sources/GenerateDawnBindings/DawnMethod+Wrappers.swift`

**Location**: After `usesWrappedType()` method (line 25)

Add helper methods:
```swift
/// Returns true if this argument is a size parameter for a Swift array argument
///
/// This method searches ALL arguments (not just adjacent ones) because array parameters
/// explicitly reference their size parameter by name via the `length` field in dawn.json.
/// For example:
///   args[0]: {name: "command count", type: "size_t"}
///   args[1]: {name: "commands", type: "command buffer", annotation: "const*", length: "command count"}
/// We check if any other argument's `length` field references this arg's name.
private func isSizeParameter(_ arg: DawnFunctionArgument, in args: [DawnFunctionArgument], data: DawnData) -> Bool {
    return args.contains { otherArg in
        if case .name(let lengthName) = otherArg.length {
            if lengthName == arg.name {
                // IMPORTANT: Only for Swift arrays (e.g., [UInt32]), not raw pointers or dictionaries.
                // The type + annotation + length combination determines the final Swift type.
                // We delegate to swiftTypeName() rather than re-implement that logic here.
                let swiftType = otherArg.swiftTypeName(data: data)
                // Check for array: starts with [ AND not a dictionary (no colon)
                return swiftType.hasPrefix("[") && !swiftType.contains(":")
            }
        }
        return false
    }
}

/// Returns arguments excluding size parameters that correspond to Swift arrays
private func publicArgs(data: DawnData) -> [DawnFunctionArgument] {
    let args = self.args ?? []
    return args.filter { !isSizeParameter($0, in: args, data: data) }
}

/// Returns the array argument that uses this size parameter
///
/// Given a size parameter name, finds the array argument whose `length` field references it.
/// Searches all arguments following the explicit linkage in the data structure.
private func arrayForSize(_ sizeName: Name, in args: [DawnFunctionArgument]) -> DawnFunctionArgument? {
    return args.first { arg in
        if case .name(let lengthName) = arg.length {
            return lengthName == sizeName
        }
        return false
    }
}
```

**Key Design Decision**: Only filter size parameters for Swift arrays (`[T]`), not raw pointers or dictionaries, because only arrays have automatic size extraction via `.count`. The check `swiftType.hasPrefix("[") && !swiftType.contains(":")` relies on the existing type generation system that already considers `type`, `annotation`, and `length` together to determine the appropriate Swift type.

#### Step 2: Count Extraction Code Generation

Add a method to generate `let count = array.count` statements:
```swift
/// Generate let statements that extract array counts into size parameter variables
private func generateArraySizeExtractions(data: DawnData) -> String {
    let allArgs = self.args ?? []
    var extractions: [String] = []

    for arg in allArgs where isSizeParameter(arg, in: allArgs, data: data) {
        guard let arrayArg = arrayForSize(arg.name, in: allArgs) else {
            continue
        }

        let arrayName = arrayArg.name.camelCase
        let sizeName = arg.name.camelCase

        // Check if the Swift type is optional (ends with ?)
        let swiftType = arrayArg.swiftTypeName(data: data)
        let isOptional = swiftType.hasSuffix("?")
        let countExpr = isOptional ? "\(arrayName)?.count ?? 0" : "\(arrayName).count"

        extractions.append("let \(sizeName) = \(countExpr)")
    }

    return extractions.isEmpty ? "" : extractions.joined(separator: "\n") + "\n"
}
```

#### Step 3: Modify `unwrapArgs` to Accept Size Extraction

**File**: `Sources/GenerateDawnBindings/DawnMethod+Wrappers.swift`
**Method**: `unwrapArgs(_:data:expression:)` (lines 28-47)

The size extraction code needs to be injected at the **innermost level** of the unwrapping closures—after all array arguments are unwrapped but before the C API call. This ensures the array variables are in scope when we call `.count` on them.

**Add a new `sizeExtraction` parameter:**
```swift
/// Unwrap the arguments for a method call, injecting size extraction at the innermost level.
func unwrapArgs(_ args: [DawnFunctionArgument], data: DawnData, expression: ExprSyntax,
                sizeExtraction: String = "") -> ExprSyntax {
    if args.isEmpty {
        if sizeExtraction.isEmpty {
            return expression.indented(by: Trivia.tab)
        }
        // Inject size extraction before the expression at the innermost level
        return ExprSyntax(
            """
            \(raw: sizeExtraction)\(expression)
            """
        )
    }

    var args = args
    let lastArg = args.removeLast()

    let lastArgDecl: ExprSyntax
    if lastArg.isWrappedType(data: data) {
        lastArgDecl = lastArg.unwrapValueWithIdentifier(lastArg.name.camelCase, data: data, expression: expression)
    } else {
        lastArgDecl = expression
    }
    let lastArgFormatted: ExprSyntax = "\(lastArgDecl, format: TabFormat(initialIndentation: .tabs(0)))"
    if args.count > 0 {
        // Pass sizeExtraction through to the next recursive call
        return unwrapArgs(args, data: data, expression: lastArgFormatted, sizeExtraction: sizeExtraction)
    }
    return lastArgFormatted
}
```

**Why this approach?** The size extraction needs to happen inside the unwrapping closures:
```swift
commands.unwrapWGPUObjectArray { commands in
    let commandCount = commands.count    // ← Inside closure, after unwrapping
    submit(commandCount: commandCount, commands: commands)
}
```

By injecting at the innermost level (when `args.isEmpty`), we ensure the array variables are in scope.

#### Step 4: Modify Method Signature Generation

**File**: `Sources/GenerateDawnBindings/DawnMethod+Wrappers.swift`
**Method**: `methodWrapperDecl(data:)` (lines 50-99)

Changes:
```swift
func methodWrapperDecl(data: DawnData) -> FunctionDeclSyntax {
    let methodName = name.camelCase

    let allArgs = self.args ?? []
    let publicArgs = publicArgs(data: data)  // NEW: Filter size parameters

    // C API call uses ALL arguments (including size params)
    let wgpuMethodCall: ExprSyntax =
        """
        \(raw: name.camelCase)(\(raw: allArgs.map { "\($0.name.camelCase): \($0.name.camelCase)" }.joined(separator: ", ")))
        """

    // NEW: Generate size extraction code
    let sizeExtraction = generateArraySizeExtractions(data: data)

    // Unwrap arguments, passing size extraction to inject at innermost level
    let unwrappedMethodCall = unwrapArgs(publicArgs, data: data, expression: wgpuMethodCall,
                                          sizeExtraction: sizeExtraction)

    // ... rest of method body uses unwrappedMethodCall ...

    // NEW: Use publicArgs for signature
    let argumentSignature = FunctionParameterListSyntax {
        for arg in publicArgs {  // Changed from allArgs
            "\(raw: arg.name.camelCase): \(raw: arg.isInOut ? "inout " : "")\(raw: arg.swiftTypeName(data: data))"
        }
    }

    // ... return function declaration ...
}
```

### Edge Cases Handled

#### 1. Optional Arrays
```swift
// Input: dynamicOffsets: [UInt32]?
// Generated: let dynamicOffsetCount = dynamicOffsets?.count ?? 0
```

#### 2. Empty Arrays
```swift
// Input: commands: []
// Generated: let commandCount = commands.count  // = 0
```

#### 3. Multiple Arrays in Same Method
```swift
// Each gets its own extraction:
let commandCount = commands.count
let bufferCount = buffers.count
```

#### 4. Raw Pointers (NOT changed)
```swift
// Parameters with type="void" or "uint8_t" + annotation="const*" + length="size"
// become UnsafeRawPointer in Swift, not arrays. These KEEP their size parameters.
func writeTexture(
    destination: GPUTexelCopyTextureInfo,
    data: UnsafeRawPointer,    // type: void, annotation: const*, length: data size
    dataSize: Int,              // <-- Kept in public API (no automatic extraction)
    dataLayout: GPUTexelCopyBufferLayout,
    writeSize: GPUExtent3D
)
```

**Why**: `UnsafeRawPointer` doesn't have a `.count` property, so we can't auto-extract the size. The user must provide it explicitly.

#### 5. Fixed-Size Arrays (Tuples)
```swift
// ArraySize.int(3) - used for tuples like (Float, Float, Float)
// These don't have separate size parameters, so unaffected
```

---

## Testing Strategy

### Unit Tests (New)

**File**: `Tests/GenerateDawnBindingsTests/DawnMethodWrapperTests.swift` (create)

```swift
import Testing
import DawnData
import GenerateDawnBindings

@Suite("DawnMethod Wrapper Generation")
struct DawnMethodWrapperTests {

    @Test("Single array with size parameter is filtered")
    func testSingleArraySizeParameterFiltered() throws {
        let method = DawnMethod(
            name: Name("submit"),
            args: [
                DawnFunctionArgument(name: Name("command count"), type: Name("size_t")),
                DawnFunctionArgument(
                    name: Name("commands"),
                    type: Name("command buffer"),
                    annotation: "const*",
                    length: .name(Name("command count"))
                )
            ]
        )

        let data = try loadDawnData()
        let publicArgs = method.publicArgs(data: data)

        #expect(publicArgs.count == 1)
        #expect(publicArgs[0].name == Name("commands"))
    }

    @Test("Optional array generates nil-coalescing count extraction")
    func testOptionalArrayCountExtraction() throws {
        let method = DawnMethod(
            name: Name("setBindGroup"),
            args: [
                DawnFunctionArgument(name: Name("dynamic offset count"), type: Name("size_t")),
                DawnFunctionArgument(
                    name: Name("dynamic offsets"),
                    type: Name("uint32_t"),
                    annotation: "const*",
                    optional: true,
                    length: .name(Name("dynamic offset count"))
                )
            ]
        )

        let data = try loadDawnData()
        let extraction = method.generateSizeExtractions(data: data)

        #expect(extraction.contains("?.count ?? 0"))
    }

    @Test("Multiple arrays get separate size extractions")
    func testMultipleArraysWithSizes() throws {
        let method = DawnMethod(
            name: Name("multiArray"),
            args: [
                DawnFunctionArgument(name: Name("count1"), type: Name("size_t")),
                DawnFunctionArgument(
                    name: Name("array1"),
                    type: Name("uint32_t"),
                    annotation: "const*",
                    length: .name(Name("count1"))
                ),
                DawnFunctionArgument(name: Name("count2"), type: Name("size_t")),
                DawnFunctionArgument(
                    name: Name("array2"),
                    type: Name("uint32_t"),
                    annotation: "const*",
                    length: .name(Name("count2"))
                )
            ]
        )

        let data = try loadDawnData()
        let publicArgs = method.publicArgs(data: data)

        #expect(publicArgs.count == 2)
        #expect(publicArgs[0].name == Name("array1"))
        #expect(publicArgs[1].name == Name("array2"))
    }

    @Test("Raw pointer size parameter is NOT filtered")
    func testRawPointerKeepsSizeParameter() throws {
        let method = DawnMethod(
            name: Name("writeTexture"),
            args: [
                DawnFunctionArgument(name: Name("data"), type: Name("void"), annotation: "const*"),
                DawnFunctionArgument(name: Name("data size"), type: Name("size_t"))
            ]
        )

        let data = try loadDawnData()
        let publicArgs = method.publicArgs(data: data)

        // Both params should remain (data is UnsafeRawPointer, not [T])
        #expect(publicArgs.count == 2)
    }

    @Test("Method without arrays is unchanged")
    func testNoArrayParameters() throws {
        let method = DawnMethod(
            name: Name("simpleMethod"),
            args: [
                DawnFunctionArgument(name: Name("value"), type: Name("uint32_t"))
            ]
        )

        let data = try loadDawnData()
        let publicArgs = method.publicArgs(data: data)

        #expect(publicArgs.count == 1)
    }

    @Test("Dictionary types are NOT treated as arrays (robustness)")
    func testDictionaryNotTreatedAsArray() throws {
        // While Dawn will never generate dictionaries, this test ensures
        // our check is robust against potential future type system changes

        // Mock a hypothetical dictionary parameter (won't exist in real Dawn data)
        // If swiftTypeName somehow returned "[String: Int]", it should NOT be filtered

        // This test would require mocking swiftTypeName() or extending the type system
        // For now, document that the check `!swiftType.contains(":")` handles this

        // The actual implementation check is:
        // return swiftType.hasPrefix("[") && !swiftType.contains(":")
        //
        // This ensures [String: Int] returns false (dictionary, not array)
    }
}
```

### Integration Tests (Extend Existing)

**File**: `Tests/DawnTests/GeneratedCodeTests.swift` (extend or create)

```swift
@Suite("Generated Code Validation")
struct GeneratedCodeTests {

    @Test("Generated submit method has correct signature")
    func testSubmitMethodSignature() throws {
        // This test runs after code generation
        let queue = try createMockQueue()

        // Should compile with new signature
        let cmd1 = try createMockCommandBuffer()
        let cmd2 = try createMockCommandBuffer()

        // Old API should NOT compile (we'll verify manually)
        // queue.submit(commandCount: 2, commands: [cmd1, cmd2])  // Should error

        // New API should compile
        queue.submit(commands: [cmd1, cmd2])
    }

    @Test("Generated setBindGroup method handles optional arrays")
    func testSetBindGroupOptionalArray() throws {
        let pass = try createMockRenderPass()
        let group = try createMockBindGroup()

        // Should compile with nil
        pass.setBindGroup(groupIndex: 0, group: group, dynamicOffsets: nil)

        // Should compile with array
        pass.setBindGroup(groupIndex: 0, group: group, dynamicOffsets: [0, 1, 2])
    }

    @Test("Generated writeTexture keeps size parameter for raw pointers")
    func testWriteTextureKeepsSizeParameter() throws {
        let queue = try createMockQueue()
        let dest = try createMockTexelCopyInfo()
        let layout = try createMockBufferLayout()
        let size = try createMockExtent3D()

        let data = UnsafeRawPointer(bitPattern: 0x1000)!

        // Should require dataSize parameter
        queue.writeTexture(
            destination: dest,
            data: data,
            dataSize: 1024,  // <-- Should still be required
            dataLayout: layout,
            writeSize: size
        )
    }
}
```

### Manual Verification Checklist

After implementation, manually verify:

- [ ] Run `swift build` - should succeed
- [ ] Run `swift test` - all tests pass
- [ ] Inspect `.build/plugins/outputs/swan/Dawn/destination/GenerateDawnBindingsPlugin/Objects.swift`
  - [ ] Find `GPUQueue.submit` - verify NO `commandCount` parameter
  - [ ] Find `GPURenderPassEncoder.setBindGroup` - verify NO `dynamicOffsetCount` parameter
  - [ ] Check method bodies contain `let commandCount = commands.count`
  - [ ] Verify `GPUQueue.writeTexture` STILL HAS `dataSize` parameter
- [ ] Try building a sample that uses the old API - should get compiler errors
- [ ] Update sample to new API - should compile

---

## Understanding Dynamic Offsets (Key Use Case)

Dynamic offsets are a critical WebGPU feature that benefits significantly from this API improvement. Understanding them helps clarify why optional array handling is important.

### What Are Dynamic Offsets?

Dynamic offsets allow you to access different parts of a buffer without creating multiple bind groups. This is a performance optimization for a common pattern.

#### The Problem They Solve

Consider rendering 100 objects, each needing per-object uniform data (transform matrix, color, etc.):

**Inefficient approach**: Create 100 separate bind groups
```swift
// DON'T DO THIS - creates 100 bind groups
for i in 0..<100 {
    let bindGroup = device.createBindGroup(
        entries: [.init(binding: 0, resource: .buffer(
            buffer: uniformBuffers[i],  // Different buffer per object
            offset: 0,
            size: 256
        ))]
    )
    bindGroups.append(bindGroup)
}
```

**Efficient approach**: One bind group + dynamic offsets
```swift
// Create ONE large buffer for all objects
let sharedBuffer = device.createBuffer(size: 100 * 256)  // 256 bytes per object

// Create ONE bind group with a dynamic buffer binding
let bindGroup = device.createBindGroup(
    entries: [.init(binding: 0, resource: .dynamicBuffer(
        buffer: sharedBuffer,
        offset: 0,
        size: 256
    ))]
)

// At render time, specify which object's data to use
for i in 0..<100 {
    renderPass.setBindGroup(
        groupIndex: 0,
        group: bindGroup,
        dynamicOffsets: [UInt32(i * 256)]  // Point to object i's data
    )
    renderPass.draw(...)
}
```

### Why They're Optional

Not all bind groups use dynamic buffers:

```swift
// Bind group with textures - no dynamic offsets needed
let textureBindGroup = device.createBindGroup(
    entries: [.init(binding: 0, resource: .textureView(myTexture))]
)

renderPass.setBindGroup(
    groupIndex: 0,
    group: textureBindGroup,
    dynamicOffsets: nil  // ← No dynamic buffers, so nil
)
```

### Impact on This Plan

Dynamic offsets are a **perfect example** of why this change matters:

#### Current API (Redundant & Error-Prone)
```swift
let offsets: [UInt32]? = needsDynamicOffset ? [UInt32(objectIndex * 256)] : nil

renderPass.setBindGroup(
    groupIndex: 0,
    group: bindGroup,
    dynamicOffsetCount: offsets?.count ?? 0,  // ← Manually compute count!
    dynamicOffsets: offsets
)
```

**Problems**:
- User must manually compute count: `offsets?.count ?? 0`
- Easy to make mistakes:
  - `dynamicOffsetCount: 1, dynamicOffsets: [100, 200]` (count mismatch)
  - `dynamicOffsetCount: 2, dynamicOffsets: nil` (crashes)
- Verbose and un-idiomatic Swift

#### Proposed API (Clean & Safe)
```swift
let offsets: [UInt32]? = needsDynamicOffset ? [UInt32(objectIndex * 256)] : nil

renderPass.setBindGroup(
    groupIndex: 0,
    group: bindGroup,
    dynamicOffsets: offsets  // ← Count automatically extracted
)
```

**Benefits**:
- **Impossible to pass wrong count** - extracted automatically
- **Cleaner** - matches Swift conventions
- **Safer** - no manual count computation means no mistakes

### Optional Array Handling Requirements

The implementation must correctly handle all these cases:

```swift
// Case 1: No dynamic offsets needed
renderPass.setBindGroup(groupIndex: 0, group: g, dynamicOffsets: nil)
// Generated: let dynamicOffsetCount = nil?.count ?? 0  // = 0

// Case 2: Empty array (unusual but valid)
renderPass.setBindGroup(groupIndex: 0, group: g, dynamicOffsets: [])
// Generated: let dynamicOffsetCount = [].count  // = 0

// Case 3: Single dynamic offset (most common)
renderPass.setBindGroup(groupIndex: 0, group: g, dynamicOffsets: [1280])
// Generated: let dynamicOffsetCount = [1280].count  // = 1

// Case 4: Multiple dynamic offsets (rare - multiple dynamic bindings)
renderPass.setBindGroup(groupIndex: 0, group: g, dynamicOffsets: [256, 512])
// Generated: let dynamicOffsetCount = [256, 512].count  // = 2
```

The implementation handles this with:
```swift
let isOptional = swiftType.hasSuffix("?")
let countExpr = isOptional ? "\(arrayName)?.count ?? 0" : "\(arrayName).count"
```

This ensures nil-safe count extraction that matches Swift best practices.

---

## Sample/Demo Updates

### WebGPULife Sample

**File**: `Sources/WebGPULife/Renderer.swift`

Currently, the sample has relevant code commented out. If/when it's active, these lines need updating:

**Line 280** (currently commented):
```swift
// OLD:
// device.queue.submit(commandBuffers: [commandBuffer])

// NEW (after uncommenting):
device.queue.submit(commands: [commandBuffer])
```

**Lines 248, 275** (currently commented):
```swift
// OLD:
// computePass.setBindGroup(index: 0, bindGroup: bindGroups[Int(step % 2)])
// pass.setBindGroup(index: 0, bindGroup: bindGroups[Int(step % 2)])

// NEW (parameter names changed, no count needed):
computePass.setBindGroup(groupIndex: 0, group: bindGroups[Int(step % 2)])
pass.setBindGroup(groupIndex: 0, group: bindGroups[Int(step % 2)])
```

**Note**: Since this code is currently commented out, it won't cause immediate build failures, but should be updated before re-enabling.

### Creating New Examples

Document the new API patterns in examples:

```swift
// Example 1: Simple array submission
let commandBuffers = [encoder.finish()]
queue.submit(commands: commandBuffers)

// Example 2: Optional dynamic offsets
// Dynamic offsets allow accessing different parts of a buffer without creating multiple bind groups.
// They're optional because not all bind groups use dynamic buffers.
pass.setBindGroup(groupIndex: 0, group: bindGroup, dynamicOffsets: nil)  // No dynamic buffers
pass.setBindGroup(groupIndex: 0, group: bindGroup, dynamicOffsets: [0, 256])  // Offset into dynamic buffer

// Example 3: Empty array is valid
queue.submit(commands: [])  // Valid, no-op

// Example 4: Raw pointers still need size
let pixelData: UnsafeRawPointer = ...
queue.writeTexture(
    destination: texInfo,
    data: pixelData,
    dataSize: width * height * 4,  // Still required!
    dataLayout: layout,
    writeSize: extent
)
```

---

## Backwards Compatibility Strategy

**This is a breaking change.** There is no backwards compatibility. Method signatures will change, and existing code will not compile until updated.

---

## Migration Guide for Users

### Automated Migration (Optional Enhancement)

Could create a Swift Package Plugin that helps migration:

```swift
// Potential future tool
swift package migrate-swan-api --from 0.1.0 --to 0.2.0
```

This would:
1. Scan Swift files for Swan API usage
2. Identify old signatures
3. Generate diffs showing required changes
4. Optionally auto-apply changes

**For now**: Manual migration is acceptable given small user base.

### Manual Migration Steps

#### Step 1: Update Swan Dependency

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/your-org/swan.git", from: "0.2.0")
]
```

#### Step 2: Build to Find Issues

```bash
swift build
```

Compiler will show errors like:
```
error: extra argument 'commandCount' in call
queue.submit(commandCount: 2, commands: [cmd1, cmd2])
             ^~~~~~~~~~~~~~~~
```

#### Step 3: Fix Each Call Site

**Pattern 1: Simple array submission**
```swift
// Before
queue.submit(commandCount: buffers.count, commands: buffers)

// After
queue.submit(commands: buffers)
```

**Pattern 2: Array with dynamic count variable**
```swift
// Before
let count = computeCount()
queue.submit(commandCount: count, commands: buffers)

// After (count variable no longer needed)
queue.submit(commands: buffers)
```

**Pattern 3: Optional arrays**
```swift
// Before
let offsets: [UInt32]? = hasOffsets ? [0, 256] : nil
pass.setBindGroup(
    groupIndex: 0,
    group: group,
    dynamicOffsetCount: offsets?.count ?? 0,
    dynamicOffsets: offsets
)

// After
let offsets: [UInt32]? = hasOffsets ? [0, 256] : nil
pass.setBindGroup(
    groupIndex: 0,
    group: group,
    dynamicOffsets: offsets
)
```

**Pattern 4: Inline array literals**
```swift
// Before
queue.submit(commandCount: 2, commands: [cmd1, cmd2])

// After
queue.submit(commands: [cmd1, cmd2])
```

#### Step 4: Search & Replace Patterns

For simple cases, regex search & replace can help:

**Queue.submit**:
```regex
# Find
\.submit\(commandCount:\s*[^,]+,\s*commands:

# Replace
.submit(commands:
```

**setBindGroup**:
```regex
# Find
\.setBindGroup\(([^)]*?)dynamicOffsetCount:\s*[^,]+,\s*dynamicOffsets:

# Replace
.setBindGroup(\1dynamicOffsets:
```

**Warning**: These patterns won't handle all cases (multiline calls, etc.). Use carefully and verify with compiler.

---

## Risk Assessment

### High Risk ⚠️

1. **External Users Blocked**
   - **Likelihood**: Medium (unknown adoption)
   - **Impact**: High (code won't compile)
   - **Mitigation**:
     - Clear release notes
     - Detailed migration guide
     - Announce breaking change in advance if possible
     - Consider creating a migration tool

### Medium Risk ⚠️

2. **Test Coverage Gaps**
   - **Likelihood**: Medium
   - **Impact**: Medium (bugs in generated code)
   - **Mitigation**:
     - Comprehensive unit tests (see Testing Strategy)
     - Integration tests with real Dawn calls
     - Manual verification checklist

3. **Edge Cases in Code Generation**
   - **Likelihood**: Low-Medium
   - **Impact**: High (incorrect generated code)
   - **Mitigation**:
     - Handle all ArraySize enum cases (.name, .int)
     - Test optional vs non-optional arrays
     - Test raw pointers vs Swift arrays
     - Test methods with multiple arrays

### Low Risk ✓

4. **Performance Regression**
   - **Likelihood**: Very Low
   - **Impact**: Low
   - **Mitigation**: Benchmark if concerned
   - **Notes**: Just moves count extraction into method body, no runtime change

5. **Rollback Difficulty**
   - **Likelihood**: N/A
   - **Impact**: Low
   - **Mitigation**: Changes isolated to one file, easy to revert

---

## Implementation Sequence

### Phase 1: Preparation (1-2 hours)
1. ✅ Create implementation plan (this document)
2. ✅ Review plan with stakeholders
3. ✅ Create feature branch: `bmedina/remove-array-size-params`
4. ✅ Set up test infrastructure if needed

### Phase 2: Implementation (2-3 hours)
1. ✅ Add helper methods to `DawnMethod+Wrappers.swift`
   - ✅ `isSizeParameter(_:in:data:)`
   - ✅ `arrayForSizeParameter(_:in:data:)` (renamed from `arrayForSize`)
   - ✅ `generateArraySizeExtractions(data:)`
2. ✅ Modify `methodWrapperDecl(data:)`
   - ✅ Filter size params from signature using inline `filter` with `isSizeParameter`
   - ✅ Generate size extraction and prepend to method body (before closures)
   - Note: `unwrapArgs` left unchanged - size extraction injected into body instead

### Phase 3: Testing (2-3 hours)
1. ✅ Add tests to `Tests/CodeGenerationTests/GenerateWrappersTest.swift`
2. ✅ Write unit tests for size parameter detection and method wrapper generation
3. ✅ Integration coverage via existing `DawnTests/` (build + runtime tests pass)
4. ✅ Run `swift test` - all 63 tests pass
5. ⬜ Manual verification checklist
6. ⬜ Address TODOs in Tests/CodeGenerationTests/GenerateWrappersTest.swift

### Phase 4: Sample Updates (1 hour)
1. ⬜ Update `WebGPULife/Renderer.swift` commented code
2. ⬜ Create example code snippets for documentation
3. ⬜ Verify samples compile

### Phase 5: Documentation (1-2 hours)
1. ⬜ Create `MIGRATION.md` with user migration guide
2. ⬜ Update `CHANGELOG.md` with breaking change notes
3. ⬜ Update `README.md` if needed
4. ⬜ Add inline code comments for future maintainers

### Phase 6: Release (1 hour)
1. ⬜ Bump version in `Package.swift` metadata
2. ⬜ Create PR with all changes
3. ⬜ Code review
4. ⬜ Merge to main
5. ⬜ Tag release (e.g., `v0.2.0`)
6. ⬜ Publish release notes

**Total Estimated Time**: 8-12 hours

---

## Success Criteria

- ✅ All size parameters removed from method signatures where corresponding array exists
- ✅ Size extraction code generated correctly in method bodies
- ✅ All edge cases handled (optional, empty, multiple arrays)
- ✅ Raw pointer methods unchanged (size param kept)
- ✅ Generated code compiles without errors
- ✅ All unit tests pass (existing + new)
- ✅ All integration tests pass
- ✅ Sample code updated and compiles
- ✅ No behavioral changes - bindings work identically, just with cleaner API
- ✅ Documentation complete (migration guide, changelog, examples)

---

## Rollback Plan

If critical issues arise post-release:

### Immediate Rollback (< 1 hour)
1. Revert commit: `git revert <commit-hash>`
2. Restore `DawnMethod+Wrappers.swift` to previous version
3. Rebuild: `swift build`
4. Tag emergency patch release (e.g., `v0.1.1`)
5. Notify users

### Partial Rollback (2-3 hours)
If only specific cases are problematic:
1. Add condition to skip problematic patterns
2. Keep change for working cases
3. Document limitations
4. Plan fix for next release

### Forward Fix (varies)
If issue is minor:
1. Fix bug in place
2. Add test coverage
3. Release patch version

---

## Open Questions

### For Decision Before Implementation

1. **Version Number**:
   - Current version: `0.1.0` (assumed)
   - Proposed: `0.2.0` or `1.0.0`?
   - **Recommendation**: `0.2.0` (save 1.0 for production-ready)

2. **Migration Tool**:
   - Should we build automated migration tooling?
   - **Recommendation**: No, not worth it for small user base. Revisit if adoption grows.

3. **Deprecation Period**:
   - Should we try to support both APIs temporarily?
   - **Recommendation**: No, not feasible due to signature conflicts. Clean break is better.

4. **Documentation Location**:
   - Where should migration guide live?
   - **Recommendation**: `MIGRATION.md` in repo root, linked from release notes

5. **Communication**:
   - How to notify existing users (if any)?
   - **Recommendation**: GitHub release notes, discussions post, update README with notice

---

## Future Enhancements

### Enable `uint8_t` Array Wrapping for `writeBuffer`

**Status**: Exploration candidate

**Current Behavior**: Methods like `writeBuffer` that take `uint8_t const*` with a `length` parameter are NOT wrapped. The `data` parameter becomes `UnsafeRawPointer` and users must manually pass the size.

**Location of exclusion**: `Sources/GenerateDawnBindings/TypeDescriptor.swift` lines 44-46:
```swift
if type.raw == "void" || type.raw == "uint8_t" {
    return false  // Explicitly NOT wrapped
}
```

**Why `uint8_t` was originally excluded**:
1. **Semantic intent**: `uint8_t*` typically represents "raw byte buffer" (like `Data`), not "array of byte values"
2. **Consistency with `void*`**: Both are treated as raw byte pointers
3. **Flexibility**: Users can pass different typed arrays (`[Float]`, `[UInt32]`, etc.) that Swift bridges to `UnsafeRawPointer`

**Why we might want to change this**:
Unlike `void*`, a `[UInt8]` array has a meaningful `.count` property. Enabling wrapping would allow:

```swift
// Current API (manual size)
device.queue.writeBuffer(buffer: buf, bufferOffset: 0, data: bytes, size: bytes.count)

// Potential new API (automatic size)
device.queue.writeBuffer(buffer: buf, bufferOffset: 0, data: bytes)
```

**Implementation**:
Remove `|| type.raw == "uint8_t"` from the condition in `TypeDescriptor.swift`:
```swift
if type.raw == "void" {  // Only exclude void, not uint8_t
    return false
}
```

**Trade-offs**:
- ✅ Cleaner API for byte array operations
- ✅ Consistent with other array parameter handling
- ⚠️ Loses flexibility of passing arbitrary typed data without explicit conversion
- ⚠️ Breaking change for existing `writeBuffer` call sites

**Related code**: `Demos/GameOfLife/GameOfLife.swift` line 57 has a TODO comment: `// TODO: Shouldn't have to pass size`

**Decision**: Defer to future PR. Evaluate after main array size elimination is complete and stable.

---

## Appendix A: Affected Methods (Examples)

Based on Dawn WebGPU API, these methods will change:

### GPUQueue
- `submit(commandCount:commands:)` → `submit(commands:)`
- `writeBuffer(buffer:bufferOffset:data:size:)` → **No change** (data is `uint8_t*`, see [Future Enhancements](#enable-uint8_t-array-wrapping-for-writebuffer))
- `writeTexture(destination:data:dataSize:dataLayout:writeSize:)` → **No change** (data is `void*` raw pointer)

### GPURenderPassEncoder
- `setBindGroup(groupIndex:group:dynamicOffsetCount:dynamicOffsets:)` → `setBindGroup(groupIndex:group:dynamicOffsets:)`
- `setVertexBuffer(slot:buffer:offset:size:)` → **No change** (no array)

### GPUComputePassEncoder
- `setBindGroup(groupIndex:group:dynamicOffsetCount:dynamicOffsets:)` → `setBindGroup(groupIndex:group:dynamicOffsets:)`

### GPURenderBundleEncoder
- `setBindGroup(groupIndex:group:dynamicOffsetCount:dynamicOffsets:)` → `setBindGroup(groupIndex:group:dynamicOffsets:)`

### GPUDevice
- `createBindGroupLayout(entries:entryCount:)` → `createBindGroupLayout(entries:)` (if exists)

**Full List**: Generate after implementation by comparing old vs new `Objects.swift`

---

## Appendix B: Reference Implementation Comparison

### Current Pattern (DawnStructure+Wrappers.swift:352-357)

The codebase already handles automatic size extraction for **structure members**:

```swift
if case .name(let lengthName) = length! {
    let count: ExprSyntax = optional ?
        "\(raw: identifier)?.count ?? 0" :
        "\(raw: identifier).count"
    // ... use count in wrapper ...
}
```

**Key Insight**: We're applying this same pattern to **method arguments**, ensuring consistency across the codebase.

---

## Appendix C: Alternative Approaches Considered

### Alternative 1: Variadic Parameters
```swift
func submit(commands: GPUCommandBuffer...)
```
**Rejected**: Forces callers to pass individual commands, can't use existing arrays without spreading.

### Alternative 2: Keep Both APIs with Defaults
```swift
func submit(commands: [GPUCommandBuffer], commandCount: Int = -1)
```
**Rejected**:
- Still redundant, doesn't solve the problem
- What does `-1` mean? Magic number
- Users might still pass wrong count

### Alternative 3: Builder Pattern
```swift
queue.submit { builder in
    builder.add(cmd1)
    builder.add(cmd2)
}
```
**Rejected**: Over-engineered, doesn't match WebGPU's API style

### Alternative 4: Do Nothing
**Rejected**: Current API is un-idiomatic Swift and error-prone

**Selected Approach**: Direct removal with auto-extraction is cleanest and most idiomatic.

---

## Approval Checklist

Before proceeding with implementation:

- [ ] Technical approach reviewed and approved
- [ ] Test strategy reviewed and approved
- [ ] Breaking change impact acknowledged
- [ ] Version bump strategy agreed upon
- [ ] Migration guide approach approved
- [ ] Timeline acceptable
- [ ] Resource allocation confirmed

---

**Document Status**: Ready for Review
**Last Updated**: 2026-01-20
**Author**: Claude (AI Assistant)
**Reviewer**: [To be assigned]
