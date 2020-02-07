// NOTE: Comments and meanings below are for Darwin. Other platforms may have to
// extensively #if/else/endif

/// An error number used by system calls to communicate what kind of error ocurred.
@frozen
public struct Errno: RawRepresentable, Error {
  /// The raw C `int`
  public let rawValue: CInt

  /// Create a strongly typed `Errno` from a raw C `int`
  public init(rawValue: CInt) { self.rawValue = rawValue }

  private init(_ raw: CInt) { self.init(rawValue: raw) }

  /// Error. Not used.
  public static var notUsed: Errno { Errno(_ERRNO_NOT_USED) }

  @available(*, unavailable, renamed: "notUsed")
  public static var ERRNO_NOT_USED: Errno { notUsed }

  /// EPERM: Operation not permitted.
  ///
  /// An attempt was made to perform an oper- ation limited to processes with
  /// appropriate privileges or to the owner of a file or other resources.
  public static var notPermitted: Errno { Errno(_EPERM) }

  @available(*, unavailable, renamed: "notPermitted")
  public static var EPERM: Errno { notPermitted }

  /// ENOENT: No such file or directory.
  ///
  /// A component of a specified pathname did not exist, or the pathname was an
  /// empty string.
  public static var noSuchFileOrDirectory: Errno { Errno(_ENOENT) }

  @available(*, unavailable, renamed: "noSuchFileOrDirectory")
  public static var ENOENT: Errno { noSuchFileOrDirectory }

  /// ESRCH: No such process.
  ///
  /// No process could be found corresponding to that specified by the given
  /// process ID.
  public static var noSuchProcess: Errno { Errno(_ESRCH) }

  @available(*, unavailable, renamed: "noSuchProcess")
  public static var ESRCH: Errno { noSuchProcess }

  /// EINTR: Interrupted function call.
  ///
  /// An asynchronous signal (such as SIGINT or SIGQUIT) was caught by the
  /// process during the execution of an interruptible function. If the signal
  /// handler performs a normal return, the interrupted function call will seem
  /// to have returned the error condition.
  public static var interrupted: Errno { Errno(_EINTR) }

  @available(*, unavailable, renamed: "interrupted")
  public static var EINTR: Errno { interrupted }

  /// EIO: Input/output error.
  ///
  /// Some physical input or output error occurred. This error will not be
  /// reported until a subsequent operation on the same file descriptor and may
  /// be lost (over written) by any subsequent errors.
  public static var ioError: Errno { Errno(_EIO) }

  @available(*, unavailable, renamed: "ioError")
  public static var EIO: Errno { ioError }

  /// ENXIO: No such device or address.
  ///
  /// Input or output on a special file referred to a device that did not exist,
  /// or made a request beyond the limits of the device.  This error may also
  /// occur when, for example, a tape drive is not online or no disk pack is
  /// loaded on a drive.
  public static var noSuchAddressOrDevice: Errno { Errno(_ENXIO) }

  @available(*, unavailable, renamed: "noSuchAddressOrDevice")
  public static var ENXIO: Errno { noSuchAddressOrDevice }

  /// E2BIG: Arg list too long.
  ///
  /// The number of bytes used for the argument and environment list of the new
  /// process exceeded the limit NCARGS (specified in <sys/param.h>).
  public static var argListTooLong: Errno { Errno(_E2BIG) }

  @available(*, unavailable, renamed: "argListTooLong")
  public static var E2BIG: Errno { argListTooLong }

  /// ENOEXEC: Exec format error.
  ///
  /// A request was made to execute a file that, although it has the appropriate
  /// permissions, was not in the for- mat required for an executable file.
  public static var noExec: Errno { Errno(_ENOEXEC) }

  @available(*, unavailable, renamed: "noExec")
  public static var ENOEXEC: Errno { noExec }

  /// EBADF: Bad file descriptor.
  ///
  /// A file descriptor argument was out of range, referred to no open file, or a
  /// read (write) request was made to a file that was only open for writing
  /// (reading).
  public static var badFileDescriptor: Errno { Errno(_EBADF) }

  @available(*, unavailable, renamed: "badFileDescriptor")
  public static var EBADF: Errno { badFileDescriptor }

  /// ECHILD: No child processes.
  ///
  /// A wait or waitpid function was executed by a process that had no existing
  /// or unwaited-for child processes.
  public static var noChildProcess: Errno { Errno(_ECHILD) }

  @available(*, unavailable, renamed: "noChildProcess")
  public static var ECHILD: Errno { noChildProcess }

