
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#else
#error("FIXME: Linux support, other platform support")
#endif

// Types

/// TODO: Consider a different naming scheme.
/// This exists to service RawRepresentable structs
public typealias CChar = Int8

/// TODO: Consider a different naming scheme.
/// This exists to service RawRepresentable structs
public typealias CInt = Int32

/*public*/internal typealias CUInt32T = UInt32
/*public*/internal typealias CUInt16T = UInt16
/*public*/internal typealias CInt16T = Int16
/*public*/internal typealias CUInt = u_int

/// TODO: Consider a different naming scheme.
/// This exists to service RawRepresentable structs
public typealias CModeT = mode_t

/*public*/internal typealias COffT = off_t

/*public*/internal typealias CFILE = FILE

/*public*/internal typealias CACLT = acl_t
/*public*/internal typealias CACLTagT = acl_tag_t.RawValue
/*public*/internal typealias CACLFlagT = acl_flag_t.RawValue
/*public*/internal typealias CACLEntryT = acl_entry_t
/*public*/internal typealias CACLPermT = acl_perm_t.RawValue

/*public*/internal typealias CDevT = dev_t
/*public*/internal typealias CNLinkT = nlink_t
/*public*/internal typealias CStat = stat
/*public*/internal typealias CInoT = ino_t
/*public*/internal typealias CUIDT = uid_t
/*public*/internal typealias CGIDT = gid_t
/*public*/internal typealias CTimespec = timespec
/*public*/internal typealias CTimeT = time_t

// Internal types
internal typealias CFStoreT = fstore_t
internal typealias CFPunchholdT = fpunchhole_t
internal typealias CRAdvisory = radvisory
internal typealias CLog2Phys = log2phys

internal typealias CSockLenT = socklen_t
internal typealias CSockAddr = sockaddr
internal typealias CSockAddrIn = sockaddr_in
internal typealias CSockAddrUn = sockaddr_un
internal typealias CMsgHdr = msghdr

internal typealias CSSizeT = ssize_t

// Polling

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
/*public*/internal typealias CKEvent = kevent
#else
#error("FIXME: Linux epoll support")
#endif
// TODO: Should we even do select/poll?


// MARK: - Values

internal var _eof: CInt { EOF }

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
internal var _errno: CInt {
  get { Darwin.errno }
  set { Darwin.errno = newValue }
}
#else
#error("FIXME: Linux support, other platform support")
#endif

internal var _O_RDONLY: CInt { O_RDONLY }
internal var _O_WRONLY: CInt { O_WRONLY }
internal var _O_RDWR: CInt { O_RDWR }

internal var _O_NONBLOCK: CInt { O_NONBLOCK }
internal var _O_APPEND: CInt { O_APPEND }
internal var _O_CREAT: CInt { O_CREAT }
internal var _O_TRUNC: CInt { O_TRUNC }
internal var _O_EXCL: CInt { O_EXCL }
internal var _O_SHLOCK: CInt { O_SHLOCK }
internal var _O_EXLOCK: CInt { O_EXLOCK }
internal var _O_NOFOLLOW: CInt { O_NOFOLLOW }
internal var _O_SYMLINK: CInt { O_SYMLINK }
internal var _O_EVTONLY: CInt { O_EVTONLY }
internal var _O_CLOEXEC: CInt { O_CLOEXEC }

internal var _SEEK_SET: CInt { SEEK_SET }
internal var _SEEK_CUR: CInt { SEEK_CUR }
internal var _SEEK_END: CInt { SEEK_END }
internal var _SEEK_HOLE: CInt { SEEK_HOLE }
internal var _SEEK_DATA: CInt { SEEK_DATA }

