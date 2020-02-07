

# System Module Prototype


A platform-specific library providing interfaces to system calls and relevant
low-level currency types.

## Introduction

Swift aims to be a systems programming language. System interfaces imported
through the `Darwin` and `Glibc` overlays are not Swifty and do not take
advantage of Swift's features such as strong types. This proposal
introduces a low-level System module for use in low level libraries, daemons,
and systems level programming. The System module is a platform-specific layer
that exists below the Foundation layer.

## Motivation

While Foundation provides an excellent platform abstraction layer, systems
programming often requires dipping below Foundation, sometimes in an environment
where Foundation may not even be available.

System interfaces were designed long before Swift and are currently exposed in
Swift in a non-Swifty manner. This makes Swift programming at the systems level
arduous and bug-prone. The `Darwin` and `Glibc` overlays present raw,
weakly-typed imported interfaces in the global namespace.

This module attempts to provide the Swiftiest wrappers and interfaces to system
calls using techniques such as strongly-typed `RawRepresentable` wrapper
structs, error handling, defaulted arguments, namespaces, and function
overloading.

### Example: `open`

For example, the `open` system call is imported as a pair of global functions:

```swift
func open(_ path: UnsafePointer<CChar>, _ oflag: Int32) -> Int32
func open(_ path: UnsafePointer<CChar>, _ oflag: Int32, _ mode: mode_t) -> Int32
```

File descriptors, alongside options, commands, errno, and other values, are
imported as ordinary `Int32`s. Callers have to remember to check for a
`-1`return value indicating an error, and if so check the value of the global
variable `errno` to know what error happened. The `oflag` argument is actually
an OR-ing of file access modes and various options/flags. File paths are
unmanaged pointers, and if they are derived from a managed object (e.g.
`Array<CChar>`), then callers must ensure that array is always null-termianted.

In contrast, this module defines the `open` system call as a static function in
the `FileDescriptor` namespace. `FileDescriptor` is a `RawRepresentable` struct
wrapping an `Int32`. File access mode is specified through a
`FileDescriptor.AccessMode` `RawRepresentable` struct, options through a
`FileDescriptor.OpenOptions` `OptionSet`, and permissions through a
`FilePermissions` `OptionSet`.


```swift
extension FileDescriptor {
  /// open: Open or create a file for reading or writing
  ///
  /// - Parameters:
  ///   - path: Location of the file to be opened
  ///   - mode: Access the file for reading, writing, or both
  ///   - options: Specify behavior
  ///   - permissions: File permissions for created files
  /// - Throws: `Errno`
  /// - Returns: A file descriptor for the open file
  public static func open(
    _ path: FilePath,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FilePermissions? = nil
  ) throws -> FileDescriptor
}
```

`FilePath` is a managed, null-termianted bag-of-bytes. (Additionally, there is
an overload taking an `UnsafePointer<CChar>` for situations where the memory
backing the path is externally managed and an additiona allocation is
undesirable).

## Proposed solution

...


### Swifty vs "systemsy"

This module does not attempt to redesign system interfaces or correct old
wrongs. It attempts to provide the Swiftiest wrappers it reasonably can. For any
irreconcilable conflict between "systemsy" and Swifty, "systemsy" wins, as the
purpose of this module is to provide the low-level system interface layer.

For example, `FileDescriptor` is a trivial struct, allowing it to be created
without allocation, stored compactly, and copied without reference counting.
Direct users of `FileDescriptor` will need to manage the lifetime and validity
of the resource. In the future, when Swift gets move-only structs, we can expose
additional resource types with linear, statically-enforced lifetimes and
validity.

If Foundation is available and such low-level concerns and interfaces are not
required, users can just use Foundation.

### Errno

Provides a strongly-typed `RawRepresentable` convenient wrapper and namespace
for dealing with system errors.

```swift
/// An error number used by system calls to communicate what kind of error ocurred.
@frozen
public struct Errno: RawRepresentable, Error {
  /// The raw C `int`
  public let rawValue: CInt

  /// Create a strongly typed `Errno` from a raw C `int`
  public init(rawValue: CInt) { self.rawValue = rawValue }

```

`Errno.current` is used to get/set current error value:

```swift
extension Errno {
  /// errno: The current error value, set by system calls on error.
  public static var current: System.Errno { get set }
}
```

Every distinct errno value is a static member of this type. Every screaming-caps
errno C constant is included as a renamed unavailable member for ease of use and
discoverability to new users. E.g.:

