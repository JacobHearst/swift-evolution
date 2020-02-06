
extension FileDescriptor {
  // Uses cursor position
  //
  // TODO: Return a ByteBuffer
  /*public*/internal func read(numBytes: Int) throws -> [UInt8] {
    return try Array<UInt8>(unsafeUninitializedCapacity: numBytes) { buf, count in
      count = try read(into: UnsafeMutableRawBufferPointer(buf))
    }
  }

  //
  // TODO: Return a ByteBuffer
  /*public*/internal func read(
    fromAbsoluteOffset offset: Int64, numBytes: Int
  ) throws -> [UInt8] {
    return try Array<UInt8>(unsafeUninitializedCapacity: numBytes) { buf, count in
      count = try read(fromAbsoluteOffset: offset, into: UnsafeMutableRawBufferPointer(buf))
    }
  }

  // TODO: similarly for write

}

// Eek, how to avoid the copy for the mutable template?
//    public static func makeTemporary(_ template: String) throws -> Descriptor {
//      guard let desc = mkstemp(template) else { throw err }
//    }

