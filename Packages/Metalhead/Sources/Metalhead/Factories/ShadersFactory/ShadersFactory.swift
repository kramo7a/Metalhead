import Metal
import Alloy
import NeedleFoundation
import Combine

public enum ShaderType {
  case brightness(factor: AnyPublisher<Float, Never>)
  case pipe
  case colorInverse
  case grayscale(weights: SIMD3<Float>)
  case sobel
  case downscale
  
  case blur(sigma: Float)
  case convolve(matrix: Matrix<Float32>, threshold: Float)
  case pixelDiff(withTexture: AnyPublisher<MTLTexture, Never>)
  case pixelSum(withTexture: AnyPublisher<MTLTexture, Never>)
  
  case houghTransform
}

public protocol ShadersFactory {
  
  // TODO: delete and make plain functions
  func shader(of type: ShaderType) throws -> Metalhead.Shader
}

final class ShadersFactoryImpl: ShadersFactory {
  
  private let context: MTLContext
  private let texturesFactory: TexturesFactory
  private let errorsObservable: ErrorsObservable
  
  private let downscaleFactor: AnyPublisher<Int, Never>
  private let frameSize: AnyPublisher<CGSize, Never>
  
  init(
    downscaleFactor: AnyPublisher<Int, Never>,
    frameSize: AnyPublisher<CGSize, Never>,
    context: MTLContext,
    texturesFactory: TexturesFactory,
    errorsObservable: ErrorsObservable
  ) {
    self.downscaleFactor = downscaleFactor
    self.frameSize = frameSize
    
    self.context = context
    self.texturesFactory = texturesFactory
    self.errorsObservable = errorsObservable
  }
  
  func shader(of type: ShaderType) throws -> Metalhead.Shader {
    switch type {
    case .brightness(let factor):
      return try Brightness(context: context, factor: factor)
    case .pipe:
      return try SimpleShader(context: context, functionName: "pipe")
    case .colorInverse:
      return try SimpleShader(context: context, functionName: "colorInverse")
    case .grayscale(let weights):
      return try Grayscale(context: context, weights: weights)
    case .sobel:
      let sobel = Sobel(device: context.device)
//      let sobel = Sobel(context: context)
      sobel.context = context
      return sobel
    case .downscale:
      return try AverageSumDownscale(context: context, downscaleFactor: downscaleFactor)
    case .blur(let sigma):
      return Blur(context: context, sigma: sigma)
    case .convolve(let matrix, let threshold):
      return try Convolve(
        context: context,
        texturesFactory: texturesFactory,
        errorsObservable: errorsObservable,
        kernelMatrixPublisher: Just(matrix).eraseToAnyPublisher(),
        threshold: threshold
      )
    case .pixelDiff(let secondaryTexture):
      return try PerPixelOperation(
        context: context,
        functionName: "pixelDiff",
        secondaryTexture: secondaryTexture
      )
    case .pixelSum(let secondaryTexture):
      return try PerPixelOperation(
        context: context,
        functionName: "pixelSum",
        secondaryTexture: secondaryTexture
      )
      
    case .houghTransform:
      return try HoughTransform(
        space: Just(.image).eraseToAnyPublisher(),
        frameSize: frameSize,
        downscaleFactor: downscaleFactor,
        context: context,
        errorsObservable: errorsObservable
      )
    }
  }
}
