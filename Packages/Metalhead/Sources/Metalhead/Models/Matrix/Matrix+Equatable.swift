extension Matrix: Equatable {
  public static func == (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    lhs.values == rhs.values
  }
}

// TODO: Unit tests
extension Matrix {
  static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columns == rhs.columns && lhs.rows == rhs.rows, "Matrix sizes is irrelative")
    
    let values = zip(lhs.values, rhs.values).map(+)
    return Matrix(values: values, columns: lhs.columns)
  }
  
  // TODO: Use vDSP_mmul instead
  static func *(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columns == rhs.rows, "Matrix sizes is irrelative")
    
    var result = Matrix<T>(rows: lhs.rows, columns: rhs.columns)
    
    for i in 0..<lhs.rows {
      for j in 0..<rhs.columns {
        for k in 0..<rhs.rows {
          result[i, j] += lhs[i, k] * rhs[k, j]
        }
      }
    }
    
    return result
  }
}
