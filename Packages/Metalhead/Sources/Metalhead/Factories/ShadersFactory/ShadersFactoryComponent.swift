import Metal
import Alloy
import NeedleFoundation
import Combine

public protocol ShadersFactoryDependency: Dependency {
  var context: MTLContext { get }
  var errorsObservable: ErrorsObservable { get }
}

public protocol ShadersFactoryBuilder {
  func shadersFactory(
    downscaleFactor: AnyPublisher<Int, Never>,
    frameSize: AnyPublisher<CGSize, Never>
  ) -> ShadersFactory
}

public final class ShadersFactoryComponent: Component<ShadersFactoryDependency>, ShadersFactoryBuilder {
  
  private lazy var texturesFactoryComponent = TexturesFactoryComponent(parent: self)
  
  public func shadersFactory(
    downscaleFactor: AnyPublisher<Int, Never>,
    frameSize: AnyPublisher<CGSize, Never>
  ) -> ShadersFactory {
    ShadersFactoryImpl(
      downscaleFactor: downscaleFactor,
      frameSize: frameSize,
      context: dependency.context,
      texturesFactory: texturesFactoryComponent.texturesFactory,
      errorsObservable: dependency.errorsObservable
    )
  }
}
