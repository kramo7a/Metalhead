import XCTest
@testable import Metalhead
import Metal

final class MatrixTests: XCTestCase {
  
  func testRotation() throws {
//    print(TestData.testMatrix)
  }
  
  func testMultiplications() throws {
    XCTAssert(TestData.testMatrix3x3 * Matrix<Float>.identity(size: TestData.testMatrix3x3.rows) == TestData.testMatrix3x3)
  }
}
