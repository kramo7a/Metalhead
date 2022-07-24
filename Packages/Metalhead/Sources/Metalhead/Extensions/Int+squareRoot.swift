import Foundation

public extension Int {
  var perfectSquareRoot: Int {
    get throws {
      guard isPerfectSquare else { throw MathError.isNotPerfectSquare(int: self) }
      
      return Int(squareRoot)
    }
  }
  
  var squareRoot: Float {
    Float(self).squareRoot()
  }
  
  var isPerfectSquare: Bool {
    let root = Float(self).squareRoot()
     
    return floor(root) == root
  }
}