  /// EDEADLK: Resource deadlock avoided.
  ///
  /// An attempt was made to lock a sys- tem resource that would have resulted in
  /// a deadlock situation.
  public static var deadlock: Errno { Errno(_EDEADLK) }

  @available(*, unavailable, renamed: "deadlock")
  public static var EDEADLK: Errno { deadlock }

  /// ENOMEM: Cannot allocate memory.
  ///
  /// The new process image required more memory than was allowed by the hardware
  /// or by system-imposed mem- ory management constraints.  A lack of swap space
  /// is normally temporary; however, a lack of core is not.  Soft limits may be
  /// increased to their corresponding hard limits.
  public static var noMemory: Errno { Errno(_ENOMEM) }

  @available(*, unavailable, renamed: "noMemory")
  public static var ENOMEM: Errno { noMemory }

  /// EACCES: Permission denied.
  ///
  /// An attempt was made to access a file in a way forbidden by its file access
  /// permissions.
  public static var permissionDenied: Errno { Errno(_EACCES) }

  @available(*, unavailable, renamed: "permissionDenied")
  public static var EACCES: Errno { permissionDenied }

  /// EFAULT: Bad address.
  ///
  /// The system detected an invalid address in attempting to use an argument of
  /// a call.
  public static var badAddress: Errno { Errno(_EFAULT) }

  @available(*, unavailable, renamed: "badAddress")
  public static var EFAULT: Errno { badAddress }

  /// ENOTBLK: Not a block device.
  ///
  /// A block device operation was attempted on a non-block device or file.
  public static var notBlockDevice: Errno { Errno(_ENOTBLK) }

  @available(*, unavailable, renamed: "notBlockDevice")
  public static var ENOTBLK: Errno { notBlockDevice }

  /// EBUSY: Resource busy.
  ///
  /// An attempt to use a system resource which was in use at the time in a
  /// manner which would have conflicted with the request.
  public static var resourceBusy: Errno { Errno(_EBUSY) }

  @available(*, unavailable, renamed: "resourceBusy")
  public static var EBUSY: Errno { resourceBusy }

  /// EEXIST: File exists.
  ///
  /// An existing file was mentioned in an inappropri- ate context, for instance,
  /// as the new link name in a link func- tion.
  public static var fileExists: Errno { Errno(_EEXIST) }

  @available(*, unavailable, renamed: "fileExists")
  public static var EEXIST: Errno { fileExists }

  /// EXDEV: Improper link.
  ///
  /// A hard link to a file on another file system was attempted.
  public static var improperLink: Errno { Errno(_EXDEV) }

  @available(*, unavailable, renamed: "improperLink")
  public static var EXDEV: Errno { improperLink }

  /// ENODEV: Operation not supported by device.
  ///
  /// An attempt was made to apply an inappropriate function to a device, for
  /// example, trying to read a write-only device such as a printer.
  public static var operationNotSupportedByDevice: Errno { Errno(_ENODEV) }

  @available(*, unavailable, renamed: "operationNotSupportedByDevice")
  public static var ENODEV: Errno { operationNotSupportedByDevice }

  /// ENOTDIR: Not a directory.
  ///
  /// A component of the specified pathname existed, but it was not a directory,
  /// when a directory was expected.
  public static var notDirectory: Errno { Errno(_ENOTDIR) }

  @available(*, unavailable, renamed: "notDirectory")
  public static var ENOTDIR: Errno { notDirectory }

  /// EISDIR: Is a directory.
  ///
  /// An attempt was made to open a directory with write mode specified.
  public static var isDirectory: Errno { Errno(_EISDIR) }

  @available(*, unavailable, renamed: "isDirectory")
  public static var EISDIR: Errno { isDirectory }

  /// EINVAL: Invalid argument.
  ///
  /// Some invalid argument was supplied. (For example, specifying an undefined
  /// signal to a signal or kill func- tion).
  public static var invalidArgument: Errno { Errno(_EINVAL) }

  @available(*, unavailable, renamed: "invalidArgument")
  public static var EINVAL: Errno { invalidArgument }

  /// ENFILE: Too many open files in system.
  ///
  /// Maximum number of file descriptors allowable on the system has been
  /// reached and a requests for an open cannot be satisfied until at least one
  /// has been closed.
  public static var tooManyOpenFilesInSystem: Errno { Errno(_ENFILE) }

  @available(*, unavailable, renamed: "tooManyOpenFilesInSystem")
  public static var ENFILE: Errno { tooManyOpenFilesInSystem }

