import CoreImage

public extension CIImage {
  var cvImageBuffer: CVImageBuffer {
    get throws {
      let width = Int(self.extent.width)
      let height = Int(self.extent.height)
      
      let attributes = [
        kCVPixelBufferCGImageCompatibilityKey: false,
        kCVPixelBufferCGBitmapContextCompatibilityKey: false,
        kCVPixelBufferWidthKey: width,
        kCVPixelBufferHeightKey: height
      ] as CFDictionary
      
      var imageBuffer: CVImageBuffer?
      let status = CVPixelBufferCreate(
        kCFAllocatorDefault,
        width,
        height,
        kCVPixelFormatType_32BGRA,
        attributes,
        &imageBuffer
      )
      
      guard
        status == kCVReturnSuccess,
        let imageBuffer = imageBuffer
      else { throw ImageProcessingError.imageBufferCreationError }
      
      let context = CIContext()
      context.render(self, to: imageBuffer)
      
      return imageBuffer
    }
  }
}
