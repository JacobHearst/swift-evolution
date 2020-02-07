
// TODO: If any of these functions become inlinable, and releases are moved between the syscall and
// the access of `errno`, then an arbitrary destructor could override `errno`. We need a way to
// prevent that.

// TODO: Retry on EINTR for everything except close.

extension FileDescriptor {
  // TODO: Consider an open that is createIfDoesntExist with non-optional permissions

  /// open: Open or create a file for reading or writing
  ///
  /// - Parameters:
  ///   - path: Location of the file to be opened
  ///   - mode: Access the file for reading, writing, or both
  ///   - options: Specify behavior
  ///   - permissions: File permissions for created files
  /// - Throws: `Errno`
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

  /// open: Open or create a file for reading or writing
  ///
  /// - Parameters:
  ///   - path: A null-terminated C string specifying the location of the file to be opened
  ///   - mode: Access the file for reading, writing, or both
  ///   - options: Specify behavior
  ///   - permissions: File permissions for created files
  /// - Throws: `Errno`
  /// - Returns: A file descriptor for the open file
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


  /// close: Delete a file descriptor
  ///
  /// Deletes the file descriptor from the per-process object reference table.
  /// If this is the last reference to the underlying object, the object will
  /// be deactivated.
  ///
  /// - Throws: `Errno`
  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw Errno.current }
  }

  /// Ensures that `self` is closed after running `body`, even if `body` throws an error.
  ///
  /// - Parameter body: The closure to run. If the closure throws an error, the file descriptor will
  /// be closed and the closure's error will be re-thrown
  /// - Throws: An error from `body` if there was one, otherwise `Errno` if the attempt to close
  /// the file descriptor fails.
  /// - Returns: The result of the closure, if successful
  public func closeAfter<R>(_ body: () throws -> R) throws -> R {
    let result: R
    do {
      result = try body()
    } catch {
      _ = try? self.close() // Squash close error and throw closure's
      throw error
    }
    try self.close()
    return result
  }

  /// lseek: Reposition read/write file offset
  ///
  /// Reposition the offset for the given file descriptor
  ///
  /// - Parameters:
  ///   - offset: The offset to reposition to
  ///   - whence: Where the offset is applied to
  /// - Throws: `Errno`
  /// - Returns: The offset location as measured in bytes from the beginning of the file
  @discardableResult
  public func seek(
    offset: Int64, from whence: FileDescriptor.SeekOrigin
  ) throws -> Int64 {
    let newOffset = _lseek(self.rawValue, COffT(offset), whence.rawValue)
    guard newOffset != -1 else { throw Errno.current }
    return Int64(newOffset)
  }

  /// read: Read `buffer.count` bytes from the current read/write offset into
  /// `buffer`, and update the offset
  ///
  /// - Parameter buffer: The destination (and number of bytes) to read into
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually read
  /// - Note: Reads from the position associated with this file descriptor, and
  ///   increments that position by the number of bytes read.
  ///   See `seek(offset:from:)`.
  public func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int {
    let numBytes = _read(self.rawValue, buffer.baseAddress, buffer.count)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// pread: Read `buffer.count` bytes from `offset` into `buffer`
  ///
  /// - Parameters:
  ///   - offset: Read from the specified position
  ///   - buffer: The destination (and number of bytes) to read into
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually read
  /// - Note: Unlike `read(into:)`, this avoids accessing and modifying the
  ///   position associated with this file descriptor
  public func read(
    fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer
  ) throws -> Int {
    let numBytes = _pread(self.rawValue, buffer.baseAddress, buffer.count, offset)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// write: Write the contents of `buffer` to the current read/write offset,
  /// and update the offset
  ///
  /// - Parameter buffer: The data to write
  /// - Throws: `Errno`
  /// - Returns: The number of bytes written
  /// - Note: Writes to the position associated with this file descriptor, and
  ///   increments that position by the number of bytes written.
  ///   See `seek(offset:from:)`.
  public func write(
    _ buffer: UnsafeRawBufferPointer
  ) throws -> Int {
    let numBytes = _write(self.rawValue, buffer.baseAddress, buffer.count)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// pwrite: Write the contents of `buffer` to `offset`
  ///
  /// - Parameters:
  ///   - offset: Write to the specified position
  ///   - buffer: The data to write
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually written
  /// - Note: Unlike `write(_:)`, this avoids accessing and modifying the
  /// position associated with this file descriptor
  public func write(
    toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer
  ) throws -> Int {
    let numBytes = _pwrite(self.rawValue, buffer.baseAddress, buffer.count, offset)
    guard numBytes >= 0 else { throw Errno.current }
    return numBytes
  }

  /// write: Write the contents of `sequence` to the current read/write offset, and update the offset
  ///
  /// - Parameter sequence: The bytes to write. If `sequence` does not
  ///   implement `withContiguousStorageIfAvailable`, a temporary allocation will occur
  /// - Throws: `Errno`
  /// - Returns: The number of bytes written
  /// - Note: Writes to the position associated with this file descriptor, and increments that position
  ///         by the number of bytes written. See `seek(offset:from:)`.
  public func write<S: Sequence>(
    _ sequence: S
  ) throws -> Int where S.Element == UInt8 {
    try sequence._withRawBufferPointer { try write($0) }
  }

  /// pwrite: Write the contents of `sequence` to `offset`
  ///
  /// - Parameters:
  ///   - offset: Write to the specified position
  ///   - sequence: The bytes to write. If `sequence` does not
  ///   implement `withContiguousStorageIfAvailable`, a temporary allocation will occur
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually written
  /// - Note: Unlike `write(_:)`, this avoids accessing and modifying the position associated with this file descriptor
  public func write<S: Sequence>(
    toAbsoluteOffset offset: Int64, _ sequence: S
  ) throws -> Int where S.Element == UInt8 {
    try sequence._withRawBufferPointer { try write(toAbsoluteOffset: offset, $0) }
  }
}
