import Combine
import SwiftUI
import Metalhead

public class ShadersViewModel: ObservableObject {
  
  let inputTexture: AnyPublisher<MTLTexture, Never>
  
  @Published public var shaders: [Metalhead.Shader] = []
  @Published public var downscaleFactor = 1
  @Published public var frameSize = CGSize(width: 480, height: 320)
  
  public init(
    inputTexture: AnyPublisher<MTLTexture, Never>,
    shaders: [ShaderType],
    shadersFactoryBuilder: ShadersFactoryBuilder,
    errorsObservable: ErrorsObservable
  ) {
    self.inputTexture = inputTexture
    
    inputTexture
      .frameSize
      .assign(to: &$frameSize)
    
    let shadersFactory = shadersFactoryBuilder.shadersFactory(
      downscaleFactor: $downscaleFactor.eraseToAnyPublisher(),
      frameSize: $frameSize.eraseToAnyPublisher()
    )
    
    do {
      self.shaders = try shaders.map { try shadersFactory.shader(of: $0) }
    } catch {
      errorsObservable.set(error: error)
      self.shaders = []
    }
  }
}
