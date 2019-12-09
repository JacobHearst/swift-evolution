public struct FileDescriptor: RawRepresentable {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
  fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }
}

extension FileDescriptor {
  fileprivate init(_checking fd: CInt) throws {
    guard fd != -1 else { throw errno }
    self.init(fd)
  }
}

extension FileDescriptor {
  // TODO: The below 2 types are unified in C, should we do the same?
  //
  // TODO: Or, an option set maybe?
  public struct AccessMode: RawRepresentable {
    public var rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // O_RDONLY        open for reading only
    public static var readOnly: AccessMode { AccessMode(rawValue: _O_RDONLY) }

    // O_WRONLY        open for writing only
    public static var writeOnly: AccessMode { AccessMode(rawValue: _O_WRONLY) }

    // O_RDWR          open for reading and writing
    public static var readWrite: AccessMode { AccessMode(rawValue: _O_RDWR) }
  }

  public struct OpenOptions: OptionSet {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }
    private init(_ raw: CInt) { self.init(rawValue: raw) }

    // O_NONBLOCK      do not block on open or for data to become available
    //
    // If the O_NONBLOCK flag is specified, do not wait for the device or file to
    // be ready or available.  If the open() call would result in the process
    // being blocked for some reason (e.g., waiting for carrier on a dialup line),
    // open() returns immediately.  This flag also has the effect of making all
    // subsequent I/O on the open file non-blocking.
    public static var nonBlocking: OpenOptions { OpenOptions(_O_NONBLOCK) }

    // O_APPEND        append on each write
    //
    // Opening a file with O_APPEND set causes each write on the file to be
    // appended to the end
    public static var append: OpenOptions { OpenOptions(_O_APPEND) }

    // O_CREAT         create file if it does not exist
    public static var create: OpenOptions { OpenOptions(_O_CREAT) }

    // O_TRUNC         truncate size to 0
    //
    // If O_TRUNC is specified and the file exists, the file is truncated to zero
    // length
    public static var truncate: OpenOptions { OpenOptions(_O_TRUNC) }

    // O_EXCL          error if O_CREAT and the file exists
    //
    // If O_EXCL is set with O_CREAT and the file already exists, open() returns
    // an error.  This may be used to implement a simple exclusive-access locking
    // mechanism.  If O_EXCL is set with O_CREAT and the last component of the
    // pathname is a symbolic link, open() will fail even if the symbolic link
    // points to a non-existent name.
    public static var exclusiveCreate: OpenOptions { OpenOptions(_O_EXCL) }

    // O_SHLOCK        atomically obtain a shared lock
    //
    // When opening a file, a lock with flock(2) semantics can be obtained by
    // setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    // creating a file with O_CREAT, the request for the lock will never fail
    // (provided that the underlying filesystem supports locking).
    public static var sharedLock: OpenOptions { OpenOptions(_O_SHLOCK) }

    // O_EXLOCK        atomically obtain an exclusive lock
    //
    // When opening a file, a lock with flock(2) semantics can be obtained by
    // setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    // creating a file with O_CREAT, the request for the lock will never fail
    // (provided that the underlying filesystem supports locking).
    public static var exclusiveLock: OpenOptions { OpenOptions(_O_EXLOCK) }

    // O_NOFOLLOW      do not follow symlinks
    //
    // If O_NOFOLLOW is used in the mask and the target file passed to open() is a
    // symbolic link then the open() will fail.
    public static var noFollow: OpenOptions { OpenOptions(_O_NOFOLLOW) }

    // O_SYMLINK       allow open of symlinks
    //
    // If O_SYMLINK is used in the mask and the target file passed to open() is a
    // symbolic link then the open() will be for the symbolic link itself, not
    // what it links to.
    public static var symlink: OpenOptions { OpenOptions(_O_SYMLINK) }

    // O_EVTONLY       descriptor requested for event notifications only
    //
    // The O_EVTONLY flag is only intended for monitoring a file for changes (e.g.
    // kqueue). Note: when this flag is used, the opened file will not prevent an
    // unmount of the volume that contains the file.
    public static var eventOnly: OpenOptions { OpenOptions(_O_EVTONLY) }

