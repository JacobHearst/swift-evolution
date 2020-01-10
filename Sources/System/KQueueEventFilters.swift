// TODO: Consider making enums or else splitting out richer types
extension KernelQueue.Event {

  // TODO: Better opaque type
  public typealias Identifier = UInt

  // TODO: Better type
  public typealias FilterData = Int

  // TODO: Better type
  public typealias UserData = OpaquePointer?

  // ident: Value used to identify the source of the event.  The exact
  // interpretation is determined by the attached filter, but often is a file
  // descriptor.
  public var identifier: Identifier {
    get { rawValue.ident }
    set { rawValue.ident = newValue }
  }

  // data: Filter-specific data value.
  public var data: FilterData {
    get { rawValue.data }
    set { rawValue.data = newValue }
  }

  // udata: Opaque user-defined value passed through the kernel unchanged. It
  // can optionally be part of the uniquing decision of the kevent system
  public var userData: UserData {
    get { OpaquePointer(rawValue.udata) }
    set { rawValue.udata = UnsafeMutableRawPointer(newValue) }
  }
}

extension KernelQueue.Event {
  public struct Filter: RawRepresentable {
    public let rawValue: CInt16T
    public init(rawValue: CInt16T) { self.rawValue = rawValue }

    private init(_ raw: CInt16T) { self.init(rawValue: raw) }

    // EVFILT_READ: Takes a file descriptor as the identifier, and returns
    // whenever there is data available to read.
    public static var read: Filter { Filter(_EVFILT_READ) }

    // EVFILT_WRITE: Takes a file descriptor as the identifier, and returns
    // whenever it is possible to write to the descriptor.
    public static var write: Filter { Filter(_EVFILT_WRITE) }

    // EVFILT_AIO: This filter is currently unsupported.
    public static var aio: Filter { Filter(_EVFILT_AIO) }

    // EVFILT_VNODE: Takes a file descriptor as the identifier and the events to
    // watch for in fflags, and returns when one or more of the requested events
    // occurs on the descriptor.
    public static var vnode: Filter { Filter(_EVFILT_VNODE) }

    // EVFILT_PROC: Takes the process ID to monitor as the identifier and the
    // events to watch for in fflags, and returns when the process performs one
    // or more of the requested events.
    public static var proc: Filter { Filter(_EVFILT_PROC) }

    // EVFILT_SIGNAL: Takes the signal number to monitor as the identifier and
    // returns when the given signal is generated for the process.
    public static var signal: Filter { Filter(_EVFILT_SIGNAL) }

    // EVFILT_TIMER: Establishes an interval timer identified by ident where
    // data specifies the timeout period (in milliseconds).
    public static var timer: Filter { Filter(_EVFILT_TIMER) }

    // EVFILT_MACHPORT: Takes the name of a mach port, or port set, in ident and
    // waits until a message is enqueued on the port or port set.
    public static var machPort: Filter { Filter(_EVFILT_MACHPORT) }

    // EVFILT_FS: Filesystem events
    public static var fileSystem: Filter { Filter(_EVFILT_FS) }

    // EVFILT_USER: User events
    public static var user: Filter { Filter(_EVFILT_USER) }

    // EVFILT_VM: Virtual memory events
    public static var vm: Filter { Filter(_EVFILT_VM) }

    // EVFILT_EXCEPT: Takes a descriptor as the identifier, and returns whenever
    // one of the specified exceptional conditions has occurred on the
    // descriptor.
    public static var except: Filter { Filter(_EVFILT_EXCEPT) }

    // TODO: SYSCOUNT, THREADMARKER?
  }

  // filter: Identifies the kernel filter used to process this event.  The
  // pre-defined system filters are described below.
  public var filter: Filter {
    get { Filter(rawValue: rawValue.filter) }
    set { rawValue.filter = newValue.rawValue }
  }
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
    public static var add: Flags { Flags(_EV_ADD) }

    // EV_DELETE: Removes the event from the kqueue.  Events which are attached
    // to file descriptors are automatically deleted on the last close of the
    // descriptor.
    public static var delete: Flags { Flags(_EV_DELETE) }

