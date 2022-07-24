import XCTest
import Metalhead
import Alloy

struct Kernels { }


extension Kernels {
  static let identityConvolution = Matrix<Float>([
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0]
  ])
  
  static let laplasianSmall = Matrix<Float>([
    [0, 1, 0],
    [1, -4, 1],
    [0, 1, 0]
  ])
  
  
}

struct ShadersTestsData {
  let sourceMatrix = Matrix<Float>([
    [ 50,  210, 100,  100  ],
    [ 50,  10,  150,  1200 ],
    [ 50,  50,  10,   100  ],
    [ 150, 50,  1100, 100  ],
    [ 10,  10,  100,  100  ],
  ])
}
