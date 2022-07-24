import SwiftUI

#if os(visionOS)
extension SimultaneousGesture<SimultaneousGesture<DragGesture, MagnifyGesture>, RotateGesture3D>.Value {
    func components() -> (Vector3D, Size3D, Rotation3D) {
      let translation = self.first?.first?.translation3D ?? .zero
      let magnification = self.first?.second?.magnification ?? 1
      let size = Size3D(width: magnification, height: magnification, depth: magnification)
      let rotation = self.second?.rotation ?? .identity
      return (translation, size, rotation)
    }
  }
#endif
