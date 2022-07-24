import Foundation

public enum MathError: LocalizedError {
  case isNotPerfectSquare(int: Int)
  case wrongMatrixLayout(height: Int?, width: Int?, valuesCount: Int)
  case cannotSumMatricesWithDifferentLayout(lhsHeight: Int, lhsWidth: Int, rhsHeight: Int, rhsWidth: Int)
  case matrixIndexIsNotValid(row: Int, column: Int, height: Int, width: Int)
}
