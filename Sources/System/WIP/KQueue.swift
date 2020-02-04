
/*public*/internal struct KernelQueue: FileDescriptorInterchangable {
  /*public*/internal let rawValue: CInt
  /*public*/internal init(rawValue: CInt) { self.rawValue = rawValue }
}

extension KernelQueue {
  /*public*/internal static func open() throws -> KernelQueue {
    try KernelQueue(_checking: _kqueue())
  }
}

extension KernelQueue {
  /*public*/internal struct Event: RawRepresentable {
    /*public*/internal var rawValue: CKEvent

    /*public*/internal init(rawValue: CKEvent) { self.rawValue = rawValue }
  }
}

