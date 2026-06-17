# RealityComposerPro Plugin Interface

A Swift package that provides the protocol-based API for building plugins for Reality Composer Pro, an editor for RealityKit content built by Apple.

Plugins extend Reality Composer Pro with custom RealityKit components, entity actions, and systems.

> Beta Notice: This package is currently in beta. The public API is not yet stable and may change before the final release. We welcome bug reports and feedback via GitHub Issues, but are not accepting pull requests at this time.

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "<this repo>", from: "1.0.0"),
],
```

Then add `"RealityComposerPro"` as a dependency of your plugin target.

## Creating a Plugin

Conform to `RealityComposerProPlugin` and register your custom types in `setup(context:)`:

```swift
import RealityComposerPro

final class MyPlugin: RealityComposerProPlugin {
    func setup(context: any RealityComposerProContext) {
        context.registerComponent(MyComponent.self)
        context.registerSystem(MySystem.self)
        context.registerAction(MyAction.self)
    }
}
```

Expose a C entry point so Reality Composer Pro can discover and load the plugin:

```swift
@_cdecl("createRealityComposerProPlugin")
public func createRealityComposerProPlugin() -> UnsafeMutableRawPointer {
    MyPlugin().passRetained()
}
```

## License

RealityComposerPro Plugin Interface is released under the MIT license. See [LICENSE](LICENSE) for details.
