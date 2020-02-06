extension OpaquePointer {
  internal var _isNULL: Bool { OpaquePointer(bitPattern: Int(bitPattern: self)) == nil }
}

extension Sequence {
  // Tries to recast contiguous pointer if available, otherwise allocates memory.
  internal func _withRawBufferPointer<R>(
    _ body: (UnsafeRawBufferPointer) throws -> R
  ) rethrows -> R {
    guard let result = try self.withContiguousStorageIfAvailable({
      try body(UnsafeRawBufferPointer($0))
    }) else {
      return try Array(self).withUnsafeBytes(body)
    }
    return result
  }
}
