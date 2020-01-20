/// TODO: Consider dropping from API for now
/*public*/internal struct ACLPermissions: OptionSet {
  /*public*/internal let rawValue: CACLPermT
  /*public*/internal init(rawValue: CACLPermT) { self.rawValue = rawValue }
  fileprivate init(_ raw: CACLPermT) { self.init(rawValue: raw) }

  /// ACL_READ_DATA
  /*public*/internal static var readData: ACLPermissions {
    ACLPermissions(_ACL_READ_DATA)
  }

  /// ACL_LIST_DIRECTORY
  /*public*/internal static var listDirectory: ACLPermissions {
    ACLPermissions(_ACL_LIST_DIRECTORY)
  }

  /// ACL_WRITE_DATA
  /*public*/internal static var writeData: ACLPermissions {
    ACLPermissions(_ACL_WRITE_DATA)
  }

  /// ACL_ADD_FILE
  /*public*/internal static var addFile: ACLPermissions {
    ACLPermissions(_ACL_ADD_FILE)
  }

  /// ACL_EXECUTE
  /*public*/internal static var execute: ACLPermissions {
    ACLPermissions(_ACL_EXECUTE)
  }

  /// ACL_SEARCH
  /*public*/internal static var search: ACLPermissions {
    ACLPermissions(_ACL_SEARCH)
  }

  /// ACL_DELETE
  /*public*/internal static var delete: ACLPermissions {
    ACLPermissions(_ACL_DELETE)
  }

  /// ACL_APPEND_DATA
  /*public*/internal static var appendData: ACLPermissions {
    ACLPermissions(_ACL_APPEND_DATA)
  }

  /// ACL_ADD_SUBDIRECTORY
  /*public*/internal static var addSubdirectory: ACLPermissions {
    ACLPermissions(_ACL_ADD_SUBDIRECTORY)
  }

  /// ACL_DELETE_CHILD
  /*public*/internal static var deleteChild: ACLPermissions {
    ACLPermissions(_ACL_DELETE_CHILD)
  }

  /// ACL_READ_ATTRIBUTES
  /*public*/internal static var readAttributes: ACLPermissions {
    ACLPermissions(_ACL_READ_ATTRIBUTES)
  }

  /// ACL_WRITE_ATTRIBUTES
  /*public*/internal static var writeAttributes: ACLPermissions {
    ACLPermissions(_ACL_WRITE_ATTRIBUTES)
  }

  /// ACL_READ_EXTATTRIBUTES
  /*public*/internal static var readExtAttributes: ACLPermissions {
    ACLPermissions(_ACL_READ_EXTATTRIBUTES)
  }

  /// ACL_WRITE_EXTATTRIBUTES
  /*public*/internal static var writeExtAttributes: ACLPermissions {
    ACLPermissions(_ACL_WRITE_EXTATTRIBUTES)
  }

  /// ACL_READ_SECURITY
  /*public*/internal static var readSecurity: ACLPermissions {
    ACLPermissions(_ACL_READ_SECURITY)
  }

  /// ACL_WRITE_SECURITY
  /*public*/internal static var writeSecurity: ACLPermissions {
    ACLPermissions(_ACL_WRITE_SECURITY)
  }

  /// ACL_CHANGE_OWNER
  /*public*/internal static var changeWwner: ACLPermissions {
    ACLPermissions(_ACL_CHANGE_OWNER)
  }

  /// ACL_SYNCHRONIZE
  /*public*/internal static var synchronize: ACLPermissions {
    ACLPermissions(_ACL_SYNCHRONIZE)
  }
}

// TODO: Darwin module imports acl_tag_t as a struct, but isn't this exclusive?
/// TODO: Consider dropping from API for now
/*public*/internal struct ACLTag: RawRepresentable {
  /*public*/internal var rawValue: CACLTagT
  /*public*/internal init(rawValue: CACLTagT) { self.rawValue = rawValue }

  /// ACL_UNDEFINED_TAG
  /*public*/internal static var undefined: ACLTag { ACLTag(rawValue: _ACL_UNDEFINED_TAG) }

  /// ACL_EXTENDED_ALLOW
  /*public*/internal static var allow: ACLTag { ACLTag(rawValue: _ACL_EXTENDED_ALLOW) }

  /// ACL_EXTENDED_DENY
  /*public*/internal static var deny: ACLTag { ACLTag(rawValue: _ACL_EXTENDED_DENY) }
}

/// TODO: Consider dropping from API for now
/*public*/internal struct ACLEntryFlags: OptionSet {
  /*public*/internal let rawValue: CACLFlagT
  /*public*/internal init(rawValue: CACLFlagT) { self.rawValue = rawValue }
  fileprivate init(_ raw: CACLFlagT) { self.init(rawValue: raw) }

  /// ACL_FLAG_DEFER_INHERIT
  /*public*/internal static var flagDeferInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_FLAG_DEFER_INHERIT)
  }

  /// ACL_FLAG_NO_INHERIT
  /*public*/internal static var flagNoInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_FLAG_NO_INHERIT)
  }

  /// ACL_ENTRY_INHERITED
  /*public*/internal static var entryInherited: ACLEntryFlags {
    ACLEntryFlags(_ACL_ENTRY_INHERITED)
  }

  /// ACL_ENTRY_FILE_INHERIT
  /*public*/internal static var entryFileInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_ENTRY_FILE_INHERIT)
  }

  /// ACL_ENTRY_DIRECTORY_INHERIT
  /*public*/internal static var entryDirectoryInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_ENTRY_DIRECTORY_INHERIT)
  }

  /// ACL_ENTRY_LIMIT_INHERIT
  /*public*/internal static var entryLimitInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_ENTRY_LIMIT_INHERIT)
  }

  /// ACL_ENTRY_ONLY_INHERIT
  /*public*/internal static var entryOnlyInherit: ACLEntryFlags {
    ACLEntryFlags(_ACL_ENTRY_ONLY_INHERIT)
  }
}

/// TODO: Consider dropping from API for now
/*public*/internal struct ACLHandle: RawRepresentable {
  /*public*/internal let rawValue: CACLT
  /*public*/internal init(rawValue: CACLT) { self.rawValue = rawValue }
  fileprivate init(_ raw: CACLT) { self.init(rawValue: raw) }
}

extension ACLHandle {
  /// TODO: Consider dropping from API for now
  /*public*/internal static func create(count: Int) throws -> ACLHandle {
    guard let ptr = _acl_init(CInt(count)) else { throw Errno.current }
    return ACLHandle(ptr)
  }

  /// TODO: Consider dropping from API for now
  /*public*/internal func duplicate() throws -> ACLHandle {
    guard let ptr = _acl_dup(self.rawValue) else { throw Errno.current }
    return ACLHandle(ptr)
  }

  /// TODO: Consider dropping from API for now
  /*public*/internal func free() throws {
    guard _acl_free(UnsafeMutableRawPointer(self.rawValue)) == 0 else { throw Errno.current }
  }

  // ...
}

/// TODO: Consider dropping from API for now
/*public*/internal struct ACLEntryHandle: RawRepresentable {
  /*public*/internal let rawValue: CACLEntryT
  /*public*/internal init(rawValue: CACLEntryT) { self.rawValue = rawValue }
  fileprivate init(_ raw: CACLEntryT) { self.init(rawValue: raw) }
}

extension ACLEntryHandle {
  // ...
}

