import NeedleFoundation
import SwiftUI
import Metalhead
import Metal
import MetalKit
import Combine

public protocol MetalRenderingViewDependency: Dependency {
  var metalDevice: MTLDevice { get }
}

public protocol MetalRenderingBuilder {
  
  func mtkViewRepresantable(
    inputTexture: AnyPublisher<MTLTexture, Never>,
    shaders: AnyPublisher<[Metalhead.Shader], Never>
  ) -> MTKViewRepresantable
}

public final class MetalRenderingComponent: Component<MetalRenderingViewDependency>, MetalRenderingBuilder {
  
  private lazy var metalPerformerComponent: MetalPerformerComponent = MetalPerformerComponent(parent: self)
  
  private func mtkViewRenderer(
    inputTexture: AnyPublisher<MTLTexture, Never>,
    shaders: AnyPublisher<[Metalhead.Shader], Never>
  ) -> MTKViewRenderer {
    MTKViewRenderer(
      performer: metalPerformerComponent.metalPerformer,
      metalDevice: dependency.metalDevice,
      inputTexture: inputTexture,
      shaders: shaders
    )
  }
  
  public func mtkViewRepresantable(
    inputTexture: AnyPublisher<MTLTexture, Never>,
    shaders: AnyPublisher<[Metalhead.Shader], Never>
  ) -> MTKViewRepresantable {
    let renderer = mtkViewRenderer(
      inputTexture: inputTexture,
      shaders: shaders
    )
    return MTKViewRepresantable(renderer: renderer, metalDevice: dependency.metalDevice)
  }
}