  /// EMFILE: Too many open files.
  ///
  /// `getdtablesize` will obtain the current limit.
  public static var tooManyOpenFiles: Errno { Errno(_EMFILE) }

  @available(*, unavailable, renamed: "tooManyOpenFiles")
  public static var EMFILE: Errno { tooManyOpenFiles }

  /// ENOTTY: Inappropriate ioctl for device.
  ///
  /// A control function (see ioctl(2)) was attempted for a file or special
  /// device for which the operation was inappropriate.
  public static var inappropriateIOCTLForDevice: Errno { Errno(_ENOTTY) }

  @available(*, unavailable, renamed: "inappropriateIOCTLForDevice")
  public static var ENOTTY: Errno { inappropriateIOCTLForDevice }

  /// ETXTBSY: Text file busy.
  ///
  /// The new process was a pure procedure (shared text) file which was open for
  /// writing by another process, or while the pure procedure file was being
  /// executed an open call requested write access.
  public static var textFileBusy: Errno { Errno(_ETXTBSY) }

  @available(*, unavailable, renamed: "textFileBusy")
  public static var ETXTBSY: Errno { textFileBusy }

  /// EFBIG: File too large.
  ///
  /// The size of a file exceeded the maximum (about 2.1E9 bytes on some
  /// filesystems including UFS, 1.8E19 bytes on HFS+ and others).
  public static var fileTooLarge: Errno { Errno(_EFBIG) }

  @available(*, unavailable, renamed: "fileTooLarge")
  public static var EFBIG: Errno { fileTooLarge }

  /// ENOSPC: Device out of space.
  ///
  /// A write to an ordinary file, the creation of a directory or symbolic link,
  /// or the creation of a directory entry failed because no more disk blocks
  /// were available on the file system, or the allocation of an inode for a
  /// newly created file failed because no more inodes were available on the file
  /// system.
  public static var noSpace: Errno { Errno(_ENOSPC) }

  @available(*, unavailable, renamed: "noSpace")
  public static var ENOSPC: Errno { noSpace }

  /// ESPIPE: Illegal seek.
  ///
  /// An lseek function was issued on a socket, pipe or FIFO.
  public static var illegalSeek: Errno { Errno(_ESPIPE) }

  @available(*, unavailable, renamed: "illegalSeek")
  public static var ESPIPE: Errno { illegalSeek }

  /// EROFS: Read-only file system.
  ///
  /// An attempt was made to modify a file or directory was made on a file system
  /// that was read-only at the time.
  public static var readOnlyFileSystem: Errno { Errno(_EROFS) }

  @available(*, unavailable, renamed: "readOnlyFileSystem")
  public static var EROFS: Errno { readOnlyFileSystem }

  /// EMLINK: Too many links.
  ///
  /// Maximum allowable hard links to a single file has been exceeded (limit of
  /// 32767 hard links per file).
  public static var tooManyLinks: Errno { Errno(_EMLINK) }

  @available(*, unavailable, renamed: "tooManyLinks")
  public static var EMLINK: Errno { tooManyLinks }

  /// EPIPE: Broken pipe.
  ///
  /// A write on a pipe, socket or FIFO for which there is no process to read the
  /// data.
  public static var brokenPipe: Errno { Errno(_EPIPE) }

  @available(*, unavailable, renamed: "brokenPipe")
  public static var EPIPE: Errno { brokenPipe }

  /// EDOM: Numerical argument out of domain.
  ///
  /// A numerical input argument was outside the defined domain of the
  /// mathematical function.
  public static var outOfDomain: Errno { Errno(_EDOM) }

  @available(*, unavailable, renamed: "outOfDomain")
  public static var EDOM: Errno { outOfDomain }

  /// ERANGE: Numerical result out of range.
  ///
  /// A numerical result of the func- tion was too large to fit in the available
  /// space (perhaps exceeded precision).
  public static var outOfRange: Errno { Errno(_ERANGE) }

  @available(*, unavailable, renamed: "outOfRange")
  public static var ERANGE: Errno { outOfRange }

  /// EAGAIN: Resource temporarily unavailable.
  ///
  /// This is a temporary condi- tion and later calls to the same routine may
  /// complete normally.
  public static var resourceTemporarilyUnavailable: Errno { Errno(_EAGAIN) }

  @available(*, unavailable, renamed: "resourceTemporarilyUnavailable")
  public static var EAGAIN: Errno { resourceTemporarilyUnavailable }

  /// EINPROGRESS: Operation now in progress.
  ///
  /// An operation that takes a long time to complete (such as a connect(2) or
  /// connectx(2)) was attempted on a non-blocking object (see fcntl(2)).
  public static var nowInProcess: Errno { Errno(_EINPROGRESS) }

