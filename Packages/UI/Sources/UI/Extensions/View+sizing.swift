import Foundation
import SwiftUI
import Metalhead
import Combine

fileprivate struct SizeObservableViewModifier: ViewModifier {
  
  @State private var frameSize: CGSize?
  
  private var frameSizePublisher: AnyPublisher<CGSize, Never>

  init(frameSizePublisher: AnyPublisher<CGSize, Never>) {
    self.frameSizePublisher = frameSizePublisher
  }

  func body(content: Content) -> some View {
    content
      .frame(width: frameSize?.width, height: frameSize?.height)
      .onReceive(frameSizePublisher) {
        self.frameSize = $0
      }
  }
}

public extension View {
  func sizing(with frameSizePublisher: AnyPublisher<CGSize, Never>) -> some View {
    modifier(SizeObservableViewModifier(frameSizePublisher: frameSizePublisher))
  }
}
