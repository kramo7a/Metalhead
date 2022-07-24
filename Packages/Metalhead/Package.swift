// swift-tools-version: 5.6

import PackageDescription
import SwiftUI

// https://theswiftdev.com/the-swift-package-manifest-file/

let package = Package(
  name: "Metalhead",
  platforms: [
    .macOS(.v12), .iOS(.v15)
  ],
  products: [
    .library(
      name: "Metalhead",
      targets: ["Metalhead"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/uber/needle.git", from: "0.18.1"),
    .package(url: "https://github.com/s1ddok/Alloy.git", from: "0.17.2"),
//    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.11.0")
  ],
  targets: [
    .target(
      name: "Metalhead",
      dependencies: [
        .product(name: "NeedleFoundation", package: "needle"),
        .product(name: "Alloy", package: "Alloy")
      ]
    ),
    .testTarget(
      name: "MetalheadTests",
      dependencies: [
        "Metalhead",
//        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ]
    )
  ]
)
