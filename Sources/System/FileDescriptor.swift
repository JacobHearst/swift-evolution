import Darwin

public struct FileDescriptor {
  public let rawValue: CInt
}

extension FileDescriptor {
  public enum AccessMode: CInt {
    // O_RDONLY        open for reading only
    case readOnly = 0x0

    // O_WRONLY        open for writing only
    case writeOnly = 0x1

    // O_RDWR          open for reading and writing
    case readWrite = 0x2
  }

  public struct OpenOptions: OptionSet {
    public let rawValue: CInt

    // O_NONBLOCK      do not block on open or for data to become available
    //
    // If the O_NONBLOCK flag is specified, do not wait for the device or file to
    // be ready or available.  If the open() call would result in the process
    // being blocked for some reason (e.g., waiting for carrier on a dialup line),
    // open() returns immediately.  This flag also has the effect of making all
    // subsequent I/O on the open file non-blocking.
    public static var nonBlocking: OpenOptions { OpenOptions(rawValue:  0x4) }

    // O_APPEND        append on each write
    //
    // Opening a file with O_APPEND set causes each write on the file to be
    // appended to the end
    public static var append: OpenOptions { OpenOptions(rawValue:  0x8) }

    // O_CREAT         create file if it does not exist
    public static var create: OpenOptions { OpenOptions(rawValue:  0x2_00) }

    // O_TRUNC         truncate size to 0
    //
    // If O_TRUNC is specified and the file exists, the file is truncated to zero
    // length
    public static var truncate: OpenOptions { OpenOptions(rawValue:  0x4_00) }

    // O_EXCL          error if O_CREAT and the file exists
    //
    // If O_EXCL is set with O_CREAT and the file already exists, open() returns
    // an error.  This may be used to implement a simple exclusive-access locking
    // mechanism.  If O_EXCL is set with O_CREAT and the last component of the
    // pathname is a symbolic link, open() will fail even if the symbolic link
    // points to a non-existent name.
    public static var exclusiveCreate: OpenOptions { OpenOptions(rawValue:  0x8_00) }

    // O_SHLOCK        atomically obtain a shared lock
    //
    // When opening a file, a lock with flock(2) semantics can be obtained by
    // setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    // creating a file with O_CREAT, the request for the lock will never fail
    // (provided that the underlying filesystem supports locking).
    public static var sharedLock: OpenOptions { OpenOptions(rawValue:  0x10) }

    // O_EXLOCK        atomically obtain an exclusive lock
    //
    // When opening a file, a lock with flock(2) semantics can be obtained by
    // setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    // creating a file with O_CREAT, the request for the lock will never fail
    // (provided that the underlying filesystem supports locking).
    public static var exclusiveLock: OpenOptions { OpenOptions(rawValue:  0x20) }

    // O_NOFOLLOW      do not follow symlinks
    //
    // If O_NOFOLLOW is used in the mask and the target file passed to open() is a
    // symbolic link then the open() will fail.
    public static var noFollow: OpenOptions { OpenOptions(rawValue:  0x1_00) }

    // O_SYMLINK       allow open of symlinks
    //
    // If O_SYMLINK is used in the mask and the target file passed to open() is a
    // symbolic link then the open() will be for the symbolic link itself, not
    // what it links to.
    public static var symlink: OpenOptions { OpenOptions(rawValue:  0x20_00_00) }

    // O_EVTONLY       descriptor requested for event notifications only
    //
    // The O_EVTONLY flag is only intended for monitoring a file for changes (e.g.
    // kqueue). Note: when this flag is used, the opened file will not prevent an
    // unmount of the volume that contains the file.
    public static var eventOnly: OpenOptions { OpenOptions(rawValue:  0x80_00) }

    // O_CLOEXEC       mark as close-on-exec
    //
    // The O_CLOEXEC flag causes the file descriptor to be marked as
    // close-on-exec, setting the FD_CLOEXEC flag.  The state of the file
    // descriptor flags can be inspected using the F_GETFD fcntl.
    public static var closeOnExec: OpenOptions { OpenOptions(rawValue:  0x1_00_00_00) }

