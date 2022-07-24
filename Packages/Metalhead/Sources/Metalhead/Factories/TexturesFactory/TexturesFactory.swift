import MetalKit
import Foundation
import AVFoundation
import CoreVideo
import Metal
import Alloy

public protocol TexturesFactory {
  
  func createTexture(from imageBuffer: CVImageBuffer) throws -> MTLTexture
  
  func createTexture(from image: Image) throws -> MTLTexture
  
  func createTexture(from descriptor: MTLTextureDescriptor?) throws -> MTLTexture
  
  func createTexture<T>(from matrix: Matrix<T>) throws -> MTLTexture
  
  func createEmptyTexture(size: MTLSize, pixelFormat: MTLPixelFormat) throws -> MTLTexture
}

final class TexturesFactoryImpl: TexturesFactory {
  
  private let pixelFormat: PixelFormat
  private let metalDevice: MTLDevice
  
  private let textureCache: CVMetalTextureCache?
  private let textureLoader: MTKTextureLoader
  
  init(pixelFormat: PixelFormat, metalDevice: MTLDevice, textureLoader: MTKTextureLoader) {
    self.pixelFormat = pixelFormat
    self.metalDevice = metalDevice
    
    var textureCache: CVMetalTextureCache?
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, metalDevice, nil, &textureCache)
    
    self.textureCache = textureCache
    self.textureLoader = textureLoader
  }
  
  func createTexture(from image: Image) throws -> MTLTexture {
    guard let cgImage = image.cgImage else {
      throw ImageProcessingError.cannotCreateCGImageFromImage
    }
    
    let texture = try textureLoader.newTexture(cgImage: cgImage)
    return texture
  }
  
  func createTexture(from descriptor: MTLTextureDescriptor?) throws -> MTLTexture {
    guard let descriptor = descriptor, let texture = metalDevice.makeTexture(descriptor: descriptor) else { throw ImageProcessingError.cannotCreateTexture }
    
    return texture
  }
  
  func createTexture<T>(from matrix: Matrix<T>) throws -> MTLTexture {
    let size = MTLSize(width: matrix.columns, height: matrix.rows, depth: 1)
    let kernelsRegion = MTLRegion(origin: .zero, size: size)
    let kernelsTexture = try createEmptyTexture(size: size, pixelFormat: .r32Float)
    kernelsTexture.replace(
      region: kernelsRegion,
      mipmapLevel: 0,
      withBytes: matrix.values,
      bytesPerRow: MemoryLayout<T>.stride * matrix.columns * kernelsTexture.sampleCount
    )
    return kernelsTexture
  }
  
  func createEmptyTexture(
    size: MTLSize,
    pixelFormat: MTLPixelFormat
  ) throws -> MTLTexture {
    let descriptor = MTLTextureDescriptor()
    descriptor.height = size.height
    descriptor.width = size.width
    descriptor.depth = size.depth
    descriptor.usage = [.shaderRead, .shaderWrite]
    descriptor.pixelFormat = pixelFormat
    
    return try self.createTexture(from: descriptor)
  }
  
  func createTexture(from imageBuffer: CVImageBuffer) throws -> MTLTexture {
    try createTexture(
      from: imageBuffer,
      planeIndex: 0,
      width: CVPixelBufferGetWidth(imageBuffer),
      height: CVPixelBufferGetHeight(imageBuffer),
      pixelFormat: .bgra8Unorm
    )
  }
  
  private func createYCbCrTextures(from imageBuffer: CVImageBuffer) throws -> [MTLTexture] {
    let planeYIndex = 0
    let textureY = try createTexture(
      from: imageBuffer,
      planeIndex: planeYIndex,
      width: CVPixelBufferGetWidthOfPlane(imageBuffer, planeYIndex),
      height: CVPixelBufferGetHeightOfPlane(imageBuffer, planeYIndex),
      pixelFormat: .r8Unorm
    )
    
    let planeCbCrIndex = 1
    let textureCbCr = try createTexture(
      from: imageBuffer,
      planeIndex: planeCbCrIndex,
      width: CVPixelBufferGetWidthOfPlane(imageBuffer, planeCbCrIndex),
      height: CVPixelBufferGetHeightOfPlane(imageBuffer, planeCbCrIndex),
      pixelFormat: .rg8Unorm
    )
    
    return [textureY, textureCbCr]
  }
  
  private func createTexture(
    from imageBuffer: CVImageBuffer,
    planeIndex: Int,
    width: Int,
    height: Int,
    pixelFormat: MTLPixelFormat
  ) throws -> MTLTexture {
    guard let textureCache else { throw MetalError.failedToCreateTextureCache }
    
    var imageTexture: CVMetalTexture?
    
    // https://developer.apple.com/documentation/corevideo/1456754-cvmetaltexturecachecreatetexture
    let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, pixelFormat, width, height, planeIndex, &imageTexture)
    
    guard
      let unwrappedImageTexture = imageTexture,
      let texture = CVMetalTextureGetTexture(unwrappedImageTexture),
      result == kCVReturnSuccess
    else { throw MetalError.failedToCreateTextureFromImage }
    
    return texture
  }
}
