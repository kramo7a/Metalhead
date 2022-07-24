import Foundation

public enum MetalError: Error, LocalizedError {

  case deviceInitError
  case failedToCreateTextureCache
  case cantCreateComputeCommandEncoder
  case missingImageBuffer
  case failedToGetImageBuffer
  case failedToCreateTextureFromImage
  case failedToRetrieveTimestamp
  case couldNotCreateMTLFunction(String)
  case specifyShaderOutputParameter
  case noTexture
  case cantDetermineThreadsPerGrid
}
