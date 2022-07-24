import XCTest
import Metalhead
import Combine
import Alloy

final class ShadersTests: XCTestCase {
  
  
  private let rootComponent = TestsRootComponent()
  
  override class func setUp() {
    try? TestsRootComponent.cleanUpFolder()
  }
  
  private lazy var anImage: MTLTexture = {
    let anImage = try! rootComponent.texturesFactory.createTexture(from: Image(named: "5")!)
    
    return anImage
  }()
  
  private func sum(
    kernels: [String: Matrix<Float>],
    imageToProcess: MTLTexture,
    convolutionName: String,
    threshold: Float = 0.1,
    saveToFolder: String = #function
  ) -> MTLTexture {
    let prepocessed = rootComponent.perform(
      shaders: [
        .grayscale(weights: .GSWeights.rec709),
        .blur(sigma: 1)
      ],
      inputTexture: imageToProcess,
      downscaleFactor: 1,
      saveToFolder: saveToFolder
//      fileNamePrefix: "\(convolutionName).0 preprocessed"
    )!
    
    let convolutions = kernels
      .map { kernelLabel, kernel in
        rootComponent.perform(
          shaders: [
            .convolve(matrix: kernel, threshold: threshold),
          ],
          inputTexture: prepocessed,
          downscaleFactor: 1,
          saveToFolder: saveToFolder
//          fileNamePrefix: "\(convolutionName).1 \(kernelLabel)"
        )!
      }
    
    let emptyTexture = try! rootComponent.texturesFactory.createEmptyTexture(size: convolutions.first!.size, pixelFormat: convolutions.first!.pixelFormat)
    return convolutions
      .reduce(emptyTexture) { partialResult, convolved in
        rootComponent.perform(
          shaders: [
            .pixelSum(withTexture: Just(partialResult).eraseToAnyPublisher())
          ],
          inputTexture: convolved,
          downscaleFactor: 1,
          saveToFolder: saveToFolder,
          fileNamePrefix: "\(convolutionName) sum"
        )!
      }
  }
  
  func testSobel() throws {
    let summedConvolutionsX = sum(
      kernels: [
        "X": Matrix.Kernels.Sobel.X,
        "XInv": Matrix.Kernels.Sobel.XInv
      ],
      imageToProcess: anImage,
      convolutionName: "1.0 X sobel"
    )
    
    let summedConvolutionsY = sum(
      kernels: [
        "Y": Matrix.Kernels.Sobel.Y,
        "YInv": Matrix.Kernels.Sobel.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "1.1 Y sobel"
    )
    
    let summedConvolutions = rootComponent.perform(
      shaders: [
        .pixelSum(withTexture: Just(summedConvolutionsY).eraseToAnyPublisher())
      ],
      inputTexture: summedConvolutionsX,
      downscaleFactor: 1,
      fileNamePrefix: "1.2 XY sobel"
    )!
    
  }
  
  func testSobelValues() throws {
    let sobel = rootComponent.perform(
      shaders: [
        .grayscale(weights: .GSWeights.rec709),
        .sobel
      ],
      inputTexture: anImage,
      downscaleFactor: 1,
      saveToFolder: nil
    )!
    
    let result = Matrix<UInt8>(texture: sobel)
    print(result)
  }
  
  func testSobel5x5() throws {
    let summedConvolutions = sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Sobel5x5.X,
        "Y": Matrix<Float>.Kernels.Sobel5x5.Y,
        "XInv": Matrix<Float>.Kernels.Sobel5x5.XInv,
        "YInv": Matrix<Float>.Kernels.Sobel5x5.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "1. X and Y"
    )
  }
  
  func testSobelXYSum() throws {
    let summedConvolutions = sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Sobel.XInv,
        "Y": Matrix<Float>.Kernels.Sobel.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "1. X and Y"
    )
    
