import NeedleFoundation
import Metalhead
import SwiftUI
import UI
import Alloy
import Combine

final class RootComponent: BootstrapComponent {
  
  override init() {
    registerProviderFactories()
    
    super.init()
  }
  
  private lazy var texturePublishersComponent = TexturePublishersComponent(parent: self)
  private lazy var metalRenderingComponent = MetalRenderingComponent(parent: self)
  private lazy var shadersFactoryComponent = ShadersFactoryComponent(parent: self)
  private lazy var texturesFactoryComponent = TexturesFactoryComponent(parent: self)
  
  let errorsObservable: ErrorsObservable = ErrorsObservable()
  var pixelFormat: PixelFormat { .rgb }
  var metalDevice: MTLDevice { shared { MTLCreateSystemDefaultDevice()! } }
  
  var context: MTLContext {
    shared { try! MTLContext(device: metalDevice) }
  }
  
  var anImage: Metalhead.Image {
    Image(named: "5") ?? Image()
  }
  
  var cameraMTKRenderingView: some View {
    let cameraTexturePublisher = texturePublishersComponent
      .cameraTexturePublisher
      .bindErrors(to: errorsObservable)
    
    return shadersView(inputTexture: cameraTexturePublisher)
  }
  
  func imageMTKRenderingView(from image: Metalhead.Image) -> some View {
    let staticImageTexture = texturePublishersComponent
      .staticImageTexturePublisher(from: image)
      .bindErrors(to: errorsObservable)
    
    return shadersView(inputTexture: staticImageTexture)
  }
  
  private func shadersView(inputTexture: AnyPublisher<MTLTexture, Never>) -> ShadersView {
    let shaders: [ShaderType] = [
      .grayscale(weights: .GSWeights.rec709),
//      .downscale,
      .blur(sigma: 2),
//      .sobel,
      .convolve(matrix: Matrix<Float32>.Kernels.laplasian, threshold: 0.2),
//      .houghTransform,
////      .pipe,
//      .pixelSum(withTexture: inputTexture)
    ]
    
    return ShadersView(
      viewModel: ShadersViewModel(
        inputTexture: inputTexture,
        shaders: shaders,
        shadersFactoryBuilder: shadersFactoryComponent,
        errorsObservable: errorsObservable
      ),
      metalRenderingBuilder: metalRenderingComponent
    )
  }
  
  func pixelDiffView(for firstImage: Metalhead.Image, and secondImage: Metalhead.Image) -> some View {
    let inputTexture = texturePublishersComponent
      .staticImageTexturePublisher(from: firstImage)
      .bindErrors(to: errorsObservable)
    
    let secondImageTexture = texturePublishersComponent
      .staticImageTexturePublisher(from: secondImage)
      .bindErrors(to: errorsObservable)
    
    let pixelDiff = ShaderType.pixelDiff(withTexture: secondImageTexture)
    let shaders = [pixelDiff]
    
    return ShadersView(
      viewModel: ShadersViewModel(
        inputTexture: inputTexture,
        shaders: shaders,
        shadersFactoryBuilder: shadersFactoryComponent,
        errorsObservable: errorsObservable
      ),
      metalRenderingBuilder: metalRenderingComponent
    )
  }
}