    // EV_ENABLE: Permit kevent,() kevent64() and kevent_qos() to return the
    // event if it is triggered.
    public static var enable: Flags { Flags(_EV_ENABLE) }

    // EV_DISABLE: Disable the event so kevent,() kevent64() and kevent_qos()
    // will not return it.  The filter itself is not disabled.
    public static var disable: Flags { Flags(_EV_DISABLE) }

    // EV_ONESHOT: Causes the event to return only the first occurrence of the
    // filter being triggered.  After the user retrieves the event from the
    // kqueue, it is deleted.
    public static var oneshot: Flags { Flags(_EV_ONESHOT) }

    // EV_CLEAR: After the event is retrieved by the user, its state is reset.
    // This is useful for filters which report state transitions instead of the
    // current state.  Note that some filters may automatically set this flag
    // internally.
    public static var clear: Flags { Flags(_EV_CLEAR) }

    // EV_RECEIPT: This flag is useful for making bulk changes to a kqueue
    // without draining any pending events. When passed as input, it forces
    // EV_ERROR to always be returned. When a filter is successfully added, the
    // data field will be zero.
    public static var receipt: Flags { Flags(_EV_RECEIPT) }

    // TODO: DISPATCH? UDATA_SPECIFIC? DISPATCH2? VANISHED? SYSFLAGS? FLAG0? FLAG1?

    // EV_EOF: Filters may set this flag to indicate filter-specific EOF
    // condition.
    public static var eof: Flags { Flags(_EV_EOF) }

    // EV_ERROR: If an error occurs while processing an element of the changelist
    // and there is enough room in the eventlist, then the event will be placed in
    // the eventlist with EV_ERROR set in flags and the system error in data.
    public static var error: Flags { Flags(_EV_ERROR) }

    // EV_OOBAND: On input, specifies that filter should actively return in the
    // presence of OOB on the descriptor. It implies that filter will return if
    // there is OOB data available to read OR when any other condition for the
    // read are met (for example number of bytes regular data becomes >=
    // low-watermark). If EV_OOBAND is not set on input, it implies that the
    // filter should not actively return for out of band data on the descriptor.
    // The filter will then only return when some other condition for read is
    // met (ex: when number of regular data bytes >=low-watermark OR when socket
    // can't receive more data (SS_CANTRCVMORE)).
    //
    // On output, EV_OOBAND indicates the presence of OOB data on the
    // descriptor. If it was not specified as an input parameter, then the data
    // count is the number of bytes before the current OOB marker, else data
    // count is the number of bytes beyond OOB marker.
    public static var oob: Flags { Flags(_EV_OOBAND) }

    // EV_POLL: Determination should be made via poll(2)
    // semantics. These semantics dictate always returning true for regular files,
    // regardless of the amount of unread data in the file.
    public static var poll: Flags { Flags(_EV_POLL) }
  }

  // flags: Actions to perform on the event.
  public var flags: Flags { Flags(rawValue: rawValue.flags) }
}

// Filter-specific flags
extension KernelQueue.Event {
  // Flags for user filter
  public struct UserFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_TRIGGER: On input, causes the event to be triggered for output
    public static var trigger: UserFilterFlags {
      UserFilterFlags(_NOTE_TRIGGER)
    }

    // NOTE_FFNOP: ignore input fflags
    public static var nop: UserFilterFlags { UserFilterFlags(_NOTE_FFNOP) }

    // NOTE_FFAND: mask for flags
    public static var and: UserFilterFlags { UserFilterFlags(_NOTE_FFAND) }

    // NOTE_FFOR: mask for operations
    public static var or: UserFilterFlags { UserFilterFlags(_NOTE_FFOR) }

    // NOTE_FFCOPY: copy fflags
    public static var copy: UserFilterFlags { UserFilterFlags(_NOTE_FFCOPY) }

    // NOTE_FFCTRLMASK: or fflags
    public static var controlMask: UserFilterFlags {
      UserFilterFlags(_NOTE_FFCTRLMASK)
    }

