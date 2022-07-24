public enum ImageProcessingError: String, Error {
  case imageBufferCreationError
  case cannotCreateCGImageFromImage
  case cannotCreateTexture
}
