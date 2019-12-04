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

// TODO: Should we have an UnsafePath that doesn't own?
public struct Path {
  // Includes nul-terminator
  public var bytes: [CChar]

  public var length: Int { bytes.count - 1 }

  public var bytesDroppingNulTerminator: ArraySlice<CChar> { bytes.dropLast() }

  public init() {
    self.bytes = [0]
  }
  internal init<C: Collection>(_ bytes: C) where C.Element == CChar {
    self.bytes = Array(bytes)
    self.bytes.append(0)
  }

  public init(nulTerminatedCPtr cPtr: UnsafePointer<CChar>) {
    self.init(UnsafeBufferPointer(start: cPtr, count: 1+strlen(cPtr)))
  }

  public init(_ str: String) {
    var str = str
    self = str.withUTF8 { Path($0._asCChar) }
  }

  internal init(
    unsafeUninitializedMaxLengthCapacity f: (UnsafeMutableRawPointer) throws -> Int
  ) rethrows {
    self.bytes = try Array(unsafeUninitializedCapacity: Path.maxLength) {
      (bufPtr: inout UnsafeMutableBufferPointer<Int8>, count: inout Int) in
      let len = try f(UnsafeMutableRawPointer(bufPtr.baseAddress!))
      bufPtr[len] = 0
      count = Swift.min(Path.maxLength, len + 1)
    }
    // TODO: We could consider shrinking now to save space.
  }
}
extension Path: ExpressibleByStringLiteral {
  public init(stringLiteral: String) {
    self.init(stringLiteral)
  }
  public var asString: String {
    bytesDroppingNulTerminator.withUnsafeBytes { String(decoding: $0, as: UTF8.self) }
  }
}

import Darwin
extension Path {
  public static var maxLength: Int { Int(MAXPATHLEN) }
}