    // NOTE_FFLAGSMASK: and fflags
    public static var flagsMask: UserFilterFlags {
      UserFilterFlags(_NOTE_FFLAGSMASK)
    }
  }

  public var userFilterFlags: UserFilterFlags {
    UserFilterFlags(rawValue: rawValue.fflags)
  }

  // Flags for read/write filter
  public struct ReadWriteFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_LOWAT: low water mark
    public static var lowWaterMark: ReadWriteFilterFlags {
      ReadWriteFilterFlags(_NOTE_LOWAT)
    }
  }

  public var readWriteFilterFlags: ReadWriteFilterFlags {
    ReadWriteFilterFlags(rawValue: rawValue.fflags)
  }


  // Flags for except filter
  public struct ExceptFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_OOB: OOB data
    public static var oob: ExceptFilterFlags { ExceptFilterFlags(_NOTE_OOB) }
  }

  public var exceptFilterFlags: ExceptFilterFlags {
    ExceptFilterFlags(rawValue: rawValue.fflags)
  }

  // Flags for vnode filter
  public struct VNodeFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_DELETE: vnode was removed
    public static var delete: VNodeFilterFlags { VNodeFilterFlags(_NOTE_DELETE) }

    // NOTE_WRITE: data contents changed
    public static var write: VNodeFilterFlags { VNodeFilterFlags(_NOTE_WRITE) }

    // NOTE_EXTEND: size increased
    public static var extend: VNodeFilterFlags { VNodeFilterFlags(_NOTE_EXTEND) }

    // NOTE_ATTRIB: attributes changed
    public static var attrib: VNodeFilterFlags { VNodeFilterFlags(_NOTE_ATTRIB) }

    // NOTE_LINK: link count changed
    public static var link: VNodeFilterFlags { VNodeFilterFlags(_NOTE_LINK) }

    // NOTE_RENAME: vnode was renamed
    public static var rename: VNodeFilterFlags { VNodeFilterFlags(_NOTE_RENAME) }

    // NOTE_REVOKE: vnode access was revoked
    public static var revoke: VNodeFilterFlags { VNodeFilterFlags(_NOTE_REVOKE) }

    // NOTE_NONE: No specific vnode event: to test for EVFILT_READ activation
    public static var none: VNodeFilterFlags { VNodeFilterFlags(_NOTE_NONE) }

    // NOTE_FUNLOCK: vnode was unlocked by flock(2)
    public static var unlock: VNodeFilterFlags {
      VNodeFilterFlags(_NOTE_FUNLOCK)
    }
  }

  public var vNodeFilterFlags: VNodeFilterFlags {
    VNodeFilterFlags(rawValue: rawValue.fflags)
  }

  // Flags for proc filter
  public struct ProcFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_EXIT: process exited */
    public static var exit: ProcFilterFlags { ProcFilterFlags(_NOTE_EXIT) }

    // NOTE_FORK: process forked */
    public static var fork: ProcFilterFlags { ProcFilterFlags(_NOTE_FORK) }

    // NOTE_EXEC: process exec'd */
    public static var exec: ProcFilterFlags { ProcFilterFlags(_NOTE_EXEC) }

    // NOTE_SIGNAL: shared with EVFILT_SIGNAL
    public static var signal: ProcFilterFlags { ProcFilterFlags(_NOTE_SIGNAL) }

    // NOTE_EXITSTATUS: exit status to be returned, valid for child process only
    public static var exitStatus: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXITSTATUS)
    }

    // NOTE_EXIT_DETAIL: provide details on reasons for exit
    public static var exitDetail: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXIT_DETAIL)
    }

    // NOTE_PDATAMASK: mask for signal & exit status
    public static var datamask: ProcFilterFlags {
      ProcFilterFlags(_NOTE_PDATAMASK)
    }

    // NOTE_EXIT_DETAIL_MASK: If NOTE_EXIT_DETAIL is present, these bits
    // indicate specific reasons for exiting.
    public static var exitDetailMask: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXIT_DETAIL_MASK)
    }

    // NOTE_EXIT_DECRYPTFAIL:
    public static var exitDecryptfail: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXIT_DECRYPTFAIL)
    }

    // NOTE_EXIT_MEMORY:
    public static var exitMemory: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXIT_MEMORY)
    }

    // NOTE_EXIT_CSERROR:
    public static var exitCSError: ProcFilterFlags {
      ProcFilterFlags(_NOTE_EXIT_CSERROR)
    }
  }

  public var procFilterFlags: ProcFilterFlags {
    ProcFilterFlags(rawValue: rawValue.fflags)
  }

  // Flags for vm filter
  public struct VMFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_VM_PRESSURE: will react on memory pressure
    public static var pressure: VMFilterFlags {
      VMFilterFlags(_NOTE_VM_PRESSURE)
    }

    // NOTE_VM_PRESSURE_TERMINATE: will quit on memory pressure, possibly after cleaning up dirty state
    public static var pressureTerminate: VMFilterFlags {
      VMFilterFlags(_NOTE_VM_PRESSURE_TERMINATE)
    }

    // NOTE_VM_PRESSURE_SUDDEN_TERMINATE: will quit immediately on memory pressure
    public static var pressureSuddenTerminate: VMFilterFlags {
      VMFilterFlags(_NOTE_VM_PRESSURE_SUDDEN_TERMINATE)
    }

    // NOTE_VM_ERROR: there was an error
    public static var error: VMFilterFlags { VMFilterFlags(_NOTE_VM_ERROR) }
  }

  public var vmFilterFlags: VMFilterFlags {
    VMFilterFlags(rawValue: rawValue.fflags)
  }

  // Flags for timer filter
  public struct TimerFilterFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_SECONDS: data is seconds
    public static var seconds: TimerFilterFlags {
      TimerFilterFlags(_NOTE_SECONDS)
    }

    // NOTE_USECONDS: data is microseconds
    public static var useconds: TimerFilterFlags {
      TimerFilterFlags(_NOTE_USECONDS)
    }

    // NOTE_NSECONDS: data is nanoseconds
    public static var nseconds: TimerFilterFlags {
      TimerFilterFlags(_NOTE_NSECONDS)
    }

    // NOTE_ABSOLUTE: absolute timeout
    public static var absolute: TimerFilterFlags {
      TimerFilterFlags(_NOTE_ABSOLUTE)
    }

    // NOTE_LEEWAY: ext[1] holds leeway for power aware timers
    public static var leeway: TimerFilterFlags {
      TimerFilterFlags(_NOTE_LEEWAY)
    }

    // NOTE_CRITICAL: system does minimal timer coalescing
    public static var critical: TimerFilterFlags {
      TimerFilterFlags(_NOTE_CRITICAL)
    }

    // NOTE_BACKGROUND: system does maximum timer coalescing
    public static var background: TimerFilterFlags {
      TimerFilterFlags(_NOTE_BACKGROUND)
    }

    // NOTE_MACH_CONTINUOUS_TIME:
    public static var machContinuousTime: TimerFilterFlags {
      TimerFilterFlags(_NOTE_MACH_CONTINUOUS_TIME)
    }

    // NOTE_MACHTIME: data is mach absolute time units
    public static var machTime: TimerFilterFlags {
      TimerFilterFlags(_NOTE_MACHTIME)
    }
  }

  public var timerFilterFlags: TimerFilterFlags {
    TimerFilterFlags(rawValue: rawValue.fflags)
  }
}

