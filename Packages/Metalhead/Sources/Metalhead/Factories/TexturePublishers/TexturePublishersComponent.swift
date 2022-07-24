import NeedleFoundation
import AVFoundation
import Combine

public protocol TexturePublishersComponentDependency: Dependency {
  var pixelFormat: PixelFormat { get }
}

public final class TexturePublishersComponent: Component<TexturePublishersComponentDependency> {
  
  private lazy var texturesFactoryComponent = TexturesFactoryComponent(parent: self)
  
  public var cameraTexturePublisher: AnyPublisher<MTLTexture, Error> {
    shared {
      AVCaptureDevice
        .videoPermissionRequest
        .receive(on: DispatchQueue.global())
        .flatMap { [unowned self] in AVCaptureSessionPublisher(pixelFormat: dependency.pixelFormat).share() }
        .tryMap { [unowned self] in try texturesFactoryComponent.texturesFactory.createTexture(from: $0) }
        .share()
        .eraseToAnyPublisher()
    }
  }
  
  public func staticImageTexturePublisher(from image: Image) -> AnyPublisher<MTLTexture, Error> {
    Just(image)
      .tryCompactMap { [unowned self] image in try texturesFactoryComponent.texturesFactory.createTexture(from: image) }
      .eraseToAnyPublisher()
  }
  
  public func staticImageTexturePublisher(from texture: MTLTexture) -> AnyPublisher<MTLTexture, Never> {
    Just(texture)
      .eraseToAnyPublisher()
  }
}
