import Combine
import Foundation

public extension NSItemProvider {
  func loadObjectPublisher<ObjectType: NSItemProviderReading>() -> AnyPublisher<ObjectType, Error> {
    Future { [unowned self] promise in
      self.loadObject(ofClass: ObjectType.self) { nsItemProviderReading, error in
        if let loadedImage = nsItemProviderReading as? ObjectType {
          promise(.success(loadedImage))
        } else {
          promise(.failure(error ?? NSItemProviderReadingError.nsItemProviderReadingError))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
