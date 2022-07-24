import Combine

public extension Publishers {
  struct ZipMany<Element, FailureType: Error>: Publisher {
    public typealias Output = [Element]
    public typealias Failure = FailureType
    
    private let upstreams: [AnyPublisher<Element, Failure>]
    
    public init(_ upstreams: [AnyPublisher<Element, Failure>]) {
      self.upstreams = upstreams
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
      let initialPublisher = Just<[Element]>([])
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
      
      upstreams
        .reduce(initialPublisher) { result, upstream in
          result.zip(upstream) { $0 + [$1] }.eraseToAnyPublisher()
        }
        .subscribe(subscriber)
    }
  }
}
