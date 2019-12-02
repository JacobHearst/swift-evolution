import Foundation
import System

public typealias Path = System.Path

// For testing
internal protocol FileOperationExamples {
  static func copyFolderContents(from: Path, to: Path)
  static func createTemporaryDirectory(under: Path) -> Path
  // ...
}


internal enum WithFoundation: FileOperationExamples {
  internal static func copyFolderContents(from: Path, to: Path) {
    fatalError()
  }
  internal static func createTemporaryDirectory(under: Path) -> Path {
    fatalError()

  }
}
internal enum WithSystem: FileOperationExamples {
  internal static func copyFolderContents(from: Path, to: Path) {
    fatalError()

  }
  internal static func createTemporaryDirectory(under: Path) -> Path {
    fatalError()

  }
}
internal enum WithFileIO: FileOperationExamples {
  internal static func copyFolderContents(from: Path, to: Path) {
    fatalError()

  }
  internal static func createTemporaryDirectory(under: Path) -> Path {
    fatalError()

  }
}



