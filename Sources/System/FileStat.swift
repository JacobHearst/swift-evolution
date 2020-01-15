/*public*/internal struct FileStat: RawRepresentable {
  /*public*/internal var rawValue: CStat
  /*public*/internal init(rawValue: CStat) { self.rawValue = rawValue }
}

extension FileStat {
  /*public*/internal struct DeviceID: RawRepresentable {
    /*public*/internal var rawValue: CDevT
    /*public*/internal init(rawValue raw: CDevT) { self.rawValue = raw }
  }

  // dev_t st_dev; /* ID of device containing file */
  /*public*/internal var device: DeviceID { DeviceID(rawValue: self.rawValue.st_dev) }

  // dev_t st_rdev; /* Device ID */
  //
  // TODO: better name: "realDevice", "deviceIfActuallyDevice?" ?
  /*public*/internal var deviceFileDevice: DeviceID { DeviceID(rawValue: self.rawValue.st_rdev) }
}

extension FileStat {
  private var stMode: CModeT { self.rawValue.st_mode }

  /*public*/internal struct FileType: RawRepresentable {
    /*public*/internal var rawValue: CModeT
    /*public*/internal init(rawValue: CModeT) { self.rawValue = rawValue }

    // S_IFIFO  0010000  /* named pipe (fifo) */
    /*public*/internal static var fifo: FileType { FileType(rawValue: _S_IFIFO) }

    // S_IFCHR  0020000  /* character special */
    /*public*/internal static var characterDevice: FileType { FileType(rawValue: _S_IFCHR) }

    // S_IFDIR  0040000  /* directory */
    /*public*/internal static var directory: FileType { FileType(rawValue: _S_IFDIR) }

    // S_IFBLK  0060000  /* block special */
    /*public*/internal static var blockDevice: FileType { FileType(rawValue: _S_IFBLK) }

    // S_IFREG  0100000  /* regular */
    /*public*/internal static var regular: FileType { FileType(rawValue: _S_IFREG) }

    // S_IFLNK  0120000  /* symbolic link */
    /*public*/internal static var symbolicLink: FileType { FileType(rawValue: _S_IFLNK) }

    // S_IFSOCK 0140000  /* socket */
    /*public*/internal static var socket: FileType { FileType(rawValue: _S_IFSOCK) }

    // S_IFWHT  0160000  /* whiteout */
    /*public*/internal static var whiteout: FileType { FileType(rawValue: _S_IFWHT) }
  }

  /*public*/internal var type: FileType { FileType(rawValue: stMode & _S_IFMT) }

  // FIXME: Remove hard coded number, maybe have a mask in Platform.swift
  /*public*/internal var permissions: FilePermissions { FilePermissions(rawValue: stMode & 0o7777) }
}

extension FileStat {
  // nlink_t st_nlink; /* Number of hard links */
  /*public*/internal var numHardLinks: Int { Int(self.rawValue.st_nlink) }
}

extension FileStat {
  /*public*/internal struct InodeID: RawRepresentable {
    /*public*/internal var rawValue: CInoT
    /*public*/internal init(rawValue: CInoT) { self.rawValue = rawValue }
  }

  // ino_t st_ino; /* File serial number */
  /*public*/internal var inode: InodeID { InodeID(rawValue: self.rawValue.st_ino) }

  /*public*/internal struct UserID: RawRepresentable {
    /*public*/internal var rawValue: CUIDT
    /*public*/internal init(rawValue: CUIDT) { self.rawValue = rawValue }
  }

  // uid_t st_uid; /* User ID of the file */
  /*public*/internal var user: UserID { UserID(rawValue: self.rawValue.st_uid) }

  /*public*/internal struct GroupID: RawRepresentable {
    /*public*/internal var rawValue: CGIDT
    /*public*/internal init(rawValue: CGIDT) { self.rawValue = rawValue }
  }

  // uid_t st_uid; /* User ID of the file */
  /*public*/internal var group: GroupID { GroupID(rawValue: self.rawValue.st_gid) }

  // struct timespec st_atimespec; /* time of last access */
  /*public*/internal var lastAccessTime: Timespec { Timespec(rawValue: self.rawValue.st_atimespec) }

  // struct timespec st_mtimespec; /* time of last data modification */
  /*public*/internal var lastModifyTime: Timespec { Timespec(rawValue: self.rawValue.st_mtimespec) }

  // struct timespec st_ctimespec; /* time of last status change */
  /*public*/internal var lastStatusChangeTime: Timespec { Timespec(rawValue: self.rawValue.st_ctimespec) }

  // struct timespec st_birthtimespec; /* time of file creation(birth) */
  /*public*/internal var creationTime: Timespec { Timespec(rawValue: self.rawValue.st_birthtimespec) }

  // off_t st_size; /* file size, in bytes */
  /*public*/internal var fileSize: Int64 { self.rawValue.st_size }

  // blkcnt_t st_blocks; /* blocks allocated for file */
  /*public*/internal var blockCount: Int { Int(self.rawValue.st_blocks) }

  // blksize_t st_blksize; /* optimal blocksize for I/O */
  /*public*/internal var blockSize: Int { Int(self.rawValue.st_blksize) }
}

extension FileStat {
  // uint32_t st_flags; /* user defined flags for file */
  /*public*/internal var userFlags: FileFlags { FileFlags(rawValue: self.rawValue.st_flags) }

  /*public*/internal struct GenerationID: RawRepresentable {
    /*public*/internal var rawValue: CUInt32T
    /*public*/internal init(rawValue: CUInt32T) { self.rawValue = rawValue }
  }

  // uint32_t st_gen; /* file generation number */
  /*public*/internal var generation: GenerationID { GenerationID(rawValue: self.rawValue.st_gen) }

}

extension FileDescriptor {
  /*public*/internal func stat() throws -> FileStat {
    var result = FileStat.RawValue()
    guard _fstat(self.rawValue, &result) == 0 else { throw errno }
    return FileStat(rawValue: result)
  }
}

extension FilePath {
  /*public*/internal func stat(followSymlinks: Bool = true) throws -> FileStat {
    var result = FileStat.RawValue()
    let stat = followSymlinks ? _stat : _lstat
    guard stat(self.bytes, &result) == 0 else { throw errno }
    return FileStat(rawValue: result)
  }
}

// TODO: where does `fstatat` fit in?
