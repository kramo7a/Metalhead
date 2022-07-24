import SwiftUI
import Combine

public extension Publisher where Output == MTLTexture {
  var frameSize: AnyPublisher<CGSize, Failure> {
    removeDuplicates { $0.width == $1.width && $0.height == $1.height }
      .map { CGSize(width: $0.width, height: $0.height) }
      .eraseToAnyPublisher()
  }
}

public extension Publisher where Output == CGSize {
  func scale(with multiplier: CGFloat) -> AnyPublisher<Output, Failure> {
    map { CGSize(width: $0.width / multiplier, height: $0.height / multiplier) }
      .eraseToAnyPublisher()
  }
}
