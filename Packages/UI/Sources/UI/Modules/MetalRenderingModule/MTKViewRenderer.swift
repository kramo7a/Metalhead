import MetalKit
import Foundation
import AVFoundation
import Metalhead
import CoreVideo
import Metal
import SwiftUI
import Combine
import Alloy

public final class MTKViewRenderer: NSObject, MTKViewDelegate {
  
  private let performer: MetalPerformer
  private let metalDevice: MTLDevice
  private let commandQueue: MTLCommandQueue?
  @Published private var shaders: [Metalhead.Shader] = []
  
  var errorsObservable: ErrorsObservable?
  
  @Published private var inputTexture: MTLTexture? = nil
  private var cancellables = Set<AnyCancellable>()
  
  init(
    performer: MetalPerformer,
    metalDevice: MTLDevice,
    inputTexture: AnyPublisher<MTLTexture, Never>,
    shaders: AnyPublisher<[Metalhead.Shader], Never>
  ) {
    self.performer = performer
    self.metalDevice = metalDevice
    self.commandQueue = metalDevice.makeCommandQueue()
    
    super.init()
    
    shaders.assign(to: &$shaders)
    inputTexture
      .asOptional
      .assign(to: &$inputTexture)
  }
  
  // MARK: - MTKViewDelegate
  
  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
  
  public func draw(in view: MTKView) {
    guard
      let commandBuffer = commandQueue?.makeCommandBuffer(),
      let currentDrawable = view.currentDrawable,
      let inputTexture,
      !shaders.isEmpty
    else { return }
    
    do {
      try performer.perform(
        shaders: &shaders,
        commandBuffer: commandBuffer,
        outputTexture: currentDrawable.texture,
        inputTexture: inputTexture
      )
    } catch {
      errorsObservable?.set(error: error)
    }
    
    commandBuffer.present(currentDrawable)
    commandBuffer.commit()
  }
}
