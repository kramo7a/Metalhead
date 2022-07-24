import Metal
import Alloy

class Grayscale: SimpleShader {
  public override var inputTexture: MTLTexture? {
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }
      descriptor.usage = [.shaderRead, .shaderWrite]
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }
  
  private let weights: SIMD3<Float>
  
  init(context: MTLContext, weights: SIMD3<Float>) throws {
    self.weights = weights

    try super.init(context: context, functionName: "grayscale")
  }
  
  override func setParameters(to commandEncoder: MTLComputeCommandEncoder) {
    commandEncoder.setValue(weights, at: 0)
  }
}
