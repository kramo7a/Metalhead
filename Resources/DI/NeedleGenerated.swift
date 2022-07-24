

import AVFoundation
import Alloy
import Combine
import Metal
import MetalKit
import Metalhead
import NeedleFoundation
import SwiftUI
import UI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MetalRenderingComponent") { component in
        return MetalRenderingViewDependency9615344b44501b3785ecProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->MetalRenderingComponent->MetalPerformerComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->TexturePublishersComponent") { component in
        return TexturePublishersComponentDependency31712389b86f71594e56Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependency12ef9edf91296b3b0a7bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->TexturePublishersComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependency1f42e23286d928bd7ee8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->ShadersFactoryComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependencya1a740a71cb45e80b38dProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->ShadersFactoryComponent") { component in
        return ShadersFactoryDependency67283343ae43a4c67bfdProvider(component: component)
    }
    
}

// MARK: - Providers

private class MetalRenderingViewDependency9615344b44501b3785ecBaseProvider: MetalRenderingViewDependency {
    var metalDevice: MTLDevice {
        return rootComponent.metalDevice
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->MetalRenderingComponent
private class MetalRenderingViewDependency9615344b44501b3785ecProvider: MetalRenderingViewDependency9615344b44501b3785ecBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
private class TexturePublishersComponentDependency31712389b86f71594e56BaseProvider: TexturePublishersComponentDependency {
    var pixelFormat: PixelFormat {
        return rootComponent.pixelFormat
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->TexturePublishersComponent
private class TexturePublishersComponentDependency31712389b86f71594e56Provider: TexturePublishersComponentDependency31712389b86f71594e56BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
private class TexturesFactoryDependency12ef9edf91296b3b0a7bBaseProvider: TexturesFactoryDependency {
    var context: MTLContext {
        return rootComponent.context
    }
    var pixelFormat: PixelFormat {
        return rootComponent.pixelFormat
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->TexturesFactoryComponent
private class TexturesFactoryDependency12ef9edf91296b3b0a7bProvider: TexturesFactoryDependency12ef9edf91296b3b0a7bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
/// ^->RootComponent->TexturePublishersComponent->TexturesFactoryComponent
private class TexturesFactoryDependency1f42e23286d928bd7ee8Provider: TexturesFactoryDependency12ef9edf91296b3b0a7bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent as! RootComponent)
    }
}
/// ^->RootComponent->ShadersFactoryComponent->TexturesFactoryComponent
private class TexturesFactoryDependencya1a740a71cb45e80b38dProvider: TexturesFactoryDependency12ef9edf91296b3b0a7bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent.parent as! RootComponent)
    }
}
private class ShadersFactoryDependency67283343ae43a4c67bfdBaseProvider: ShadersFactoryDependency {
    var context: MTLContext {
        return rootComponent.context
    }
    var errorsObservable: ErrorsObservable {
        return rootComponent.errorsObservable
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ShadersFactoryComponent
private class ShadersFactoryDependency67283343ae43a4c67bfdProvider: ShadersFactoryDependency67283343ae43a4c67bfdBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
