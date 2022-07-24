import XCTest
import Metalhead
import Alloy
import Darwin
import Combine

final class HoughTransformTests: XCTestCase {
  
  private let rootComponent = TestsRootComponent()
  
  override class func setUp() {
    try? TestsRootComponent.cleanUpFolder()
  }
  
  func testHoughTransform() throws {
//    let image = Image(named: "theta45_rho9")!
    let image = Image(named: "5")!
    let texture = try rootComponent.texturesFactory.createTexture(from: image)
    
    let shaders: [ShaderType] = [
      .pipe,
      .grayscale(weights: .GSWeights.rec709),
//      .downscale,
      .sobel,
      .houghTransform
    ]
    
    let result = rootComponent.perform(shaders: shaders, inputTexture: texture, downscaleFactor: 1)!
//    let resultMatrix = Matrix(texture: result)

//    print(resultMatrix)

//    resultMatrix
//      .findIndices { $0 != 0 }
//      .forEach { i, j in
//        print("[\(i), \(j)] = \(resultMatrix[i, j])")
//      }
  }
}
