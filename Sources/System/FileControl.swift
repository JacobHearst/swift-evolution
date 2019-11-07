import Darwin

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
  private func _control(_ command: CInt) throws -> CInt {
    let value = fcntl(self.rawValue, command)
    guard value != -1 else { throw errno }
    return value
  }
  private func _control(_ command: CInt, _ arg: CInt) throws -> CInt {
    let value = fcntl(self.rawValue, command, arg)
    guard value != -1 else { throw errno }
    return value
  }
  private func _control(
    _ command: CInt, _ ptr: UnsafeMutableRawPointer
  ) throws -> CInt {
    let value = fcntl(self.rawValue, command, ptr)
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
    return FileDescriptor(rawValue: try _control(setCloseOnExec ? F_DUPFD_CLOEXEC : F_DUPFD))
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
    return try Flags(_control(F_GETFD))
  }

  // F_SETFD            Set the file descriptor flags to arg.
  public func setFlags(_ value: Flags) throws {
    _ = try _control(F_SETFD, value.rawValue)
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
    StatusFlags(try _control(F_GETFL))
  }

  // F_SETFL            Set descriptor status flags to arg.
  public func setStatusFlags(_ flags: StatusFlags) throws {
    _ = try _control(F_SETFL, flags.rawValue)
  }

  public struct PIDOrPGID: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }
    fileprivate init(_ raw: CInt) { self.init(rawValue: raw) }

    // TODO: inits, when we have actual PID or PGID type

    // TODO: expose optional PID or PGID, or maybe even an enum...

  }

  // F_GETOWN           Get the process ID or process group currently receiv-
  //                    ing SIGIO and SIGURG signals; process groups are
  //                    returned as negative values (arg is ignored).
  public func getOwner() throws -> PIDOrPGID {
    try PIDOrPGID(_control(F_GETOWN))
  }

  // F_SETOWN           Set the process or process group to receive SIGIO and
  //                    SIGURG signals; process groups are specified by sup-
  //                    plying arg as negative, otherwise arg is interpreted
  //                    as a process ID.
  public func setOwner(_ id: PIDOrPGID) throws {
    _ = try _control(F_SETOWN, id.rawValue)
  }

  // F_GETPATH          Get the path of the file descriptor
  //
  // F_GETPATH_NOFIRMLINK
  //                    Get the non firmlinked path of the file descriptor
  //                    Fildes.  The argument must be a buffer of size
  //                    MAXPATHLEN or greater.
  public func getPath(noFirmLink: Bool = false) throws -> Path {
    return try Path {
      _ = try _control(noFirmLink ? F_GETPATH_NOFIRMLINK : F_GETPATH, $0)
      return 1 + strlen($0.assumingMemoryBound(to: Int8.self))
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
    var arg = fstore_t(
      fst_flags: flags.rawValue,
      fst_posmode: F_PEOFPOSMODE,
      fst_offset: 0, // TODO: Is this field ignored?
      fst_length: COffsetT(bytesFromEnd),
      fst_bytesalloc: 0)
    _ = try _control(F_PREALLOCATE, &arg)
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
    var arg = fstore_t(
      fst_flags: flags.rawValue,
      fst_posmode: F_PEOFPOSMODE,
      fst_offset: COffsetT(regionStart),
      fst_length: COffsetT(length),
      fst_bytesalloc: 0)
    _ = try _control(F_PREALLOCATE, &arg)
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
    var arg = fpunchhole_t(
      fp_flags: 0, reserved: 0, fp_offset: COffsetT(offset), fp_length: COffsetT(length))
    _ = try _control(F_PUNCHHOLE, &arg)
  }

  // F_SETSIZE          Truncate a file without zeroing space.  The calling
  //                    process must have root privileges.
  public func setSize(to: Int64) throws {
    // Reading online code snippets show that size is passed indirectly...
    var size = COffsetT(to)
    _ = try _control(F_SETSIZE, &size)
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
    var arg = radvisory(ra_offset: COffsetT(offset), ra_count: CInt(length))
    _ = try _control(F_RDADVISE, &arg)
  }

  // F_RDAHEAD          Turn read ahead off/on.  A zero value in arg disables
  //                    read ahead.  A non-zero value in arg turns read ahead
  //                    on.
  public func enableReadAhead(_ value: Bool) throws {
    _ = try _control(F_RDAHEAD, value ? 1 : 0)
  }

  // F_NOCACHE          Turns data caching off/on. A non-zero value in arg
  //                    turns data caching off.  A value of zero in arg turns
  //                    data caching on.
  public func disableDataCaching(_ value: Bool) throws {
    _ = try _control(F_NOCACHE, value ? 1 : 0)
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
    var arg = log2phys(l2p_flags: 0, l2p_contigbytes: 0, l2p_devoffset: 0)
    _ = try _control(F_LOG2PHYS, &arg)
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
    var arg = log2phys(
      l2p_flags: 0,
      l2p_contigbytes: COffsetT(numContiguousBytesToQuery),
      l2p_devoffset: COffsetT(offset))
    _ = try _control(F_LOG2PHYS_EXT, &arg)
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
    _ = try _control(F_BARRIERFSYNC)
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
    _ = try _control(F_FULLFSYNC)
  }

  // F_SETNOSIGPIPE     Determines whether a SIGPIPE signal will be generated
  //                    when a write fails on a pipe or socket for which there
  //                    is no reader.  If arg is non-zero, SIGPIPE generation
  //                    is disabled for descriptor fildes, while an arg of
  //                    zero enables it (the default).
  public func disableSIGPIPE(_ value: Bool = true) throws {
    _ = try _control(F_SETNOSIGPIPE, value ? 1 : 0)
  }

  // F_GETNOSIGPIPE     Returns whether a SIGPIPE signal will be generated
  //                    when a write fails on a pipe or socket for which there
  //                    is no reader.  The semantics of the return value match
  //                    those of the arg of F_SETNOSIGPIPE.
  public func hasDisabledSIGPIPE() throws -> Bool {
    return try _control(F_GETNOSIGPIPE) != 0
  }

  // TODO: WFT, docs have the below comment but never mention bootstrap commands
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
