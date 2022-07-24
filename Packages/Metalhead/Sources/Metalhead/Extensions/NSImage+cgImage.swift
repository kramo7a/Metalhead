#if canImport(AppKit)
import AppKit
#endif

#if os(macOS)
public extension NSImage {
  var cgImage: CGImage? {
    cgImage(forProposedRect: nil, context: nil, hints: nil)
  }
}
#endif
