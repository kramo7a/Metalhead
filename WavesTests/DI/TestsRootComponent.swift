import NeedleFoundation
import Metalhead
import SwiftUI
import UI
import Combine
import Alloy

final class TestsRootComponent: BootstrapComponent {
  
  var pixelFormat: PixelFormat { .rgb }
  let errorsObservable: ErrorsObservable = ErrorsObservable()
  
  private lazy var texturesFactoryComponent = TexturesFactoryComponent(parent: self)
  private lazy var metalPerformerComponent = MetalPerformerComponent(parent: self)
  private lazy var texturePublishersComponent = TexturePublishersComponent(parent: self)
  private lazy var shadersFactoryComponent = ShadersFactoryComponent(parent: self)
  
  lazy var texturesFactory = texturesFactoryComponent.texturesFactory
  
  override init() {
    registerProviderFactories()
    
    super.init()
  }
  
  let context: MTLContext = try! MTLContext()
  
  private lazy var metalPerformer = metalPerformerComponent.metalPerformer
  
  @discardableResult
  func perform(
    shaders: [ShaderType],
    inputTexture: MTLTexture,
    downscaleFactor: Int,
    saveToFolder: String? = #function,
    calledFromFile: String = #file,
    fileNamePrefix: String = ""
  ) -> MTLTexture? {
    let shadersFactory = shadersFactoryComponent.shadersFactory(
      downscaleFactor: Just(downscaleFactor).eraseToAnyPublisher(),
      frameSize: Just(CGSize(width: inputTexture.width, height: inputTexture.height)).eraseToAnyPublisher()
    )
    
    var intermediateInputTexture: MTLTexture? = inputTexture
    shaders
      .enumerated()
      .forEach { index, shaderType in
        let shader = try! shadersFactory.shader(of: shaderType)
//        let shaderName = "\(fileNamePrefix) \(index). \(shader.debugLabel)"
        
        let shaderName = (shaderType.fileName != nil) ? "\(fileNamePrefix) \(index). \(shaderType.fileName!)" : nil
        
        intermediateInputTexture = try! self.perform(
          shader: shader,
          inputTexture: intermediateInputTexture,
          saveAs: shaderName,
          saveToFolder: saveToFolder,
          calledFromFile: calledFromFile
        )
      }
    
    return intermediateInputTexture
  }
  
  private func perform(
    shader: Shader,
    inputTexture: MTLTexture?,
    saveAs fileName: String? = nil,
    saveToFolder: String?,
    calledFromFile: String
  ) throws -> MTLTexture? {
    guard let inputTexture else { return nil }
    
    let commandBuffer = context.commandQueue.makeCommandBuffer()!
    
    let outputTexture = try texturesFactory.createEmptyTexture(size: inputTexture.size, pixelFormat: .r8Unorm)
    
    var shaders = [shader]
    try metalPerformer.perform(
      shaders: &shaders,
      commandBuffer: commandBuffer,
      outputTexture: outputTexture,
      inputTexture: inputTexture
    )
    
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
    
    
//    if let ht = shader as? HoughTransform {
//      let htResult = Matrix<UInt32>(buffer: ht.accumulator!, rows: ht.accumulatorHeight, columns: ht.thetaSteps)
//
//      print(htResult)
//
//      htResult
//        .findIndices { $0 > 15 }
//        .forEach { i, j in
//          print("[\(i), \(j)] = \(htResult[i, j])")
//        }
//    }
    
    if let fileName, let saveToFolder {
      try Self.saveToDirectory(
        texture: outputTexture,
        imageName: fileName,
        saveToFolder: saveToFolder,
        calledFromFile: calledFromFile
      )
    }
    
    return outputTexture
  }
  
  private class func snapshotsFolder(
    in file: String
  ) -> URL {
    let fileUrl = URL(fileURLWithPath: file, isDirectory: false)
    
    return fileUrl
      .deletingLastPathComponent()
      .appendingPathComponent("__Snapshots__")
  }
  
  private class func saveToDirectory(
    texture: MTLTexture,
    imageName: String,
    saveToFolder: String,
    calledFromFile: String
  ) throws {
    let snapshotDirectoryUrl = snapshotsFolder(in: calledFromFile)
      .appendingPathComponent("\(saveToFolder.pathComponentSanitized)")
    
    let snapshotFileUrl = snapshotDirectoryUrl
      .appendingPathComponent("\(imageName)")
      .appendingPathExtension("png")
    
    let fileManager = FileManager.default
    try fileManager.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true)
    
    let cgImage = try texture.cgImage()
    let pngData = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)).pngData()!
    
    try pngData.write(to: snapshotFileUrl)
  }
  
  class func cleanUpFolder(in testFile: String = #file) throws {
    try FileManager.default.removeItem(at: snapshotsFolder(in: testFile))
  }
}