internal var _UF_NODUMP: CUInt { CUInt(bitPattern: UF_NODUMP) }
internal var _UF_IMMUTABLE: CUInt { CUInt(bitPattern: UF_IMMUTABLE) }
internal var _UF_APPEND: CUInt { CUInt(bitPattern: UF_APPEND) }
internal var _UF_OPAQUE: CUInt { CUInt(bitPattern: UF_OPAQUE) }
internal var _UF_HIDDEN: CUInt { CUInt(bitPattern: UF_HIDDEN) }
internal var _SF_ARCHIVED: CUInt { CUInt(bitPattern: SF_ARCHIVED) }
internal var _SF_IMMUTABLE: CUInt { CUInt(bitPattern: SF_IMMUTABLE) }
internal var _SF_APPEND: CUInt { CUInt(bitPattern: SF_APPEND) }

internal var _S_IFMT: CModeT { S_IFMT }
internal var _S_IFIFO: CModeT { S_IFIFO }
internal var _S_IFCHR: CModeT { S_IFCHR }
internal var _S_IFDIR: CModeT { S_IFDIR }
internal var _S_IFBLK: CModeT { S_IFBLK }
internal var _S_IFREG: CModeT { S_IFREG }
internal var _S_IFLNK: CModeT { S_IFLNK }
internal var _S_IFSOCK: CModeT { S_IFSOCK }
internal var _S_IFWHT: CModeT { S_IFWHT }

internal var _MSG_OOB: CInt { MSG_OOB }
internal var _MSG_DONTROUTE: CInt { MSG_DONTROUTE }
internal var _MSG_PEEK: CInt { MSG_PEEK }
internal var _MSG_WAITALL: CInt { MSG_WAITALL }

internal var _MAXPATHLEN: CInt { MAXPATHLEN }

