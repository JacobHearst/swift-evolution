import Foundation
import System

public typealias Path = System.Path


// For testing
internal protocol SynchronousFileOperationExamples {
  // Returns number of bytes copied
  static func copyFileContents(from: Path, into: (UInt8) throws -> ()) throws -> Int

  // Recommended default value of `true` for overwriteIfExists... Really want default protocol args.
  static func copyFile(from: Path, to: Path, overwriteIfExits: Bool) throws

  static func copyFolderContents(from: Path, to: Path) throws
  static func createTemporaryDirectory(under: Path) throws -> Path
  static func printWorkingDirectory() throws
  // ...
}
extension SynchronousFileOperationExamples {
  static func copyFileContents(from: Path, into: (UInt8) throws -> ()) throws -> Int {
    fatalError()
  }
  internal static func copyFile(from: Path, to: Path, overwriteIfExits: Bool) throws {
    fatalError()
  }
  internal static func copyFolderContents(from: Path, to: Path) throws {
    fatalError()
  }
  internal static func createTemporaryDirectory(under: Path) throws -> Path {
    fatalError()
  }
  internal static func printWorkingDirectory() throws {
    fatalError()
  }
}

internal enum WithFoundation: SynchronousFileOperationExamples {
  internal static func copyFile(from: Path, to: Path, overwriteIfExits: Bool = true) throws {
    let fm = FileManager.default
    let destPathString = to.asString
    if overwriteIfExits && fm.fileExists(atPath: destPathString) {
      try fm.removeItem(atPath: destPathString)
    }
    try FileManager.default.copyItem(atPath: from.asString, toPath: destPathString)
  }
}

internal enum WithSystem: SynchronousFileOperationExamples {

}

internal enum WithFileIO: SynchronousFileOperationExamples {

}



