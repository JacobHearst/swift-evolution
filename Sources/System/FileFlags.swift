import Darwin

public struct FileFlags: OptionSet {
  public var rawValue: CUInt
  public init(rawValue: CUInt) { self.rawValue = rawValue }

  // Do not dump the file.
  public static var noDump: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.UF_NODUMP))
  }

  // The file may not be changed.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  public static var immutable: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.UF_IMMUTABLE))
  }

  // The file may only be appended to.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  public static var append: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.UF_APPEND))
  }

  // The directory is opaque when viewed through a union stack.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  public static var opaque: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.UF_OPAQUE))
  }

  // The file or directory is not intended to be displayed to the user.
  //
  // This flag may be set or unset by either the owner of a file or the super-
  // user.
  public static var hidden: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.UF_HIDDEN))
  }

  // The file has been archived.
  //
  // This flag may only be set or unset by the super-user.
  public static var systemArchived: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.SF_ARCHIVED))
  }

  // The file may not be changed.
  //
  // This flag may only be set or unset by the super-user.
  public static var systemImmutable: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.SF_IMMUTABLE))
  }

  // The file may only be appended to.
  //
  // This flag may only be set or unset by the super-user.
  public static var systemAppend: FileFlags {
    FileFlags(rawValue: CUInt(bitPattern: Darwin.SF_APPEND))
  }
}

extension FileDescriptor {
  public func changeFlags(to flags: FileFlags) throws {
    guard Darwin.fchflags(self.rawValue, flags.rawValue) == 0 else { throw errno }
  }
}
extension Path {
  public func changeFlags(to flags: FileFlags) throws {
    guard Darwin.chflags(self.bytes, flags.rawValue) == 0 else { throw errno }
  }
}
