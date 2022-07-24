import Foundation
import PackagePlugin

@main
struct GenerateNeedleGenerated: BuildToolPlugin {
//  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
//    let sourcesFolder = target.directory
//    let generatedFile = sourcesFolder.appending("Generated").appending("NeedleGenerated.swift")
//
//    let input = sourcesFolder
//    let output = generatedFile
//
//    return [
//      PackagePlugin.Command.buildCommand(
//        displayName: "Generating dependencies with Needle for \(target.name)",
//        executable: try context.tool(named: "runNeedle").path,
//        arguments: [input, output],
//        environment: ["PATH": "$PATH:/opt/homebrew/bin", "SOURCEKIT_LOGGING": "0"],
//        inputFiles: [input],
//        outputFiles: [output]
//      )
//    ]
//  }
  
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
    let sourcesFolder = target.directory
    let generatedFile = sourcesFolder.appending("Generated").appending("NeedleGenerated.swift")
    
    let input = sourcesFolder
    let output = generatedFile
    
    generate(input: input, output: output)
    return []
  }

  
  private func generate(input: Path, output: Path) {
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.arguments = ["-c", "needle generate \(input.string) \(output.string)"]
    task.environment = ["PATH": "$PATH:/opt/homebrew/bin", "SOURCEKIT_LOGGING": "0"]
    
    let outputPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = outputPipe
    try! task.run()
    task.waitUntilExit()
    
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: outputData, as: UTF8.self)
    
    print("result: \(output)")
  }
}
