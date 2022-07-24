import Combine

extension Publisher {
  public var ignoreErrors: Publishers.CompactMap<Publishers.ReplaceError<Publishers.Map<Self, Self.Output?>>, Self.Output> {
    map { $0 as Optional }
      .replaceError(with: nil)
      .compactMap { $0 }
  }
}
