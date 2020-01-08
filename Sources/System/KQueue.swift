
public struct KernelQueue: FileDescriptorProtocol {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
}

extension KernelQueue {
  public static func open() throws -> KernelQueue {
    try KernelQueue(_checking: _kqueue())
  }
}

extension KernelQueue {
  public struct Event: RawRepresentable {
    public let rawValue: CKEvent

    public init(rawValue: CKEvent) { self.rawValue = rawValue }
  }
}

// TODO: Consider making enums or else splitting out richer types
extension KernelQueue.Event {
  // ident: Value used to identify the source of the event.  The exact
  // interpretation is determined by the attached filter, but often is a file
  // descriptor.
  public var identifier: UInt /* TODO: better opaque type... */ {
    rawValue.ident
  }

  // data: Filter-specific data value.
  public var data: Int /* TODO: better type */ {
    rawValue.data
  }

  // udata: Opaque user-defined value passed through the kernel unchanged. It
  // can optionally be part of the uniquing decision of the kevent system
  public var userData: OpaquePointer? /* TODO: better type */ {
    OpaquePointer(rawValue.udata)
  }

}

extension KernelQueue.Event {
  public struct Filter: RawRepresentable {
    public let rawValue: CInt16T
    public init(rawValue: CInt16T) { self.rawValue = rawValue }

    private init(_ raw: CInt16T) { self.init(rawValue: raw) }

    // EVFILT_READ: Takes a file descriptor as the identifier, and returns
    // whenever there is data available to read.
    public var read: Filter { Filter(_EVFILT_READ) }

    // EVFILT_WRITE: Takes a file descriptor as the identifier, and returns
    // whenever it is possible to write to the descriptor.
    public var write: Filter { Filter(_EVFILT_WRITE) }

    // EVFILT_AIO: This filter is currently unsupported.
    public var aio: Filter { Filter(_EVFILT_AIO) }

    // EVFILT_VNODE: Takes a file descriptor as the identifier and the events to
    // watch for in fflags, and returns when one or more of the requested events
    // occurs on the descriptor.
    public var vnode: Filter { Filter(_EVFILT_VNODE) }

    // EVFILT_PROC: Takes the process ID to monitor as the identifier and the
    // events to watch for in fflags, and returns when the process performs one
    // or more of the requested events.
    public var proc: Filter { Filter(_EVFILT_PROC) }

    // EVFILT_SIGNAL: Takes the signal number to monitor as the identifier and
    // returns when the given signal is generated for the process.
    public var signal: Filter { Filter(_EVFILT_SIGNAL) }

    // EVFILT_TIMER: Establishes an interval timer identified by ident where
    // data specifies the timeout period (in milliseconds).
    public var timer: Filter { Filter(_EVFILT_TIMER) }

    // EVFILT_MACHPORT: Takes the name of a mach port, or port set, in ident and
    // waits until a message is enqueued on the port or port set.
    public var machport: Filter { Filter(_EVFILT_MACHPORT) }

    // TODO: fileSystem, user, virtualMemory

    // EVFILT_EXCEPT: Takes a descriptor as the identifier, and returns whenever
    // one of the specified exceptional conditions has occurred on the
    // descriptor.
    public var except: Filter { Filter(_EVFILT_EXCEPT) }

    // TODO: SYSCOUNT?

  }

  // filter: Identifies the kernel filter used to process this event.  The
  // pre-defined system filters are described below.
  public var filter: Filter { Filter(rawValue: rawValue.filter) }
}


extension KernelQueue.Event {
  public struct Flags: OptionSet {
    public let rawValue: CUInt16T
    public init(rawValue: CUInt16T) { self.rawValue = rawValue }

    private init(_ raw: CUInt16T) { self.init(rawValue: raw) }

    // EV_ADD: Adds the event to the kqueue.  Re-adding an existing event will
    // modify the parameters of the original event, and not result in a
    // duplicate entry.  Adding an event automatically enables it, unless
    // overridden by the EV_DISABLE flag.
    public var add: Flags { Flags(_EV_ADD) }

    // EV_ENABLE: Permit kevent,() kevent64() and kevent_qos() to return the
    // event if it is triggered.
    public var enable: Flags { Flags(_EV_ENABLE) }

    // EV_DISABLE: Disable the event so kevent,() kevent64() and kevent_qos()
    // will not return it.  The filter itself is not disabled.
    public var disable: Flags { Flags(_EV_DISABLE) }

    // EV_DELETE: Removes the event from the kqueue.  Events which are attached
    // to file descriptors are automatically deleted on the last close of the
    // descriptor.
    public var delete: Flags { Flags(_EV_DELETE) }

    // EV_RECEIPT: This flag is useful for making bulk changes to a kqueue
    // without draining any pending events. When passed as input, it forces
    // EV_ERROR to always be returned. When a filter is successfully added, the
    // data field will be zero.
    public var receipt: Flags { Flags(_EV_RECEIPT) }

    // EV_ONESHOT: Causes the event to return only the first occurrence of the
    // filter being triggered.  After the user retrieves the event from the
    // kqueue, it is deleted.
    public var oneshot: Flags { Flags(_EV_ONESHOT) }

    // EV_CLEAR: After the event is retrieved by the user, its state is reset.
    // This is useful for filters which report state transitions instead of the
    // current state.  Note that some filters may automatically set this flag
    // internally.
    public var clear: Flags { Flags(_EV_CLEAR) }

    // EV_EOF: Filters may set this flag to indicate filter-specific EOF
    // condition.
    public var eof: Flags { Flags(_EV_EOF) }

    // EV_OOBAND: Read filter on socket may set this flag to indicate the
    // presence of out of band data on the descriptor.
    public var outOfBand: Flags { Flags(_EV_OOBAND) }

    // EV_ERROR: If an error occurs while processing an element of the changelist
    // and there is enough room in the eventlist, then the event will be placed in
    // the eventlist with EV_ERROR set in flags and the system error in data.
    public var error: Flags { Flags(_EV_ERROR) }
  }

  // flags: Actions to perform on the event.
  public var flags: Flags { Flags(rawValue: rawValue.flags) }
}

extension KernelQueue.Event {
  // TODO: Due to overlap, should we break this out at this level? Creation/init
  // will certainly want them broken out...
  //
  // TODO: There are many more than listed in the man-page, so consider adding
  // them or else permitting
  public struct FilterSpecificFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

  }

  // fflags: Filter-specific flags.
  public var filterFlags: FilterSpecificFlags {
    FilterSpecificFlags(rawValue: rawValue.fflags)
  }
}
