import Combine
import SwiftUI

extension Publisher where Failure == Never {
  public var asErrorPublisher: Publishers.TryMap<Self, Output> {
    tryMap { $0 }
  }
}
