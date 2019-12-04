


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

let aPath = Path("/tmp/a")

import Foundation

enum EntryKind {
  case directory
  case file
  case socket
  case symlink

  case unknown
}
extension EntryKind {
  init(from: FileAttributeType) {
    switch from {
    case .typeDirectory: self = .directory
    case .typeRegular: self = .file
    case .typeSocket: self = .socket
    case .typeSymbolicLink: self = .symlink

    default: self = .unknown
    }
  }
}

guard let enumerator = FileManager.default.enumerator(atPath: aPath.asString) else {
  fatalError("No FileManager enumerator provided for \(aPath.asString)")
}
print(enumerator.fileAttributes?[.type] ?? "none")

print()
for entry in enumerator {
  guard let name = entry as? String,
        let fileAttrType = enumerator.fileAttributes?[.type] as? FileAttributeType
  else {
    fatalError("wha?")
  }

  let kind = EntryKind(from: fileAttrType)
  print("\(name), level \(enumerator.level), kind: \(kind)")

  guard let posixPermissions = enumerator.fileAttributes?[.posixPermissions] as? NSNumber else {
    fatalError("wha?")
  }
  let isExec = false
  print(String(posixPermissions.int16Value, radix: 8))
}

print("Done")

// tree:
//   -F  Append  a `/' for directories, a `=' for socket files, a `*' for executable files, and a `|' for FIFO's