    // O_CLOEXEC       mark as close-on-exec
    //
    // The O_CLOEXEC flag causes the file descriptor to be marked as
    // close-on-exec, setting the FD_CLOEXEC flag.  The state of the file
    // descriptor flags can be inspected using the F_GETFD fcntl.
    public static var closeOnExec: OpenOptions { OpenOptions(_O_CLOEXEC) }

  }

  // TODO: Consider breaking out seek into multiple APIs instead
  public struct SeekOrigin: RawRepresentable {
    public var rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // SEEK_SET: the offset is set to offset bytes.
    public static var start: SeekOrigin { SeekOrigin(rawValue: _SEEK_SET) }

    // SEEK_CUR: the offset is set to its current location plus offset bytes.
    public static var current: SeekOrigin { SeekOrigin(rawValue: _SEEK_CUR) }

    // SEEK_END: the offset is set to the size of the file plus offset bytes.
    public static var end: SeekOrigin { SeekOrigin(rawValue: _SEEK_END) }

    // SEEK_HOLE: the offset is set to the start of the next hole greater than
    // or equal to the supplied offset.  The definition of a hole is provided
    // below.
    public static var nextHole: SeekOrigin { SeekOrigin(rawValue: _SEEK_HOLE) }

    // SEEK_DATA: the offset is set to the start of the next non-hole file
    // region greater than or equal to the supplied offset.
    public static var nextData: SeekOrigin { SeekOrigin(rawValue: _SEEK_DATA) }
  }
}

extension FileDescriptor {
  // TODO: Consider putting on Path
  public static func open(
    _ path: Path,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FilePermissions? = nil
  ) throws -> FileDescriptor {
    let oFlag = mode.rawValue | options.rawValue
    let desc: CInt
    if let permissions = permissions {
      desc = _open(path.bytes, oFlag, permissions.rawValue)
    } else {
      precondition(!options.contains(.create), "Create must be given permissions")
      desc = _open(path.bytes, oFlag)
    }
    return try FileDescriptor(_checking: desc)
  }

  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw errno }
  }

  public func seek(
    offset: Int64, from whence: FileDescriptor.SeekOrigin
  ) throws -> Int64 {
    let newOffset = _lseek(self.rawValue, COffsetT(offset), whence.rawValue)
    guard newOffset != -1 else { throw errno }
    return Int64(newOffset)
  }

  // Uses cursor position
  public func read(into: UnsafeMutableRawBufferPointer) throws -> Int {
    let numBytes = _read(self.rawValue, into.baseAddress, into.count)
    guard numBytes >= 0 else { throw errno }
    return numBytes
  }

  public func read(
    fromAbsoluteOffset offset: Int64, into: UnsafeMutableRawBufferPointer
  ) throws -> Int {
    let numBytes = _pread(self.rawValue, into.baseAddress, into.count, offset)
    guard numBytes >= 0 else { throw errno }
    return numBytes
  }

  // Uses cursor position
  //
  // TODO: Return a ByteBuffer
  public func read(numBytes: Int) throws -> [UInt8] {
    return try Array<UInt8>(unsafeUninitializedCapacity: numBytes) { buf, count in
      count = try read(into: UnsafeMutableRawBufferPointer(buf))
    }
  }

  //
  // TODO: Return a ByteBuffer
  public func read(
    fromAbsoluteOffset offset: Int64, numBytes: Int
  ) throws -> [UInt8] {
    return try Array<UInt8>(unsafeUninitializedCapacity: numBytes) { buf, count in
      count = try read(fromAbsoluteOffset: offset, into: UnsafeMutableRawBufferPointer(buf))
    }
  }
}



// Eek, how to avoid the copy for the mutable template?
//    public static func makeTemporary(_ template: String) throws -> Descriptor {
//      guard let desc = mkstemp(template) else { throw err }
//    }

