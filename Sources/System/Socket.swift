
struct Socket: FileDescriptorInterchangable {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
}

extension Socket {
  public struct Domain: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // Host-internal protocols, formerly called PF_UNIX,
    public static var local: Domain { Domain(rawValue: _PF_LOCAL) }

    // Host-internal protocols, deprecated, use PF_LOCAL,
    public static var unix: Domain { Domain(rawValue: _PF_UNIX) }

    // Internet version 4 protocols,
    public static var ipv4: Domain { Domain(rawValue: _PF_INET) }

    // Internal Routing protocol,
    public static var routing: Domain { Domain(rawValue: _PF_ROUTE) }

    // Internal key-management function,
    public static var keyManagement: Domain { Domain(rawValue: _PF_KEY) }

    // Internet version 6 protocols,
    public static var ipv6: Domain { Domain(rawValue: _PF_INET6) }

    // System domain,
    public static var system: Domain { Domain(rawValue: _PF_SYSTEM) }

    // Raw access to network device
    public static var networkDevice: Domain { Domain(rawValue: _PF_NDRV) }
  }

  public struct ConnectionType: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // Sequenced, reliable, two-way connection based byte streams.
    public var stream: ConnectionType { ConnectionType(rawValue: _SOCK_STREAM) }

    // Datagrams (connectionless, unreliable messages of a fixed (typically small) maximum length)
    public var datagram: ConnectionType { ConnectionType(rawValue: _SOCK_DGRAM) }

    // Only available to the super user
    public var raw: ConnectionType { ConnectionType(rawValue: _SOCK_RAW) }
  }

  public struct ProtocolID: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // TODO: What goes here???

    // TODO: ProtocolEntry via `getprotoent`, etc., in a ProtocolEntry.swift file.
  }

  public struct MessageFlags: OptionSet {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    private init(_ raw: CInt) { self.init(rawValue: raw) }

    // MSG_OOB: process out-of-band data
    public static var outOfBand: MessageFlags { MessageFlags(_MSG_OOB) }

    // MSG_DONTROUTE: bypass routing, use direct interface
    public static var doNotRoute: MessageFlags { MessageFlags(_MSG_DONTROUTE) }

    // MSG_PEEK: peek at incoming message
    public static var peek: MessageFlags { MessageFlags(_MSG_PEEK) }

    // MSG_WAITALL: wait for full request or error
    public static var waitForAll: MessageFlags { MessageFlags(_MSG_WAITALL) }
  }

}

extension Socket {
  // TODO: Consider having a SocketDescriptor and unifying protocol, if that helps keep things
  // organized for clients.

  // `socket` syscall
  public static func open(
    _ domain: Domain,
    _ type: ConnectionType,
    _ proto: ProtocolID
  ) throws -> Socket {
    try Socket(_checking: _socket(domain.rawValue, type.rawValue, proto.rawValue))
  }

  public func bind() {
    fatalError("TODO: how to model sockaddrs?")
  }
  public func unlink() {
    fatalError("TODO: can we use unlinkat to skip path lookup?")
  }

  public func listen(backlog: Int) throws {
    guard _listen(self.rawValue, CInt(backlog)) == 0 else { throw errno }
  }

  public func accept(
  ) throws -> Socket {
    fatalError("TODO: how to model sockaddrs?")
  }

  public func send(
    _ buffer: UnsafeRawBufferPointer, _ flags: MessageFlags
  ) throws -> Int {
    let result = _send(self.rawValue, buffer.baseAddress, buffer.count, flags.rawValue)
    guard result != -1 else { throw errno }
    return Int(result)
  }
  // TODO: Convenience helper taking ByteBuffer...

  public func sendmsg(
  ) throws {
    fatalError("TODO: msghdr")
  }

  // TODO: `sendto`

  public func receive(
    _ buffer: UnsafeMutableRawBufferPointer, _ flags: MessageFlags
  ) throws -> Int {
    let result = _recv(self.rawValue, buffer.baseAddress, buffer.count, flags.rawValue)
    guard result != -1 else { throw errno }
    return Int(result)
  }

  // TODO: `recvfrom` and `recvmsg`...


  public func connect(
  ) throws {
    fatalError("TODO: how to model sockaddrs?")
  }

  // TODO: `connectx`

  // TODO: setsockopt, getsockopt

}

// TODO: socket addresses...
