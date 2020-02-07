/// An abstract handle to input/output data resources, such as files and sockets.
///
/// NOTE: Programmers should ensure that FileDescriptors are not reused after being closed.
/// TODO: Describe the "non-linear"-ness of this type better...
/// TODO: More description, example usage
@frozen
public struct FileDescriptor: RawRepresentable {
  /// The raw C `int`
  public let rawValue: CInt

  /// Create a strongly-typed `FileDescriptor` from a raw C `int`
  public init(rawValue: CInt) { self.rawValue = rawValue }

  fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }
}

extension FileDescriptor {
  /// How to access a newly opened file: read, write, or both.
  @frozen
  public struct AccessMode: RawRepresentable {
    /// The raw C `int`
    public var rawValue: CInt

    /// Create a strongly-typed `AccessMode` from a raw C `int`
    public init(rawValue: CInt) { self.rawValue = rawValue }

    /// O_RDONLY: open for reading only
    public static var readOnly: AccessMode { AccessMode(rawValue: _O_RDONLY) }

    @available(*, unavailable, renamed: "readOnly")
    public static var O_RDONLY: AccessMode { readOnly }

    /// O_WRONLY: open for writing only
    public static var writeOnly: AccessMode { AccessMode(rawValue: _O_WRONLY) }

    @available(*, unavailable, renamed: "writeOnly")
    public static var O_WRONLY: AccessMode { writeOnly }

    /// O_RDWR: open for reading and writing
    public static var readWrite: AccessMode { AccessMode(rawValue: _O_RDWR) }

    @available(*, unavailable, renamed: "readWrite")
    public static var O_RDWR: AccessMode { readWrite }
  }

  /// Options specifying behavior on opening a file
  @frozen
  public struct OpenOptions: OptionSet {
    /// The raw C `int`
    public var rawValue: CInt

    /// Create a strongly-typed `OpenOptions` from a raw C `int`
    public init(rawValue: CInt) { self.rawValue = rawValue }

    private init(_ raw: CInt) { self.init(rawValue: raw) }

    /// O_NONBLOCK: do not block on open or for data to become available
    ///
    /// If the O_NONBLOCK flag is specified, do not wait for the device or file to
    /// be ready or available.  If the open() call would result in the process
    /// being blocked for some reason (e.g., waiting for carrier on a dialup line),
    /// open() returns immediately.  This flag also has the effect of making all
    /// subsequent I/O on the open file non-blocking.
    public static var nonBlocking: OpenOptions { OpenOptions(_O_NONBLOCK) }

    @available(*, unavailable, renamed: "nonBlocking")
    public static var O_NONBLOCK: OpenOptions { nonBlocking }

    /// O_APPEND: append on each write
    ///
    /// Opening a file with O_APPEND set causes each write on the file to be
    /// appended to the end
    public static var append: OpenOptions { OpenOptions(_O_APPEND) }

    @available(*, unavailable, renamed: "append")
    public static var O_APPEND: OpenOptions { append }

    /// O_CREAT: create file if it does not exist
    public static var create: OpenOptions { OpenOptions(_O_CREAT) }

    @available(*, unavailable, renamed: "create")
    public static var O_CREAT: OpenOptions { create }

    /// O_TRUNC: truncate size to 0
    ///
    /// If O_TRUNC is specified and the file exists, the file is truncated to zero
    /// length
    public static var truncate: OpenOptions { OpenOptions(_O_TRUNC) }

    @available(*, unavailable, renamed: "truncate")
    public static var O_TRUNC: OpenOptions { truncate }

    /// O_EXCL: error if O_CREAT and the file exists
    ///
    /// If O_EXCL is set with O_CREAT and the file already exists, open() returns
    /// an error.  This may be used to implement a simple exclusive-access locking
    /// mechanism.  If O_EXCL is set with O_CREAT and the last component of the
    /// pathname is a symbolic link, open() will fail even if the symbolic link
    /// points to a non-existent name.
    public static var exclusiveCreate: OpenOptions { OpenOptions(_O_EXCL) }

    @available(*, unavailable, renamed: "exclusiveCreate")
    public static var O_EXCL: OpenOptions { exclusiveCreate }

    /// O_SHLOCK: atomically obtain a shared lock
    ///
    /// When opening a file, a lock with flock(2) semantics can be obtained by
    /// setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    /// creating a file with O_CREAT, the request for the lock will never fail
    /// (provided that the underlying filesystem supports locking).
    public static var sharedLock: OpenOptions { OpenOptions(_O_SHLOCK) }

