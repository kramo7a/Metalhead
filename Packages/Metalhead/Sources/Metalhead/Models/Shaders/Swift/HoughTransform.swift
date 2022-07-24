import Metal
import Alloy
import Combine

public final class HoughTransform: Shader {
  
  public var outputTexture: MTLTexture?
  public var inputTexture: MTLTexture? {
    didSet {
      guard let descriptor = inputTexture?.descriptor else { return }
      outputTexture = try? context.texture(descriptor: descriptor)
    }
  }
  
  public enum Space {
    case image
    case hough
  }
  
  public let thetaSteps = 180
  @Published private var threshold: UInt32 = 330
  @Published private var frameSize: CGSize = .zero
  @Published private var rhoCompressionFactor: UInt32 = 1
  @Published private var rhoMax: Float = 0
  @Published private var accumulatorHeight: Int = 1
  @Published private var space: Space = .image
  
  @Published public var accumulator: MTLBuffer?
  
  private let houghTransformPipelineState: MTLComputePipelineState
  private let accumulatorResetPipelineState: MTLComputePipelineState
  private let imageSpaceDrawerPipelineState: MTLComputePipelineState
  private let houghSpaceDrawerPipelineState: MTLComputePipelineState
  
  private let context: MTLContext
  
  private var cancellables = Set<AnyCancellable>()
  
  init(
    space: AnyPublisher<Space, Never>,
    frameSize: AnyPublisher<CGSize, Never>,
    downscaleFactor: AnyPublisher<Int, Never>,
    context: MTLContext,
    errorsObservable: ErrorsObservable
  ) throws {
    self.houghTransformPipelineState = try context.computePipelineState(function: "houghTransform")
    self.accumulatorResetPipelineState = try context.computePipelineState(function: "bufferFill")
    self.imageSpaceDrawerPipelineState = try context.computePipelineState(function: "HT_ImageSpaceDrawer")
    self.houghSpaceDrawerPipelineState = try context.computePipelineState(function: "HT_HoughSpaceDrawer")
    self.context = context
    
    space.assign(to: &$space)
    frameSize.assign(to: &$frameSize)
    downscaleFactor.map { UInt32($0) }.assign(to: &$rhoCompressionFactor)
    
    Publishers.CombineLatest(frameSize, downscaleFactor)
      .map { frameSize, downscaleFactor in sqrt(Float(frameSize.width * frameSize.width + frameSize.height * frameSize.height)) / Float(downscaleFactor) }
      .eraseToAnyPublisher()
      .assign(to: &$rhoMax)
    
    
    $rhoMax.map { Int(ceil($0 * 2)) }.assign(to: &$accumulatorHeight)
    
    $accumulatorHeight
      .tryMap { [unowned self] maxRho in
        try self.context.device.buffer(for: UInt32.self, count: thetaSteps * maxRho, options: .storageModeShared)
      }
      .asOptional
      .bindErrors(to: errorsObservable)
      .assign(to: &$accumulator)
  }
  
  public func perform(in commandBuffer: MTLCommandBuffer) throws {
    performAccumulatorReset(in: commandBuffer)
    performHoughTransform(in: commandBuffer)
    
    switch space {
    case .image:
      performImageSpaceDrawer(in: commandBuffer)
    case .hough:
      performHoughSpaceDrawer(in: commandBuffer)
    }
  }
  
  private func performAccumulatorReset(in commandBuffer: MTLCommandBuffer) {
    self.accumulator = try! context.device.buffer(for: UInt32.self, count: thetaSteps * accumulatorHeight, options: .storageModeShared)
//    guard let accumulator else { return }
//
//    commandBuffer.compute(debugLabel: "accumulatorReset") { encoder in
//      encoder.setTextures([inputTexture, outputTexture])
//      encoder.setBuffer(accumulator, offset: 0, index: 0)
//      encoder.setValue(0, at: 1)
//      encoder.dispatch1d(state: accumulatorResetPipelineState, exactly: accumulator.length)
//    }
  }
  
  private func performHoughTransform(in commandBuffer: MTLCommandBuffer) {
    guard let inputTexture else { return }
    
    commandBuffer.compute(debugLabel: "houghTransform") { encoder in
      encoder.setTexture(inputTexture, index: 0)
      encoder.setBuffer(accumulator, offset: 0, index: 0)
      encoder.setValue(rhoMax, at: 1)
      
      encoder.setComputePipelineState(houghTransformPipelineState)
      
      // TODO: try to increase threadsPerThreadgroup
      encoder.dispatchThreads(
        MTLSize(
          width: inputTexture.width,
          height: inputTexture.height,
          depth: thetaSteps
        ),
        threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: thetaSteps)
      )
    }
  }
  
  private func performImageSpaceDrawer(in commandBuffer: MTLCommandBuffer) {
    guard let inputTexture else { return }
    
    commandBuffer.compute(debugLabel: "imageSpaceDrawer") { encoder in
      encoder.setTexture(outputTexture, index: 0)
      encoder.setBuffer(accumulator, offset: 0, index: 0)
      encoder.setValue(rhoMax, at: 1)
      encoder.setValue(rhoCompressionFactor, at: 2)
      encoder.setValue(threshold, at: 3)
      
      encoder.setComputePipelineState(imageSpaceDrawerPipelineState)
      encoder.dispatchThreads(
        MTLSize(
          width: inputTexture.width * Int(rhoCompressionFactor),
          height: inputTexture.height * Int(rhoCompressionFactor),
          depth: thetaSteps
        ),
        threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: thetaSteps)
      )
    }
  }
  
  private func performHoughSpaceDrawer(in commandBuffer: MTLCommandBuffer) {
    guard let inputTexture else { return }
    
    commandBuffer.compute(debugLabel: "houghSpaceDrawer") { encoder in
      encoder.setTexture(outputTexture, index: 0)
      encoder.setBuffer(accumulator, offset: 0, index: 0)
      encoder.setValue(threshold, at: 1)
      
      encoder.setComputePipelineState(houghSpaceDrawerPipelineState)
      encoder.dispatchThreads(
        MTLSize(
          width: accumulatorHeight,
          height: thetaSteps,
          depth: 1
        ),
        threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: thetaSteps)
      )
    }
  }

}