  @available(*, unavailable, renamed: "nowInProcess")
  public static var EINPROGRESS: Errno { nowInProcess }

  /// EALREADY: Operation already in progress.
  ///
  /// An operation was attempted on a non-blocking object that already had an
  /// operation in progress.
  public static var alreadyInProcess: Errno { Errno(_EALREADY) }

  @available(*, unavailable, renamed: "alreadyInProcess")
  public static var EALREADY: Errno { alreadyInProcess }

  /// ENOTSOCK: Socket operation on non-socket.
  ///
  /// Self-explanatory.
  public static var notSocket: Errno { Errno(_ENOTSOCK) }

  @available(*, unavailable, renamed: "notSocket")
  public static var ENOTSOCK: Errno { notSocket }

  /// EDESTADDRREQ: Destination address required.
  ///
  /// A required address was omitted from an operation on a socket.
  public static var addressRequired: Errno { Errno(_EDESTADDRREQ) }

  @available(*, unavailable, renamed: "addressRequired")
  public static var EDESTADDRREQ: Errno { addressRequired }

  /// EMSGSIZE: Message too long.
  ///
  /// A message sent on a socket was larger than the internal message buffer or
  /// some other network limit.
  public static var messageTooLong: Errno { Errno(_EMSGSIZE) }

  @available(*, unavailable, renamed: "messageTooLong")
  public static var EMSGSIZE: Errno { messageTooLong }

  /// EPROTOTYPE: Protocol wrong type for socket.
  ///
  /// A protocol was specified that does not support the semantics of the socket
  /// type requested. For example, you cannot use the ARPA Internet UDP protocol
  /// with type SOCK_STREAM.
  public static var protocolWrongTypeForSocket: Errno { Errno(_EPROTOTYPE) }

  @available(*, unavailable, renamed: "protocolWrongTypeForSocket")
  public static var EPROTOTYPE: Errno { protocolWrongTypeForSocket }

  /// ENOPROTOOPT: Protocol not available.
  ///
  /// A bad option or level was speci- fied in a getsockopt(2) or setsockopt(2)
  /// call.
  public static var protocolNotAvailable: Errno { Errno(_ENOPROTOOPT) }

  @available(*, unavailable, renamed: "protocolNotAvailable")
  public static var ENOPROTOOPT: Errno { protocolNotAvailable }

  /// EPROTONOSUPPORT: Protocol not supported.
  ///
  /// The protocol has not been configured into the system or no implementation
  /// for it exists.
  public static var protocolNotSupported: Errno { Errno(_EPROTONOSUPPORT) }

  @available(*, unavailable, renamed: "protocolNotSupported")
  public static var EPROTONOSUPPORT: Errno { protocolNotSupported }

  /// ESOCKTNOSUPPORT: Socket type not supported.
  ///
  /// The support for the socket type has not been configured into the system or
  /// no implementation for it exists.
  public static var socketTypeNotSupported: Errno { Errno(_ESOCKTNOSUPPORT) }

  @available(*, unavailable, renamed: "socketTypeNotSupported")
  public static var ESOCKTNOSUPPORT: Errno { socketTypeNotSupported }

  /// ENOTSUP: Not supported.
  ///
  /// The attempted operation is not supported for the type of object
  /// referenced.
  public static var notSupported: Errno { Errno(_ENOTSUP) }

  @available(*, unavailable, renamed: "notSupported")
  public static var ENOTSUP: Errno { notSupported }

  /// EPFNOSUPPORT: Protocol family not supported.
  ///
  /// The protocol family has not been configured into the system or no
  /// implementation for it exists.
  public static var protocolFamilyNotSupported: Errno { Errno(_EPFNOSUPPORT) }

  @available(*, unavailable, renamed: "protocolFamilyNotSupported")
  public static var EPFNOSUPPORT: Errno { protocolFamilyNotSupported }

  /// EAFNOSUPPORT: Address family not supported by protocol family.
  ///
  /// An address incompatible with the requested protocol was used.  For example,
  /// you shouldn't necessarily expect to be able to use NS addresses with ARPA
  /// Internet protocols.
  public static var addressFamilyNotSupported: Errno { Errno(_EAFNOSUPPORT) }

  @available(*, unavailable, renamed: "addressFamilyNotSupported")
  public static var EAFNOSUPPORT: Errno { addressFamilyNotSupported }

  /// EADDRINUSE: Address already in use.
  ///
  /// Only one usage of each address is normally permitted.
  public static var addressInUse: Errno { Errno(_EADDRINUSE) }

