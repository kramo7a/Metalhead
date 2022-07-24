import SwiftUI
import Metalhead
import MetalKit
import Combine

#if os(macOS)
public typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
public typealias ViewRepresentable = UIViewRepresentable
#endif

#if os(macOS)
public typealias ViewRepresentableContext = NSViewRepresentableContext
#elseif os(iOS)
public typealias ViewRepresentableContext = UIViewRepresentableContext
#endif

