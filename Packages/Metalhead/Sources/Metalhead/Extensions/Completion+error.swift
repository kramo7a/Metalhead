import Combine

public extension Subscribers.Completion {
  var error: Error? {
    switch self {
    case .failure(let error):
      return error
    case .finished:
      return nil
    }
  }
}