  @available(*, unavailable, renamed: "addressInUse")
  public static var EADDRINUSE: Errno { addressInUse }

  /// EADDRNOTAVAIL: Cannot assign requested address.
  ///
  /// Normally results from an attempt to create a socket with an address not on
  /// this machine.
  public static var addressNotAvailable: Errno { Errno(_EADDRNOTAVAIL) }

  @available(*, unavailable, renamed: "addressNotAvailable")
  public static var EADDRNOTAVAIL: Errno { addressNotAvailable }

  /// ENETDOWN: Network is down.
  ///
  /// A socket operation encountered a dead net- work.
  public static var networkDown: Errno { Errno(_ENETDOWN) }

  @available(*, unavailable, renamed: "networkDown")
  public static var ENETDOWN: Errno { networkDown }

  /// ENETUNREACH: Network is unreachable.
  ///
  /// A socket operation was attempted to an unreachable network.
  public static var networkUnreachable: Errno { Errno(_ENETUNREACH) }

  @available(*, unavailable, renamed: "networkUnreachable")
  public static var ENETUNREACH: Errno { networkUnreachable }

  /// ENETRESET: Network dropped connection on reset.
  ///
  /// The host you were con- nected to crashed and rebooted.
  public static var networkReset: Errno { Errno(_ENETRESET) }

  @available(*, unavailable, renamed: "networkReset")
  public static var ENETRESET: Errno { networkReset }

  /// ECONNABORTED: Software caused connection abort.
  ///
  /// A connection abort was caused internal to your host machine.
  public static var connectionAbort: Errno { Errno(_ECONNABORTED) }

  @available(*, unavailable, renamed: "connectionAbort")
  public static var ECONNABORTED: Errno { connectionAbort }

  /// ECONNRESET: Connection reset by peer.
  ///
  /// A connection was forcibly closed by a peer.  This normally results from a
  /// loss of the connection on the remote socket due to a timeout or a reboot.
  public static var connectionReset: Errno { Errno(_ECONNRESET) }

  @available(*, unavailable, renamed: "connectionReset")
  public static var ECONNRESET: Errno { connectionReset }

  /// ENOBUFS: No buffer space available.
  ///
  /// An operation on a socket or pipe was not performed because the system
  /// lacked sufficient buffer space or because a queue was full.
  public static var noBufferSpace: Errno { Errno(_ENOBUFS) }

  @available(*, unavailable, renamed: "noBufferSpace")
  public static var ENOBUFS: Errno { noBufferSpace }

  /// EISCONN: Socket is already connected.
  ///
  /// A connect or connectx request was made on an already connected socket; or,
  /// a sendto or sendmsg request on a connected socket specified a destination
  /// when already connected.
  public static var socketIsConnected: Errno { Errno(_EISCONN) }

  @available(*, unavailable, renamed: "socketIsConnected")
  public static var EISCONN: Errno { socketIsConnected }

  /// ENOTCONN: Socket is not connected.
  ///
  /// An request to send or receive data was disallowed because the socket was
  /// not connected and (when sending on a datagram socket) no address was
  /// supplied.
  public static var socketNotConnected: Errno { Errno(_ENOTCONN) }

  @available(*, unavailable, renamed: "socketNotConnected")
  public static var ENOTCONN: Errno { socketNotConnected }

  /// ESHUTDOWN: Cannot send after socket shutdown.
  ///
  /// A request to send data was disallowed because the socket had already been
  /// shut down with a previous shutdown(2) call.
  public static var socketShutdown: Errno { Errno(_ESHUTDOWN) }

  @available(*, unavailable, renamed: "socketShutdown")
  public static var ESHUTDOWN: Errno { socketShutdown }

  /// ETIMEDOUT: Operation timed out.
  ///
  /// A connect, connectx or send request failed because the connected party did
  /// not properly respond after a period of time.  (The timeout period is
  /// dependent on the commu- nication protocol.)
  public static var timedOut: Errno { Errno(_ETIMEDOUT) }

  @available(*, unavailable, renamed: "timedOut")
  public static var ETIMEDOUT: Errno { timedOut }

  /// ECONNREFUSED: Connection refused.
  ///
  /// No connection could be made because the target machine actively refused it.
  ///  This usually results from trying to connect to a service that is inactive
  /// on the for- eign host.
  public static var connectionRefused: Errno { Errno(_ECONNREFUSED) }

  @available(*, unavailable, renamed: "connectionRefused")
  public static var ECONNREFUSED: Errno { connectionRefused }

