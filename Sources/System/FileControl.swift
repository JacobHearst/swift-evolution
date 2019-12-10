extension FileDescriptor {
  // Namespace for `fcntl` APIs
  public struct Control {
    internal let fd: FileDescriptor
    internal init(_ fd: FileDescriptor) { self.fd = fd }
    fileprivate var rawValue: CInt { fd.rawValue }
  }
  // Access `fcntl` APIs
  public var control: Control { Control(self) }
}

extension FileDescriptor.Control {
  private func cntl(_ command: CInt) throws -> CInt {
    let value = _fcntl(self.rawValue, command)
    guard value != -1 else { throw errno }
    return value
  }
  private func cntl(_ command: CInt, _ arg: CInt) throws -> CInt {
    let value = _fcntl(self.rawValue, command, arg)
    guard value != -1 else { throw errno }
    return value
  }
  private func cntl(
    _ command: CInt, _ ptr: UnsafeMutableRawPointer
  ) throws -> CInt {
    let value = _fcntl(self.rawValue, command, ptr)
    guard value != -1 else { throw errno }
    return value
  }

  // F_DUPFD            Return a new descriptor as follows:
  //
  //                        o   Lowest numbered available descriptor greater
  //                            than or equal to arg.
  //                        o   Same object references as the original
  //                            descriptor.
  //                        o   New descriptor shares the same file offset if
  //                            the object was a file.
  //                        o   Same access mode (read, write or read/write).
  //                        o   Same file status flags (i.e., both file
  //                            descriptors share the same file status flags).
  //                        o   The close-on-exec flag associated with the new
  //                            file descriptor is cleared so that the
  //                            descriptor remains open across an execv(2)
  //                            system call.
  //
  // F_DUPFD_CLOEXEC    Like F_DUPFD, except that the close-on-exec flag asso-
  //                    ciated with the new file descriptor is set.
  public func duplicate(setCloseOnExec: Bool = false) throws -> FileDescriptor {
    return FileDescriptor(
      rawValue: try cntl(setCloseOnExec ? _F_DUPFD_CLOEXEC : _F_DUPFD))
  }

