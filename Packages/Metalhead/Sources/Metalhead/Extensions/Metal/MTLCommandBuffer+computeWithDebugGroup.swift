import Metal
import Alloy

public extension MTLCommandBuffer {
  func compute(
    dispatch: MTLDispatchType = .serial,
    debugLabel: String?,
    _ commands: (MTLComputeCommandEncoder) -> Void
  ) {
    guard let debugLabel else { return compute(dispatch: dispatch, commands) }
    
    compute(dispatch: dispatch) { encoder in
      encoder.pushDebugGroup("\(debugLabel) debug group")
      commands(encoder)
      encoder.popDebugGroup()
    }
  }
}
