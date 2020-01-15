/// TODO: docs
public struct FilePermissions: OptionSet {
  public let rawValue: CModeT
  public init(rawValue: CModeT) { self.rawValue = rawValue }
  private init(_ raw: CModeT) { self.init(rawValue: raw) }

  /// Read permissions for other
  public static var otherRead: FilePermissions { FilePermissions(0o4) }

  /// Write permissions for other
  public static var otherWrite: FilePermissions { FilePermissions(0o2) }

  /// Execute permissions for other
  public static var otherExecute: FilePermissions { FilePermissions(0o1) }

  /// Read-write mask for other
  public static var otherReadWrite: FilePermissions { FilePermissions(0o6) }

  /// Read-write-execute mask for other
  public static var otherReadWriteExecute: FilePermissions { FilePermissions(0o7) }

  /// Read for group
  public static var groupRead: FilePermissions { FilePermissions(0o40) }

  /// Write permissions for group
  public static var groupWrite: FilePermissions { FilePermissions(0o20) }

  /// Read-write mask for group
  public static var groupReadWrite: FilePermissions { FilePermissions(0o60) }

  /// Execute permissions for group
  public static var groupExecute: FilePermissions { FilePermissions(0o10) }

  /// Read-write-execute mask for group
  public static var groupReadWriteExecute: FilePermissions { FilePermissions(0o70) }

  /// Read for owner
  public static var ownerRead: FilePermissions { FilePermissions(0o400) }

  /// Write permissions for owner
  public static var ownerWrite: FilePermissions { FilePermissions(0o200) }

  /// Execute permissions for owner
  public static var ownerExecute: FilePermissions { FilePermissions(0o100) }

  /// Read-write mask for owner
  public static var ownerReadWrite: FilePermissions { FilePermissions(0o600) }

  /// Read-write-execute mask for owner
  public static var ownerReadWriteExecute: FilePermissions { FilePermissions(0o700) }

  /// set user id on execution
  public static var setUserID: FilePermissions { FilePermissions(0o4000) }

  /// set group id on execution
  public static var setGroupID: FilePermissions { FilePermissions(0o2000) }

  /// save swapped text even after use
  public static var saveText: FilePermissions { FilePermissions(0o1000) }
}
// TODO: Consider making Permisions ExpressibleByIntegerLiteral for octal literals...

// TODO: chmod family, access family
