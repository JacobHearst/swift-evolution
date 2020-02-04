
extension FileDescriptor {
  /// open: Open or create a file for reading or writing
  ///
  /// - Returns: A file descriptor for the open file
  public static func open(
    _ path: FilePath,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FilePermissions? = nil
  ) throws -> FileDescriptor {
    try FileDescriptor.open(
      path.bytes, mode, options: options, permissions: permissions)
  }

  /// TODO: Docs
  public static func open(
    _ path: UnsafePointer<CChar>,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FilePermissions? = nil
  ) throws -> FileDescriptor {
    let oFlag = mode.rawValue | options.rawValue
    let desc: CInt
    if let permissions = permissions {
      desc = _open(path, oFlag, permissions.rawValue)
    } else {
      precondition(!options.contains(.create), "Create must be given permissions")
      desc = _open(path, oFlag)
    }
    return try FileDescriptor(_checking: desc)
  }


  /// TODO: Docs
  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw Errno.current }
  }

  /// TODO: Docs
  public func seek(
    offset: Int64, from whence: FileDescriptor.SeekOrigin
  ) throws -> Int64 {
    let newOffset = _lseek(self.rawValue, COffT(offset), whence.rawValue)
    guard newOffset != -1 else { throw Errno.current }
    return Int64(newOffset)
  }

  /// TODO: Docs, uses cursor position
  public func read(into: UnsafeMutableRawBufferPointer) throws -> Int {
    let numBytes = _read(self.rawValue, into.baseAddress, into.count)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// TODO: Docs
  public func read(
    fromAbsoluteOffset offset: Int64, into: UnsafeMutableRawBufferPointer
  ) throws -> Int {
    let numBytes = _pread(self.rawValue, into.baseAddress, into.count, offset)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

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

  /// TODO: Docs, uses cursor position
  public func write(
    _ buffer: UnsafeRawBufferPointer
  ) throws -> Int {
    let numBytes = _write(self.rawValue, buffer.baseAddress, buffer.count)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// TODO: Docs
  public func write(
    toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer
  ) throws -> Int {
    let numBytes = _pwrite(self.rawValue, buffer.baseAddress, buffer.count, offset)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

}
