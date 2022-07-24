import MetalKit
import Alloy
import Metal
import Combine

open class SimpleShader: Shader {
  
  open var outputTexture: MTLTexture?
  open var inputTexture: MTLTexture? {
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }      
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }
  
  private let pipelineState: MTLComputePipelineState
  public let context: MTLContext
  
  init(
    context: MTLContext,
    functionName: String
  ) throws {
    self.pipelineState = try context.computePipelineState(function: functionName)
    self.context = context
  }
  
  open func perform(in commandBuffer: MTLCommandBuffer) throws {
    guard let outputTexture else { return }
    commandBuffer.compute(debugLabel: debugLabel) { encoder in
      setParameters(to: encoder)
      
      encoder.setTextures([inputTexture, outputTexture])
      encoder.dispatch2d(state: pipelineState, covering: outputTexture.size)
    }
  }
  
  open func setParameters(to commandEncoder: MTLComputeCommandEncoder) { }
}
