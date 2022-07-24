#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

#if os(macOS)
public typealias Image = NSImage
#elseif os(iOS)
public typealias Image = UIImage
#endif