// errno
internal var _ERRNO_NOT_USED: CInt { 0 } // TODO: Darwin-specific?
internal var _EPERM: CInt { EPERM }
internal var _ENOENT: CInt { ENOENT }
internal var _ESRCH: CInt { ESRCH }
internal var _EINTR: CInt { EINTR }
internal var _EIO: CInt { EIO }
internal var _ENXIO: CInt { ENXIO }
internal var _E2BIG: CInt { E2BIG }
internal var _ENOEXEC: CInt { ENOEXEC }
internal var _EBADF: CInt { EBADF }
internal var _ECHILD: CInt { ECHILD }
internal var _EDEADLK: CInt { EDEADLK }
internal var _ENOMEM: CInt { ENOMEM }
internal var _EACCES: CInt { EACCES }
internal var _EFAULT: CInt { EFAULT }
internal var _ENOTBLK: CInt { ENOTBLK }
internal var _EBUSY: CInt { EBUSY }
internal var _EEXIST: CInt { EEXIST }
internal var _EXDEV: CInt { EXDEV }
internal var _ENODEV: CInt { ENODEV }
internal var _ENOTDIR: CInt { ENOTDIR }
internal var _EISDIR: CInt { EISDIR }
internal var _EINVAL: CInt { EINVAL }
internal var _ENFILE: CInt { ENFILE }
internal var _EMFILE: CInt { EMFILE }
internal var _ENOTTY: CInt { ENOTTY }
internal var _ETXTBSY: CInt { ETXTBSY }
internal var _EFBIG: CInt { EFBIG }
internal var _ENOSPC: CInt { ENOSPC }
internal var _ESPIPE: CInt { ESPIPE }
internal var _EROFS: CInt { EROFS }
internal var _EMLINK: CInt { EMLINK }
internal var _EPIPE: CInt { EPIPE }
internal var _EDOM: CInt { EDOM }
internal var _ERANGE: CInt { ERANGE }
internal var _EAGAIN: CInt { EAGAIN }
internal var _EINPROGRESS: CInt { EINPROGRESS }
internal var _EALREADY: CInt { EALREADY }
internal var _ENOTSOCK: CInt { ENOTSOCK }
internal var _EDESTADDRREQ: CInt { EDESTADDRREQ }
internal var _EMSGSIZE: CInt { EMSGSIZE }
internal var _EPROTOTYPE: CInt { EPROTOTYPE }
internal var _ENOPROTOOPT: CInt { ENOPROTOOPT }
internal var _EPROTONOSUPPORT: CInt { EPROTONOSUPPORT }
internal var _ESOCKTNOSUPPORT: CInt { ESOCKTNOSUPPORT }
internal var _ENOTSUP: CInt { ENOTSUP }
internal var _EPFNOSUPPORT: CInt { EPFNOSUPPORT }
internal var _EAFNOSUPPORT: CInt { EAFNOSUPPORT }
internal var _EADDRINUSE: CInt { EADDRINUSE }
internal var _EADDRNOTAVAIL: CInt { EADDRNOTAVAIL }
internal var _ENETDOWN: CInt { ENETDOWN }
internal var _ENETUNREACH: CInt { ENETUNREACH }
internal var _ENETRESET: CInt { ENETRESET }
internal var _ECONNABORTED: CInt { ECONNABORTED }
internal var _ECONNRESET: CInt { ECONNRESET }
internal var _ENOBUFS: CInt { ENOBUFS }
internal var _EISCONN: CInt { EISCONN }
internal var _ENOTCONN: CInt { ENOTCONN }
internal var _ESHUTDOWN: CInt { ESHUTDOWN }
internal var _ETIMEDOUT: CInt { ETIMEDOUT }
internal var _ECONNREFUSED: CInt { ECONNREFUSED }
internal var _ELOOP: CInt { ELOOP }
internal var _ENAMETOOLONG: CInt { ENAMETOOLONG }
internal var _EHOSTDOWN: CInt { EHOSTDOWN }
internal var _EHOSTUNREACH: CInt { EHOSTUNREACH }
internal var _ENOTEMPTY: CInt { ENOTEMPTY }
internal var _EPROCLIM: CInt { EPROCLIM }
internal var _EUSERS: CInt { EUSERS }
internal var _EDQUOT: CInt { EDQUOT }
internal var _ESTALE: CInt { ESTALE }
internal var _EBADRPC: CInt { EBADRPC }
internal var _ERPCMISMATCH: CInt { ERPCMISMATCH }
internal var _EPROGUNAVAIL: CInt { EPROGUNAVAIL }
internal var _EPROGMISMATCH: CInt { EPROGMISMATCH }
internal var _EPROCUNAVAIL: CInt { EPROCUNAVAIL }
internal var _ENOLCK: CInt { ENOLCK }
internal var _ENOSYS: CInt { ENOSYS }
internal var _EFTYPE: CInt { EFTYPE }
internal var _EAUTH: CInt { EAUTH }
internal var _ENEEDAUTH: CInt { ENEEDAUTH }
internal var _EPWROFF: CInt { EPWROFF }
internal var _EDEVERR: CInt { EDEVERR }
internal var _EOVERFLOW: CInt { EOVERFLOW }
internal var _EBADEXEC: CInt { EBADEXEC }
internal var _EBADARCH: CInt { EBADARCH }
internal var _ESHLIBVERS: CInt { ESHLIBVERS }
internal var _EBADMACHO: CInt { EBADMACHO }
internal var _ECANCELED: CInt { ECANCELED }
internal var _EIDRM: CInt { EIDRM }
internal var _ENOMSG: CInt { ENOMSG }
internal var _EILSEQ: CInt { EILSEQ }
internal var _ENOATTR: CInt { ENOATTR }
internal var _EBADMSG: CInt { EBADMSG }
internal var _EMULTIHOP: CInt { EMULTIHOP }
internal var _ENODATA: CInt { ENODATA }
internal var _ENOLINK: CInt { ENOLINK }
internal var _ENOSR: CInt { ENOSR }
internal var _ENOSTR: CInt { ENOSTR }
internal var _EPROTO: CInt { EPROTO }
internal var _ETIME: CInt { ETIME }
internal var _EOPNOTSUPP: CInt { EOPNOTSUPP }


