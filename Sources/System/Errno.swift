public enum Errno: CInt, Error {
  // 0 Error 0.  Not used.
  case notUsed = 0

  // 1 EPERM Operation not permitted.  An attempt was made to perform an oper-
  //      ation limited to processes with appropriate privileges or to the
  //      owner of a file or other resources.
  case notPermitted = 1

  // 2 ENOENT No such file or directory.  A component of a specified pathname
  //      did not exist, or the pathname was an empty string.
  case noSuchFileOrDirectory = 2

  // 3 ESRCH No such process.  No process could be found corresponding to that
  //      specified by the given process ID.
  case noSuchProcess = 3

  // 4 EINTR Interrupted function call.  An asynchronous signal (such as
  //      SIGINT or SIGQUIT) was caught by the process during the execution
  //      of an interruptible function. If the signal handler performs a
  //      normal return, the interrupted function call will seem to have
  //      returned the error condition.
  case interrupted = 4

  // 5 EIO Input/output error.  Some physical input or output error occurred.
  //      This error will not be reported until a subsequent operation on
  //      the same file descriptor and may be lost (over written) by any
  //      subsequent errors.
  case ioError = 5

  // 6 ENXIO No such device or address.  Input or output on a special file
  //      referred to a device that did not exist, or made a request beyond
  //      the limits of the device.  This error may also occur when, for
  //      example, a tape drive is not online or no disk pack is loaded on
  //      a drive.
  case noSuchAddressOrDevice = 6

  // 7 E2BIG Arg list too long.  The number of bytes used for the argument and
  //      environment list of the new process exceeded the limit NCARGS
  //      (specified in <sys/param.h>).
  case argListTooLong = 7

  // 8 ENOEXEC Exec format error.  A request was made to execute a file that,
  //      although it has the appropriate permissions, was not in the for-
  //      mat required for an executable file.
  case noExec = 8

  // 9 EBADF Bad file descriptor.  A file descriptor argument was out of
  //      range, referred to no open file, or a read (write) request was
  //      made to a file that was only open for writing (reading).
  case badFileDescriptor = 9

  // 10 ECHILD No child processes.  A wait or waitpid function was executed by
  //      a process that had no existing or unwaited-for child processes.
  case noChildProcess = 10

  // 11 EDEADLK Resource deadlock avoided.  An attempt was made to lock a sys-
  //      tem resource that would have resulted in a deadlock situation.
  case deadlock = 11

  // 12 ENOMEM Cannot allocate memory.  The new process image required more
  //      memory than was allowed by the hardware or by system-imposed mem-
  //      ory management constraints.  A lack of swap space is normally
  //      temporary; however, a lack of core is not.  Soft limits may be
  //      increased to their corresponding hard limits.
  case noMemory = 12

  // 13 EACCES Permission denied.  An attempt was made to access a file in a
  //      way forbidden by its file access permissions.
  case permissionDenied = 13

  // 14 EFAULT Bad address.  The system detected an invalid address in
  //      attempting to use an argument of a call.
  case badAddress = 14

  // 15 ENOTBLK Not a block device.  A block device operation was attempted on
  //      a non-block device or file.
  case notBlockDevice = 15

  // 16 EBUSY Resource busy.  An attempt to use a system resource which was in
  //      use at the time in a manner which would have conflicted with the
  //      request.
  case resourceBusy = 16

  // 17 EEXIST File exists.  An existing file was mentioned in an inappropri-
  //      ate context, for instance, as the new link name in a link func-
  //      tion.
  case fileExists = 17

  // 18 EXDEV Improper link.  A hard link to a file on another file system was
  //      attempted.
  case improperLink = 18

  // 19 ENODEV Operation not supported by device.  An attempt was made to
  //      apply an inappropriate function to a device, for example, trying
  //      to read a write-only device such as a printer.
  case operationNotSupportedByDevice = 19

  // 20 ENOTDIR Not a directory.  A component of the specified pathname
  //      existed, but it was not a directory, when a directory was
  //      expected.
  case notDirectory = 20

  // 21 EISDIR Is a directory.  An attempt was made to open a directory with
  //      write mode specified.
  case isDirectory = 21

  // 22 EINVAL Invalid argument.  Some invalid argument was supplied. (For
  //      example, specifying an undefined signal to a signal or kill func-
  //      tion).
  case invalidArgument = 22

  // 23 ENFILE Too many open files in system.  Maximum number of file descrip-
  //      tors allowable on the system has been reached and a requests for
  //      an open cannot be satisfied until at least one has been closed.
  case tooManyOpenFilesInSystem = 23

  // 24 EMFILE Too many open files.  <As released, the limit on the number of
  //      open files per process is 64.> Getdtablesize(2) will obtain the
  //      current limit.
  case tooManyOpenFiles = 24

  // 25 ENOTTY Inappropriate ioctl for device.  A control function (see
  //      ioctl(2)) was attempted for a file or special device for which
  //      the operation was inappropriate.
  case inappropriateIOCTLForDevice = 25

  // 26 ETXTBSY Text file busy.  The new process was a pure procedure (shared
  //      text) file which was open for writing by another process, or
  //      while the pure procedure file was being executed an open call
  //      requested write access.
  case textFileBusy = 26

  // 27 EFBIG File too large.  The size of a file exceeded the maximum (about
  //      2.1E9 bytes on some filesystems including UFS, 1.8E19 bytes on
  //      HFS+ and others).
  case fileTooLarge = 27

  // 28 ENOSPC Device out of space.  A write to an ordinary file, the creation
  //      of a directory or symbolic link, or the creation of a directory
  //      entry failed because no more disk blocks were available on the
  //      file system, or the allocation of an inode for a newly created
  //      file failed because no more inodes were available on the file
  //      system.
  case noSpace = 28

  // 29 ESPIPE Illegal seek.  An lseek function was issued on a socket, pipe
  //      or FIFO.
  case illegalSeek = 29

  // 30 EROFS Read-only file system.  An attempt was made to modify a file or
  //      directory was made on a file system that was read-only at the
  //      time.
  case readOnlyFileSystem = 30

  // 31 EMLINK Too many links.  Maximum allowable hard links to a single file
  //      has been exceeded (limit of 32767 hard links per file).
  case tooManyLinks = 31

  // 32 EPIPE Broken pipe.  A write on a pipe, socket or FIFO for which there
  //      is no process to read the data.
  case brokenPipe = 32

  // 33 EDOM Numerical argument out of domain.  A numerical input argument was
  //      outside the defined domain of the mathematical function.
  case outOfDomain = 33

  // 34 ERANGE Numerical result out of range.  A numerical result of the func-
  //      tion was too large to fit in the available space (perhaps
  //      exceeded precision).
  case outOfRange = 34

  // 35 EAGAIN Resource temporarily unavailable.  This is a temporary condi-
  //      tion and later calls to the same routine may complete normally.
  case resourceTemporarilyUnavailable = 35

  // 36 EINPROGRESS Operation now in progress.  An operation that takes a long
  //      time to complete (such as a connect(2) or connectx(2)) was
  //      attempted on a non-blocking object (see fcntl(2)).
  case nowInProcess = 36

  // 37 EALREADY Operation already in progress.  An operation was attempted on
  //      a non-blocking object that already had an operation in progress.
  case alreadyInProcess = 37

  // 38 ENOTSOCK Socket operation on non-socket.  Self-explanatory.
  case notSocket = 38

  // 39 EDESTADDRREQ Destination address required.  A required address was
  //      omitted from an operation on a socket.
  case addressRequired = 39

  // 40 EMSGSIZE Message too long.  A message sent on a socket was larger than
  //      the internal message buffer or some other network limit.
  case messageTooLong = 40

  // 41 EPROTOTYPE Protocol wrong type for socket.  A protocol was specified
  //      that does not support the semantics of the socket type requested.
  //      For example, you cannot use the ARPA Internet UDP protocol with
  //      type SOCK_STREAM.
  case protocolWrongTypeForSocket = 41

  // 42 ENOPROTOOPT Protocol not available.  A bad option or level was speci-
  //      fied in a getsockopt(2) or setsockopt(2) call.
  case protocolNotAvailable = 42

  // 43 EPROTONOSUPPORT Protocol not supported.  The protocol has not been
  //      configured into the system or no implementation for it exists.
  case protocolNotSupported = 43

  // 44 ESOCKTNOSUPPORT Socket type not supported.  The support for the socket
  //      type has not been configured into the system or no implementation
  //      for it exists.
  case socketTypeNotSupported = 44

  // 45 ENOTSUP Not supported.  The attempted operation is not supported for
  //      the type of object referenced.
  case notSupported = 45

  // 46 EPFNOSUPPORT Protocol family not supported.  The protocol family has
  //      not been configured into the system or no implementation for it
  //      exists.
  case protocolFamilyNotSupported = 46

  // 47 EAFNOSUPPORT Address family not supported by protocol family.  An
  //      address incompatible with the requested protocol was used.  For
  //      example, you shouldn't necessarily expect to be able to use NS
  //      addresses with ARPA Internet protocols.
  case addressFamilyNotSupported = 47

  // 48 EADDRINUSE Address already in use.  Only one usage of each address is
  //      normally permitted.
  case addressInUse = 48

  // 49 EADDRNOTAVAIL Cannot assign requested address.  Normally results from
  //      an attempt to create a socket with an address not on this
  //      machine.
  case addressNotAvailable = 49

  // 50 ENETDOWN Network is down.  A socket operation encountered a dead net-
  //      work.
  case networkDown = 50

  // 51 ENETUNREACH Network is unreachable.  A socket operation was attempted
  //      to an unreachable network.
  case networkUnreachable = 51

  // 52 ENETRESET Network dropped connection on reset.  The host you were con-
  //      nected to crashed and rebooted.
  case networkReset = 52

  // 53 ECONNABORTED Software caused connection abort.  A connection abort was
  //      caused internal to your host machine.
  case connectionAbort = 53

  // 54 ECONNRESET Connection reset by peer.  A connection was forcibly closed
  //      by a peer.  This normally results from a loss of the connection
  //      on the remote socket due to a timeout or a reboot.
  case connectionReset = 54

  // 55 ENOBUFS No buffer space available.  An operation on a socket or pipe
  //      was not performed because the system lacked sufficient buffer
  //      space or because a queue was full.
  case noBufferSpace = 55

  // 56 EISCONN Socket is already connected.  A connect or connectx request
  //      was made on an already connected socket; or, a sendto or sendmsg
  //      request on a connected socket specified a destination when
  //      already connected.
  case socketIsConnected = 56

  // 57 ENOTCONN Socket is not connected.  An request to send or receive data
  //      was disallowed because the socket was not connected and (when
  //      sending on a datagram socket) no address was supplied.
  case socketNotConnected = 57

  // 58 ESHUTDOWN Cannot send after socket shutdown.  A request to send data
  //      was disallowed because the socket had already been shut down with
  //      a previous shutdown(2) call.
  case socketShutdown = 58

  // 60 ETIMEDOUT Operation timed out.  A connect, connectx or send request
  //      failed because the connected party did not properly respond after
  //      a period of time.  (The timeout period is dependent on the commu-
  //      nication protocol.)
  case timedOut = 60

  // 61 ECONNREFUSED Connection refused.  No connection could be made because
  //      the target machine actively refused it.  This usually results
  //      from trying to connect to a service that is inactive on the for-
  //      eign host.
  case connectionRefused = 61

  // 62 ELOOP Too many levels of symbolic links.  A path name lookup involved
  //      more than 8 symbolic links.
  case tooManySymbolicLinkLevels = 62

  // 63 ENAMETOOLONG File name too long.  A component of a path name exceeded
  //      255 (MAXNAMELEN) characters, or an entire path name exceeded 1023
  //      (MAXPATHLEN-1) characters.
  case fileNameTooLong = 63

  // 64 EHOSTDOWN Host is down.  A socket operation failed because the desti-
  //      nation host was down.
  case hostIsDown = 64

  // 65 EHOSTUNREACH No route to host.  A socket operation was attempted to an
  //      unreachable host.
  case noRouteToHost = 65

  // 66 ENOTEMPTY Directory not empty.  A directory with entries other than
  //      `.' and `..' was supplied to a remove directory or rename call.
  case directoyNotEmpty = 66

  // 67 EPROCLIM Too many processes.
  case tooManyProcesses = 67

  // 68 EUSERS Too many users.  The quota system ran out of table entries.
  case tooManyUsers = 68

  // 69 EDQUOT Disc quota exceeded.  A write to an ordinary file, the creation
  //      of a directory or symbolic link, or the creation of a directory
  //      entry failed because the user's quota of disk blocks was
  //      exhausted, or the allocation of an inode for a newly created file
  //      failed because the user's quota of inodes was exhausted.
  case diskQuotaExceeded = 69

  // 70 ESTALE Stale NFS file handle.  An attempt was made to access an open
  //      file (on an NFS filesystem) which is now unavailable as refer-
  //      enced by the file descriptor.  This may indicate the file was
  //      deleted on the NFS server or some other catastrophic event
  //      occurred.
  case staleNFSFileHandle = 70

  // 72 EBADRPC RPC struct is bad.  Exchange of RPC information was unsuccess-
  //      ful.
  case rpcUnsuccessful = 72

  // 73 ERPCMISMATCH RPC version wrong.  The version of RPC on the remote peer
  //      is not compatible with the local version.
  case rpcVersionMismatch = 73

  // 74 EPROGUNAVAIL RPC prog. not avail.  The requested program is not regis-
  //      tered on the remote host.
  case rpcProgramUnavailable = 74

  // 75 EPROGMISMATCH Program version wrong.  The requested version of the
  //      program is not available on the remote host (RPC).
  case rpcProgramVersionMismatch = 75

  // 76 EPROCUNAVAIL Bad procedure for program.  An RPC call was attempted for
  //      a procedure which doesn't exist in the remote program.
  case rpcProcedureUnavailable = 76

  // 77 ENOLCK No locks available.  A system-imposed limit on the number of
  //      simultaneous file locks was reached.
  case noLocks = 77

  // 78 ENOSYS Function not implemented.  Attempted a system call that is not
  //      available on this system.
  case noFunction = 78

  // 79 EFTYPE Inappropriate file type or format.  The file was the wrong type
  //      for the operation, or a data file had the wrong format.
  case badFileTypeOrFormat = 79

  // 80 EAUTH Authentication error.  Attempted to use an invalid authentica-
  //      tion ticket to mount an NFS file system.
  case authenticationError = 80

  // 81 ENEEDAUTH Need authenticator.  An authentication ticket must be
  //      obtained before the given NFS file system may be mounted.
  case needAuthenticator = 81

  // 82 EPWROFF Device power is off.  The device power is off.
  case devicePowerIsOff = 82

  // 83 EDEVERR Device error.  A device error has occurred, e.g. a printer
  //      running out of paper.
  case deviceError = 83

  // 84 EOVERFLOW Value too large to be stored in data type.  A numerical
  //      result of the function was too large to be stored in the caller
  //      provided space.
  case overflow = 84

  // 85 EBADEXEC Bad executable (or shared library).  The executable or shared
  //      library being referenced was malformed.
  case badExecutable = 85

  // 86 EBADARCH Bad CPU type in executable.  The executable in question does
  //      not support the current CPU.
  case badCPUType = 86

  // 87 ESHLIBVERS Shared library version mismatch.  The version of the shared
  //      library on the system does not match the version which was
  //      expected.
  case sharedLibraryVersionMismatch = 87

  // 88 EBADMACHO Malformed Mach-o file.  The Mach object file is malformed.
  case malformedMachO = 88

  // 89 ECANCELED Operation canceled.  The scheduled operation was canceled.
  case canceled = 89

  // 90 EIDRM Identifier removed.  An IPC identifier was removed while the
  //      current process was waiting on it.
  case identifierRemoved = 90

  // 91 ENOMSG No message of desired type.  An IPC message queue does not con-
  //      tain a message of the desired type, or a message catalog does not
  //      contain the requested message.
  case noMessage = 91

  // 92 EILSEQ Illegal byte sequence.  While decoding a multibyte character
  //      the function came along an invalid or an incomplete sequence of
  //      bytes or the given wide character is invalid.
  case illegalByteSequence = 92

  // 93 ENOATTR Attribute not found.  The specified extended attribute does
  //      not exist.
  case attributeNotFound = 93

  // 94 EBADMSG Bad message.  The message to be received is inapprorpiate for
  //      the operation being attempted.
  case badMessage = 94

  // 95 EMULTIHOP Reserved.  This error is reserved for future use.
  case multiHop = 95

  // 96 ENODATA No message available.  No message was available to be received
  //      by the requested operation.
  case noData = 96

  // 97 ENOLINK Reserved.  This error is reserved for future use.
  case noLink = 97

  // 98 ENOSR No STREAM resources.  This error is reserved for future use.
  case noStream = 98

  // 99 ENOSTR Not a STREAM.  This error is reserved for future use.
  case notStream = 99

  // 100 EPROTO Protocol error.  Some protocol error occurred. This error is
  //      device-specific, but is generally not related to a hardware fail-
  //      ure.
  case protocolError = 100

  // 101 ETIME STREAM ioctl() timeout.  This error is reserved for future use.
  case timeout = 101

  // 102 EOPNOTSUPP Operation not supported on socket.  The attempted opera-
  //      tion is not supported for the type of socket referenced; for
  //      example, trying to accept a connection on a datagram socket.
  case notSupportedOnSocket = 102
}

import Darwin
public var errno: Errno {
  get { Errno(rawValue: Darwin.errno)! }
  set { Darwin.errno = newValue.rawValue }
}