    @available(*, unavailable, renamed: "sharedLock")
    public static var O_SHLOCK: OpenOptions { sharedLock }

    /// O_EXLOCK: atomically obtain an exclusive lock
    ///
    /// When opening a file, a lock with flock(2) semantics can be obtained by
    /// setting O_SHLOCK for a shared lock, or O_EXLOCK for an exclusive lock.  If
    /// creating a file with O_CREAT, the request for the lock will never fail
    /// (provided that the underlying filesystem supports locking).
    public static var exclusiveLock: OpenOptions { OpenOptions(_O_EXLOCK) }

    @available(*, unavailable, renamed: "exclusiveLock")
    public static var O_EXLOCK: OpenOptions { exclusiveLock }

    /// O_NOFOLLOW: do not follow symlinks
    ///
    /// If O_NOFOLLOW is used in the mask and the target file passed to open() is a
    /// symbolic link then the open() will fail.
    public static var noFollow: OpenOptions { OpenOptions(_O_NOFOLLOW) }

    @available(*, unavailable, renamed: "noFollow")
    public static var O_NOFOLLOW: OpenOptions { noFollow }

    /// O_SYMLINK: allow open of symlinks
    ///
    /// If O_SYMLINK is used in the mask and the target file passed to open() is a
    /// symbolic link then the open() will be for the symbolic link itself, not
    /// what it links to.
    public static var symlink: OpenOptions { OpenOptions(_O_SYMLINK) }

    @available(*, unavailable, renamed: "symlink")
    public static var O_SYMLINK: OpenOptions { symlink }

    /// O_EVTONLY: descriptor requested for event notifications only
    ///
    /// The O_EVTONLY flag is only intended for monitoring a file for changes (e.g.
    /// kqueue). Note: when this flag is used, the opened file will not prevent an
    /// unmount of the volume that contains the file.
    public static var eventOnly: OpenOptions { OpenOptions(_O_EVTONLY) }

    @available(*, unavailable, renamed: "eventOnly")
    public static var O_EVTONLY: OpenOptions { eventOnly }

    /// O_CLOEXEC: mark as close-on-exec
    ///
    /// The O_CLOEXEC flag causes the file descriptor to be marked as
    /// close-on-exec, setting the FD_CLOEXEC flag.  The state of the file
    /// descriptor flags can be inspected using the F_GETFD fcntl.
    public static var closeOnExec: OpenOptions { OpenOptions(_O_CLOEXEC) }

    @available(*, unavailable, renamed: "closeOnExec")
    public static var O_CLOEXEC: OpenOptions { closeOnExec }

  }

  /// Specify from whence the file descriptor's read/write file offset applies.
  @frozen
  public struct SeekOrigin: RawRepresentable {
    /// The raw C `int`
    public var rawValue: CInt

    /// Create a strongly-typed `SeekOrigin` from a raw C `int`
    public init(rawValue: CInt) { self.rawValue = rawValue }

    /// SEEK_SET: the offset is set to offset bytes.
    public static var start: SeekOrigin { SeekOrigin(rawValue: _SEEK_SET) }

    @available(*, unavailable, renamed: "start")
    public static var SEEK_SET: SeekOrigin { start }

    /// SEEK_CUR: the offset is set to its current location plus offset bytes.
    public static var current: SeekOrigin { SeekOrigin(rawValue: _SEEK_CUR) }

    @available(*, unavailable, renamed: "current")
    public static var SEEK_CUR: SeekOrigin { current }

    /// SEEK_END: the offset is set to the size of the file plus offset bytes.
    public static var end: SeekOrigin { SeekOrigin(rawValue: _SEEK_END) }

    @available(*, unavailable, renamed: "end")
    public static var SEEK_END: SeekOrigin { end }

    /// SEEK_HOLE: the offset is set to the start of the next hole greater than
    /// or equal to the supplied offset.  The definition of a hole is provided
    /// below.
    public static var nextHole: SeekOrigin { SeekOrigin(rawValue: _SEEK_HOLE) }

    @available(*, unavailable, renamed: "nextHole")
    public static var SEEK_HOLE: SeekOrigin { nextHole }

    /// SEEK_DATA: the offset is set to the start of the next non-hole file
    /// region greater than or equal to the supplied offset.
    public static var nextData: SeekOrigin { SeekOrigin(rawValue: _SEEK_DATA) }

    @available(*, unavailable, renamed: "nextData")
    public static var SEEK_DATA: SeekOrigin { nextData }
  }
}

