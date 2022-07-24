import CoreGraphics
import VideoToolbox

public extension CVImageBuffer {
  var cgImage: CGImage? {
    var image: CGImage?
    VTCreateCGImageFromCVPixelBuffer(
      self,
      options: nil,
      imageOut: &image
    )
    return image
  }
}
