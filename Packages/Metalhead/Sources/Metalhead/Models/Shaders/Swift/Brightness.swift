import Metal
import Alloy
import Combine

public final class Brightness: SimpleShader {
  
  @Published private var factor: Float = 1
  
  init(
    context: MTLContext,
    factor: AnyPublisher<Float, Never>
  ) throws {
    try super.init(context: context, functionName: "brightness")
    
    factor.assign(to: &$factor)
  }
  
  public override func setParameters(to commandEncoder: MTLComputeCommandEncoder) {
    commandEncoder.setValue(factor, at: 0)
  }
}
