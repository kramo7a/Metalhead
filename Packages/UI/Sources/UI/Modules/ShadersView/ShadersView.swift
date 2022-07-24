import Foundation
import SwiftUI
import Metalhead

public struct ShadersView: View {
  
  @ObservedObject private var viewModel: ShadersViewModel
  
  private let metalRenderingBuilder: MetalRenderingBuilder
  
  public init(viewModel: ShadersViewModel, metalRenderingBuilder: MetalRenderingBuilder) {
    self.metalRenderingBuilder = metalRenderingBuilder
    self.viewModel = viewModel
  }
  
  public var body: some View {
    metalRenderingBuilder
      .mtkViewRepresantable(
        inputTexture: viewModel.inputTexture,
        shaders: viewModel.$shaders.eraseToAnyPublisher()
      )
      .frame(
        width: viewModel.frameSize.width / Screen.scaleFactor,
        height: viewModel.frameSize.height / Screen.scaleFactor
      )
  }
}
