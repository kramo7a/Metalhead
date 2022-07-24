import MetalKit
import Foundation
import AVFoundation
import CoreVideo
import Metal
import Combine
import Alloy

public protocol MetalPerformer {
  func perform(
    shaders: inout [Metalhead.Shader],
    commandBuffer: MTLCommandBuffer,
    outputTexture: MTLTexture,
    inputTexture: MTLTexture?
  ) throws
}

public class MetalPerformerImpl: MetalPerformer {
  
  init() { }
  
  public func perform(
    shaders: inout [Metalhead.Shader],
    commandBuffer: MTLCommandBuffer,
    outputTexture: MTLTexture,
    inputTexture: MTLTexture?
  ) throws {
    shaders.first?.inputTexture = inputTexture
    
    if shaders.count > 1 {
      for i in 0..<shaders.count - 1 {
        shaders[i + 1].inputTexture = shaders[i].outputTexture
      }
    }
    
    shaders.last?.outputTexture = outputTexture
    
    for shader in shaders {
      try shader.perform(in: commandBuffer)
    }
  }
}