// fcntl
internal var _F_DUPFD_CLOEXEC: CInt { F_DUPFD_CLOEXEC }
internal var _F_DUPFD: CInt { F_DUPFD }
internal var _F_GETFD: CInt { F_GETFD }
internal var _F_SETFD: CInt { F_SETFD }
internal var _F_GETFL: CInt { F_GETFL }
internal var _F_SETFL: CInt { F_SETFL }
internal var _F_GETOWN: CInt { F_GETOWN }
internal var _F_SETOWN: CInt { F_SETOWN }
internal var _F_GETPATH_NOFIRMLINK: CInt { F_GETPATH_NOFIRMLINK }
internal var _F_GETPATH: CInt { F_GETPATH }
internal var _F_PEOFPOSMODE: CInt { F_PEOFPOSMODE }
internal var _F_PREALLOCATE: CInt { F_PREALLOCATE }
internal var _F_PUNCHHOLE: CInt { F_PUNCHHOLE }
internal var _F_SETSIZE: CInt { F_SETSIZE }
internal var _F_RDADVISE: CInt { F_RDADVISE }
internal var _F_RDAHEAD: CInt { F_RDAHEAD }
internal var _F_NOCACHE: CInt { F_NOCACHE }
internal var _F_LOG2PHYS: CInt { F_LOG2PHYS }
internal var _F_LOG2PHYS_EXT: CInt { F_LOG2PHYS_EXT }
internal var _F_BARRIERFSYNC: CInt { F_BARRIERFSYNC }
internal var _F_FULLFSYNC: CInt { F_FULLFSYNC }
internal var _F_SETNOSIGPIPE: CInt { F_SETNOSIGPIPE }
internal var _F_GETNOSIGPIPE: CInt { F_GETNOSIGPIPE }

// Sockets
internal var _PF_LOCAL: CInt { PF_LOCAL }
internal var _PF_UNIX: CInt { PF_UNIX }
internal var _PF_INET: CInt { PF_INET }
internal var _PF_ROUTE: CInt { PF_ROUTE }
internal var _PF_KEY: CInt { PF_KEY }
internal var _PF_INET6: CInt { PF_INET6 }
internal var _PF_SYSTEM: CInt { PF_SYSTEM }
internal var _PF_NDRV: CInt { PF_NDRV }

internal var _SOCK_STREAM: CInt { SOCK_STREAM }
internal var _SOCK_DGRAM: CInt { SOCK_DGRAM }
internal var _SOCK_RAW: CInt { SOCK_RAW }


// Polling
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
internal var _EV_ADD: CUInt16T { UInt16(bitPattern: Int16(EV_ADD)) }
internal var _EV_ENABLE: CUInt16T { UInt16(bitPattern: Int16(EV_ENABLE)) }
internal var _EV_DISABLE: CUInt16T { UInt16(bitPattern: Int16(EV_DISABLE)) }
internal var _EV_DELETE: CUInt16T { UInt16(bitPattern: Int16(EV_DELETE)) }
internal var _EV_RECEIPT: CUInt16T { UInt16(bitPattern: Int16(EV_RECEIPT)) }
internal var _EV_ONESHOT: CUInt16T { UInt16(bitPattern: Int16(EV_ONESHOT)) }
internal var _EV_CLEAR: CUInt16T { UInt16(bitPattern: Int16(EV_CLEAR)) }
internal var _EV_EOF: CUInt16T { UInt16(bitPattern: Int16(EV_EOF)) }
internal var _EV_OOBAND: CUInt16T { UInt16(bitPattern: Int16(EV_OOBAND)) }
internal var _EV_ERROR: CUInt16T { UInt16(bitPattern: Int16(EV_ERROR)) }
internal var _EV_POLL: CUInt16T { UInt16(bitPattern: Int16(EV_POLL)) }
// TODO: dispatch? dispatch2? udata_specific? vanished? flag0/1? poll?

