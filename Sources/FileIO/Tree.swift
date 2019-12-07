// An example implementation of something similar to the `tree` command line utility

// TODO: Make sure we don't export this extension...
extension String: Error {}

//  Output style of `tree -F` is:
//
//  treeExample
//  ├── a.txt
//  ├── b.sh*
//  ├── c
//  ├── dir/
//  │   ├── link.txt -> ../a.txt
//  │   ├── nested/
//  │   │   ├── d.txt
//  │   │   └── fifo|
//  │   ├── nested2/
//  │   │   ├── exec_link -> ../../b.sh*
//  │   │   └── z_dir/
//  │   │       ├── e.txt
//  │   │       ├── f.txt
//  │   │       └── g.txt
//  │   └── z.txt
//  ├── link_to_nested.txt -> dir/nested2/z_dir/f.txt
//  ├── somesocket=
//  ├── y.txt
//  └── zz.txt
//
//  4 directories, 15 files
struct Entry {
  enum FileKind {
    case plain(isExecutable: Bool)
    case socket
    case fifo
    case directory
    case symlink(target: String) // FIXME: target needs to be an Entry for the metacharacter
  }

  let name: String
  let kind: FileKind
  let level: Int
}

extension Entry {
  // FIXME: Doesn't omit indentation bars for last leaf, which needs to be communicated somehow
  // FIXME: Doesn't acount for last entry using `└──` instead of `├──`.
  func formatted() -> String {
    var result = String(repeating: "│   ", count: level - 1)
    result += "├── \(name)"
    switch self.kind {
    case .plain(isExecutable: let exec):
      if exec { result += "*" }
    case .socket: result += "="
    case .fifo: result += "|"
    case .directory: result += "/"
    case .symlink(target: let target): result += " -> \(target)"
      // FIXME: We need to append target's metacharacter...
    }
    return result
  }
}

// MARK: - With System

import System



// MARK: - With Foundation

import Foundation

extension Entry {
  init(
    _ enumerator: FileManager.DirectoryEnumerator,
    _ ent: FileManager.DirectoryEnumerator.Iterator.Element // aka `Any` :-(
  ) throws { // aka `Any` :-(
    guard let fullName = ent as? String else {
      throw "expected string instance for given FileManager.DirectoryEnumerator.Iterator.Element"
    }
    guard let fileAttrType = enumerator.fileAttributes?[.type] as? FileAttributeType else {
      fatalError("wha?")
    }
    let level = enumerator.level

    let name = URL(fileURLWithPath: fullName).pathComponents.last!

    switch fileAttrType {
    case .typeDirectory:
      self = Entry(name: name, kind: .directory, level: level)

    case .typeRegular:
      guard let posixPermissions = enumerator.fileAttributes?[.posixPermissions] as? NSNumber else {
        fatalError("wha?")
      }
      let exec = 0o111 & posixPermissions.uint16Value != 0
      self = Entry(name: name, kind: .plain(isExecutable: exec), level: level)

    case .typeSocket:
      self = Entry(name: name, kind: .socket, level: level)

    case .typeSymbolicLink:
      let target = try FileManager.default.destinationOfSymbolicLink(
        atPath: treeExample.asString + "/" + fullName)
      self = Entry(name: name, kind: .symlink(target: target), level: level)

    case .typeUnknown:
      // FIXME: Does this mean fifo, or could it be something else
      self = Entry(name: name, kind: .fifo, level: level)

    default: throw "Unhandled file attribute type \(fileAttrType)"
    }
  }
}

extension WithFoundation {
  struct RecursiveEntries: Sequence {
    typealias Element = Entry

    let path: Path

    init(_ path: Path) {
      self.path = path
    }

    struct Iterator: IteratorProtocol {
      let path: Path
      var enumerator: FileManager.DirectoryEnumerator
      var enumeratorIterator: FileManager.DirectoryEnumerator.Iterator

      init(_ path: Path) {
        guard let enumerator = FileManager.default.enumerator(atPath: path.asString) else {
          fatalError("No FileManager enumerator provided for \(path.asString)")
        }
        self.path = path
        self.enumerator = enumerator
        self.enumeratorIterator = enumerator.makeIterator()
      }

      mutating func next() -> Entry? {
        guard let ent = enumeratorIterator.next() else { return nil }
        do {
          return try Entry(enumerator, ent)
        } catch {
          // FIXME: This is where we need generators or throwing iterators
          dump(error)
          fatalError()
        }
      }
    }

    func makeIterator() -> Iterator { Iterator(path) }
  }
}
