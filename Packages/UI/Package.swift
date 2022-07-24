// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "UI",
  platforms: [
    .macOS(.v12), .iOS(.v15)
  ],
  products: [
    .library(
      name: "UI",
      targets: ["UI"]
    ),
  ],
  dependencies: [
    .package(path: "Metalhead")
  ],
  targets: [
    .target(
      name: "UI",
      dependencies: [.byName(name: "Metalhead")]
    ),
    .testTarget(
      name: "UITests",
      dependencies: ["UI"]
    ),
  ]
)
