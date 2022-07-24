import SwiftUI
import UI
import Metalhead

@main
struct WavesApp: App {
  
  private let rootComponent = RootComponent()
  @State private var droppedImages: [Metalhead.Image] = []
  
  @Environment(\.openWindow) private var openWindow
  
  var body: some Scene {
    WindowGroup {
//      rootComponent.cameraMTKRenderingView
      rootComponent.imageMTKRenderingView(from: rootComponent.anImage)
        .dropHandling($droppedImages)
        .errorHandling(errorsObservable: rootComponent.errorsObservable)
        .onChange(of: droppedImages) { droppedImages in
          if droppedImages.count == 2 {
            openWindow(value: PixelDiffDestionation(firstImage: droppedImages[0].codable, secondImage: droppedImages[1].codable))
          } else {
            droppedImages.forEach {
              openWindow(value: $0.codable)
            }
          }
        }
    }
    
    WindowGroup(for: CodableImage.self) { droppedImage in
      rootComponent
        .imageMTKRenderingView(from: droppedImage.wrappedValue.image)
        .errorHandling()
    } defaultValue: { CodableImage(image: Image()) }
    
    
    WindowGroup(for: PixelDiffDestionation.self) { droppedImage in
      rootComponent
        .pixelDiffView(
          for: droppedImage.wrappedValue.firstImage.image,
          and: droppedImage.wrappedValue.secondImage.image
        )
        .errorHandling()
    } defaultValue: {
      PixelDiffDestionation(
        firstImage: CodableImage(image: Image()),
        secondImage: CodableImage(image: Image())
      )
    }
  }
}

fileprivate struct PixelDiffDestionation: Codable, Hashable {
  let firstImage: CodableImage
  let secondImage: CodableImage
}