```swift
extension Errno {
  /// EINTR: Interrupted function call.
  ///
  /// An asynchronous signal (such as SIGINT or SIGQUIT) was caught by the
  /// process during the execution of an interruptible function. If the signal
  /// handler performs a normal return, the interrupted function call will seem
  /// to have returned the error condition.
  public static var interrupted: System.Errno { get }

  @available(*, unavailable, renamed: “interrupted”)
  public static var EINTR: System.Errno { get }
}
```

Errno conforms to Error so it can be thrown. All system calls in System module
throw `Errno.current` on failure. E.g.:

```swift
extension FileDescriptor {
  /// close: Delete a file descriptor
  ///
  /// Deletes the file descriptor from the per-process object reference table.
  /// If this is the last reference to the underlying object, the object will
  /// be deactivated.
  ///
  /// - Throws: `Errno`
  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw Errno.current }
  }
}
```

TODO: Determine if `Errno` would have an error domain.

### FileDescriptor

Provides a strongly-typed, RawRepresentable wrapper around file descriptors.

```swift
/// An abstract handle to input/output data resources, such as files and sockets.
@frozen
public struct FileDescriptor: RawRepresentable {
  /// The raw C `int`
  public let rawValue: CInt

  /// Create a strongly-typed `FileDescriptor` from a raw C `int`
  public init(rawValue: CInt) { self.rawValue = rawValue }
}
```

FileDescriptor serves as a namespace for various flags, OptionSets, constants,
etc., related to system calls over descriptors.

```swift
extension FileDescriptor {
  /// How to access a newly opened file: read, write, or both.
  @frozen
  public struct AccessMode: RawRepresentable {
    /// The raw C `int`
    public var rawValue: CInt

    /// Create a strongly-typed `AccessMode` from a raw C `int`
    public init(rawValue: CInt) { self.rawValue = rawValue }

    /// O_RDONLY: open for reading only
    public static var readOnly: AccessMode { AccessMode(rawValue: _O_RDONLY) }

    @available(*, unavailable, renamed: "readOnly")
    public static var O_RDONLY: AccessMode { readOnly }

    /// O_WRONLY: open for writing only
    public static var writeOnly: AccessMode { AccessMode(rawValue: _O_WRONLY) }

    @available(*, unavailable, renamed: "writeOnly")
    public static var O_WRONLY: AccessMode { writeOnly }

    /// O_RDWR: open for reading and writing
    public static var readWrite: AccessMode { AccessMode(rawValue: _O_RDWR) }

    @available(*, unavailable, renamed: "readWrite")
    public static var O_RDWR: AccessMode { readWrite }
  }
}
```

and similarly for `OpenOptions`, `SeekOrigin`, and `FilePermissions`.

FileDescriptor has methods for a handful of high-value system calls.
Our plan is to add more in future versions (see "In the Future" below).

```swift
  /// open: Open or create a file for reading or writing
  ///
  /// - Parameters:
  ///   - path: Location of the file to be opened
  ///   - mode: Access the file for reading, writing, or both
  ///   - options: Specify behavior
  ///   - permissions: File permissions for created files
  /// - Throws: `Errno`
  /// - Returns: A file descriptor for the open file
  public static func open(
    _ path: FilePath,
    _ mode: FileDescriptor.AccessMode,
    options: FileDescriptor.OpenOptions = FileDescriptor.OpenOptions(),
    permissions: FilePermissions? = nil
  ) throws -> FileDescriptor

  /// close: Delete a file descriptor
  ///
  /// Deletes the file descriptor from the per-process object reference table.
  /// If this is the last reference to the underlying object, the object will
  /// be deactivated.
  ///
  /// - Throws: `Errno`
  public func close() throws

  /// lseek: Reposition read/write file offset
  ///
  /// Reposition the offset for the given file descriptor
  ///
  /// - Parameters:
  ///   - offset: The offset to reposition to
  ///   - whence: Where the offset is applied to
  /// - Throws: `Errno`
  /// - Returns: The offset location as measured in bytes from the beginning of the file
  @discardableResult
  public func seek(
    offset: Int64, from whence: FileDescriptor.SeekOrigin
  ) throws -> Int64

  /// read: Read `buffer.count` bytes from the current read/write offset into
  /// `buffer`, and update the offset
  ///
  /// - Parameter buffer: The destination (and number of bytes) to read into
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually read
  /// - Note: Reads from the position associated with this file descriptor, and
  ///   increments that position by the number of bytes read.
  ///   See `seek(offset:from:)`.
  public func read(into buffer: UnsafeMutableRawBufferPointer) throws -> Int

  /// pread: Read `buffer.count` bytes from `offset` into `buffer`
  ///
  /// - Parameters:
  ///   - offset: Read from the specified position
  ///   - buffer: The destination (and number of bytes) to read into
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually read
  /// - Note: Unlike `read(into:)`, this avoids accessing and modifying the
  ///   position associated with this file descriptor
  public func read(
    fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer
  ) throws -> Int

  /// write: Write the contents of `buffer` to the current read/write offset,
  /// and update the offset
  ///
  /// - Parameter buffer: The data to write
  /// - Throws: `Errno`
  /// - Returns: The number of bytes written
  /// - Note: Writes to the position associated with this file descriptor, and
  ///   increments that position by the number of bytes written.
  ///   See `seek(offset:from:)`.
  public func write(
    _ buffer: UnsafeRawBufferPointer
  ) throws -> Int

  /// pwrite: Write the contents of `buffer` to `offset`
  ///
  /// - Parameters:
  ///   - offset: Write to the specified position
  ///   - buffer: The data to write
  /// - Throws: `Errno`
  /// - Returns: The number of bytes actually written
  /// - Note: Unlike `write(_:)`, this avoids accessing and modifying the
  /// position associated with this file descriptor
  public func write(
    toAbsoluteOffset offset: Int64, _ buffer: UnsafeRawBufferPointer
  ) throws -> Int
```