  /// ELOOP: Too many levels of symbolic links.
  ///
  /// A path name lookup involved more than 8 symbolic links.
  public static var tooManySymbolicLinkLevels: Errno { Errno(_ELOOP) }

  @available(*, unavailable, renamed: "tooManySymbolicLinkLevels")
  public static var ELOOP: Errno { tooManySymbolicLinkLevels }

  /// ENAMETOOLONG: File name too long.
  ///
  /// A component of a path name exceeded 255 (MAXNAMELEN) characters, or an
  /// entire path name exceeded 1023 (MAXPATHLEN-1) characters.
  public static var fileNameTooLong: Errno { Errno(_ENAMETOOLONG) }

  @available(*, unavailable, renamed: "fileNameTooLong")
  public static var ENAMETOOLONG: Errno { fileNameTooLong }

  /// EHOSTDOWN: Host is down.
  ///
  /// A socket operation failed because the desti- nation host was down.
  public static var hostIsDown: Errno { Errno(_EHOSTDOWN) }

  @available(*, unavailable, renamed: "hostIsDown")
  public static var EHOSTDOWN: Errno { hostIsDown }

  /// EHOSTUNREACH: No route to host.
  ///
  /// A socket operation was attempted to an unreachable host.
  public static var noRouteToHost: Errno { Errno(_EHOSTUNREACH) }

  @available(*, unavailable, renamed: "noRouteToHost")
  public static var EHOSTUNREACH: Errno { noRouteToHost }

  /// ENOTEMPTY: Directory not empty.
  ///
  /// A directory with entries other than `.' and `..' was supplied to a remove
  /// directory or rename call.
  public static var directoyNotEmpty: Errno { Errno(_ENOTEMPTY) }

  @available(*, unavailable, renamed: "directoyNotEmpty")
  public static var ENOTEMPTY: Errno { directoyNotEmpty }

  /// EPROCLIM: Too many processes.
  ///
  /// public static var tooManyProcesses: Errno { Errno(_EPROCLIM) }

  /// EUSERS: Too many users.
  ///
  /// The quota system ran out of table entries.
  public static var tooManyUsers: Errno { Errno(_EUSERS) }

  @available(*, unavailable, renamed: "tooManyUsers")
  public static var EUSERS: Errno { tooManyUsers }

  /// EDQUOT: Disc quota exceeded.
  ///
  /// A write to an ordinary file, the creation of a directory or symbolic link,
  /// or the creation of a directory entry failed because the user's quota of
  /// disk blocks was exhausted, or the allocation of an inode for a newly
  /// created file failed because the user's quota of inodes was exhausted.
  public static var diskQuotaExceeded: Errno { Errno(_EDQUOT) }

  @available(*, unavailable, renamed: "diskQuotaExceeded")
  public static var EDQUOT: Errno { diskQuotaExceeded }

  /// ESTALE: Stale NFS file handle.
  ///
  /// An attempt was made to access an open file (on an NFS filesystem) which is
  /// now unavailable as refer- enced by the file descriptor.  This may indicate
  /// the file was deleted on the NFS server or some other catastrophic event
  /// occurred.
  public static var staleNFSFileHandle: Errno { Errno(_ESTALE) }

  @available(*, unavailable, renamed: "staleNFSFileHandle")
  public static var ESTALE: Errno { staleNFSFileHandle }

  /// EBADRPC: RPC struct is bad.
  ///
  /// Exchange of RPC information was unsuccess- ful.
  public static var rpcUnsuccessful: Errno { Errno(_EBADRPC) }

  @available(*, unavailable, renamed: "rpcUnsuccessful")
  public static var EBADRPC: Errno { rpcUnsuccessful }

  /// ERPCMISMATCH: RPC version wrong.
  ///
  /// The version of RPC on the remote peer is not compatible with the local
  /// version.
  public static var rpcVersionMismatch: Errno { Errno(_ERPCMISMATCH) }

  @available(*, unavailable, renamed: "rpcVersionMismatch")
  public static var ERPCMISMATCH: Errno { rpcVersionMismatch }

  /// EPROGUNAVAIL: RPC prog.
  ///
  /// ot avail.  The requested program is not regis- tered on the remote host.
  public static var rpcProgramUnavailable: Errno { Errno(_EPROGUNAVAIL) }

  @available(*, unavailable, renamed: "rpcProgramUnavailable")
  public static var EPROGUNAVAIL: Errno { rpcProgramUnavailable }

