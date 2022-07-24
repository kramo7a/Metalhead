import SwiftUI
import Metalhead
import MetalKit
import Combine

public struct MTKViewRepresantable: ViewRepresentable {
  
  @EnvironmentObject var errorsObservable: ErrorsObservable
  
  public typealias NSViewType = MTKView
  
  private let renderer: MTKViewRenderer
  private let metalDevice: MTLDevice
  
  init(
    renderer: MTKViewRenderer,
    metalDevice: MTLDevice
  ) {
    self.renderer = renderer
    self.metalDevice = metalDevice
  }
  
  public func makeCoordinator() -> MTKViewRenderer {
    renderer.errorsObservable = errorsObservable
    return renderer
  }
  
  public func makeUIView(context: ViewRepresentableContext<MTKViewRepresantable>) -> MTKView { createMtkView(with: context) }
  public func makeNSView(context: ViewRepresentableContext<MTKViewRepresantable>) -> MTKView { createMtkView(with: context) }
  
  public func updateUIView(_ uiView: MTKView, context: ViewRepresentableContext<MTKViewRepresantable>) { }
  public func updateNSView(_ nsView: MTKView, context: ViewRepresentableContext<MTKViewRepresantable>) { }
  
  private func createMtkView(with context: ViewRepresentableContext<MTKViewRepresantable>) -> MTKView {
    let mtkView = MTKView()
    
    mtkView.delegate = context.coordinator
    mtkView.preferredFramesPerSecond = 120
    mtkView.enableSetNeedsDisplay = true
    mtkView.device = metalDevice
    mtkView.framebufferOnly = false
    mtkView.isPaused = false
    mtkView.colorPixelFormat = .bgra8Unorm
    
    return mtkView
  }
}
