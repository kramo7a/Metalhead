extension Matrix {
  public static func identity(size: Int) -> Matrix {
    var result = Matrix(rows: size, columns: size)
    for i in 0..<size {
      result[i, i] = 1
    }
    
    return result
  }
}

public typealias MatrixIndex = (i: Int, j: Int)

extension Matrix {
  
  public func findIndices(where valuePredicate: ((T) -> Bool)) -> [MatrixIndex] {
    var indices: [MatrixIndex] = []
    
    for i in 0..<rows {
      for j in 0..<columns where valuePredicate(self[i, j]) {
        indices.append((i, j))
      }
    }
    
    return indices
  }
  
  public func index(from arrayIndex: Int) -> MatrixIndex {
    MatrixIndex(i: Int(arrayIndex / columns), j: arrayIndex % columns)
  }
  
  public func findIndicesOfTop(_ elementsCount: Int) -> [MatrixIndex] {
    values
      .enumerated()
      .sorted { $0.1 > $1.1 }[0..<elementsCount]
      .map { arrayIndex, _ in index(from: arrayIndex) }
  }
}

extension Matrix: CustomDebugStringConvertible {
  public var debugDescription: String {
    let matrixSize = "Matrix size: \(rows)x\(columns) \n"
    
    let matrixSerialized = (0..<rows)
      .map { row in return self[row].map { String(describing: $0) }.joined(separator: ", ") }
      .joined(separator: "\n")
    
    return matrixSize + matrixSerialized
  }
}
