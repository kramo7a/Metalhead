import NeedleFoundation
import Alloy
import MetalKit
import Metal

public protocol TexturesFactoryDependency: Dependency {
  var context: MTLContext { get }
  var pixelFormat: PixelFormat { get }
}

public final class TexturesFactoryComponent: Component<TexturesFactoryDependency> {
  
  private var textureLoader: MTKTextureLoader {
    MTKTextureLoader(device: dependency.context.device)
  }
  
  public var texturesFactory: TexturesFactory {
    get {
      shared {
        TexturesFactoryImpl(
          pixelFormat: dependency.pixelFormat,
          metalDevice: dependency.context.device,
          textureLoader: textureLoader
        )
      }
    }
  }
}
