// NOTE: Comments and meanings below are for Darwin. Other platforms may have to
// extensively #if/else/endif

/// TODO: Docs
public struct Errno: RawRepresentable, Error {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
  private init(_ raw: CInt) { self.init(rawValue: raw) }

  /// Error. Not used.
  public static var notUsed: Errno { Errno(_ERRNO_NOT_USED) }

  /// EPERM: Operation not permitted.
  ///
  /// An attempt was made to perform an oper- ation limited to processes with
  /// appropriate privileges or to the owner of a file or other resources.
  public static var notPermitted: Errno { Errno(_EPERM) }

  /// ENOENT: No such file or directory.
  ///
  /// A component of a specified pathname did not exist, or the pathname was an
  /// empty string.
  public static var noSuchFileOrDirectory: Errno { Errno(_ENOENT) }

  /// ESRCH: No such process.
  ///
  /// No process could be found corresponding to that specified by the given
  /// process ID.
  public static var noSuchProcess: Errno { Errno(_ESRCH) }

  /// EINTR: Interrupted function call.
  ///
  /// An asynchronous signal (such as SIGINT or SIGQUIT) was caught by the
  /// process during the execution of an interruptible function. If the signal
  /// handler performs a normal return, the interrupted function call will seem
  /// to have returned the error condition.
  public static var interrupted: Errno { Errno(_EINTR) }

  /// EIO: Input/output error.
  ///
  /// Some physical input or output error occurred. This error will not be
  /// reported until a subsequent operation on the same file descriptor and may
  /// be lost (over written) by any subsequent errors.
  public static var ioError: Errno { Errno(_EIO) }

  /// ENXIO: No such device or address.
  ///
  /// Input or output on a special file referred to a device that did not exist,
  /// or made a request beyond the limits of the device.  This error may also
  /// occur when, for example, a tape drive is not online or no disk pack is
  /// loaded on a drive.
  public static var noSuchAddressOrDevice: Errno { Errno(_ENXIO) }

  /// E2BIG: Arg list too long.
  ///
  /// The number of bytes used for the argument and environment list of the new
  /// process exceeded the limit NCARGS (specified in <sys/param.h>).
  public static var argListTooLong: Errno { Errno(_E2BIG) }

  /// ENOEXEC: Exec format error.
  ///
  /// A request was made to execute a file that, although it has the appropriate
  /// permissions, was not in the for- mat required for an executable file.
  public static var noExec: Errno { Errno(_ENOEXEC) }

  /// EBADF: Bad file descriptor.
  ///
  /// A file descriptor argument was out of range, referred to no open file, or a
  /// read (write) request was made to a file that was only open for writing
  /// (reading).
  public static var badFileDescriptor: Errno { Errno(_EBADF) }

  /// ECHILD: No child processes.
  ///
  /// A wait or waitpid function was executed by a process that had no existing
  /// or unwaited-for child processes.
  public static var noChildProcess: Errno { Errno(_ECHILD) }

  /// EDEADLK: Resource deadlock avoided.
  ///
  /// An attempt was made to lock a sys- tem resource that would have resulted in
  /// a deadlock situation.
  public static var deadlock: Errno { Errno(_EDEADLK) }

  /// ENOMEM: Cannot allocate memory.
  ///
  /// The new process image required more memory than was allowed by the hardware
  /// or by system-imposed mem- ory management constraints.  A lack of swap space
  /// is normally temporary; however, a lack of core is not.  Soft limits may be
  /// increased to their corresponding hard limits.
  public static var noMemory: Errno { Errno(_ENOMEM) }

  /// EACCES: Permission denied.
  ///
  /// An attempt was made to access a file in a way forbidden by its file access
  /// permissions.
  public static var permissionDenied: Errno { Errno(_EACCES) }

  /// EFAULT: Bad address.
  ///
  /// The system detected an invalid address in attempting to use an argument of
  /// a call.
  public static var badAddress: Errno { Errno(_EFAULT) }

