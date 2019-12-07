


//try WithFoundation.copyFile(from: Path("/tmp/a/bar.txt"), to: "/tmp/b/xbar.txt")


func tryCopyFile() {
  do {
    try WithSystem.copyFileContents(from: Path("/tmp/a/bar.txt")) {
      print(UnicodeScalar($0))
    }
  } catch {
    dump(error)
    fatalError()
  }
}
tryCopyFile()

// Do a `tree`-like printout

let treeExample = Path("/tmp/treeExample")

import Foundation

// Mimic tree -FU using FileManager
extension WithFoundation {
  static func treeFU(_ path: Path) throws {
    let entries = WithFoundation.RecursiveEntries(path)
    for entry in entries {
      print(entry.formatted())
    }
  }
}
try! WithFoundation.treeFU(treeExample)


print("Done")


import System

extension WithSystem {
  static func treeFU(_ path: Path) throws {
    fatalError()
  }
}
try! WithSystem.treeFU(treeExample)

// tree:
//   -F  Append  a `/' for directories, a `=' for socket files, a `*' for executable files, and a `|' for FIFO's



