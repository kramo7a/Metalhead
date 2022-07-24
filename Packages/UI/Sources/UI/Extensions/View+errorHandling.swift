import Foundation
import SwiftUI
import Metalhead

fileprivate struct ErrorHandlingViewModifier: ViewModifier {
  @ObservedObject private var errorsObservable: ErrorsObservable
  
  init(errorsObservable: ErrorsObservable) {
    self.errorsObservable = errorsObservable
  }
  
  func body(content: Content) -> some View {
    content
      .environmentObject(errorsObservable)
      .background(
        EmptyView()
          .alert(item: $errorsObservable.errorAlert) { (currentAlert: ErrorAlert) in
            Alert(
              title: Text(currentAlert.title),
              message: Text(currentAlert.message),
              dismissButton: .default(Text(currentAlert.dismissButtonTitle)) {
                currentAlert.onDismiss?()
              }
            )
          }
      )
  }
}

public extension View {
  func errorHandling(errorsObservable: ErrorsObservable = ErrorsObservable()) -> some View {
    modifier(ErrorHandlingViewModifier(errorsObservable: errorsObservable))
  }
}