  /// ENOTBLK: Not a block device.
  ///
  /// A block device operation was attempted on a non-block device or file.
  public static var notBlockDevice: Errno { Errno(_ENOTBLK) }

  /// EBUSY: Resource busy.
  ///
  /// An attempt to use a system resource which was in use at the time in a
  /// manner which would have conflicted with the request.
  public static var resourceBusy: Errno { Errno(_EBUSY) }

  /// EEXIST: File exists.
  ///
  /// An existing file was mentioned in an inappropri- ate context, for instance,
  /// as the new link name in a link func- tion.
  public static var fileExists: Errno { Errno(_EEXIST) }

  /// EXDEV: Improper link.
  ///
  /// A hard link to a file on another file system was attempted.
  public static var improperLink: Errno { Errno(_EXDEV) }

  /// ENODEV: Operation not supported by device.
  ///
  /// An attempt was made to apply an inappropriate function to a device, for
  /// example, trying to read a write-only device such as a printer.
  public static var operationNotSupportedByDevice: Errno { Errno(_ENODEV) }

  /// ENOTDIR: Not a directory.
  ///
  /// A component of the specified pathname existed, but it was not a directory,
  /// when a directory was expected.
  public static var notDirectory: Errno { Errno(_ENOTDIR) }

  /// EISDIR: Is a directory.
  ///
  /// An attempt was made to open a directory with write mode specified.
  public static var isDirectory: Errno { Errno(_EISDIR) }

  /// EINVAL: Invalid argument.
  ///
  /// Some invalid argument was supplied. (For example, specifying an undefined
  /// signal to a signal or kill func- tion).
  public static var invalidArgument: Errno { Errno(_EINVAL) }

  /// ENFILE: Too many open files in system.
  ///
  /// Maximum number of file descrip- tors allowable on the system has been
  /// reached and a requests for an open cannot be satisfied until at least one
  /// has been closed.
  public static var tooManyOpenFilesInSystem: Errno { Errno(_ENFILE) }

  /// EMFILE: Too many open files.
  ///
  /// <As released, the limit on the number of open files per process is 64.>
  /// Getdtablesize(2) will obtain the current limit.
  public static var tooManyOpenFiles: Errno { Errno(_EMFILE) }

  /// ENOTTY: Inappropriate ioctl for device.
  ///
  /// A control function (see ioctl(2)) was attempted for a file or special
  /// device for which the operation was inappropriate.
  public static var inappropriateIOCTLForDevice: Errno { Errno(_ENOTTY) }

  /// ETXTBSY: Text file busy.
  ///
  /// The new process was a pure procedure (shared text) file which was open for
  /// writing by another process, or while the pure procedure file was being
  /// executed an open call requested write access.
  public static var textFileBusy: Errno { Errno(_ETXTBSY) }

  /// EFBIG: File too large.
  ///
  /// The size of a file exceeded the maximum (about 2.1E9 bytes on some
  /// filesystems including UFS, 1.8E19 bytes on HFS+ and others).
  public static var fileTooLarge: Errno { Errno(_EFBIG) }

  /// ENOSPC: Device out of space.
  ///
  /// A write to an ordinary file, the creation of a directory or symbolic link,
  /// or the creation of a directory entry failed because no more disk blocks
  /// were available on the file system, or the allocation of an inode for a
  /// newly created file failed because no more inodes were available on the file
  /// system.
  public static var noSpace: Errno { Errno(_ENOSPC) }

  /// ESPIPE: Illegal seek.
  ///
  /// An lseek function was issued on a socket, pipe or FIFO.
  public static var illegalSeek: Errno { Errno(_ESPIPE) }

  /// EROFS: Read-only file system.
  ///
  /// An attempt was made to modify a file or directory was made on a file system
  /// that was read-only at the time.
  public static var readOnlyFileSystem: Errno { Errno(_EROFS) }

