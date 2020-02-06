/*public*/internal protocol FileDescriptorInterchangable: RawRepresentable where RawValue == CInt {
  var rawValue: CInt { get }
  init(rawValue: CInt)
}

// Interchange with `FileDescriptor`
extension FileDescriptorInterchangable {
  /*public*/internal init(_ fd: FileDescriptor) {
    self.init(rawValue: fd.rawValue)
  }

  /*public*/internal var fileDescriptor: FileDescriptor { FileDescriptor(rawValue: self.rawValue) }

  internal init(_checking fd: CInt) throws {
    guard fd != -1 else { throw Errno.current }
    self.init(rawValue: fd)
  }
}

extension FileDescriptorInterchangable {
  // All file descriptors can be closed
  /*public*/internal func close() throws {
    guard _close(self.rawValue) != -1 else { throw Errno.current }
  }
}

extension FileDescriptor: FileDescriptorInterchangable {}

