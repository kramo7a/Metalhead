import AVFoundation

public enum PixelFormat {
  case rgb
  case yCbCr
  
  var coreVideoType: OSType {
    switch self {
    case .rgb:
      return kCVPixelFormatType_32BGRA
    case .yCbCr:
      return kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    }
  }
}