  /// EMLINK: Too many links.
  ///
  /// Maximum allowable hard links to a single file has been exceeded (limit of
  /// 32767 hard links per file).
  public static var tooManyLinks: Errno { Errno(_EMLINK) }

  /// EPIPE: Broken pipe.
  ///
  /// A write on a pipe, socket or FIFO for which there is no process to read the
  /// data.
  public static var brokenPipe: Errno { Errno(_EPIPE) }

  /// EDOM: Numerical argument out of domain.
  ///
  /// A numerical input argument was outside the defined domain of the
  /// mathematical function.
  public static var outOfDomain: Errno { Errno(_EDOM) }

  /// ERANGE: Numerical result out of range.
  ///
  /// A numerical result of the func- tion was too large to fit in the available
  /// space (perhaps exceeded precision).
  public static var outOfRange: Errno { Errno(_ERANGE) }

  /// EAGAIN: Resource temporarily unavailable.
  ///
  /// This is a temporary condi- tion and later calls to the same routine may
  /// complete normally.
  public static var resourceTemporarilyUnavailable: Errno { Errno(_EAGAIN) }

  /// EINPROGRESS: Operation now in progress.
  ///
  /// An operation that takes a long time to complete (such as a connect(2) or
  /// connectx(2)) was attempted on a non-blocking object (see fcntl(2)).
  public static var nowInProcess: Errno { Errno(_EINPROGRESS) }

  /// EALREADY: Operation already in progress.
  ///
  /// An operation was attempted on a non-blocking object that already had an
  /// operation in progress.
  public static var alreadyInProcess: Errno { Errno(_EALREADY) }

  /// ENOTSOCK: Socket operation on non-socket.
  ///
  /// Self-explanatory.
  public static var notSocket: Errno { Errno(_ENOTSOCK) }

  /// EDESTADDRREQ: Destination address required.
  ///
  /// A required address was omitted from an operation on a socket.
  public static var addressRequired: Errno { Errno(_EDESTADDRREQ) }

  /// EMSGSIZE: Message too long.
  ///
  /// A message sent on a socket was larger than the internal message buffer or
  /// some other network limit.
  public static var messageTooLong: Errno { Errno(_EMSGSIZE) }

  /// EPROTOTYPE: Protocol wrong type for socket.
  ///
  /// A protocol was specified that does not support the semantics of the socket
  /// type requested. For example, you cannot use the ARPA Internet UDP protocol
  /// with type SOCK_STREAM.
  public static var protocolWrongTypeForSocket: Errno { Errno(_EPROTOTYPE) }

  /// ENOPROTOOPT: Protocol not available.
  ///
  /// A bad option or level was speci- fied in a getsockopt(2) or setsockopt(2)
  /// call.
  public static var protocolNotAvailable: Errno { Errno(_ENOPROTOOPT) }

  /// EPROTONOSUPPORT: Protocol not supported.
  ///
  /// The protocol has not been configured into the system or no implementation
  /// for it exists.
  public static var protocolNotSupported: Errno { Errno(_EPROTONOSUPPORT) }

  /// ESOCKTNOSUPPORT: Socket type not supported.
  ///
  /// The support for the socket type has not been configured into the system or
  /// no implementation for it exists.
  public static var socketTypeNotSupported: Errno { Errno(_ESOCKTNOSUPPORT) }

  /// ENOTSUP: Not supported.
  ///
  /// The attempted operation is not supported for the type of object
  /// referenced.
  public static var notSupported: Errno { Errno(_ENOTSUP) }

  /// EPFNOSUPPORT: Protocol family not supported.
  ///
  /// The protocol family has not been configured into the system or no
  /// implementation for it exists.
  public static var protocolFamilyNotSupported: Errno { Errno(_EPFNOSUPPORT) }

  /// EAFNOSUPPORT: Address family not supported by protocol family.
  ///
  /// An address incompatible with the requested protocol was used.  For example,
  /// you shouldn't necessarily expect to be able to use NS addresses with ARPA
  /// Internet protocols.
  public static var addressFamilyNotSupported: Errno { Errno(_EAFNOSUPPORT) }

