#if canImport(AppKit)
import AppKit
#endif

#if os(macOS)
public extension NSImage {
  var ciImage: CIImage? {
    guard
      let data = self.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: data)
    else { return nil }
    
    return CIImage(bitmapImageRep: bitmap)
  }
}
#endif
