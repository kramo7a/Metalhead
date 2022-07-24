import AVFoundation
import Combine

extension AVCaptureDevice {
  static var videoPermissionRequest: Future<Void, Error> {
    Future { promise in
      switch authorizationStatus(for: .video) {
      case .notDetermined:
        requestAccess(for: .video) { isAuthorized in
          if isAuthorized {
            promise(.success(()))
          } else {
            promise(.failure(CameraError.deniedAuthorization))
          }
        }
      case .restricted:
        promise(.failure(CameraError.restrictedAuthorization))
      case .denied:
        promise(.failure(CameraError.deniedAuthorization))
      case .authorized:
        promise(.success(()))
      @unknown default:
        promise(.failure(CameraError.unknownAuthorization))
      }
    }
  }
}