  /// EADDRINUSE: Address already in use.
  ///
  /// Only one usage of each address is normally permitted.
  public static var addressInUse: Errno { Errno(_EADDRINUSE) }

  /// EADDRNOTAVAIL: Cannot assign requested address.
  ///
  /// Normally results from an attempt to create a socket with an address not on
  /// this machine.
  public static var addressNotAvailable: Errno { Errno(_EADDRNOTAVAIL) }

  /// ENETDOWN: Network is down.
  ///
  /// A socket operation encountered a dead net- work.
  public static var networkDown: Errno { Errno(_ENETDOWN) }

  /// ENETUNREACH: Network is unreachable.
  ///
  /// A socket operation was attempted to an unreachable network.
  public static var networkUnreachable: Errno { Errno(_ENETUNREACH) }

  /// ENETRESET: Network dropped connection on reset.
  ///
  /// The host you were con- nected to crashed and rebooted.
  public static var networkReset: Errno { Errno(_ENETRESET) }

  /// ECONNABORTED: Software caused connection abort.
  ///
  /// A connection abort was caused internal to your host machine.
  public static var connectionAbort: Errno { Errno(_ECONNABORTED) }

  /// ECONNRESET: Connection reset by peer.
  ///
  /// A connection was forcibly closed by a peer.  This normally results from a
  /// loss of the connection on the remote socket due to a timeout or a reboot.
  public static var connectionReset: Errno { Errno(_ECONNRESET) }

  /// ENOBUFS: No buffer space available.
  ///
  /// An operation on a socket or pipe was not performed because the system
  /// lacked sufficient buffer space or because a queue was full.
  public static var noBufferSpace: Errno { Errno(_ENOBUFS) }

  /// EISCONN: Socket is already connected.
  ///
  /// A connect or connectx request was made on an already connected socket; or,
  /// a sendto or sendmsg request on a connected socket specified a destination
  /// when already connected.
  public static var socketIsConnected: Errno { Errno(_EISCONN) }

  /// ENOTCONN: Socket is not connected.
  ///
  /// An request to send or receive data was disallowed because the socket was
  /// not connected and (when sending on a datagram socket) no address was
  /// supplied.
  public static var socketNotConnected: Errno { Errno(_ENOTCONN) }

  /// ESHUTDOWN: Cannot send after socket shutdown.
  ///
  /// A request to send data was disallowed because the socket had already been
  /// shut down with a previous shutdown(2) call.
  public static var socketShutdown: Errno { Errno(_ESHUTDOWN) }

  /// ETIMEDOUT: Operation timed out.
  ///
  /// A connect, connectx or send request failed because the connected party did
  /// not properly respond after a period of time.  (The timeout period is
  /// dependent on the commu- nication protocol.)
  public static var timedOut: Errno { Errno(_ETIMEDOUT) }

  /// ECONNREFUSED: Connection refused.
  ///
  /// No connection could be made because the target machine actively refused it.
  ///  This usually results from trying to connect to a service that is inactive
  /// on the for- eign host.
  public static var connectionRefused: Errno { Errno(_ECONNREFUSED) }

  /// ELOOP: Too many levels of symbolic links.
  ///
  /// A path name lookup involved more than 8 symbolic links.
  public static var tooManySymbolicLinkLevels: Errno { Errno(_ELOOP) }

  /// ENAMETOOLONG: File name too long.
  ///
  /// A component of a path name exceeded 255 (MAXNAMELEN) characters, or an
  /// entire path name exceeded 1023 (MAXPATHLEN-1) characters.
  public static var fileNameTooLong: Errno { Errno(_ENAMETOOLONG) }

  /// EHOSTDOWN: Host is down.
  ///
  /// A socket operation failed because the desti- nation host was down.
  public static var hostIsDown: Errno { Errno(_EHOSTDOWN) }