  public struct Flags: OptionSet {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }
    fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }

    public static var closeOnExec: Flags { Flags(1) }
  }

  // F_GETFD            Get the flags associated with the file descriptor
  //                    fildes, as described below (arg is ignored).
  public func getFlags() throws -> Flags {
    return try Flags(cntl(_F_GETFD))
  }

  // F_SETFD            Set the file descriptor flags to arg.
  public func setFlags(_ value: Flags) throws {
    _ = try cntl(_F_SETFD, value.rawValue)
  }

  public struct StatusFlags: OptionSet {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }
    fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }

    // O_NONBLOCK   Non-blocking I/O; if no data is available to a read
    //              call, or if a write operation would block, the read or
    //              write call returns -1 with the error EAGAIN.
    public static var nonblocking: StatusFlags { StatusFlags(0x4) }

    // O_APPEND     Force each write to append at the end of file; corre-
    //              sponds to the O_APPEND flag of open(2).
    public static var append: StatusFlags { StatusFlags(0x8) }

    // O_ASYNC      Enable the SIGIO signal to be sent to the process
    //              group when I/O is possible, e.g., upon availability of
    //              data to be read.
    public static var async: StatusFlags { StatusFlags(0x40) }
  }

  // F_GETFL            Get descriptor status flags, as described below (arg
  //                    is ignored).
  public func getStatusFlags() throws -> StatusFlags {
    StatusFlags(try cntl(_F_GETFL))
  }

  // F_SETFL            Set descriptor status flags to arg.
  public func setStatusFlags(_ flags: StatusFlags) throws {
    _ = try cntl(_F_SETFL, flags.rawValue)
  }

  public struct PIDOrPGID: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }
    fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }

    // FIXME: inits, when we have actual PID or PGID type

    // FIXME: expose optional PID or PGID, or maybe even an enum...

  }

  // F_GETOWN           Get the process ID or process group currently receiv-
  //                    ing SIGIO and SIGURG signals; process groups are
  //                    returned as negative values (arg is ignored).
  public func getOwner() throws -> PIDOrPGID {
    try PIDOrPGID(cntl(_F_GETOWN))
  }

  // F_SETOWN           Set the process or process group to receive SIGIO and
  //                    SIGURG signals; process groups are specified by sup-
  //                    plying arg as negative, otherwise arg is interpreted
  //                    as a process ID.
  public func setOwner(_ id: PIDOrPGID) throws {
    _ = try cntl(_F_SETOWN, id.rawValue)
  }

  // F_GETPATH          Get the path of the file descriptor
  //
  // F_GETPATH_NOFIRMLINK
  //                    Get the non firmlinked path of the file descriptor
  //                    Fildes.  The argument must be a buffer of size
  //                    MAXPATHLEN or greater.
  public func getPath(noFirmLink: Bool = false) throws -> Path {
    return try Path {
      _ = try cntl(noFirmLink ? _F_GETPATH_NOFIRMLINK : _F_GETPATH, $0)
      return 1 + _strlen($0.assumingMemoryBound(to: Int8.self))
    }
  }

  public struct PreallocateFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }
    fileprivate init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    //       F_ALLOCATECONTIG   Allocate contiguous space.
    public static var allocateContiguous: PreallocateFlags { PreallocateFlags(2) }

    //       F_ALLOCATEALL      Allocate all requested space or no space at all.
    public static var allocateAll: PreallocateFlags { PreallocateFlags(4) }
  }

  // F_PREALLOCATE      Preallocate file storage space. Note: upon success,
  //                    the space that is allocated can be the size requested,
  //                    larger than the size requested, or (if the
  //                    F_ALLOCATEALL flag is not provided) smaller than the
  //                    space requested.
  public func preallocate(
    _ flags: PreallocateFlags, bytesFromEnd: Int64
  ) throws -> Int64 {
    // The F_PREALLOCATE command operates on the following structure:
    //
    //         typedef struct fstore {
    //             u_int32_t fst_flags;      /* IN: flags word */
    //             int       fst_posmode;    /* IN: indicates offset field */
    //             off_t     fst_offset;     /* IN: start of the region */
    //             off_t     fst_length;     /* IN: size of the region */
    //             off_t     fst_bytesalloc; /* OUT: number of bytes allocated */
    //         } fstore_t;
    //
    // The position modes (fst_posmode) for the F_PREALLOCATE command indicate
    // how to use the offset field.  The modes are as follows:
    //
    //       F_PEOFPOSMODE   Allocate from the physical end of file.  In this
    //                       case, fst_length indicates the number of newly
    //                       allocated bytes desired.
    var arg = CFStoreT(
      fst_flags: flags.rawValue,
      fst_posmode: _F_PEOFPOSMODE,
      fst_offset: 0,
      fst_length: COffT(bytesFromEnd),
      fst_bytesalloc: 0)
    _ = try cntl(_F_PREALLOCATE, &arg)
    return Int64(arg.fst_bytesalloc)
  }

  public func preallocate(
    _ flags: PreallocateFlags, regionStart: Int64, length: Int64
  ) throws -> Int64 {
    // The F_PREALLOCATE command operates on the following structure:
    //
    //         typedef struct fstore {
    //             u_int32_t fst_flags;      /* IN: flags word */
    //             int       fst_posmode;    /* IN: indicates offset field */
    //             off_t     fst_offset;     /* IN: start of the region */
    //             off_t     fst_length;     /* IN: size of the region */
    //             off_t     fst_bytesalloc; /* OUT: number of bytes allocated */
    //         } fstore_t;
    //
    // The position modes (fst_posmode) for the F_PREALLOCATE command indicate
    // how to use the offset field.  The modes are as follows:
    //
    //       F_VOLPOSMODE    Allocate from the volume offset.
    var arg = CFStoreT(
      fst_flags: flags.rawValue,
      fst_posmode: _F_PEOFPOSMODE,
      fst_offset: COffT(regionStart),
      fst_length: COffT(length),
      fst_bytesalloc: 0)
    _ = try cntl(_F_PREALLOCATE, &arg)
    return Int64(arg.fst_bytesalloc)
  }

  // F_PUNCHHOLE        Deallocate a region and replace it with a hole. Subse-
  //                    quent reads of the affected region will return bytes
  //                    of zeros that are usually not backed by physical
  //                    blocks. This will not change the actual file size.
  //                    Holes must be aligned to file system block boundaries.
  //                    This will fail on file systems that do not support
  //                    this interface.
  public func punchHole(startingAt offset: Int64, length: Int64) throws {
    // The F_PUNCHHOLE command operates on the following structure:
    //
    //         typedef struct fpunchhole {
    //             u_int32_t fp_flags;     /* unused */
    //             u_int32_t reserved;     /* (to maintain 8-byte alignment) */
    //             off_t     fp_offset;    /* IN: start of the region */
    //             off_t     fp_length;    /* IN: size of the region */
    //         } fpunchhole_t;
    var arg = CFPunchholdT(
      fp_flags: 0, reserved: 0, fp_offset: COffT(offset), fp_length: COffT(length))
    _ = try cntl(_F_PUNCHHOLE, &arg)
  }

  // F_SETSIZE          Truncate a file without zeroing space.  The calling
  //                    process must have root privileges.
  public func setSize(to: Int64) throws {
    // Reading online code snippets show that size is passed indirectly...
    var size = COffT(to)
    _ = try cntl(_F_SETSIZE, &size)
  }

  // F_RDADVISE         Issue an advisory read async with no copy to user.
  public func advisoryRead(offset: Int64, length: Int) throws {
    // The F_RDADVISE command operates on the following structure which holds
    // information passed from the user to the system:
    //
    //         struct radvisory {
    //            off_t   ra_offset;  /* offset into the file */
    //            int     ra_count;   /* size of the read     */
    //         };
    var arg = CRAdvisory(ra_offset: COffT(offset), ra_count: CInt(length))
    _ = try cntl(_F_RDADVISE, &arg)
  }

  // F_RDAHEAD          Turn read ahead off/on.  A zero value in arg disables
  //                    read ahead.  A non-zero value in arg turns read ahead
  //                    on.
  public func enableReadAhead(_ value: Bool) throws {
    _ = try cntl(_F_RDAHEAD, value ? 1 : 0)
  }

  // F_NOCACHE          Turns data caching off/on. A non-zero value in arg
  //                    turns data caching off.  A value of zero in arg turns
  //                    data caching on.
  public func disableDataCaching(_ value: Bool) throws {
    _ = try cntl(_F_NOCACHE, value ? 1 : 0)
  }

  // F_LOG2PHYS         Get disk device information.  Currently this only
  //                    returns the disk device address that corresponds to
  //                    the current file offset. Note that the system may
  //                    return -1 as the disk device address if the file is
  //                    not backed by physical blocks. This is subject to
  //                    change.
  //
  public func getDeviceOffset() throws -> Int64 {
    // The F_LOG2PHYS command operates on the following structure:
    //
    //         struct log2phys {
    //             u_int32_t l2p_flags;        /* unused so far */
    //             off_t     l2p_contigbytes;  /* unused so far */
    //             off_t     l2p_devoffset;    /* bytes into device */
    //         };
    var arg = CLog2Phys(l2p_flags: 0, l2p_contigbytes: 0, l2p_devoffset: 0)
    _ = try cntl(_F_LOG2PHYS, &arg)
    return arg.l2p_devoffset
  }

  // F_LOG2PHYS_EXT     Variant of F_LOG2PHYS that uses the passed in file
  //                    offset and length.
  public func getDeviceOffset(
    numContiguousBytesToQuery: Int64, offset: Int64
  ) throws -> (numContiguousBytesAllocated: Int64, deviceOffset: Int64) {
    // The F_LOG2PHYS_EXT command operates on the same structure as F_LOG2PHYS
    // but treats it as an in/out:
    //
    //         struct log2phys {
    //             u_int32_t l2p_flags;        /* unused so far */
    //             off_t     l2p_contigbytes;  /* IN: number of bytes to be queried;
    //                                            OUT: number of contiguous bytes allocated at this position */
    //             off_t     l2p_devoffset;    /* IN: bytes into file;
    //                                            OUT: bytes into device */
    //         };
    var arg = CLog2Phys(
      l2p_flags: 0,
      l2p_contigbytes: COffT(numContiguousBytesToQuery),
      l2p_devoffset: COffT(offset))
    _ = try cntl(_F_LOG2PHYS_EXT, &arg)
    return (Int64(arg.l2p_contigbytes), Int64(arg.l2p_devoffset))
  }

  // F_BARRIERFSYNC     Does the same thing as fsync(2) then issues a barrier
  //                    command to the drive (arg is ignored).  The barrier
  //                    applies to I/O that have been flushed with fsync(2) on
  //                    the same device before.  These operations are guaran-
  //                    teed to be persisted before any other I/O that would
  //                    follow the barrier, although no assumption should be
  //                    made on what has been persisted or not when this call
  //                    returns.  After the barrier has been issued, opera-
  //                    tions on other FDs that have been fsync'd before can
  //                    still be re-ordered by the device, but not after the
  //                    barrier.  This is typically useful to guarantee valid
  //                    state on disk when ordering is a concern but durabil-
  //                    ity is not.  A barrier can be used to order two phases
  //                    of operations on a set of file descriptors and ensure
  //                    that no file can possibly get persisted with the
  //                    effect of the second phase without the effect of the
  //                    first one. To do so, execute operations of phase one,
  //                    then fsync(2) each FD and issue a single barrier.
  //                    Finally execute operations of phase two.  This is cur-
  //                    rently implemented on HFS and APFS. It requires hard-
  //                    ware support, which Apple SSDs are guaranteed to pro-
  //                    vide.
  public func syncBarrier() throws {
    _ = try cntl(_F_BARRIERFSYNC)
  }

  // F_FULLFSYNC        Does the same thing as fsync(2) then asks the drive to
  //                    flush all buffered data to the permanent storage
  //                    device (arg is ignored).  As this drains the entire
  //                    queue of the device and acts as a barrier, data that
  //                    had been fsync'd on the same device before is guaran-
  //                    teed to be persisted when this call returns.  This is
  //                    currently implemented on HFS, MS-DOS (FAT), Universal
  //                    Disk Format (UDF) and APFS file systems.  The opera-
  //                    tion may take quite a while to complete.  Certain
  //                    FireWire drives have also been known to ignore the
  //                    request to flush their buffered data.
  public func fullSync() throws {
    _ = try cntl(_F_FULLFSYNC)
  }

  // F_SETNOSIGPIPE     Determines whether a SIGPIPE signal will be generated
  //                    when a write fails on a pipe or socket for which there
  //                    is no reader.  If arg is non-zero, SIGPIPE generation
  //                    is disabled for descriptor fildes, while an arg of
  //                    zero enables it (the default).
  public func disableSIGPIPE(_ value: Bool = true) throws {
    _ = try cntl(_F_SETNOSIGPIPE, value ? 1 : 0)
  }

  // F_GETNOSIGPIPE     Returns whether a SIGPIPE signal will be generated
  //                    when a write fails on a pipe or socket for which there
  //                    is no reader.  The semantics of the return value match
  //                    those of the arg of F_SETNOSIGPIPE.
  public func hasDisabledSIGPIPE() throws -> Bool {
    return try cntl(_F_GETNOSIGPIPE) != 0
  }

  // FIXME: WTF, docs have the below comment but never mention bootstrap commands
  //
  // The F_READBOOTSTRAP and F_WRITEBOOTSTRAP commands operate on the follow-
  // ing structure.
  //
  //         typedef struct fbootstraptransfer {
  //             off_t fbt_offset;       /* IN: offset to start read/write */
  //             size_t fbt_length;      /* IN: number of bytes to transfer */
  //             void *fbt_buffer;       /* IN: buffer to be read/written */
  //         } fbootstraptransfer_t;
}

