open class ManagedRawBuffer<Header> {
  public final var header: Header

  private init(_doNotCallMe: ()) {
    fatalError("Only initialize these by calling create")
  }
}
extension ManagedRawBuffer {
  public final class func create(
    minimumByteCapacity: Int,
    makingHeaderWith factory: (ManagedRawBuffer<Header>) throws -> Header
  ) rethrows -> ManagedRawBuffer<Header> {
    fatalError("TODO: tail-allocate contents")
  }
}

public final class RawBufferStorage: ManagedRawBuffer<RawBufferStorage.Header> {
  public struct Header {
    internal var capacity: Int
  }

  public var capacity: Int { header.capacity }
}

// Just provide basic COW support. Consider dropping...
public struct RawBufferStorage🐮 {
  internal var storage: RawBufferStorage

  public var capacity: Int { storage.capacity }
}

public struct RawBuffer {
  internal var storage: RawBufferStorage🐮

  // Everthing prior to this offset
  public var headOffset: Int
  public var tailOffset: Int
}

extension RawBuffer {
  internal func _invariantCheck() {
    assert(0 <= headOffset && headOffset <= tailOffset && tailOffset <= totalByteCapacity)
  }
}

// Provide mutable, typed views over the storage
extension RawBuffer {
  public func view<T /* : Trivial */>(as type: T.Type = T.self) ->
  /* some RAC: RandomAccessCollection & MutableCollection where RAC.Element == T */
  Never {
    fatalError()
  }

  public var bytes:
  /* some RAC: RandomAccessCollection & MutableCollection where RAC.Element == UInt8 */
  Never {
    view(as: UInt8.self)
  }
}

// RawBuffer is not a collection (but it vends views that are). Expose some raw operations
extension RawBuffer {
  public var byteCount: Int { tailOffset &- headOffset }

  public var totalByteCapacity: Int { storage.capacity }

  public var excessTailByteCapacity: Int { totalByteCapacity &- tailOffset }

  public var excessLeadingByteCapacity: Int { headOffset }

  public var postHeadByteCapacity: Int { totalByteCapacity &- headOffset }

  // ...
  public mutating func slide() {
    if true { fatalError("TODO: Slide the allocation down...") }
    self.tailOffset &-= self.headOffset
    self.headOffset = 0
  }

  public mutating func reserveCapacity(_ bytes: Int) {
    guard bytes > postHeadByteCapacity else { return }

    guard bytes > totalByteCapacity else {
      slide()
      return
    }

    grow(bytes)
  }

  public mutating func grow(_ bytes: Int) {
    fatalError()
  }

}

