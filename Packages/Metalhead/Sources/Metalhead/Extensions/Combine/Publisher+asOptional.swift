import Combine

extension Publisher {
  public var asOptional: Publishers.Map<Self, Optional<Output>> {
    map { $0 as Optional }
  }
}
