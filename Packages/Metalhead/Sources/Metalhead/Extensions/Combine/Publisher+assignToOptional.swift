import Combine

extension Publisher where Self.Failure == Never {
  public func assign(to published: inout Optional<Published<Self.Output>.Publisher>) {
    guard var published else { return }
    assign(to: &published)
  }
}
