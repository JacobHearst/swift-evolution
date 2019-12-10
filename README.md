# Prototype: System

A platform-specific library providing interfaces to syscalls and relevant currency types.

**Note: This is still a prototype and is completely untested!**

## Provides

* Error throwing with `struct Errno`
* Strongly-typed, `RawRepresentable` wrappers over everything (`FileDescriptor`, `Errno`, ... )
* Currency types (managed-lifetime `Path`, ...)
* `FileDescriptor`-related types and operations
  * `open`, `close`, `seek`, `read`
  * `fcntl` sub-commands (`getOwner`, `preallocate`, `setStatusFlags`, ... )
  * `struct FilePermissions: OptionSet`, ...
* ...  


## Organization and Conventions

Platform.swift provides platform-specific wrappers and aliases. It should be the only file that actually imports
the platform (`import Darwin`).

In general, `enum`s are avoided in lieu of `RawRepresentable` structs, which are more flexible,
unless exhaustive switching is very desirable.

Platform type aliases are `public` and used as the `RawValue`.  Platform values and syscalls
are `internal` and preceded by an underscore. Examples:

```swift
public struct FileType: RawRepresentable {
  public var rawValue: CModeT
  public init(rawValue: CModeT) { self.rawValue = rawValue }

  public static var fifo: FileType { FileType(rawValue: _S_IFIFO) }

  public static var characterDevice: FileType { FileType(rawValue: _S_IFCHR) }

...
}
```


## TODO

* Threading (`pthread`, TLS, ...)
* Process operations (`exit`, `fork`, `posix_spawn`, `kill`, `getpid`, `wait`, ...)
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

