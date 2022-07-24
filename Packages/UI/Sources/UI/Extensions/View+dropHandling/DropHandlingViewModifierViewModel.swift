import Foundation
import SwiftUI
import Metalhead
import Combine

final class DropHandlingViewModifierViewModel<DroppedObjectType: NSItemProviderReading>: ObservableObject {
  
  private var cancellables = Set<AnyCancellable>()
  @Binding private var droppedObjectsBinding: [DroppedObjectType]
  @Published var error: Error?
  
  init(droppedObjectsBinding: Binding<[DroppedObjectType]>) {
    self._droppedObjectsBinding = droppedObjectsBinding
  }
  
  func recieve(providers: [NSItemProvider]) {
    let loadObjectFuture = providers.map { $0.loadObjectPublisher() as AnyPublisher<DroppedObjectType, Error> }
    Publishers.ZipMany(loadObjectFuture)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        guard let error = completion.error else { return }
        self.error = error
      } receiveValue: { images in
        self.droppedObjectsBinding = images
      }.store(in: &cancellables)
  }
}
