import Foundation

public struct CodableImage: Codable, Hashable {

  public let image: Image
  
  public init(image: Image) {
    self.image = image
  }

  // MARK: - Codable

  public enum CodingKeys: String, CodingKey {
    case image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let data = try container.decode(Data.self, forKey: CodingKeys.image)

    guard let image = Image(data: data) else {
      throw DecodingError.dataCorruptedError(forKey: CodingKeys.image, in: container, debugDescription: "Image decoding failed")
    }

    self.image = image
  }

  public func encode(to encoder: Swift.Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    if let data = image.pngData() {
      try container.encode(data, forKey: CodingKeys.image)
    } else {
      try container.encodeNil(forKey: CodingKeys.image)
    }
  }
}

public extension Image {
  var codable: CodableImage {
    CodableImage(image: self)
  }
}