  /// EPROGMISMATCH: Program version wrong.
  ///
  /// The requested version of the program is not available on the remote host
  /// (RPC).
  public static var rpcProgramVersionMismatch: Errno { Errno(_EPROGMISMATCH) }

  @available(*, unavailable, renamed: "rpcProgramVersionMismatch")
  public static var EPROGMISMATCH: Errno { rpcProgramVersionMismatch }

  /// EPROCUNAVAIL: Bad procedure for program.
  ///
  /// An RPC call was attempted for a procedure which doesn't exist in the remote
  /// program.
  public static var rpcProcedureUnavailable: Errno { Errno(_EPROCUNAVAIL) }

  @available(*, unavailable, renamed: "rpcProcedureUnavailable")
  public static var EPROCUNAVAIL: Errno { rpcProcedureUnavailable }

  /// ENOLCK: No locks available.
  ///
  /// A system-imposed limit on the number of simultaneous file locks was
  /// reached.
  public static var noLocks: Errno { Errno(_ENOLCK) }

  @available(*, unavailable, renamed: "noLocks")
  public static var ENOLCK: Errno { noLocks }

  /// ENOSYS: Function not implemented.
  ///
  /// Attempted a system call that is not available on this system.
  public static var noFunction: Errno { Errno(_ENOSYS) }

  @available(*, unavailable, renamed: "noFunction")
  public static var ENOSYS: Errno { noFunction }

  /// EFTYPE: Inappropriate file type or format.
  ///
  /// The file was the wrong type for the operation, or a data file had the wrong
  /// format.
  public static var badFileTypeOrFormat: Errno { Errno(_EFTYPE) }

  @available(*, unavailable, renamed: "badFileTypeOrFormat")
  public static var EFTYPE: Errno { badFileTypeOrFormat }

  /// EAUTH: Authentication error.
  ///
  /// Attempted to use an invalid authentica- tion ticket to mount an NFS file
  /// system.
  public static var authenticationError: Errno { Errno(_EAUTH) }

  @available(*, unavailable, renamed: "authenticationError")
  public static var EAUTH: Errno { authenticationError }

  /// ENEEDAUTH: Need authenticator.
  ///
  /// An authentication ticket must be obtained before the given NFS file system
  /// may be mounted.
  public static var needAuthenticator: Errno { Errno(_ENEEDAUTH) }

  @available(*, unavailable, renamed: "needAuthenticator")
  public static var ENEEDAUTH: Errno { needAuthenticator }

  /// EPWROFF: Device power is off.
  ///
  /// The device power is off.
  public static var devicePowerIsOff: Errno { Errno(_EPWROFF) }

  @available(*, unavailable, renamed: "devicePowerIsOff")
  public static var EPWROFF: Errno { devicePowerIsOff }

  /// EDEVERR: Device error.
  ///
  /// A device error has occurred, e.g. a printer running out of paper.
  public static var deviceError: Errno { Errno(_EDEVERR) }

  @available(*, unavailable, renamed: "deviceError")
  public static var EDEVERR: Errno { deviceError }

  /// EOVERFLOW: Value too large to be stored in data type.
  ///
  /// A numerical result of the function was too large to be stored in the caller
  /// provided space.
  public static var overflow: Errno { Errno(_EOVERFLOW) }

  @available(*, unavailable, renamed: "overflow")
  public static var EOVERFLOW: Errno { overflow }

  /// EBADEXEC: Bad executable (or shared library).
  ///
  /// The executable or shared library being referenced was malformed.
  public static var badExecutable: Errno { Errno(_EBADEXEC) }

  @available(*, unavailable, renamed: "badExecutable")
  public static var EBADEXEC: Errno { badExecutable }

  /// EBADARCH: Bad CPU type in executable.
  ///
  /// The executable in question does not support the current CPU.
  public static var badCPUType: Errno { Errno(_EBADARCH) }

  @available(*, unavailable, renamed: "badCPUType")
  public static var EBADARCH: Errno { badCPUType }

  /// ESHLIBVERS: Shared library version mismatch.
  ///
  /// The version of the shared library on the system does not match the version
  /// which was expected.
  public static var sharedLibraryVersionMismatch: Errno { Errno(_ESHLIBVERS) }

  @available(*, unavailable, renamed: "sharedLibraryVersionMismatch")
  public static var ESHLIBVERS: Errno { sharedLibraryVersionMismatch }

  /// EBADMACHO: Malformed Mach-o file.
  ///
  /// The Mach object file is malformed.
  public static var malformedMachO: Errno { Errno(_EBADMACHO) }

