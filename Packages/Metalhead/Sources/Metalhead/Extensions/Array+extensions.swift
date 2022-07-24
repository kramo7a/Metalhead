public extension Array {
  func appending(_ elements: [Element]) -> Self {
    var result = self
    result.append(contentsOf: elements)
    return self
  }
  
  func appending(_ element: Element) -> Self {
    return appending([element])
  }
  
  func group(by batchSize: Int) -> [Self] {
    enumerated()
      .split(whereSeparator: { $0.offset % batchSize == 0 })
      .map { $0.map { $0.element } }
  }
  
  func makeDictionary<Key, Value>(producer: (Element) -> (Key, Value)) -> [Key: Value] {
    reduce(into: [:]) { resultDictionary, element in
      let (key, value) = producer(element)
      resultDictionary[key] = value
    }
  }
}
