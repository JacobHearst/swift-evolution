extension OpaquePointer {
  internal var isNULL: Bool { OpaquePointer(bitPattern: Int(bitPattern: self)) == nil }
}


