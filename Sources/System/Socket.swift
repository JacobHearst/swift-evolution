
struct Socket: RawRepresentable {
  public let rawValue: CInt
  public init(rawValue: CInt) { self.rawValue = rawValue }
}

// Sockets are the same as file descriptors. Consider a protocol to unify them, if we're
// going with a separate type...

extension Socket {
  fileprivate init(_ fd: FileDescriptor) { self.rawValue = fd.rawValue }

  public var fileDescriptor: FileDescriptor { FileDescriptor(rawValue: self.rawValue) }
}

extension Socket {
  public struct Domain: RawRepresentable {
    public let rawValue: CInt
    public init(rawValue: CInt) { self.rawValue = rawValue }

    // Host-internal protocols, formerly called PF_UNIX,
    public static var PF_LOCAL: Domain { Domain(rawValue: _PF_LOCAL) }

    // Host-internal protocols, deprecated, use PF_LOCAL,
    public static var PF_UNIX: Domain { Domain(rawValue: _PF_UNIX) }

    // Internet version 4 protocols,
    public static var PF_INET: Domain { Domain(rawValue: _PF_INET) }

    // Internal Routing protocol,
    public static var PF_ROUTE: Domain { Domain(rawValue: _PF_ROUTE) }

    // Internal key-management function,
    public static var PF_KEY: Domain { Domain(rawValue: _PF_KEY) }

    // Internet version 6 protocols,
    public static var PF_INET6: Domain { Domain(rawValue: _PF_INET6) }

    // System domain,
    public static var PF_SYSTEM: Domain { Domain(rawValue: _PF_SYSTEM) }

    // Raw access to network device
    public static var PF_NDRV: Domain { Domain(rawValue: _PF_NDRV) }
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
    Socket(try FileDescriptor(
      _checking: _socket(domain.rawValue, type.rawValue, proto.rawValue)))
  }
}

// TODO: socket addresses...
// TODO: connect[x], send, recv, recvfrom, setsockopt, getsockopt, bind, listen, accept