    rootComponent.perform(
      shaders: [
        .convolve(matrix: Matrix<Float>.Kernels.Sobel.XYInv, threshold: 0.1)
      ],
      inputTexture: anImage,
      downscaleFactor: 1,
      fileNamePrefix: "2. XY"
    )!
  }
  
  func testDifferencialConvolution() throws {
    let summedConvolutions = sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Differencial.X,
//        "XInv": Matrix<Float>.Kernels.Differencial.XInv,
        "Y": Matrix<Float>.Kernels.Differencial.Y,
//        "YInv": Matrix<Float>.Kernels.Differencial.YInv,
      ],
      imageToProcess: anImage,
      convolutionName: "0. differencial"
    )
  }
  
  func testPrewittConvolution() throws {
    let x = sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Prewitt.X,
        "XInv": Matrix<Float>.Kernels.Prewitt.XInv
      ],
      imageToProcess: anImage,
      convolutionName: "0. x"
    )
    
    let y = sum(
      kernels: [
        "Y": Matrix<Float>.Kernels.Prewitt.Y,
        "YInv": Matrix<Float>.Kernels.Prewitt.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "1. y"
    )
    
    rootComponent.perform(
      shaders: [
        .pixelSum(withTexture: Just(x).eraseToAnyPublisher())
      ],
      inputTexture: y,
      downscaleFactor: 1,
      fileNamePrefix: "2. sum"
    )
  }
  
  func testRobertsConvolution() throws {
    let x = sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Roberts.X,
        "XInv": Matrix<Float>.Kernels.Roberts.XInv
      ],
      imageToProcess: anImage,
      convolutionName: "0. x"
    )
    
    let y = sum(
      kernels: [
        "Y": Matrix<Float>.Kernels.Roberts.Y,
        "YInv": Matrix<Float>.Kernels.Roberts.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "1. y"
    )
    
    rootComponent.perform(
      shaders: [
        .pixelSum(withTexture: Just(x).eraseToAnyPublisher())
      ],
      inputTexture: y,
      downscaleFactor: 1,
      fileNamePrefix: "2. sum"
    )
    
    sum(
      kernels: [
        "X": Matrix<Float>.Kernels.Roberts.X,
        "XInv": Matrix<Float>.Kernels.Roberts.XInv,
        "Y": Matrix<Float>.Kernels.Roberts.Y,
        "YInv": Matrix<Float>.Kernels.Roberts.YInv
      ],
      imageToProcess: anImage,
      convolutionName: "3. X+XInv+Y+YInv"
    )
    
  }
  
  func testLaplasianConvolution() throws {
    let gs = rootComponent.perform(
      shaders: [
        .grayscale(weights: .GSWeights.rec709),
      ],
      inputTexture: anImage,
      downscaleFactor: 1
    )!
    
    let imax = 30
    for i in 0 ... imax {
      rootComponent.perform(
        shaders: [
          .blur(sigma: Float(i) / 5),
          .convolve(matrix: Matrix<Float>.Kernels.laplasian, threshold: 0)
        ],
        inputTexture: gs,
        downscaleFactor: 1,
        fileNamePrefix: "\(i)"
      )!
    }
    for i in 0 ... imax {
      rootComponent.perform(
        shaders: [
          .blur(sigma: Float(i) / 5),
          .convolve(matrix: Matrix<Float>.Kernels.laplasian, threshold: 0)
        ],
        inputTexture: gs,
        downscaleFactor: 1,
        fileNamePrefix: "\(imax*2-i + 1)"
      )!
    }
  }
  
  func testThreshold() throws {
    let gs = rootComponent.perform(
      shaders: [
        .grayscale(weights: .GSWeights.rec709),
      ],
      inputTexture: anImage,
      downscaleFactor: 1
    )!
    
    for i in 0 ... 10 {
      sum(
        kernels: [
          "X": Matrix<Float>.Kernels.Sobel.X,
          "XInv": Matrix<Float>.Kernels.Sobel.XInv,
          "Y": Matrix<Float>.Kernels.Sobel.Y,
          "YInv": Matrix<Float>.Kernels.Sobel.YInv
        ],
        imageToProcess: anImage,
        convolutionName: "\(Float(i)) threshold",
        threshold: 0.1 * Float(i)
      )
    }
  }
}

