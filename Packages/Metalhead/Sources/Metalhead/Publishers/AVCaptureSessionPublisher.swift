import AVFoundation
import Combine

public final class AVCaptureSessionPublisher: NSObject, Publisher, AVCaptureVideoDataOutputSampleBufferDelegate {
  
  public typealias Output = CVImageBuffer
  public typealias Failure = Error
  
  private let pixelFormat: PixelFormat
  
  private let imageBufferSubject = PassthroughSubject<CVImageBuffer, Error>()
  
  private let session = AVCaptureSession()
  private let videoOutput = AVCaptureVideoDataOutput()
  
  public init(pixelFormat: PixelFormat) {
    self.pixelFormat = pixelFormat
    
    super.init()
    
    do {
      try configureCaptureSession()
    } catch {
      imageBufferSubject.send(completion: .failure(error))
    }
  }
  
  public func receive<S: Subscriber>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    imageBufferSubject.receive(subscriber: subscriber)
  }
  
  private func configureCaptureSession() throws {
    session.beginConfiguration()
    
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    else { throw CameraError.cameraUnavailable }
    
    let cameraInput = try AVCaptureDeviceInput(device: camera)
    
    guard session.canAddInput(cameraInput) else { throw CameraError.cannotAddInput }
    session.addInput(cameraInput)
    
    guard session.canAddOutput(videoOutput) else { throw CameraError.cannotAddOutput }
    session.addOutput(videoOutput)
    
    weak var weakSelf = self
    videoOutput.setSampleBufferDelegate(weakSelf, queue: DispatchQueue.main)
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: pixelFormat.coreVideoType]
    
    let videoConnection = videoOutput.connection(with: .video)
    videoConnection?.videoOrientation = .portrait
    
    session.commitConfiguration()
    session.startRunning()
  }
  
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let imageBuffer = sampleBuffer.imageBuffer else { return }
    imageBufferSubject.send(imageBuffer)
  }
  
  public func captureOutput(_ output: AVCaptureOutput, didFailWithError error: Error, from connection: AVCaptureConnection) {
    imageBufferSubject.send(completion: .failure(error))
  }
}
