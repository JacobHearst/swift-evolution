# Prototype: System

A platform-specific library providing interfaces to syscalls and relevant currency types.

**Note: This is still a prototype and is completely untested!**

### "What is a syscall?"

This package is probably not for you, refer to Foundation and/or higher-level packages.

A syscall is the lowest-level interface for user-space processes to interact with the operating system. This
package provides a more convenient, Swiftier interface, but still sits at the lowest level available. Tricky details,
as well as general resource management, are left up to the user of this library. These details are often 
esoteric and not portable.

In short, while this library tries to provide Swifty interfaces when reasonable, whenever "Swifty" is at
odds with "Systems-y", "Systems-y" wins.


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


## TODO

* Threading (`pthread`, TLS, ...)
* Process operations (`exit`, `fork`, `posix_spawn`, `kill`, `getpid`, `wait`, ...)
* More sockets
* Path components
* File locking (`fcntl` file locking, `flock`, ...)
* More error info ( `strerror`, ...)
* Directory info/navigation (`dir`, `dirent`, ...)
* More file operations (`chmod`, `chown`, `symlink`, `link`, `unlink`, ...)
* More permissions (`acl_tag_t`, flags, permissions, ...)


#### `EINTR` and others

Consider doing the "correct" thing of always retrying on `EINTR` (except for `close`, because reasons).
Need to figure out some kind of watchdog, etc., and some calls such as file close are dubious.

`EAGAIN/WOULDBLOCK` should be surfaced cheaply
(TODO: check if errors are too heavy weight and what to do about it).
We really would want typed throws, no reason throwing an `Int32` should be expensive or indirect.