### FilePath

A managed-lifetime bag-o-bytes systems-level path type for locations on the file
system. FilePath internally ensures it is always nul-terminated.

```swift
/// A managed, null-terminated bag-of-bytes representing a location on the file
/// system
///
/// This example creates a FilePath from a string literal and uses it to open
/// and append to a log file.
///
///     let message: String = ...
///     let path: FilePath = "/tmp/log"
///     let fd = try FileDescriptor.open(path, .writeOnly, options: .append)
///     try fd.closeAfter { _ = try fd.write(message.utf8) }
///
/// - Note: FilePaths are Equatable and Hashable by equating / hashing their
///   raw byte contents, allowing them to be used as keys in Dictionaries.
///   However, path equivalence is a file-system-specific concept. A specific
///   file system may, e.g., consider paths equivalent after case conversion,
///   Unicode normalization, or resolving symbolic links.
public struct FilePath {
  /// Creates an empty path
  public init()

  /// Create a file path by copying null-termianted bytes from `cString`
  ///
  /// - Parameter cString: A pointer to null-terminated bytes
  public init(cString: UnsafePointer<CChar>)

  /// Calls the given closure with a pointer to the contents of the file path,
  /// represented as a pointer to null-terminated bytes.
  ///
  /// The pointer passed as an argument to `body` is valid only during the
  /// execution of `withCString(_:)`. Do not store or return the pointer for
  /// later use.
  ///
  /// - Parameter body: A closure with a pointer parameter that points to a
  ///   null-terminated sequence of bytes. If `body` has a return
  ///   value, that value is also used as the return value for the
  ///   `withCString(_:)` method. The pointer argument is valid only for the
  ///   duration of the method's execution.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  public func withCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result
}
```

It comes with a conformance to `Hashable` and other convenience protocols for
programmatic use, though proper semantic use is filesystem and context specific
(e.g. normalization, encoding validity, symlinks, relative paths, etc.).

```swift
extension FilePath: Hashable, Codable {}
```

You can go to/from a String (in which encoding errors will be corrected), and
construct one from a literal.

```swift
extension FilePath: ExpressibleByStringLiteral {
  /// Create a file path a String literal's UTF-8 contents
  ///
  /// - Parameter stringLiteral: A string literal whose UTF-8 contents will be the contents of the created path
  public init(stringLiteral: String)


  /// Create a file path from a string's UTF-8 contents
  ///
  /// - Parameter string: A string whose UTF-8 contents will be the contents of the created path
  public init(_ string: String)
}

extension FilePath: CustomStringConvertible {
  public var description: String { get }
}
extension String {
  /// Create a string from a file path
  ///
  /// - Parameter path: The file path whose bytes will be interpreted as UTF-8.
  /// - Note: Any encoding errors in the path's bytes will be error corrected.
  ///   This means that, depending on the semantics of the specific file system,
  ///   some paths cannot be round-tripped through a string.
  public init(_ path: FilePath)
}
```

We are not planning on adding any path components API in this release. See "In
the Future" for discussion.

## Example usage

TODO


