import Metalhead
import MetalKit
import Combine

#if os(macOS)
public typealias ViewController = NSViewController
#elseif os(iOS)
public typealias ViewController = UIViewController
#endif


// View reserved for SwiftUI
#if os(macOS)
public typealias NSUIView = NSView
#elseif os(iOS)
public typealias NSUIView = UIView
#endif