internal var _EVFILT_READ: CInt16T { Int16(EVFILT_READ) }
internal var _EVFILT_EXCEPT: CInt16T { Int16(EVFILT_EXCEPT) }
internal var _EVFILT_WRITE: CInt16T { Int16(EVFILT_WRITE) }
internal var _EVFILT_AIO: CInt16T { Int16(EVFILT_AIO) }
internal var _EVFILT_VNODE: CInt16T { Int16(EVFILT_VNODE) }
internal var _EVFILT_PROC: CInt16T { Int16(EVFILT_PROC) }
internal var _EVFILT_SIGNAL: CInt16T { Int16(EVFILT_SIGNAL) }
internal var _EVFILT_MACHPORT: CInt16T { Int16(EVFILT_MACHPORT) }
internal var _EVFILT_TIMER: CInt16T { Int16(EVFILT_TIMER) }
internal var _EVFILT_FS: CInt16T { Int16(EVFILT_FS) }
internal var _EVFILT_USER: CInt16T { Int16(EVFILT_USER) }
internal var _EVFILT_VM: CInt16T { Int16(EVFILT_VM) }
// TODO: syscount? threadmarker?

internal var _NOTE_TRIGGER: CUInt32T { UInt32(bitPattern: NOTE_TRIGGER) }
internal var _NOTE_FFNOP: CUInt32T { UInt32(bitPattern: NOTE_FFNOP) }
internal var _NOTE_FFAND: CUInt32T { UInt32(bitPattern: NOTE_FFAND) }
internal var _NOTE_FFOR: CUInt32T { NOTE_FFOR }
internal var _NOTE_FFCOPY: CUInt32T { NOTE_FFCOPY }
internal var _NOTE_FFCTRLMASK: CUInt32T { NOTE_FFCTRLMASK }
internal var _NOTE_FFLAGSMASK: CUInt32T { UInt32(bitPattern: NOTE_FFLAGSMASK) }
internal var _NOTE_LOWAT: CUInt32T { UInt32(bitPattern: NOTE_LOWAT) }
internal var _NOTE_OOB: CUInt32T { UInt32(bitPattern: NOTE_OOB) }
internal var _NOTE_DELETE: CUInt32T { UInt32(bitPattern: NOTE_DELETE) }
internal var _NOTE_WRITE: CUInt32T { UInt32(bitPattern: NOTE_WRITE) }
internal var _NOTE_EXTEND: CUInt32T { UInt32(bitPattern: NOTE_EXTEND) }
internal var _NOTE_ATTRIB: CUInt32T { UInt32(bitPattern: NOTE_ATTRIB) }
internal var _NOTE_LINK: CUInt32T { UInt32(bitPattern: NOTE_LINK) }
internal var _NOTE_RENAME: CUInt32T { UInt32(bitPattern: NOTE_RENAME) }
internal var _NOTE_REVOKE: CUInt32T { UInt32(bitPattern: NOTE_REVOKE) }
internal var _NOTE_NONE: CUInt32T { UInt32(bitPattern: NOTE_NONE) }
internal var _NOTE_FUNLOCK: CUInt32T { UInt32(bitPattern: NOTE_FUNLOCK) }
internal var _NOTE_EXIT: CUInt32T { NOTE_EXIT }
internal var _NOTE_FORK: CUInt32T { UInt32(bitPattern: NOTE_FORK) }
internal var _NOTE_EXEC: CUInt32T { UInt32(bitPattern: NOTE_EXEC) }
internal var _NOTE_SIGNAL: CUInt32T { UInt32(bitPattern: NOTE_SIGNAL) }
internal var _NOTE_EXITSTATUS: CUInt32T { UInt32(bitPattern: NOTE_EXITSTATUS) }
internal var _NOTE_EXIT_DETAIL: CUInt32T { UInt32(bitPattern: NOTE_EXIT_DETAIL) }
internal var _NOTE_PDATAMASK: CUInt32T { UInt32(bitPattern: NOTE_PDATAMASK) }
internal var _NOTE_EXIT_DETAIL_MASK: CUInt32T { UInt32(bitPattern: NOTE_EXIT_DETAIL_MASK) }
internal var _NOTE_EXIT_DECRYPTFAIL: CUInt32T { UInt32(bitPattern: NOTE_EXIT_DECRYPTFAIL) }
internal var _NOTE_EXIT_MEMORY: CUInt32T { UInt32(bitPattern: NOTE_EXIT_MEMORY) }
internal var _NOTE_EXIT_CSERROR: CUInt32T { UInt32(bitPattern: NOTE_EXIT_CSERROR) }
internal var _NOTE_VM_PRESSURE: CUInt32T { NOTE_VM_PRESSURE }
internal var _NOTE_VM_PRESSURE_TERMINATE: CUInt32T { UInt32(bitPattern: NOTE_VM_PRESSURE_TERMINATE) }
internal var _NOTE_VM_PRESSURE_SUDDEN_TERMINATE: CUInt32T { UInt32(bitPattern: NOTE_VM_PRESSURE_SUDDEN_TERMINATE) }
internal var _NOTE_VM_ERROR: CUInt32T { UInt32(bitPattern: NOTE_VM_ERROR) }
internal var _NOTE_SECONDS: CUInt32T { UInt32(bitPattern: NOTE_SECONDS) }
internal var _NOTE_USECONDS: CUInt32T { UInt32(bitPattern: NOTE_USECONDS) }
internal var _NOTE_NSECONDS: CUInt32T { UInt32(bitPattern: NOTE_NSECONDS) }
internal var _NOTE_ABSOLUTE: CUInt32T { UInt32(bitPattern: NOTE_ABSOLUTE) }
internal var _NOTE_LEEWAY: CUInt32T { UInt32(bitPattern: NOTE_LEEWAY) }
internal var _NOTE_CRITICAL: CUInt32T { UInt32(bitPattern: NOTE_CRITICAL) }
internal var _NOTE_BACKGROUND: CUInt32T { UInt32(bitPattern: NOTE_BACKGROUND) }
internal var _NOTE_MACH_CONTINUOUS_TIME: CUInt32T { UInt32(bitPattern: NOTE_MACH_CONTINUOUS_TIME) }
internal var _NOTE_MACHTIME: CUInt32T { UInt32(bitPattern: NOTE_MACHTIME) }
internal var _NOTE_TRACK: CUInt32T { UInt32(bitPattern: NOTE_TRACK) }
internal var _NOTE_TRACKERR: CUInt32T { UInt32(bitPattern: NOTE_TRACKERR) }
internal var _NOTE_CHILD: CUInt32T { UInt32(bitPattern: NOTE_CHILD) }

