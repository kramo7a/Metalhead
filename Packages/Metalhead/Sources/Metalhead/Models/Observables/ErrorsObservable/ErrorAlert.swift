import SwiftUI

public struct ErrorAlert: Identifiable {
  public let id = UUID()
  public let title: String
  public let message: String
  public let dismissButtonTitle: String
  public let onDismiss: (() -> Void)?
}
