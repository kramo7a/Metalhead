public enum Event<T> {
  case element(T)
  case error(Error)

  public var element: T? {
    if case let .element(element) = self {
      return element
    }
    return nil
  }

  public var error: Error? {
    if case let .error(error) = self {
      return error
    }
    return nil
  }
}
