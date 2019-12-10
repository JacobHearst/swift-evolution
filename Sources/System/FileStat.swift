public struct FileStat: RawRepresentable {
  public var rawValue: CStat
  public init(rawValue: CStat) { self.rawValue = rawValue }
}

extension FileStat {
  public struct DeviceID: RawRepresentable {
    public var rawValue: CDevT
    public init(rawValue raw: CDevT) { self.rawValue = raw }
  }

  // dev_t st_dev; /* ID of device containing file */
  public var device: DeviceID { DeviceID(rawValue: self.rawValue.st_dev) }

  // dev_t st_rdev; /* Device ID */
  //
  // TODO: better name: "realDevice", "deviceIfActuallyDevice?" ?
  public var deviceFileDevice: DeviceID { DeviceID(rawValue: self.rawValue.st_rdev) }
}

extension FileStat {
  private var stMode: CModeT { self.rawValue.st_mode }

  public struct FileType: RawRepresentable {
    public var rawValue: CModeT
    public init(rawValue: CModeT) { self.rawValue = rawValue }

    // S_IFIFO  0010000  /* named pipe (fifo) */
    public static var fifo: FileType { FileType(rawValue: _S_IFIFO) }

    // S_IFCHR  0020000  /* character special */
    public static var characterDevice: FileType { FileType(rawValue: _S_IFCHR) }

    // S_IFDIR  0040000  /* directory */
    public static var directory: FileType { FileType(rawValue: _S_IFDIR) }

    // S_IFBLK  0060000  /* block special */
    public static var blockDevice: FileType { FileType(rawValue: _S_IFBLK) }

    // S_IFREG  0100000  /* regular */
    public static var regular: FileType { FileType(rawValue: _S_IFREG) }

    // S_IFLNK  0120000  /* symbolic link */
    public static var symbolicLink: FileType { FileType(rawValue: _S_IFLNK) }

    // S_IFSOCK 0140000  /* socket */
    public static var socket: FileType { FileType(rawValue: _S_IFSOCK) }

    // S_IFWHT  0160000  /* whiteout */
    public static var whiteout: FileType { FileType(rawValue: _S_IFWHT) }
  }

  public var type: FileType { FileType(rawValue: stMode & _S_IFMT) }

  // FIXME: Remove hard coded number, maybe have a mask in Platform.swift
  public var permissions: FilePermissions { FilePermissions(rawValue: stMode & 0o7777) }
}

extension FileStat {
  // nlink_t st_nlink; /* Number of hard links */
  public var numHardLinks: Int { Int(self.rawValue.st_nlink) }
}

extension FileStat {
  public struct InodeID: RawRepresentable {
    public var rawValue: CInoT
    public init(rawValue: CInoT) { self.rawValue = rawValue }
  }

  // ino_t st_ino; /* File serial number */
  public var inode: InodeID { InodeID(rawValue: self.rawValue.st_ino) }

  public struct UserID: RawRepresentable {
    public var rawValue: CUIDT
    public init(rawValue: CUIDT) { self.rawValue = rawValue }
  }

  // uid_t st_uid; /* User ID of the file */
  public var user: UserID { UserID(rawValue: self.rawValue.st_uid) }

  public struct GroupID: RawRepresentable {
    public var rawValue: CGIDT
    public init(rawValue: CGIDT) { self.rawValue = rawValue }
  }

  // uid_t st_uid; /* User ID of the file */
  public var group: GroupID { GroupID(rawValue: self.rawValue.st_gid) }

  // struct timespec st_atimespec; /* time of last access */
  public var lastAccessTime: Timespec { Timespec(rawValue: self.rawValue.st_atimespec) }

  // struct timespec st_mtimespec; /* time of last data modification */
  public var lastModifyTime: Timespec { Timespec(rawValue: self.rawValue.st_mtimespec) }

  // struct timespec st_ctimespec; /* time of last status change */
  public var lastStatusChangeTime: Timespec { Timespec(rawValue: self.rawValue.st_ctimespec) }

  // struct timespec st_birthtimespec; /* time of file creation(birth) */
  public var creationTime: Timespec { Timespec(rawValue: self.rawValue.st_birthtimespec) }

  // off_t st_size; /* file size, in bytes */
  public var fileSize: Int64 { self.rawValue.st_size }

  // blkcnt_t st_blocks; /* blocks allocated for file */
  public var blockCount: Int { Int(self.rawValue.st_blocks) }

  // blksize_t st_blksize; /* optimal blocksize for I/O */
  public var blockSize: Int { Int(self.rawValue.st_blksize) }
}

extension FileStat {
  // uint32_t st_flags; /* user defined flags for file */
  public var userFlags: FileFlags { FileFlags(rawValue: self.rawValue.st_flags) }

  public struct GenerationID: RawRepresentable {
    public var rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }
  }

  // uint32_t st_gen; /* file generation number */
  public var generation: GenerationID { GenerationID(rawValue: self.rawValue.st_gen) }

}

extension FileDescriptor {
  public func stat() throws -> FileStat {
    var result = FileStat.RawValue()
    guard _fstat(self.rawValue, &result) == 0 else { throw errno }
    return FileStat(rawValue: result)
  }
}

extension Path {
  public func stat(followSymlinks: Bool = true) throws -> FileStat {
    var result = FileStat.RawValue()
    let stat = followSymlinks ? _stat : _lstat
    guard stat(self.bytes, &result) == 0 else { throw errno }
    return FileStat(rawValue: result)
  }
}

// TODO: where does `fstatat` fit in?
