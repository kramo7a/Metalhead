import Metal
import MetalKit
import MetalPerformanceShaders
import Combine
import Alloy

public protocol Shader: AnyObject, Debugable {
  
  var inputTexture: MTLTexture? { get set }
  var outputTexture: MTLTexture? { get set }
  
  func perform(in commandBuffer: MTLCommandBuffer) throws
}

public extension Shader where Self: MPSUnaryImageKernel {
  func perform(in commandBuffer: MTLCommandBuffer) throws {
    guard let inputTexture, let outputTexture else {
      throw MetalError.noTexture
    }
    
    encode(commandBuffer: commandBuffer, sourceTexture: inputTexture, destinationTexture: outputTexture)
  }
}
