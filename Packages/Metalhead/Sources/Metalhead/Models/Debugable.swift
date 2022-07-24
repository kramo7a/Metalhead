public protocol Debugable {
  var debugLabel: String { get }
}

public extension Debugable {
  
  var debugLabel: String {
    let entityName = String(describing: self)
    
    return entityName.split(separator: ".")
      .dropFirst()
      .first?
      .components(separatedBy: .letters.inverted)
      .first(where: { !$0.isEmpty })
    ?? entityName
  }
}
