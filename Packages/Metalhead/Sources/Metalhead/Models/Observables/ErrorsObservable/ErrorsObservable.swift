import SwiftUI

public final class ErrorsObservable: ObservableObject {
  
  @Published public var errorAlert: ErrorAlert?
  
  public init() { }
  
  public func set(
    error: Error?,
    onDismiss: (() -> Void)? = nil
  ) {
    guard let error else { return }
    
    self.errorAlert = ErrorAlert(
      title: "Whooops..",
      message: "\(error)",
      dismissButtonTitle: "Ok, Boss",
      onDismiss: onDismiss
    )
  }
}
