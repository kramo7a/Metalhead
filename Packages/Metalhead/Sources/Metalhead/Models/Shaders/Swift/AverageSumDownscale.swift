import Metal
import Alloy
import Combine

public final class AverageSumDownscale: SimpleShader {
  
  public override var inputTexture: MTLTexture? {
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }
      descriptor.height /= downscaleFactor
      descriptor.width /= downscaleFactor
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }
  
  @Published private var downscaleFactor: Int = 1
  
  init(
    context: MTLContext,
    downscaleFactor: AnyPublisher<Int, Never>
  ) throws {
    try super.init(context: context, functionName: "averageSumDownscale")
    
    downscaleFactor.assign(to: &$downscaleFactor)
  }
}
