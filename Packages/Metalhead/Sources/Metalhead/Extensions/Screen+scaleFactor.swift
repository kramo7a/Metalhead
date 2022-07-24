import Foundation

#if os(macOS)
import AppKit

public extension NSScreen {
  static var scaleFactor: CGFloat {
    CGFloat(NSScreen.main?.backingScaleFactor ?? 1)
  }
}
#endif

#if os(iOS)
import UIKit

public extension UIScreen {
  static var scaleFactor: CGFloat {
    CGFloat(UIScreen.main.scale)
  }
}
#endif