#else
#error("FIXME: Linux epoll support")
#endif
// TODO: Should we even do select/poll?


// ACL permissions
internal var _ACL_READ_DATA: CACLPermT { ACL_READ_DATA.rawValue }
internal var _ACL_LIST_DIRECTORY: CACLPermT { ACL_LIST_DIRECTORY.rawValue }
internal var _ACL_WRITE_DATA: CACLPermT { ACL_WRITE_DATA.rawValue }
internal var _ACL_ADD_FILE: CACLPermT { ACL_ADD_FILE.rawValue }
internal var _ACL_EXECUTE: CACLPermT { ACL_EXECUTE.rawValue }
internal var _ACL_SEARCH: CACLPermT { ACL_SEARCH.rawValue }
internal var _ACL_DELETE: CACLPermT { ACL_DELETE.rawValue }
internal var _ACL_APPEND_DATA: CACLPermT { ACL_APPEND_DATA.rawValue }
internal var _ACL_ADD_SUBDIRECTORY: CACLPermT { ACL_ADD_SUBDIRECTORY.rawValue }
internal var _ACL_DELETE_CHILD: CACLPermT { ACL_DELETE_CHILD.rawValue }
internal var _ACL_READ_ATTRIBUTES: CACLPermT { ACL_READ_ATTRIBUTES.rawValue }
internal var _ACL_WRITE_ATTRIBUTES: CACLPermT { ACL_WRITE_ATTRIBUTES.rawValue }
internal var _ACL_READ_EXTATTRIBUTES: CACLPermT { ACL_READ_EXTATTRIBUTES.rawValue }
internal var _ACL_WRITE_EXTATTRIBUTES: CACLPermT { ACL_WRITE_EXTATTRIBUTES.rawValue }
internal var _ACL_READ_SECURITY: CACLPermT { ACL_READ_SECURITY.rawValue }
internal var _ACL_WRITE_SECURITY: CACLPermT { ACL_WRITE_SECURITY.rawValue }
internal var _ACL_CHANGE_OWNER: CACLPermT { ACL_CHANGE_OWNER.rawValue }
internal var _ACL_SYNCHRONIZE: CACLPermT { ACL_SYNCHRONIZE.rawValue }

