extension UnsafePointer where Pointee == UInt8 {
  internal var _asCChar: UnsafePointer<CChar> {
    UnsafeRawPointer(self).assumingMemoryBound(to: CChar.self)
  }
}
extension UnsafePointer where Pointee == CChar {
  internal var _asUInt8: UnsafePointer<UInt8> {
    UnsafeRawPointer(self).assumingMemoryBound(to: UInt8.self)
  }
}
extension UnsafeBufferPointer where Element == UInt8 {
  internal var _asCChar: UnsafeBufferPointer<CChar> {
    let base = baseAddress?._asCChar
    return UnsafeBufferPointer<CChar>(start: base, count: self.count)
  }
}
extension UnsafeBufferPointer where Element == CChar {
  internal var _asUInt8: UnsafeBufferPointer<UInt8> {
    let base = baseAddress?._asUInt8
    return UnsafeBufferPointer<UInt8>(start: base, count: self.count)
  }
}

// NOTE: FilePath not frozen for ABI flexibility

/// TODO: Docs
/// TODO: Note Equatable/Hashable for programmatic use and semantics over
///       raw bytes. FS behavior is FS-specific, presentation to users should
///       whatever whatever, etc. Case sensitivity, normalization, relative paths
///       symlinks, etc.
///
public struct FilePath {
  internal var bytes: [CChar]

  public init() {
    self.bytes = [0]
    _invariantCheck()
  }
}

//
// MARK: - Public Interfaces
//
extension FilePath {
  /// TODO: Docs, Length of the file path (excluding nul terminator)
  public var length: Int { bytes.count - 1 }

  /// TODO: Docs
  public static var maxLength: Int { Int(_MAXPATHLEN) }

  @available(*, deprecated, renamed: "maxLength")
  public static var MAXPATHLEN: Int { maxLength}
}
extension FilePath: Hashable, Codable {}

extension FilePath {
  internal init<C: Collection>(nulTerminatedBytes bytes: C) where C.Element == CChar {
    self.bytes = Array(bytes)
    _invariantCheck()
  }
}

extension FilePath {
  internal init<C: Collection>(_ bytes: C) where C.Element == CChar {
    var nulTermBytes = Array(bytes)
    nulTermBytes.append(0)
    self.init(nulTerminatedBytes: nulTermBytes)
  }

  internal init(
    unsafeUninitializedMaxLengthCapacity f: (UnsafeMutableRawPointer) throws -> Int
  ) rethrows {
    self.init(nulTerminatedBytes:
      try Array(unsafeUninitializedCapacity: FilePath.maxLength) {
        (bufPtr: inout UnsafeMutableBufferPointer<Int8>, count: inout Int) in
        let len = try f(UnsafeMutableRawPointer(bufPtr.baseAddress!))
        bufPtr[len] = 0
        count = Swift.min(FilePath.maxLength, len + 1)
      })
    // TODO: We could consider shrinking now to save space.
  }
}

//
// MARK: - CString interfaces
//
extension FilePath {
  /// TODO: docs
  public init(cString ptr: UnsafePointer<CChar>) {
    self.init(UnsafeBufferPointer(start: ptr, count: 1+_strlen(ptr)))
  }

  /// TODO: docs
  public func withCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result {
    try bytes.withUnsafeBufferPointer { try body($0.baseAddress!) }
  }

  // TODO: in the future, with opaque result types with associated
  // type constraints, we want to provide a RAC for termianted
  // contents and unterminated contents.
}

//
// MARK: - String interfaces
//
extension FilePath: ExpressibleByStringLiteral {
  /// TODO: docs
  public init(stringLiteral: String) {
    self.init(stringLiteral)
  }

  /// TODO: docs
  public init(_ str: String) {
    var str = str
    self = str.withUTF8 { FilePath($0._asCChar) }
  }
}
extension String {
  /// TODO: Docs
  public init(_ path: FilePath) {
    self = path.withCString { String(cString: $0) }
  }
}

extension FilePath: CustomStringConvertible {
  /// TODO: docs
  public var description: String { String(self) }
}


extension FilePath {
  fileprivate func _invariantCheck() {
    assert(bytes.last! == 0)
    assert(bytes.firstIndex(of: 0) == bytes.count - 1)
  }
}

// TODO: Look at SPM, which has types and POSIX stuff.
