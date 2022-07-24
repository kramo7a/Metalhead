import Foundation
import Alloy

public struct Matrix<T> where T: Numeric, T: Comparable {
  public private(set) var values: [T]
  public let rows: Int
  public let columns: Int
  
  internal init(rows: Int, columns: Int) {
    self.init(values: Array(repeating: T.zero, count: columns * rows), rows: rows, columns: columns)
  }
  
  public init(_ values: [[T]]) {
    self.init(values: values.flatMap { $0 }, rows: values.count, columns: values.first?.count ?? 0)
  }
  
  public init(values: [T], columns: Int) {
    self.init(values: values, rows: values.count / columns, columns: columns)
  }
  
  public init(values: [T], rows: Int) {
    self.init(values: values, rows: rows, columns: values.count / rows)
  }
  
  public init(values: [T], rows: Int, columns: Int)  {
    assert(columns * rows == values.count, "Wrong matrix layout")
    
    self.values = values
    self.columns = columns
    self.rows = rows
  }
  
  public init(buffer: MTLBuffer, rows: Int, columns: Int) {
    self.init(
      values: buffer.array(of: T.self, count: columns * rows) ?? [],
      rows: rows,
      columns: columns
    )
  }
  
  public init(texture: MTLTexture) where T == Float {
    let columns = texture.width
    let rows = texture.height
    let values = (try? texture.toFloatArray(width: columns, height: rows, featureChannels: 1)) ?? []
    
    self.init(values: values, rows: rows, columns: columns)
  }
  
  public init(texture: MTLTexture) where T == UInt8 {
    let columns = texture.width
    let rows = texture.height
    let values = (try? texture.toUInt8Array(width: columns, height: rows, featureChannels: 1)) ?? []
    
    self.init(values: values, rows: rows, columns: columns)
  }
  
  public subscript(row: Int, column: Int) -> T {
    get {
      assert(row < rows && column < columns, "Index out of range: [\(row), \(column)]. Matrix size: [\(rows), \(columns)]")
      return values[(row * columns) + column]
    } set {
      assert(row < rows && column < columns, "Index out of range: [\(row), \(column)]. Matrix size: [\(rows), \(columns)]")
      values[(row * columns) + column] = newValue
    }
  }
  
  public subscript(row: Int) -> [T] {
    get {
      assert(row < rows, "Index out of range")
      return Array(values[(row * columns) ..< ((row + 1) * columns)])
    }
  }
}

