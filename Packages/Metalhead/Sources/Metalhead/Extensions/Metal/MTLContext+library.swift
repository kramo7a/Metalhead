import MetalKit
import Alloy
import Metal

public extension MTLContext {
  
  func function(
    named: String,
    placedIn bundle: Bundle
  ) throws -> MTLFunction {
    guard
      let function = try library(for: bundle).makeFunction(name: named)
      else { throw MetalError.couldNotCreateMTLFunction(named) }
    
    return function
  }
  
  func computePipelineState(
    function named: String,
    placedIn bundle: Bundle = Bundle.main
  ) throws -> MTLComputePipelineState {
    try computePipelineState(function: function(named: named, placedIn: bundle))
  }
}
