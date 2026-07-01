// swift-tools-version: 6.2

//===----------------------------------------------------------------------===//
//
// This source file is part of the RealityComposerPro Plugin Interface open source project
//
// Copyright (c) 2026 Apple Inc.
// Licensed under MIT License
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "RealityComposerPro",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "RealityComposerPro",
            targets: ["RealityComposerPro"]
        ),
    ],
    targets: [
        .target(
            name: "RealityComposerPro"
        ),
    ],
    swiftLanguageModes: [.v6]
)
