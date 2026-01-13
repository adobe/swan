# Swan

---

## ⚠️ WARNINGS

> [!WARNING]
> **This project is not ready for use.** It is currently under development and intended only for feedback and experimentation.

> [!IMPORTANT]
> **Swift Requirement:** You must use a recent mainline build of Swift. This project may not work with released versions of Swift.

---

## Swift WebGPU Bindings for Dawn and Web

A set of Swift APIs for using WebGPU across multiple platforms.

## Goals

The goal is to be able to write GPU code, using Swift, that works everywhere, including
(eventually) the web.

The initial implementation is a Swift binding to Google's Dawn library.

## Non-Goals

Swan is not intended to be a full rendering engine. It does not provide any rendering
primitives beyond what is in WebGPU spec. For example, we do not specify a 4x4 matrix
implementation, although we may use one in our examples.

### Quick Start

The following snippet shows how to add Swan to your Swift package:

```swift
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/adobe/swan", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "Logging", package: "swan")
            ]
        )
    ]
)
```

### Usage

You can run the demo by:

```sh
swift run GameOfLife
```

### Updating Dawn

More docs to come...

```sh
swift package plugin --allow-writing-to-package-directory generate-dawn-apinotes
```

### Alternatives

- [swift-webgpu](https://github.com/henrybetts/swift-webgpu) is another binding
  for WebGPU that takes a different approach.

  |                               | swift-webgpu                                         | swift-wgpu (this project)                                                                           |
  | ----------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
  | Dawn binding generation       | Swift code generated from dawn.json acts as wrappers | C headers from Dawn are used directly in conjunction with an apinotes file generated from dawn.json |
  | JavaScript binding generation | N/A                                                  | In progress                                                                                         |

### Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

### Licensing

This project is licensed under the BSD 3-Clause License. See [LICENSE](LICENSE) for more information.
