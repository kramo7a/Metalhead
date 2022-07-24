import XCTest
import Metalhead
import Alloy

//final class MatriceisConvolutionsTests: XCTestCase {
//  
//  private let rootComponent = TestsRootComponent()
//  private let testData = ShadersTestsData()
//  
//  override func setUpWithError() throws { }
//  
//  override func tearDownWithError() throws { }
//  
////  func testPerformanceExample() throws {
////    measure { }
////  }
//  
////  func testIdentityConvolution() throws {
////    let output = try convolve(sourceMatrix: testData.sourceMatrix, convolution: testData.identityConvolution)
////    print(output)
////    XCTAssert(output == testData.sourceMatrix)
////  }
//  
//  func convolve(sourceMatrix: Matrix<Float>, convolution: Matrix<Float>) throws -> Matrix<Float> {
//    let sourceMatrixTexture = try rootComponent.texturesFactory.createTexture(from: sourceMatrix)
//    
//    let shaders = rootComponent.shadersFactoryComponent(for: sourceMatrixTexture)
//    let convolution = try shaders.convolve(with: convolution)
//    
//    let outputTexture = try rootComponent.perform(shader: convolution, inputTexture: sourceMatrixTexture, calledFromFunction: #function)!
//    let floats = try outputTexture.toFloatArray(width: outputTexture.width, height: outputTexture.height, featureChannels: 1)
//    
//    return Matrix(values: floats, rows: outputTexture.width, columns: outputTexture.height)
//  }
//}
