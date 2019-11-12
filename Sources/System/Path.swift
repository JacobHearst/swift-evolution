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
  public var bytes: [CChar]

  public init() {
    self.bytes = []
  }
  public init<C: Collection>(_ bytes: C) where C.Element == CChar {
    self.bytes = Array(bytes)
  }
  public init(_ cPtr: UnsafePointer<CChar>) {
    self.init(UnsafeBufferPointer(start: cPtr, count: strlen(cPtr)))
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
      count = try f(UnsafeMutableRawPointer(bufPtr.baseAddress!))
    }
  }
}
extension Path: ExpressibleByStringLiteral {
  public init(stringLiteral: String) {
    self.init(stringLiteral)
  }
  public var asString: String {
    bytes.withUnsafeBytes { String(decoding: $0, as: UTF8.self) }
  }
}

import Darwin
extension Path {
  public static var maxLength: Int { Int(MAXPATHLEN) }

//  public mutating func reserveMaxLangth() {
//    self.bytes.reserveCapacity(Path.maxLength)
//  }
//
//  public var hasMaxLengthCapacity: Bool { bytes.capacity >= Path.maxLength }
}

