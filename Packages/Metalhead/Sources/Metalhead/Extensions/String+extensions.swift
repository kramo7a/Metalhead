public extension String {
  var pathComponentSanitized: String {
    self
      .replacingOccurrences(of: "\\W+", with: "", options: .regularExpression)
  }
}
