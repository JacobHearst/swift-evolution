

import Darwin

public typealias CChar = Int8
public typealias CInt = Int32
public typealias CUInt32T = UInt32

public typealias CModeT = mode_t
public typealias COffsetT = off_t
public typealias CACLT = acl_t
public typealias CACLEntryT = acl_entry_t
public typealias CDevT = dev_t
public typealias CNLinkT = nlink_t
public typealias CStat = stat
public typealias CInoT = ino_t
public typealias CUIDT = uid_t
public typealias CGIDT = gid_t
public typealias CTimespec = timespec
public typealias CTimeT = time_t
public typealias CUInt = u_int

internal var eof: CInt { -1 }

/// ACLs
internal var _ACL_READ_DATA: CInt = (1<<1)
internal var _ACL_LIST_DIRECTORY: CInt =  _ACL_READ_DATA
internal var _ACL_WRITE_DATA: CInt = (1<<2)
internal var _ACL_ADD_FILE: CInt =  _ACL_WRITE_DATA
internal var _ACL_EXECUTE: CInt = (1<<3)
internal var _ACL_SEARCH: CInt =  _ACL_EXECUTE
internal var _ACL_DELETE: CInt = (1<<4)
internal var _ACL_APPEND_DATA: CInt = (1<<5)
internal var _ACL_ADD_SUBDIRECTORY: CInt =  _ACL_APPEND_DATA
internal var _ACL_DELETE_CHILD: CInt = (1<<6)
internal var _ACL_READ_ATTRIBUTES: CInt = (1<<7)
internal var _ACL_WRITE_ATTRIBUTES: CInt = (1<<8)
internal var _ACL_READ_EXTATTRIBUTES: CInt = (1<<9)
internal var _ACL_WRITE_EXTATTRIBUTES: CInt = (1<<10)
internal var _ACL_READ_SECURITY: CInt = (1<<11)
internal var _ACL_WRITE_SECURITY: CInt = (1<<12)
internal var _ACL_CHANGE_OWNER: CInt = (1<<13)
internal var _ACL_SYNCHRONIZE: CInt = (1<<20)

internal var _ACL_EXTENDED_ALLOW: CInt =  1
internal var _ACL_EXTENDED_DENY: CInt =  2

internal var _ACL_ENTRY_INHERITED: CInt = (1<<4)
internal var _ACL_ENTRY_FILE_INHERIT: CInt = (1<<5)
internal var _ACL_ENTRY_DIRECTORY_INHERIT: CInt = (1<<6)
internal var _ACL_ENTRY_LIMIT_INHERIT: CInt = (1<<7)
internal var _ACL_ENTRY_ONLY_INHERIT: CInt = (1<<8)
internal var _ACL_FLAG_NO_INHERIT: CInt = (1<<17)