## Detailed design

TODO: attach the generated API. Also, consider moving most of "Proposed
solution" to this section, as there will be redundancy.

## Impact on existing code

None

## Alternatives considered

### Changing `Darwin` / `Glibc` overlays

TODO

### In the Future

TODO



----

## NOTE: From the old README

### Organization and Conventions

Platform.swift provides platform-specific wrappers and aliases. It should be the
only file that actually imports the platform (`import Darwin`). This keeps the
rest of the library clean of platform imports and trims down on inessential
`#if/else/endif`.

Platform type aliases are `public` and used as the `RawValue`, beginning with
the letter `C` as in `CInt`. If an imported type is a `typedef` in C, but
imported with as a newtype into Swift via a `RawRepresentable` struct, the type
alias will refer to the underlying raw type, since attributes may differ per
platform.

```swift
// Platform.swift
public typealias CChar = Int8
public typealias CModeT = mode_t
public typealias COffT = off_t
public typealias CTimeT = time_t

public typealias CACLTagT = acl_tag_t.RawValue // Darwin imports as a wrapper type
```

Platform values and syscalls are not part of the library's API. They are
`internal` and preceded by an underscore.

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

Outside of Platform.swift (i.e. everywhere else), strong type wrappers are
defined around these typealiases. This gives a type safe API and provides
convenient namespaces for lookup. Functions/methods take these strong types,
invoke the corresponding syscall with their raw values, and map error values
into `Errno` throws.

```swift
// FileDescriptor.swift
public struct FileDescriptor: RawRepresentable {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }

  public func close() throws {
    guard _close(self.rawValue) != -1 else { throw Errno.current }
  }
}
```

In general, `enum`s are avoided in lieu of `RawRepresentable` structs, which are
more flexible, unless exhaustive switching is critical.

Note: There are currently no `enum`s in System's API, i.e. no cases where
exhaustive switching has been critical

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

### Next Steps


#### 1. Coverage for SwiftNIO

SwiftNIO is a perfect example of a client of this package. Complete coverage for
the functionality in NIO's `System.swift` demonstrate the utility of this
library and provides a rough guide for what functionality should be present in
the intial release.

NIO would additionally need:

##### Sockets and network interfaces

Sockets and networking provide a large and important API surface area for NIO.
They also present design considerations (e.g. separate Socket type vs
FileDescriptor type?).

##### Polling and events

`poll`, `select`, `kqueue`, and `epoll` are all highly relevant for asynchronous
programming around resources.


##### Threading with pthreads

NIO uses pthreads in their threading implementation. Pthreads are also a way to
access useful structures such as thread-local-storage, and thus should be
surfaced better for low level libraries.

Pthreads, like directory support below, may surface some challenges with
providing Swifty APIs around what's currently defined.


#### 2. Evaluate currency types

Potential clients include low-level libraries that wish to use currency types
declared here, such as `FileDescriptor` and the managed `Path` type.

We should make sure our currency types are adequate for such usage, and
potentially work with such clients to reduce their dependencies on
platform-specific currency types.


#### 3. Directory navigation

Covering directory-related calls might illustrate some of the challenges
involved in providing Swifty interfaces around systems designed in a very
non-Swifty way. This package is more interested in wrapping the lowest-level
relevant syscalls, and layering functionality on top of that, then in reexposing
the C standard library.

E.g., Darwin's library should provide wrappers and layered functionality
around `getattrlistbulk`

#### 4. Enlist platform experts

Darwin, Linux, and Windows have specific platform considerations about the right
calls to expose and how to expose them. We should reach out and enlist the
guidance of platform experts.


#### 5. Misc TODOs

* Process operations (`exit`, `fork`, `posix_spawn`, `kill`, `getpid`, `wait`, ...)
* Path components
* File locking (`fcntl` file locking, `flock`, ...)
* More error info ( `strerror`, ...)
* More file operations (`chmod`, `chown`, `symlink`, `link`, `unlink`, ...)
* More permissions (`acl_tag_t`, flags, permissions, ...)


### TODO: `EINTR` and others

Consider doing the "correct" thing of always retrying on `EINTR` (except for
`close`, because reasons). Need to figure out some kind of watchdog, etc., and
some calls such as file close are dubious.

`EAGAIN/WOULDBLOCK` should be surfaced cheaply. We really would want typed
throws, no reason throwing an `Int32` should be expensive or indirect.
Alternatively, some calls may be marked `@inlinable` to try to allow the
compiler to optimize away intermediary overhead.