// All filter flags, together
extension KernelQueue.Event {
  // All flags, together
  public struct AllFilterSpecificFlags: OptionSet {
    public let rawValue: CUInt32T
    public init(rawValue: CUInt32T) { self.rawValue = rawValue }

    private init(_ raw: CUInt32T) { self.init(rawValue: raw) }

    // NOTE_TRIGGER: On input, causes the event to be triggered for output
    public static var trigger: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_TRIGGER)
    }

    // NOTE_FFNOP: ignore input fflags
    public static var nop: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFNOP)
    }

    // NOTE_FFAND: mask for flags
    public static var and: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFAND)
    }

    // NOTE_FFOR: mask for operations
    public static var or: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFOR)
    }

    // NOTE_FFCOPY: copy fflags
    public static var copy: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFCOPY)
    }

    // NOTE_FFCTRLMASK: or fflags
    public static var controlMask: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFCTRLMASK)
    }

    // NOTE_FFLAGSMASK: and fflags
    public static var flagsMask: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FFLAGSMASK)
    }

    // NOTE_LOWAT: low water mark
    public static var lowWaterMark: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_LOWAT)
    }

    // NOTE_OOB: OOB data
    public static var oob: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_OOB)
    }

    // NOTE_DELETE: vnode was removed
    public static var delete: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_DELETE)
    }

    // NOTE_WRITE: data contents changed
    public static var write: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_WRITE)
    }

    // NOTE_EXTEND: size increased
    public static var extend: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXTEND)
    }

    // NOTE_ATTRIB: attributes changed
    public static var attrib: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_ATTRIB)
    }

    // NOTE_LINK: link count changed
    public static var link: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_LINK)
    }

    // NOTE_RENAME: vnode was renamed
    public static var rename: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_RENAME)
    }

    // NOTE_REVOKE: vnode access was revoked
    public static var revoke: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_REVOKE)
    }

    // NOTE_NONE: No specific vnode event: to test for EVFILT_READ activation
    public static var none: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_NONE)
    }

    // NOTE_FUNLOCK: vnode was unlocked by flock(2)
    public static var unlock: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FUNLOCK)
    }

    // NOTE_EXIT: process exited */
    public static var exit: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT)
    }

    // NOTE_FORK: process forked */
    public static var fork: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_FORK)
    }

    // NOTE_EXEC: process exec'd */
    public static var exec: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXEC)
    }

    // NOTE_SIGNAL: shared with EVFILT_SIGNAL
    public static var signal: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_SIGNAL)
    }

    // NOTE_EXITSTATUS: exit status to be returned, valid for child process only
    public static var exitStatus: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXITSTATUS)
    }

    // NOTE_EXIT_DETAIL: provide details on reasons for exit
    public static var exitDetail: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT_DETAIL)
    }

    // NOTE_PDATAMASK: mask for signal & exit status
    public static var datamask: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_PDATAMASK)
    }

    // indicate specific reasons for exiting.
    public static var exitDetailMask: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT_DETAIL_MASK)
    }

    // NOTE_EXIT_DECRYPTFAIL:
    public static var exitDecryptfail: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT_DECRYPTFAIL)
    }

    // NOTE_EXIT_MEMORY:
    public static var exitMemory: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT_MEMORY)
    }

    // NOTE_EXIT_CSERROR:
    public static var exitCSError: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_EXIT_CSERROR)
    }

    // NOTE_VM_PRESSURE: will react on memory pressure
    public static var pressure: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_VM_PRESSURE)
    }

    // NOTE_VM_PRESSURE_TERMINATE: will quit on memory pressure, possibly after cleaning up dirty state
    public static var pressureTerminate: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_VM_PRESSURE_TERMINATE)
    }

    // NOTE_VM_PRESSURE_SUDDEN_TERMINATE: will quit immediately on memory pressure
    public static var pressureSuddenTerminate: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_VM_PRESSURE_SUDDEN_TERMINATE)
    }

    // NOTE_VM_ERROR: there was an error
    public static var error: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_VM_ERROR)
    }

    // NOTE_SECONDS: data is seconds
    public static var seconds: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_SECONDS)
    }

    // NOTE_USECONDS: data is microseconds
    public static var useconds: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_USECONDS)
    }

    // NOTE_NSECONDS: data is nanoseconds
    public static var nseconds: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_NSECONDS)
    }

    // NOTE_ABSOLUTE: absolute timeout
    public static var absolute: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_ABSOLUTE)
    }

    // NOTE_LEEWAY: ext[1] holds leeway for power aware timers
    public static var leeway: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_LEEWAY)
    }

    // NOTE_CRITICAL: system does minimal timer coalescing
    public static var critical: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_CRITICAL)
    }

    // NOTE_BACKGROUND: system does maximum timer coalescing
    public static var background: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_BACKGROUND)
    }

    // NOTE_MACH_CONTINUOUS_TIME:
    public static var machContinuousTime: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_MACH_CONTINUOUS_TIME)
    }

    // NOTE_MACHTIME: data is mach absolute time units
    public static var machTime: AllFilterSpecificFlags {
      AllFilterSpecificFlags(_NOTE_MACHTIME)
    }
  }

  // fflags: Filter-specific flags.
  public var filterFlags: AllFilterSpecificFlags {
    AllFilterSpecificFlags(rawValue: rawValue.fflags)
  }
}
