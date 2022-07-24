#if canImport(AppKit)
import AppKit
#endif

#if os(macOS)
public extension NSImage {
  func pngData() -> Data? {
    guard let bitmap = NSBitmapImageRep(
      bitmapDataPlanes: nil,
      pixelsWide: Int(size.width),
      pixelsHigh: Int(size.height),
      bitsPerSample: 8,
      samplesPerPixel: 4,
      hasAlpha: true,
      isPlanar: false,
      colorSpaceName: .deviceRGB,
      bitmapFormat: [],
      bytesPerRow: 0,
      bitsPerPixel: 0
    ) else {
      return nil
    }
    
    bitmap.size = size
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.current?.imageInterpolation = .high
    draw(
      in: NSRect(origin: .zero, size: size),
      from: .zero,
      operation: .copy,
      fraction: 1.0
    )
    NSGraphicsContext.restoreGraphicsState()
    
    return bitmap.representation(using: .png, properties: [:])
  }
}
#endif
