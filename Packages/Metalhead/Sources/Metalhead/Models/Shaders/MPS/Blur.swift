import MetalPerformanceShaders
import Alloy

final class Blur: MPSImageGaussianBlur, Metalhead.Shader {
  var inputTexture: MTLTexture?{
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }
      descriptor.usage = [.shaderRead, .shaderWrite]
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }
  
  var outputTexture: MTLTexture?
  
  private let context: MTLContext
  
  init(context: MTLContext, sigma: Float) {
    self.context = context
    
    super.init(device: context.device, sigma: sigma)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

