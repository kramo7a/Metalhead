import Metalhead

extension MatrixTests {
  struct TestData {
    static var testMatrix5x5 = Matrix<Float>([
      [1, 11, 111, 1111, 11111],
      [2, 22, 222, 2222, 22222],
      [3, 33, 333, 3333, 33333],
      [4, 44, 444, 4444, 44444],
      [5, 55, 555, 5555, 55555],
    ])
    
    static var testMatrix3x3 = Matrix<Float>([
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ])
  }
}
