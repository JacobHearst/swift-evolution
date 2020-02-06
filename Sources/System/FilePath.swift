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

/// A managed, null-terminated bag-of-bytes representing a location on the file system
///
/// This example creates a FilePath from a string literal and uses it to open and append to a log file
///
///     let message: String = ...
///     let path: FilePath = "/tmp/log"
///     let fd = try FileDescriptor.open(path, .writeOnly, options: .append)
///     try fd.closeAfter { _ = try fd.write(message.utf8) }
///
/// - Note: FilePaths are Equatable and Hashable by equating / hashing their raw byte contents,
/// allowing them to be used as keys in Dictionaries. However, path equivalence is a
/// file-system-specific concept. A specific file system may, e.g., consider paths equivalent after
/// case conversion, Unicode normalization, or resolving symbolic links.
public struct FilePath {
  internal var bytes: [CChar]

  /// Creates an empty path
  public init() {
    self.bytes = [0]
    _invariantCheck()
  }
}

//
// MARK: - Public Interfaces
//
extension FilePath {
  /// The length of the file path, excluding the null-terminator
  public var length: Int { bytes.count - 1 }

  /// MAXPATHLEN: the longest permissable path length after expanding symbolic links.
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
  /// Create a file path by copying null-termianted bytes from `cString`
  ///
  /// - Parameter cString: A pointer to null-terminated bytes
  public init(cString: UnsafePointer<CChar>) {
    self.init(UnsafeBufferPointer(start: cString, count: 1+_strlen(cString)))
  }

  /// Calls the given closure with a pointer to the contents of the file path,
  /// represented as a pointer to null-terminated bytes.
  ///
  /// The pointer passed as an argument to `body` is valid only during the
  /// execution of `withCString(_:)`. Do not store or return the pointer for
  /// later use.
  ///
  /// - Parameter body: A closure with a pointer parameter that points to a
  ///   null-terminated sequence of bytes. If `body` has a return
  ///   value, that value is also used as the return value for the
  ///   `withCString(_:)` method. The pointer argument is valid only for the
  ///   duration of the method's execution.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  public func withCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result {
    try bytes.withUnsafeBufferPointer { try body($0.baseAddress!) }
  }

  // TODO: in the future, with opaque result types with associated
  // type constraints, we want to provide a RAC for terminated
  // contents and unterminated contents.
}

//
// MARK: - String interfaces
//
extension FilePath: ExpressibleByStringLiteral {
  /// Create a file path a String literal's UTF-8 contents
  ///
  /// - Parameter stringLiteral: A string literal whose UTF-8 contents will be the contents of the created path
  public init(stringLiteral: String) {
    self.init(stringLiteral)
  }

  /// Create a file path from a string's UTF-8 contents
  ///
  /// - Parameter string: A string whose UTF-8 contents will be the contents of the created path
  public init(_ string: String) {
    var str = string
    self = str.withUTF8 { FilePath($0._asCChar) }
  }
}
extension String {
  /// Create a string from a file path
  ///
  /// - Parameter path: The file path whose bytes will be interpreted as UTF-8.
  /// Any encoding errors in the path's bytes will be error corrected.
  /// This means that, depending on the semantics of the specific file system, some paths
  /// cannot be round-tripped through a string.
  public init(_ path: FilePath) {
    self = path.withCString { String(cString: $0) }
  }
}

extension FilePath: CustomStringConvertible {
  public var description: String { String(self) }
}


extension FilePath {
  fileprivate func _invariantCheck() {
    assert(bytes.last! == 0)
    assert(bytes.firstIndex(of: 0) == bytes.count - 1)
  }
}

// TODO: Look at SPM, which has types and POSIX stuff.