// TODO File locking

// Several commands are available for doing advisory file locking; they all
// operate on the following structure:
//
//         struct flock {
//             off_t       l_start;    /* starting offset */
//             off_t       l_len;      /* len = 0 means until end of file */
//             pid_t       l_pid;      /* lock owner */
//             short       l_type;     /* lock type: read/write, etc. */
//             short       l_whence;   /* type of l_start */
//         };
//
// The commands available for advisory record locking are as follows:
//
// F_GETLK    Get the first lock that blocks the lock description pointed to
//            by the third argument, arg, taken as a pointer to a struct
//            flock (see above).  The information retrieved overwrites the
//            information passed to fcntl in the flock structure.  If no
//            lock is found that would prevent this lock from being created,
//            the structure is left unchanged by this function call except
//            for the lock type which is set to F_UNLCK.
//
// F_SETLK    Set or clear a file segment lock according to the lock
//            description pointed to by the third argument, arg, taken as a
//            pointer to a struct flock (see above).  F_SETLK is used to
//            establish shared (or read) locks (F_RDLCK) or exclusive (or
//            write) locks, (F_WRLCK), as well as remove either type of lock
//            (F_UNLCK).  If a shared or exclusive lock cannot be set, fcntl
//            returns immediately with EAGAIN.
//
// F_SETLKW   This command is the same as F_SETLK except that if a shared or
//            exclusive lock is blocked by other locks, the process waits
//            until the request can be satisfied.  If a signal that is to be
//            caught is received while fcntl is waiting for a region, the
//            fcntl will be interrupted if the signal handler has not speci-
//            fied the SA_RESTART (see sigaction(2)).
//
// When a shared lock has been set on a segment of a file, other processes
// can set shared locks on that segment or a portion of it.  A shared lock
// prevents any other process from setting an exclusive lock on any portion
// of the protected area.  A request for a shared lock fails if the file
// descriptor was not opened with read access.
//
// An exclusive lock prevents any other process from setting a shared lock
// or an exclusive lock on any portion of the protected area.  A request for
// an exclusive lock fails if the file was not opened with write access.
//
// The value of l_whence is SEEK_SET, SEEK_CUR, or SEEK_END to indicate that
// the relative offset, l_start bytes, will be measured from the start of
// the file, current position, or end of the file, respectively.  The value
// of l_len is the number of consecutive bytes to be locked.  If l_len is
// negative, the result is undefined.  The l_pid field is only used with
// F_GETLK to return the process ID of the process holding a blocking lock.
// After a successful F_GETLK request, the value of l_whence is SEEK_SET.
//
// Locks may start and extend beyond the current end of a file, but may not
// start or extend before the beginning of the file.  A lock is set to
// extend to the largest possible value of the file offset for that file if
// l_len is set to zero. If l_whence and l_start point to the beginning of
// the file, and l_len is zero, the entire file is locked.  If an applica-
// tion wishes only to do entire file locking, the flock(2) system call is
// much more efficient.
//
// There is at most one type of lock set for each byte in the file.  Before
// a successful return from an F_SETLK or an F_SETLKW request when the call-
// ing process has previously existing locks on bytes in the region speci-
// fied by the request, the previous lock type for each byte in the speci-
// fied region is replaced by the new lock type.  As specified above under
// the descriptions of shared locks and exclusive locks, an F_SETLK or an
// F_SETLKW request fails or blocks respectively when another process has
// existing locks on bytes in the specified region and the type of any of
// those locks conflicts with the type specified in the request.
//
// This interface follows the completely stupid semantics of System V and
// IEEE Std 1003.1-1988 (``POSIX.1'') that require that all locks associated
// with a file for a given process are removed when any file descriptor for
// that file is closed by that process.  This semantic means that applica-
// tions must be aware of any files that a subroutine library may access.
// For example if an application for updating the password file locks the
// password file database while making the update, and then calls
// getpwname(3) to retrieve a record, the lock will be lost because
// getpwname(3) opens, reads, and closes the password database.  The data-
// base close will release all locks that the process has associated with
// the database, even if the library routine never requested a lock on the
// database.  Another minor semantic problem with this interface is that
// locks are not inherited by a child process created using the fork(2)
// function.  The flock(2) interface has much more rational last close
// semantics and allows locks to be inherited by child processes.  Flock(2)
// is recommended for applications that want to ensure the integrity of
// their locks when using library routines or wish to pass locks to their
// children.  Note that flock(2) and fcntl(2) locks may be safely used con-
// currently.
//
// All locks associated with a file for a given process are removed when the
// process terminates.
//
// A potential for deadlock occurs if a process controlling a locked region
// is put to sleep by attempting to lock the locked region of another
// process.  This implementation detects that sleeping until a locked region
// is unlocked would cause a deadlock and fails with an EDEADLK error.

