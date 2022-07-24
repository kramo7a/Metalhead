import Combine

public extension Publisher where Failure == Error {
  
  func bindErrors(to errorsObservable: ErrorsObservable?) -> AnyPublisher<Output, Never> {
    self.catch { error in
      errorsObservable?.set(error: error)
      return Empty<Output, Never>()
    }.eraseToAnyPublisher()
  }
}
