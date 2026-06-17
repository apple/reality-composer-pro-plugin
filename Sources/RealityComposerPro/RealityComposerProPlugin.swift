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

import RealityKit

/// A context object that registers custom components, entity actions, and systems with Reality Composer Pro.
///
/// Use the context during plugin setup to register your custom RealityKit components, entity actions,
/// and systems with Reality Composer Pro.
@available(macOS 26.4, iOS 27.0, visionOS 27.0, tvOS 27.0, *)
public protocol RealityComposerProContext {
    /// Registers a custom component type with Reality Composer Pro.
    ///
    /// - Parameter component: The component type to register.
    func registerComponent<ComponentType: Component & Codable>(_ component: ComponentType.Type)

    /// Registers a custom action type with Reality Composer Pro.
    ///
    /// - Parameter action: The entity action type to register.
    func registerAction<ActionType: EntityAction>(_ action: ActionType.Type)

    /// Registers a custom system with Reality Composer Pro.
    ///
    /// - Parameter system: The system type to register.
    func registerSystem(_ system: any System.Type)

    /// Registers a custom component type along with a default value.
    ///
    /// - Parameters:
    ///   - componentType: The component type to register.
    ///   - defaultValue: The default value for new instances of the component type.
    func registerComponent<ComponentType: Component & Codable>(_ componentType: ComponentType.Type, defaultValue: ComponentType)
}

/// The interface for Reality Composer Pro plugins.
///
/// Conform to this protocol to create a plugin that contributes custom RealityKit components,
/// entity actions, and systems. Implement the ``setup(context:)`` method to register your custom
/// types, and optionally implement ``shutdown()`` to perform cleanup when unloading.
///
/// For Reality Composer Pro to discover your plugin, you must define a public
/// `@_cdecl("createRealityComposerProPlugin")` function that returns the plugin instance
/// via ``passRetained()``:
///
/// ```swift
/// final class CustomComponentsPlugin: RealityComposerProPlugin {
///     func setup(context: any RealityComposerProContext) {
///         context.registerComponent(MyComponent.self)
///         context.registerSystem(MySystem.self)
///     }
/// }
///
/// @_cdecl("createRealityComposerProPlugin")
/// public func createRealityComposerProPlugin() -> UnsafeMutableRawPointer {
///     CustomComponentsPlugin().passRetained()
/// }
/// ```
@available(macOS 26.4, iOS 27.0, visionOS 27.0, tvOS 27.0, *)
public protocol RealityComposerProPlugin: AnyObject {
    /// Performs setup when Reality Composer Pro loads the plugin.
    ///
    /// Implement this method to register your custom components, entity actions, and systems
    /// with the provided context.
    ///
    /// - Parameter context: The Reality Composer Pro context for registering plugin types.
    func setup(context: any RealityComposerProContext)

    /// Performs cleanup when Reality Composer Pro unloads the plugin.
    ///
    /// Implement this method to perform any necessary cleanup.
    func shutdown()
}

@available(macOS 26.4, iOS 27.0, visionOS 27.0, tvOS 27.0, *)
extension RealityComposerProPlugin {
    /// Provides a default no-op implementation for plugins that don't need cleanup.
    public func shutdown() {}

    /// Creates a C-compatible opaque pointer from this plugin instance.
    ///
    /// Use this in your `@_cdecl("createRealityComposerProPlugin")` function to return the plugin instance
    /// to the host application.
    ///
    /// - Returns: An opaque pointer suitable for returning from `createRealityComposerProPlugin()`.
    public func passRetained() -> UnsafeMutableRawPointer {
        Unmanaged.passRetained(_RealityComposerProPluginBox(self)).toOpaque()
    }
}

/// A wrapper that carries a ``RealityComposerProPlugin`` instance through a C-compatible opaque pointer.
///
/// Don't use this type directly; it's an implementation detail of ``RealityComposerProPlugin/passRetained()``.
@available(macOS 26.4, iOS 27.0, visionOS 27.0, tvOS 27.0, *)
public final class _RealityComposerProPluginBox {
    /// The boxed plugin instance.
    public let plugin: any RealityComposerProPlugin
    /// Creates a box that retains the given plugin instance.
    public init(_ plugin: any RealityComposerProPlugin) {
        self.plugin = plugin
    }
}

/// Reality Composer Pro editor-state detection on `Scene`.
@available(macOS 26.4, iOS 27.0, visionOS 27.0, tvOS 27.0, *)
extension Scene {
    /// Represents the editor state of a ``Scene``.
    public enum EditorState: String {
        /// The user's app owns this hierarchy, not the editor.
        case none = ""
        /// This hierarchy lives in an editor Viewport where simulations aren't running.
        case viewport = "RCP - Viewport"
        /// This hierarchy lives in a currently paused Simulation view.
        case simulationPaused = "RCP - Simulation - Paused"
        /// This hierarchy lives in a currently playing Simulation view.
        case simulationPlaying = "RCP - Simulation - Playing"
        /// This hierarchy lives in a currently paused Preview view.
        case previewPaused = "RCP - Preview - Paused"
        /// This hierarchy lives in a currently playing Preview view.
        case previewPlaying = "RCP - Preview - Playing"
    }

    /// The editor state of the scene, derived from the Reality Composer Pro root entity.
    public var editorState: EditorState {
        #if os(macOS)
            if let n = self.anchors.first?.children.first?.name {
                return EditorState(rawValue: n) ?? .none
            }
        #endif
        return .none
    }
}
