import MetalKit
import Alloy
import Metal
import Combine

final class PerPixelOperation: SimpleShader {
  
  @Published private var secondaryTexture: MTLTexture? = nil
  
  init(
    context: MTLContext,
    functionName: String,
    secondaryTexture: AnyPublisher<MTLTexture, Never>
  ) throws {
    try super.init(context: context, functionName: functionName)
    
    secondaryTexture
      .asOptional
      .assign(to: &$secondaryTexture)
  }
  
  public override func setParameters(to commandEncoder: MTLComputeCommandEncoder) {
    commandEncoder.setTexture(secondaryTexture, index: 2)
  }
}