// ACL tags
internal var _ACL_UNDEFINED_TAG: CACLTagT { ACL_UNDEFINED_TAG.rawValue }
internal var _ACL_EXTENDED_ALLOW: CACLTagT { ACL_EXTENDED_ALLOW.rawValue }
internal var _ACL_EXTENDED_DENY: CACLTagT { ACL_EXTENDED_DENY.rawValue }

// ACL flags
internal var _ACL_FLAG_DEFER_INHERIT: CACLFlagT { ACL_FLAG_DEFER_INHERIT.rawValue }
internal var _ACL_FLAG_NO_INHERIT: CACLFlagT { ACL_FLAG_NO_INHERIT.rawValue }
internal var _ACL_ENTRY_INHERITED: CACLFlagT { ACL_ENTRY_INHERITED.rawValue }
internal var _ACL_ENTRY_FILE_INHERIT: CACLFlagT { ACL_ENTRY_FILE_INHERIT.rawValue }
internal var _ACL_ENTRY_DIRECTORY_INHERIT: CACLFlagT { ACL_ENTRY_DIRECTORY_INHERIT.rawValue }
internal var _ACL_ENTRY_LIMIT_INHERIT: CACLFlagT { ACL_ENTRY_LIMIT_INHERIT.rawValue }
internal var _ACL_ENTRY_ONLY_INHERIT: CACLFlagT { ACL_ENTRY_ONLY_INHERIT.rawValue }

// MARK: - System Calls

internal func _fcntl(_ fd: Int32, _ cmd: Int32) -> Int32 {
  fcntl(fd, cmd)
}
internal func _fcntl(_ fd: Int32, _ cmd: Int32, _ value: Int32) -> Int32 {
  fcntl(fd, cmd, value)
}
internal func _fcntl(_ fd: Int32, _ cmd: Int32, _ ptr: UnsafeMutableRawPointer) -> Int32 {
  fcntl(fd, cmd, ptr)
}

internal func _open(_ path: UnsafePointer<CChar>, _ oflag: Int32) -> Int32 {
  open(path, oflag)
}
internal func _open(
  _ path: UnsafePointer<CChar>, _ oflag: Int32, _ mode: mode_t
) -> Int32 {
  open(path, oflag, mode)
}

internal let _close = close
internal let _read = read
internal let _pread = pread
internal let _lseek = lseek
internal let _write = write
internal let _pwrite = pwrite

internal let _fopen = fopen
internal let _fclose = fclose
internal let _fwrite = fwrite
internal let _fread = fread
internal let _setbuffer = setbuffer
internal let _fflush = fflush

internal let _fchflags = fchflags
internal let _chflags = chflags

internal let _fstat = fstat
internal let _lstat = lstat
internal let _stat = stat

// Sockets
internal let _socket = socket
internal let _connect = connect
internal let _listen = listen
internal let _bind = bind
internal let _send = send
internal let _sendmsg = sendmsg
internal let _sendto = sendto
internal let _recv = recv
internal let _recvmsg = recvmsg
internal let _recvfrom = recvfrom


// C stdlib
internal let _strlen = strlen

// ACL
internal let _acl_init = acl_init
internal let _acl_dup = acl_dup
internal let _acl_free = acl_free


// Polling

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
internal let _kqueue = kqueue
#else
#error("FIXME: Linux epoll support")
#endif
// TODO: Should we even do select/poll?
