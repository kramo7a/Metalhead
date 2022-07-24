import CoreGraphics

public extension CGSize {
  func scaled(by factor: CGFloat) -> Self {
    .init(
      width: width * factor,
      height: height * factor
    )
  }
}
