# Prototype: System

A platform-specific library providing interfaces to syscalls and relevant currency types.

**Note: This is still a prototype and is completely untested!**

### "What is a syscall?"

If you're asking this question, this package is probably not for you.
Refer to Foundation and/or higher-level packages.

A syscall is the lowest-level interface for user-space processes to interact with the operating system. This
package provides a more convenient, Swiftier interface, but still sits at the lowest level available. Tricky details,
as well as general resource management, are left up to the user of this library. These details are often 
esoteric and not portable.

In short, while this library tries to provide Swifty interfaces when reasonable, whenever "Swifty" is at
odds with "Systems-y", "Systems-y" wins.

### "I need a platform abstraction layer"

This is not that. Refer to Foundation and/or higher-level packages.

### "Is this complete?"

Completeness is not a requirement or goal of this package.
API is added as-needed, provided additions design for the basic patterns, conventions,
and relevant currency types.


## Provides

* Error throwing with `struct Errno`
* Strongly-typed, `RawRepresentable` wrappers over everything
  * `FileDescriptor`, `Errno`, `Socket.Domain`, ..., are all separate strong types rather than just `int`
* Currency types (managed-lifetime `Path`, ...)
* `FileDescriptor`-related types and operations
  * `open`, `close`, `seek`, `read`
  * `fcntl` sub-commands (`getOwner`, `preallocate`, `setStatusFlags`, ... )
  * `struct FilePermissions: OptionSet`, ...
* Sockets  
* `kqueue`
* ...  


## Organization and Conventions

Platform.swift provides platform-specific wrappers and aliases. It should be the only file that actually imports
the platform (`import Darwin`). This keeps the rest of the library clean of platform imports and trims down
on inessential `#if/else/endif`.

Platform type aliases are `public` and used as the `RawValue`, beginning with the letter `C` as in `CInt`.
If an imported type is a `typedef` in C, but imported with as a newtype into Swift via a `RawRepresentable`
struct, the type alias will refer to the underlying raw type, since attributes may differ per platform. 

```swift
// Platform.swift
public typealias CChar = Int8
public typealias CModeT = mode_t
public typealias COffT = off_t
public typealias CTimeT = time_t

public typealias CACLTagT = acl_tag_t.RawValue // Darwin imports as a wrapper type
```

Platform values and syscalls are not part of the library's API. They are  `internal` and preceded by an
underscore.

```swift
// Platform.swift
internal var _O_NONBLOCK: CInt { O_NONBLOCK }
internal var _O_APPEND: CInt { O_APPEND }
internal var _O_CREAT: CInt { O_CREAT }
internal var _O_TRUNC: CInt { O_TRUNC }
internal var _O_EXCL: CInt { O_EXCL }

internal let _close = close
internal let _read = read
internal let _pread = pread
internal let _lseek = lseek
internal func _fcntl(_ fd: Int32, _ cmd: Int32) -> Int32 {
  fcntl(fd, cmd)
}
internal func _fcntl(_ fd: Int32, _ cmd: Int32, _ value: Int32) -> Int32 {
  fcntl(fd, cmd, value)
}
internal func _fcntl(_ fd: Int32, _ cmd: Int32, _ ptr: UnsafeMutableRawPointer) -> Int32 {
  fcntl(fd, cmd, ptr)
}
```

Outside of Platform.swift (i.e. everywhere else), strong type wrappers are defined around these typealiases.
This gives a type safe API and provides convenient namespaces for lookup.
Functions/methods take these strong types, invoke the corresponding syscall with their raw values, and map
error values into `Errno` throws.

```swift
// FileDescriptor.swift
public struct FileDescriptor: RawRepresentable {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }

  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw errno }
  }
}
```

In general, `enum`s are avoided in lieu of `RawRepresentable` structs, which are more flexible,
unless exhaustive switching is critical.

TODO: elaborate on what we mean by "more flexible".

Note: There are currently no `enum`s in System's API, i.e. no cases where exhaustive switching has been critical

