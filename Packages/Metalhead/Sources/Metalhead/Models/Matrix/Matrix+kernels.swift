public extension Matrix {
  struct Kernels {
    private init() { }
  }
}

public extension Matrix.Kernels {
  static var laplasian: Matrix {
    .init([
      [1, 4, 1],
      [4, -20, 4],
      [1, 4, 1]
    ])
  }
}

public extension Matrix.Kernels {
  struct Differencial {
    public static var X: Matrix  {
      .init([
        [ -1, 1 ],
        [ -1, 1 ]
      ])
    }
    public static var Y: Matrix  {
      .init([
        [  1,  1 ],
        [ -1, -1 ]
      ])
    }
    public static var XInv: Matrix  {
      .init([
        [ 1, -1 ],
        [ 1, -1 ]
      ])
    }
    public static var YInv: Matrix  {
      .init([
        [ -1, -1 ],
        [  1,  1 ]
      ])
    }
  }
}

public extension Matrix.Kernels {
  struct Roberts {
    public static var X: Matrix {
      .init([
        [ 0, 1 ],
        [ -1, 0 ]
      ])
      
    }
    public static var Y: Matrix {
      .init([
        [  1,  0 ],
        [  0, -1 ]
      ])
      
    }
    public static var XInv: Matrix {
      .init([
        [ 0, -1 ],
        [ 1,  0 ]
      ])
      
    }
    public static var YInv: Matrix {
      .init([
        [ -1, 0 ],
        [  0, 1 ]
      ])
    }
  }
}

public extension Matrix.Kernels {
  struct Prewitt {
    public static var X: Matrix {
      .init([
        [1, 0, -1],
        [1, 0, -1],
        [1, 0, -1]
      ])
    }
    public static var XInv: Matrix {
      .init([
        [-1, 0, 1],
        [-1, 0, 1],
        [-1, 0, 1]
      ])
    }
    public static var Y: Matrix {
      .init([
        [1, 1, 1],
        [0, 0, 0],
        [-1, -1, -1]
      ])
    }
    public static var YInv: Matrix {
      .init([
        [-1, -1, -1],
        [0, 0, 0],
        [1, 1, 1]
      ])
    }
  }
}

public extension Matrix.Kernels {
  struct Sobel {
    public static var X: Matrix {
      .init([
        [1, 0, -1],
        [2, 0, -2],
        [1, 0, -1]
      ])
    }
    public static var XInv: Matrix {
      .init([
        [-1, 0, 1],
        [-2, 0, 2],
        [-1, 0, 1]
      ])
    }
    public static var Y: Matrix {
      .init([
        [1, 2, 1],
        [0, 0, 0],
        [-1, -2, -1]
      ])
    }
    public static var YInv: Matrix {
      .init([
        [-1, -2, -1],
        [0, 0, 0],
        [1, 2, 1]
      ])
    }
    public static var XYInv: Matrix {
      .init([
        [-2, -2, 0],
        [-2, 0, 2],
        [0, 2, 2]
      ])
    }
  }
}

public extension Matrix.Kernels {
  struct Sobel5x5 {
    public static var X: Matrix {
      .init([
        [1, 2, 0, -2, -1],
        [2, 3, 0, -3, -2],
        [3, 5, 0, -5, -3],
        [2, 3, 0, -3, -2],
        [1, 2, 0, -2, -1]
      ])
    }
    public static var Y: Matrix {
      .init([
        [1, 2, 3, 2, 1],
        [2, 3, 5, 3, 2],
        [0, 0, 0, 0, 0],
        [-2, -3, -5, -3, -2],
        [-1, -2, -3, -2, -1]
      ])
    }
    public static var XInv: Matrix {
      .init([
        [-1, -2, 0, 2, 1],
        [-2, -3, 0, 3, 2],
        [-3, -5, 0, 5, 3],
        [-2, -3, 0, 3, 2],
        [-1, -2, 0, 2, 1]
      ])
    }
    public static var YInv: Matrix {
      .init([
        [-1, -2, -3, -2, -1],
        [-2, -3, -5, -3, -2],
        [0, 0, 0, 0, 0],
        [2, 3, 5, 3, 2],
        [1, 2, 3, 2, 1]
      ])
    }
  }
}

public extension Matrix.Kernels {
  static var average3x3: Matrix<Float> {
    let v: Float = 1/9
    
    return .init([
      [v, v, v],
      [v, v, v],
      [v, v, v]
    ])
  }
}