  @available(*, unavailable, renamed: "malformedMachO")
  public static var EBADMACHO: Errno { malformedMachO }

  /// ECANCELED: Operation canceled.
  ///
  /// The scheduled operation was canceled.
  public static var canceled: Errno { Errno(_ECANCELED) }

  @available(*, unavailable, renamed: "canceled")
  public static var ECANCELED: Errno { canceled }

  /// EIDRM: Identifier removed.
  ///
  /// An IPC identifier was removed while the current process was waiting on it.
  public static var identifierRemoved: Errno { Errno(_EIDRM) }

  @available(*, unavailable, renamed: "identifierRemoved")
  public static var EIDRM: Errno { identifierRemoved }

  /// ENOMSG: No message of desired type.
  ///
  /// An IPC message queue does not con- tain a message of the desired type, or a
  /// message catalog does not contain the requested message.
  public static var noMessage: Errno { Errno(_ENOMSG) }

  @available(*, unavailable, renamed: "noMessage")
  public static var ENOMSG: Errno { noMessage }

  /// EILSEQ: Illegal byte sequence.
  ///
  /// While decoding a multibyte character the function came along an invalid or
  /// an incomplete sequence of bytes or the given wide character is invalid.
  public static var illegalByteSequence: Errno { Errno(_EILSEQ) }

  @available(*, unavailable, renamed: "illegalByteSequence")
  public static var EILSEQ: Errno { illegalByteSequence }

  /// ENOATTR: Attribute not found.
  ///
  /// The specified extended attribute does not exist.
  public static var attributeNotFound: Errno { Errno(_ENOATTR) }

  @available(*, unavailable, renamed: "attributeNotFound")
  public static var ENOATTR: Errno { attributeNotFound }

  /// EBADMSG: Bad message.
  ///
  /// The message to be received is inapprorpiate for the operation being
  /// attempted.
  public static var badMessage: Errno { Errno(_EBADMSG) }

  @available(*, unavailable, renamed: "badMessage")
  public static var EBADMSG: Errno { badMessage }

  /// EMULTIHOP: Reserved.
  ///
  /// This error is reserved for future use.
  public static var multiHop: Errno { Errno(_EMULTIHOP) }

  @available(*, unavailable, renamed: "multiHop")
  public static var EMULTIHOP: Errno { multiHop }

  /// ENODATA: No message available.
  ///
  /// No message was available to be received by the requested operation.
  public static var noData: Errno { Errno(_ENODATA) }

  @available(*, unavailable, renamed: "noData")
  public static var ENODATA: Errno { noData }

  /// ENOLINK: Reserved.
  ///
  /// This error is reserved for future use.
  public static var noLink: Errno { Errno(_ENOLINK) }

  @available(*, unavailable, renamed: "noLink")
  public static var ENOLINK: Errno { noLink }

  /// ENOSR: No STREAM resources.
  ///
  /// This error is reserved for future use.
  public static var noStreamResources: Errno { Errno(_ENOSR) }

  @available(*, unavailable, renamed: "noStreamResources")
  public static var ENOSR: Errno { noStreamResources }

  /// ENOSTR: Not a STREAM.
  ///
  /// This error is reserved for future use.
  public static var notStream: Errno { Errno(_ENOSTR) }

  @available(*, unavailable, renamed: "notStream")
  public static var ENOSTR: Errno { notStream }

  /// EPROTO: Protocol error.
  ///
  /// Some protocol error occurred. This error is device-specific, but is
  /// generally not related to a hardware fail- ure.
  public static var protocolError: Errno { Errno(_EPROTO) }

  @available(*, unavailable, renamed: "protocolError")
  public static var EPROTO: Errno { protocolError }

  /// ETIME: STREAM ioctl() timeout.
  ///
  /// This error is reserved for future use.
  public static var timeout: Errno { Errno(_ETIME) }

  @available(*, unavailable, renamed: "timeout")
  public static var ETIME: Errno { timeout }

  /// EOPNOTSUPP: Operation not supported on socket.
  ///
  /// The attempted operation is not supported for the type of socket
  /// referenced; for example, trying to accept a connection on a datagram
  /// socket.
  public static var notSupportedOnSocket: Errno { Errno(_EOPNOTSUPP) }

  @available(*, unavailable, renamed: "notSupportedOnSocket")
  public static var EOPNOTSUPP: Errno { notSupportedOnSocket }
}

extension Errno {
  /// errno: The current error value, set by system calls on error.
  public static var current: Errno {
    get { Errno(rawValue: _errno) }
    set { _errno = newValue.rawValue }
  }
}