```swift
// Errno.swift
public struct Errno: RawRepresentable, Error {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
  private init(_ raw: CInt) { self.init(rawValue: raw) }

  // Error. Not used.
  public static var notUsed: Errno { Errno(_ERRNO_NOT_USED) }

  // EPERM Operation not permitted.
  //
  // An attempt was made to perform an oper- ation limited to processes with
  // appropriate privileges or to the owner of a file or other resources.
  public static var notPermitted: Errno { Errno(_EPERM) }

  // ENOENT No such file or directory.
  //
  // A component of a specified pathname did not exist, or the pathname was an
  // empty string.
  public static var noSuchFileOrDirectory: Errno { Errno(_ENOENT) }
  
  ...
}
```



## Next Steps


### 1. Coverage for SwiftNIO

SwiftNIO is a perfect example of a client of this package. Complete coverage for
the functionality in NIO's `System.swift` demonstrate the utility of this library and
provides a rough guide for what functionality should be present in the intial release.

NIO would additionally need:

#### Sockets and network interfaces

Sockets and networking provide a large and important API surface area for NIO.
They also present design considerations (e.g. separate Socket type vs FileDescriptor type?).

#### Polling and events

`poll`, `select`, `kqueue`, and `epoll` are all highly relevant for asynchronous programming 
around resources.


#### Threading with pthreads

NIO uses pthreads in their threading implementation. Pthreads are also a way to access
useful structures such as thread-local-storage, and thus should be surfaced better
for low level libraries.

Pthreads, like directory support below, may surface some challenges with providing
Swifty APIs around what's currently defined.


### 2. Evaluate currency types

Potential clients include low-level libraries that wish to use currency types
declared here, such as `FileDescriptor` and the managed `Path` type.

We should make sure our currency types are adequate for such usage, and
potentially work with such clients to reduce their dependencies on
platform-specific currency types.


### 3. Directory navigation

Covering directory-related calls might illustrate some of the challenges involved in
providing Swifty interfaces around systems designed in a very non-Swifty way. This
package is more interested in wrapping the lowest-level relevant syscalls, and layering
functionality on top of that, then in reexposing the C standard library.

E.g., Darwin's library should provide wrappers and layered functionality
around `getattrlistbulk`

### 4. Enlist platform experts

Darwin, Linux, and Windows have specific platform considerations about the right calls to
expose and how to expose them. We should reach out and enlist the guidance of platform
experts.


### 5. Misc TODOs

* Process operations (`exit`, `fork`, `posix_spawn`, `kill`, `getpid`, `wait`, ...)
* Path components
* File locking (`fcntl` file locking, `flock`, ...)
* More error info ( `strerror`, ...)
* More file operations (`chmod`, `chown`, `symlink`, `link`, `unlink`, ...)
* More permissions (`acl_tag_t`, flags, permissions, ...)



## TODO: `EINTR` and others

Consider doing the "correct" thing of always retrying on `EINTR` (except for `close`, because reasons).
Need to figure out some kind of watchdog, etc., and some calls such as file close are dubious.

`EAGAIN/WOULDBLOCK` should be surfaced cheaply. We really would want typed throws,
no reason throwing an `Int32` should be expensive or indirect. Alternatively, some calls
may be marked `@inlinable` to try to allow the compiler to optimize away intermediary overhead.

## Detailed Description

### FileDescriptor

TODO: brief description of the problem

`FileDescriptor` is a strong wrapper type that serves as the currency type. `Socket`, `KernelQueue`, and
others are more specific file descriptor types that provide specialized interfaces.

Since Swift doesn't support struct subtyping, we define a `FileDescriptorInterchangable` which each
type of file descriptor conforms to. This protocol provides the means to convert to/from the 
`FileDescriptor` currency type, and defines some universal operations such as `close`
as well as utility methods.

TODO: Consider having "FileDescriptor" itself be a specialized type, and have a more abstract "Descriptor"
or resource-like currency type.