    public init(rawValue: CInt) {
      self.rawValue = rawValue
    }
  }

  public struct Permissions: OptionSet {
    public let rawValue: CModeT

    // Read permissions for other
    public static var otherRead: Permissions { Permissions(rawValue: 0o4) }

    // Write permissions for other
    public static var otherWrite: Permissions { Permissions(rawValue: 0o2) }

    // Execute permissions for other
    public static var otherExecute: Permissions { Permissions(rawValue: 0o1) }

    // Read-write-execute mask for other
    public static var otherReadWriteExecute: Permissions { Permissions(rawValue: 0o7) }

    // Read for group
    public static var groupRead: Permissions { Permissions(rawValue: 0o40) }

    // Write permissions for group
    public static var groupWrite: Permissions { Permissions(rawValue: 0o20) }

    // Execute permissions for group
    public static var groupExecute: Permissions { Permissions(rawValue: 0o10) }

    // Read-write-execute mask for group
    public static var groupReadWriteExecute: Permissions { Permissions(rawValue: 0o70) }

    // Read for owner
    public static var ownerRead: Permissions { Permissions(rawValue: 0o400) }

    // Write permissions for owner
    public static var ownerWrite: Permissions { Permissions(rawValue: 0o200) }

    // Execute permissions for owner
    public static var ownerExecute: Permissions { Permissions(rawValue: 0o100) }

    // Read-write-execute mask for owner
    public static var ownerReadWriteExecute: Permissions { Permissions(rawValue: 0o700) }

    // set user id on execution
    public static var setUserID: Permissions { Permissions(rawValue: 0o4000) }

    // set group id on execution
    public static var setGroupID: Permissions { Permissions(rawValue: 0o2000) }

    // save swapped text even after use
    public static var saveText: Permissions { Permissions(rawValue: 0o1000) }

    public init(rawValue: CModeT) {
      self.rawValue = rawValue
    }
  }

  public enum SeekWhence: CInt {
    // SEEK_SET: the offset is set to offset bytes.
    case set

    // SEEK_CUR: the offset is set to its current location plus offset bytes.
    case current

    // SEEK_END: the offset is set to the size of the file plus offset bytes.
    case end

    // SEEK_HOLE: the offset is set to the start of the next hole greater than
    // or equal to the supplied offset.  The definition of a hole is provided
    // below.
    case hole

    // SEEK_DATA: the offset is set to the start of the next non-hole file
    // region greater than or equal to the supplied offset.
    case data
  }
}

extension FileDescriptor {
  public init(
    open path: Path,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FileDescriptor.Permissions? = nil
  ) throws {
    let oFlag = mode.rawValue | options.rawValue
    let desc: CInt
    if let permissions = permissions {
      desc = Darwin.open(path.rawValue, oFlag, permissions.rawValue)
    } else {
      precondition(!options.contains(.create), "Create must be given permissions")
      desc = Darwin.open(path.rawValue, oFlag)
    }
    guard desc != -1 else { throw errno }
    self.rawValue = desc
  }

  public func close() throws {
    // TODO: Flush and close are mixed up, maybe intercept and suppress some errors like EINTR?
    guard Darwin.close(self.rawValue) != -1 else { throw errno }
  }

  // Hmm... can't use Int for offset/return; we want 32bit systems to support large files...
  public func seek(
    offset: COffT, whence: FileDescriptor.SeekWhence
  ) throws -> COffT {
    let newOffset = Darwin.lseek(self.rawValue, offset, whence.rawValue)
    guard newOffset != -1 else { throw errno }
    return newOffset
  }
}


// Eek, how to avoid the copy for the mutable template?
//    public static func makeTemporary(_ template: String) throws -> Descriptor {
//      guard let desc = mkstemp(template) else { throw err }
//    }

