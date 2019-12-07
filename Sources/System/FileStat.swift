
public struct FileStat: RawRepresentable {
  public var rawValue: CStat
  public init(rawValue: CStat) { self.rawValue = rawValue }
}

// TODO: Separate file
public struct Time: RawRepresentable {
  public var rawValue: CTimeT
  public init(rawValue: CTimeT) { self.rawValue = rawValue }
}
public struct Timespec: RawRepresentable {
  public var rawValue: CTimespec
  public init(rawValue: CTimespec) { self.rawValue = rawValue }

  // TODO: Bleh, this is messy as C has them both type aliased to `long`...
  public var seconds: Time { Time(rawValue: self.rawValue.tv_sec) }

  public var nanoseconds: Int { self.rawValue.tv_nsec }
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
  // TODO: better name
  public var deviceFileDevice: DeviceID { DeviceID(rawValue: self.rawValue.st_rdev) }
}

extension FileStat {
  private var stMode: CModeT { self.rawValue.st_mode }

  public enum FileType: CModeT {
    // S_IFIFO  0010000  /* named pipe (fifo) */
    case fifo = 0o010000

    // S_IFCHR  0020000  /* character special */
    case characterDevice = 0o020000

    // S_IFDIR  0040000  /* directory */
    case directory = 0o040000

    // S_IFBLK  0060000  /* block special */
    case blockDevice = 0o060000

    // S_IFREG  0100000  /* regular */
    case regular = 0o100000

    // S_IFLNK  0120000  /* symbolic link */
    case symbolicLink = 0o120000

    // S_IFSOCK 0140000  /* socket */
    case socket = 0o140000

    // S_IFWHT  0160000  /* whiteout */
    case whiteout = 0o160000
  }

  // TODO: Are these always mutually exclusive?
  public var type: FileType { FileType(rawValue: stMode & 0o170000)! }

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
  public struct UserFlags: RawRepresentable {
    public var rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    // TODO: Maybe an option set, define actual flags...
  }

  // uint32_t st_flags; /* user defined flags for file */
  public var userFlags: UserFlags { UserFlags(rawValue: self.rawValue.st_flags) }

  public struct GenerationID: RawRepresentable {
    public var rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }
  }

  // uint32_t st_gen; /* file generation number */
  public var generation: GenerationID { GenerationID(rawValue: self.rawValue.st_gen) }

}

// TODO: chflags(2) for user flags

