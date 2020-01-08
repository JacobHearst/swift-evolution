
public struct KernelQueue: FileDescriptorInterchangable {
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

