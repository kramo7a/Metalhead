import Foundation
import SwiftUI
import Metalhead
import Combine

public extension View {
  func dropHandling<DroppedObjectType: NSItemProviderReading>(_ droppedObjectsBinding: Binding<[DroppedObjectType]>) -> some View {
    let viewModel = DropHandlingViewModifierViewModel(droppedObjectsBinding: droppedObjectsBinding)
    return modifier(DropHandlingViewModifier(viewModel: viewModel))
  }
}
