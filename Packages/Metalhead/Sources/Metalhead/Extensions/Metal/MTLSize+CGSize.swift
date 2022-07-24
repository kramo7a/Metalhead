import NeedleFoundation
import AVFoundation
import Combine

public extension MTLSize {
  var cgSize: CGSize {
    CGSize(width: width, height: height)
  }
}
