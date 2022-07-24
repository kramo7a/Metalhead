// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// https://www.wwdcnotes.com/notes/wwdc22/110401/
// https://github.com/apple/swift-evolution/blob/main/proposals/0303-swiftpm-extensible-build-tools.md
// https://theswiftdev.com/the-swift-package-manifest-file/

let package = Package(
  name: "NeedleGeneratePlugin",
  products: [
    .plugin(name: "GenerateNeedleGenerated", targets: ["GenerateNeedleGenerated"])
  ],
  dependencies: [],
  targets: [
    .executableTarget(
      name: "runNeedle",
      dependencies: []
    ),
    .plugin(
      name: "GenerateNeedleGenerated",
      capability: .buildTool(),
      dependencies: ["runNeedle"]
    )
  ]
)
