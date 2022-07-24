import Foundation
import SwiftUI
import Metalhead
import Combine

struct DropHandlingViewModifier<DroppedObjectType: NSItemProviderReading>: ViewModifier {
  @EnvironmentObject private var errorsObservable: ErrorsObservable
  @ObservedObject private var viewModel: DropHandlingViewModifierViewModel<DroppedObjectType>
  
  init(viewModel: DropHandlingViewModifierViewModel<DroppedObjectType>) {
    self.viewModel = viewModel
  }
  
  func body(content: Content) -> some View {
    content
      .onDrop(of: [.image, .video], isTargeted: nil) { providers, _ in
        viewModel.recieve(providers: providers)
        return true
      }
      .onReceive(viewModel.$error) { error in
        errorsObservable.set(error: error)
      }
  }
}
