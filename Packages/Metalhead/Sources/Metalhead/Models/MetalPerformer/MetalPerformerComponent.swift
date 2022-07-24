import NeedleFoundation
import SwiftUI
import Metal
import MetalKit
import Combine

public final class MetalPerformerComponent: Component<EmptyDependency> {
  
  public var metalPerformer: MetalPerformer {
    MetalPerformerImpl()
  }
}
