/*public*/internal struct FileFlags: OptionSet {
  /*public*/internal var rawValue: CUInt
  /*public*/internal init(rawValue: CUInt) { self.rawValue = rawValue }

  // Do not dump the file.
  /*public*/internal static var noDump: FileFlags { FileFlags(rawValue: _UF_NODUMP) }

  // The file may not be changed.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  /*public*/internal static var immutable: FileFlags { FileFlags(rawValue: _UF_IMMUTABLE) }

  // The file may only be appended to.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  /*public*/internal static var append: FileFlags { FileFlags(rawValue: _UF_APPEND) }

  // The directory is opaque when viewed through a union stack.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  /*public*/internal static var opaque: FileFlags { FileFlags(rawValue: _UF_OPAQUE) }

  // The file or directory is not intended to be displayed to the user.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  /*public*/internal static var hidden: FileFlags { FileFlags(rawValue: _UF_HIDDEN) }

  // The file has been archived.
  //
  // This flag may only be set or unset by the super-user.
  /*public*/internal static var systemArchived: FileFlags {
    FileFlags(rawValue: _SF_ARCHIVED)
  }

  // The file may not be changed.
  //
  // This flag may only be set or unset by the super-user.
  /*public*/internal static var systemImmutable: FileFlags {
    FileFlags(rawValue: _SF_IMMUTABLE)
  }

  // The file may only be appended to.
  //
  // This flag may only be set or unset by the super-user.
  /*public*/internal static var systemAppend: FileFlags { FileFlags(rawValue: _SF_APPEND) }
}

extension FileDescriptor {
  /*public*/internal func changeFlags(to flags: FileFlags) throws {
    guard _fchflags(self.rawValue, flags.rawValue) == 0 else { throw Errno.current }
  }
}
extension FilePath {
  /*public*/internal func changeFlags(to flags: FileFlags) throws {
    guard _chflags(self.bytes, flags.rawValue) == 0 else { throw Errno.current }
  }
}
