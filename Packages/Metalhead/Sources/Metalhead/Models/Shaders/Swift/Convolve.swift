import Metal
import Alloy
import Combine

final class Convolve<T: Numeric & Comparable>: SimpleShader {
  
  @Published private var convolutionMatrixTexture: MTLTexture?
  private var cancellables = Set<AnyCancellable>()
  private var threshold: Float
  
  init(
    context: MTLContext,
    texturesFactory: TexturesFactory,
    errorsObservable: ErrorsObservable,
    kernelMatrixPublisher: AnyPublisher<Matrix<T>, Never>,
    threshold: Float
  ) throws {
    self.threshold = threshold
    
    try super.init(context: context, functionName: "convolve")
    
    kernelMatrixPublisher
      .tryMap {
        guard $0.values.count.isPerfectSquare else { throw MathError.isNotPerfectSquare(int: $0.values.count) }
        return try texturesFactory.createTexture(from: $0)
      }
      .asOptional
      .bindErrors(to: errorsObservable)
      .assign(to: &$convolutionMatrixTexture)
  }
  
  public override func setParameters(to commandEncoder: MTLComputeCommandEncoder) {
    commandEncoder.setValue(threshold, at: 0)
    commandEncoder.setTexture(convolutionMatrixTexture, index: 2)
  }
}
