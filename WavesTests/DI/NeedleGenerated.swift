

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
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->MetalPerformerComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->TexturePublishersComponent") { component in
        return TexturePublishersComponentDependency7283ae779a3ad7d1c6b6Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->TexturePublishersComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependency57f0f43ad5ce7eb822faProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->ShadersFactoryComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependency752ee5f84fd7b1116426Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->TexturesFactoryComponent") { component in
        return TexturesFactoryDependencyfc4219eb645a74fd068eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent->ShadersFactoryComponent") { component in
        return ShadersFactoryDependency176316a3e0fd85f35be3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->TestsRootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

private class TexturePublishersComponentDependency7283ae779a3ad7d1c6b6BaseProvider: TexturePublishersComponentDependency {
    var pixelFormat: PixelFormat {
        return testsRootComponent.pixelFormat
    }
    private let testsRootComponent: TestsRootComponent
    init(testsRootComponent: TestsRootComponent) {
        self.testsRootComponent = testsRootComponent
    }
}
/// ^->TestsRootComponent->TexturePublishersComponent
private class TexturePublishersComponentDependency7283ae779a3ad7d1c6b6Provider: TexturePublishersComponentDependency7283ae779a3ad7d1c6b6BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(testsRootComponent: component.parent as! TestsRootComponent)
    }
}
private class TexturesFactoryDependency57f0f43ad5ce7eb822faBaseProvider: TexturesFactoryDependency {
    var context: MTLContext {
        return testsRootComponent.context
    }
    var pixelFormat: PixelFormat {
        return testsRootComponent.pixelFormat
    }
    private let testsRootComponent: TestsRootComponent
    init(testsRootComponent: TestsRootComponent) {
        self.testsRootComponent = testsRootComponent
    }
}
/// ^->TestsRootComponent->TexturePublishersComponent->TexturesFactoryComponent
private class TexturesFactoryDependency57f0f43ad5ce7eb822faProvider: TexturesFactoryDependency57f0f43ad5ce7eb822faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(testsRootComponent: component.parent.parent as! TestsRootComponent)
    }
}
/// ^->TestsRootComponent->ShadersFactoryComponent->TexturesFactoryComponent
private class TexturesFactoryDependency752ee5f84fd7b1116426Provider: TexturesFactoryDependency57f0f43ad5ce7eb822faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(testsRootComponent: component.parent.parent as! TestsRootComponent)
    }
}
/// ^->TestsRootComponent->TexturesFactoryComponent
private class TexturesFactoryDependencyfc4219eb645a74fd068eProvider: TexturesFactoryDependency57f0f43ad5ce7eb822faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(testsRootComponent: component.parent as! TestsRootComponent)
    }
}
private class ShadersFactoryDependency176316a3e0fd85f35be3BaseProvider: ShadersFactoryDependency {
    var context: MTLContext {
        return testsRootComponent.context
    }
    var errorsObservable: ErrorsObservable {
        return testsRootComponent.errorsObservable
    }
    private let testsRootComponent: TestsRootComponent
    init(testsRootComponent: TestsRootComponent) {
        self.testsRootComponent = testsRootComponent
    }
}
/// ^->TestsRootComponent->ShadersFactoryComponent
private class ShadersFactoryDependency176316a3e0fd85f35be3Provider: ShadersFactoryDependency176316a3e0fd85f35be3BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(testsRootComponent: component.parent as! TestsRootComponent)
    }
}
