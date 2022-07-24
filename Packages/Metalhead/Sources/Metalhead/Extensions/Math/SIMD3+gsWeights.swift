public extension SIMD3 where Scalar == Float {
  enum GSWeights {
    public static var rec709 = SIMD3(x: 0.2126, y: 0.7152, z: 0.0722)
    public static var rec601 = SIMD3(x: 0.299, y: 0.587, z: 0.114)
    public static var average = SIMD3(x: 1/3, y: 1/3, z: 1/3)
  }
}
