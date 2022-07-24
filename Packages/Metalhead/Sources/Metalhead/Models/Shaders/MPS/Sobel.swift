import MetalPerformanceShaders
import Alloy

final class Sobel: MPSImageSobel, Shader {
  var inputTexture: MTLTexture? {
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }
      descriptor.pixelFormat = .r8Unorm
      descriptor.usage = [.shaderWrite, .shaderRead]
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }

  var outputTexture: MTLTexture? {
    didSet {
//      print("")
    }
  }

  var context: MTLContext!
}