  /// EHOSTUNREACH: No route to host.
  ///
  /// A socket operation was attempted to an unreachable host.
  public static var noRouteToHost: Errno { Errno(_EHOSTUNREACH) }

  /// ENOTEMPTY: Directory not empty.
  ///
  /// A directory with entries other than `.' and `..' was supplied to a remove
  /// directory or rename call.
  public static var directoyNotEmpty: Errno { Errno(_ENOTEMPTY) }

  /// EPROCLIM: Too many processes.
  ///
  /// public static var tooManyProcesses: Errno { Errno(_EPROCLIM) }

  /// EUSERS: Too many users.
  ///
  /// The quota system ran out of table entries.
  public static var tooManyUsers: Errno { Errno(_EUSERS) }

  /// EDQUOT: Disc quota exceeded.
  ///
  /// A write to an ordinary file, the creation of a directory or symbolic link,
  /// or the creation of a directory entry failed because the user's quota of
  /// disk blocks was exhausted, or the allocation of an inode for a newly
  /// created file failed because the user's quota of inodes was exhausted.
  public static var diskQuotaExceeded: Errno { Errno(_EDQUOT) }

  /// ESTALE: Stale NFS file handle.
  ///
  /// An attempt was made to access an open file (on an NFS filesystem) which is
  /// now unavailable as refer- enced by the file descriptor.  This may indicate
  /// the file was deleted on the NFS server or some other catastrophic event
  /// occurred.
  public static var staleNFSFileHandle: Errno { Errno(_ESTALE) }

  /// EBADRPC: RPC struct is bad.
  ///
  /// Exchange of RPC information was unsuccess- ful.
  public static var rpcUnsuccessful: Errno { Errno(_EBADRPC) }

  /// ERPCMISMATCH: RPC version wrong.
  ///
  /// The version of RPC on the remote peer is not compatible with the local
  /// version.
  public static var rpcVersionMismatch: Errno { Errno(_ERPCMISMATCH) }

  /// EPROGUNAVAIL: RPC prog.
  ///
  /// ot avail.  The requested program is not regis- tered on the remote host.
  public static var rpcProgramUnavailable: Errno { Errno(_EPROGUNAVAIL) }

  /// EPROGMISMATCH: Program version wrong.
  ///
  /// The requested version of the program is not available on the remote host
  /// (RPC).
  public static var rpcProgramVersionMismatch: Errno { Errno(_EPROGMISMATCH) }

  /// EPROCUNAVAIL: Bad procedure for program.
  ///
  /// An RPC call was attempted for a procedure which doesn't exist in the remote
  /// program.
  public static var rpcProcedureUnavailable: Errno { Errno(_EPROCUNAVAIL) }

  /// ENOLCK: No locks available.
  ///
  /// A system-imposed limit on the number of simultaneous file locks was
  /// reached.
  public static var noLocks: Errno { Errno(_ENOLCK) }

  /// ENOSYS: Function not implemented.
  ///
  /// Attempted a system call that is not available on this system.
  public static var noFunction: Errno { Errno(_ENOSYS) }

  /// EFTYPE: Inappropriate file type or format.
  ///
  /// The file was the wrong type for the operation, or a data file had the wrong
  /// format.
  public static var badFileTypeOrFormat: Errno { Errno(_EFTYPE) }

  /// EAUTH: Authentication error.
  ///
  /// Attempted to use an invalid authentica- tion ticket to mount an NFS file
  /// system.
  public static var authenticationError: Errno { Errno(_EAUTH) }

  /// ENEEDAUTH: Need authenticator.
  ///
  /// An authentication ticket must be obtained before the given NFS file system
  /// may be mounted.
  public static var needAuthenticator: Errno { Errno(_ENEEDAUTH) }

  /// EPWROFF: Device power is off.
  ///
  /// The device power is off.
  public static var devicePowerIsOff: Errno { Errno(_EPWROFF) }

  /// EDEVERR: Device error.
  ///
  /// A device error has occurred, e.g. a printer running out of paper.
  public static var deviceError: Errno { Errno(_EDEVERR) }