//  func testConvolutionAssociativeness() throws {
//    let grayscale = try rootComponent.perform(shader: shaders.rec709Grayscale, inputTexture: anImage, saveAs: nil)
//
//    let l = try shaders.convolve(with: testData.laplasianConvolution)
//    let b = shaders.blur(sigma: 1)
//
//    let blur = try rootComponent.perform(shader: b, inputTexture: grayscale, saveAs: nil)
//    try rootComponent.perform(shader: l, inputTexture: blur, saveAs: "b_l")
//
//    let laplasian = try rootComponent.perform(shader: l, inputTexture: grayscale, saveAs: "l_b")
////    try rootComponent.perform(shader: b, inputTexture: laplasian, saveAs: "l_b")
//  }
//
//  func testGaussianWithSobel() throws {
//    let grayscale = try rootComponent.perform(shader: shaders.rec709Grayscale, inputTexture: anImage, saveAs: nil)
//    try rootComponent.perform(shader: shaders.sobel, inputTexture: grayscale, saveAs: "sobel_0")
//    for i in 1...10 {
//      let grayscale = try rootComponent.perform(shader: shaders.rec709Grayscale, inputTexture: anImage, saveAs: nil)
//      let blur = try rootComponent.perform(shader: shaders.blur(sigma: Float(i)), inputTexture: grayscale, saveAs: "gaussian_\(i)")
//      try rootComponent.perform(shader: shaders.sobel, inputTexture: blur, saveAs: "sobel_\(i)")
//
//    }
//  }
//
//  func testInvertedMatricies() throws {
//    let grayscale = try rootComponent.perform(shader: shaders.rec709Grayscale, inputTexture: anImage, saveAs: nil)!
//    let blur = try rootComponent.perform(shader: shaders.blur(sigma: 2), inputTexture: grayscale, saveAs: nil)!
//    let testTexture = blur
//
////    try convolve(sourceTexture: testTexture, convolution: testData.identityConvolution, saveAs: "identityConvolution")
//
//    let sobelConvolutionX = try convolve(sourceTexture: testTexture, convolution: testData.sobelConvolutionX, saveAs: nil) // "sobelConvolutionX")
//    let sobelConvolutionXInv = try convolve(sourceTexture: testTexture, convolution: testData.sobelConvolutionXInv, saveAs: nil) // "sobelConvolutionXInv")
//    let sobelConvolutionY = try convolve(sourceTexture: testTexture, convolution: testData.sobelConvolutionY, saveAs: nil) // "sobelConvolutionY")
//    let sobelConvolutionYInv = try convolve(sourceTexture: testTexture, convolution: testData.sobelConvolutionYInv, saveAs: nil) // "sobelConvolutionYInv")
//
//    let xAndXINVSum = try sum(texture: sobelConvolutionX, and: sobelConvolutionXInv, saveAs: nil) // "xAndXINVSum")
//    let yAndYINVSum = try sum(texture: sobelConvolutionY, and: sobelConvolutionYInv, saveAs: nil) // "yAndYINVSum")
//
//    try sum(texture: xAndXINVSum, and: yAndYINVSum, saveAs: "allSum")
//    try rootComponent.perform(shader: shaders.sobel, inputTexture: testTexture, saveAs: "sobel")
//  }
//
//  @discardableResult
//  private func sum(texture firstTexture: MTLTexture, and secondTexture: MTLTexture, saveAs fileName: String?, calledFromFunction: String = #function) throws -> MTLTexture {
//    let sum = try shaders.pixelSum(with: staticImageTexturePublisher(texture: secondTexture))
//
//    return try rootComponent.perform(shader: sum, inputTexture: firstTexture, saveAs: fileName, calledFromFunction: calledFromFunction)!
//  }
//
//  @discardableResult
//  private func convolve(sourceTexture: MTLTexture, convolution: Matrix<Float>, saveAs fileName: String?, calledFromFunction: String = #function) throws -> MTLTexture {
//    let convolution = try shaders.convolve(with: convolution)
//
//    return try rootComponent.perform(shader: convolution, inputTexture: sourceTexture, saveAs: fileName, calledFromFunction: calledFromFunction)!
//  }
//}
