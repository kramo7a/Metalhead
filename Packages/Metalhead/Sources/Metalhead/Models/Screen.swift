import MetalKit
import Combine

#if os(macOS)
public typealias Screen = NSScreen
#elseif os(iOS)
public typealias Screen = UIScreen
#endif