  /// EOVERFLOW: Value too large to be stored in data type.
  ///
  /// A numerical result of the function was too large to be stored in the caller
  /// provided space.
  public static var overflow: Errno { Errno(_EOVERFLOW) }

  /// EBADEXEC: Bad executable (or shared library).
  ///
  /// The executable or shared library being referenced was malformed.
  public static var badExecutable: Errno { Errno(_EBADEXEC) }

  /// EBADARCH: Bad CPU type in executable.
  ///
  /// The executable in question does not support the current CPU.
  public static var badCPUType: Errno { Errno(_EBADARCH) }

  /// ESHLIBVERS: Shared library version mismatch.
  ///
  /// The version of the shared library on the system does not match the version
  /// which was expected.
  public static var sharedLibraryVersionMismatch: Errno { Errno(_ESHLIBVERS) }

  /// EBADMACHO: Malformed Mach-o file.
  ///
  /// The Mach object file is malformed.
  public static var malformedMachO: Errno { Errno(_EBADMACHO) }

  /// ECANCELED: Operation canceled.
  ///
  /// The scheduled operation was canceled.
  public static var canceled: Errno { Errno(_ECANCELED) }

  /// EIDRM: Identifier removed.
  ///
  /// An IPC identifier was removed while the current process was waiting on it.
  public static var identifierRemoved: Errno { Errno(_EIDRM) }

  /// ENOMSG: No message of desired type.
  ///
  /// An IPC message queue does not con- tain a message of the desired type, or a
  /// message catalog does not contain the requested message.
  public static var noMessage: Errno { Errno(_ENOMSG) }

  /// EILSEQ: Illegal byte sequence.
  ///
  /// While decoding a multibyte character the function came along an invalid or
  /// an incomplete sequence of bytes or the given wide character is invalid.
  public static var illegalByteSequence: Errno { Errno(_EILSEQ) }

  /// ENOATTR: Attribute not found.
  ///
  /// The specified extended attribute does not exist.
  public static var attributeNotFound: Errno { Errno(_ENOATTR) }

  /// EBADMSG: Bad message.
  ///
  /// The message to be received is inapprorpiate for the operation being
  /// attempted.
  public static var badMessage: Errno { Errno(_EBADMSG) }

  /// EMULTIHOP: Reserved.
  ///
  /// This error is reserved for future use.
  public static var multiHop: Errno { Errno(_EMULTIHOP) }

  /// ENODATA: No message available.
  ///
  /// No message was available to be received by the requested operation.
  public static var noData: Errno { Errno(_ENODATA) }

  /// ENOLINK: Reserved.
  ///
  /// This error is reserved for future use.
  public static var noLink: Errno { Errno(_ENOLINK) }

  /// ENOSR: No STREAM resources.
  ///
  /// This error is reserved for future use.
  public static var noStreamResources: Errno { Errno(_ENOSR) }

  /// ENOSTR: Not a STREAM.
  ///
  /// This error is reserved for future use.
  public static var notStream: Errno { Errno(_ENOSTR) }

  /// EPROTO: Protocol error.
  ///
  /// Some protocol error occurred. This error is device-specific, but is
  /// generally not related to a hardware fail- ure.
  public static var protocolError: Errno { Errno(_EPROTO) }

  /// ETIME: STREAM ioctl() timeout.
  ///
  /// This error is reserved for future use.
  public static var timeout: Errno { Errno(_ETIME) }

  /// EOPNOTSUPP: Operation not supported on socket.
  ///
  /// The attempted operation is not supported for the type of socket
  /// referenced; for example, trying to accept a connection on a datagram
  /// socket.
  public static var notSupportedOnSocket: Errno { Errno(_EOPNOTSUPP) }
}

/// errno: Set when a system call detects an error
public var errno: Errno {
  get { Errno(rawValue: _errno) }
  set { _errno = newValue.rawValue }
}
