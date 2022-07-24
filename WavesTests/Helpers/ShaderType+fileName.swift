import Metalhead

extension ShaderType {
  var fileName: String? {
    switch self {
    case .pipe:
      return "pipe"
    case .colorInverse:
      return "colorInverse"
    case .grayscale:
      return "grayscale"
    case .sobel:
      return "sobel"
    case .downscale:
      return "downscale"
    case .blur(let sigma):
      return nil
//      return "blur [sigma \(sigma)]"
    case .convolve(let matrix):
//      return nil
      return "convolve [matrix \(matrix)]"
    case .pixelDiff:
      return "pixelDiff"
    case .pixelSum:
      return "pixelSum"
    case .houghTransform:
      return "houghTransformDrawer"
    case .brightness:
      return "brightness"
    }
  }
}
