// NOTE: not syscalls, but cstdio. Useful to put everything together?

import Darwin

public struct Stream {
  var rawValue: UnsafeMutablePointer<FILE>
}

extension Stream {
  public enum AccessMode: String {
    case read = "r"
    case write = "w"
    case append = "a"
    case readUpdate = "r+"
    case writeUpdate = "w+"
    case appendUpdate = "a+"
  }

  public init(open path: Path, _ mode: Stream.AccessMode) throws {
    guard let obj = fopen(path.rawValue, mode.rawValue) else { throw errno }
    self.rawValue = obj
  }

  public func close() throws {
    guard fclose(self.rawValue) == 0 else { throw errno }
  }

  public static func temporaryFile() throws -> Stream {
    guard let object = tmpfile() else { throw errno }
    return Stream(rawValue: object)
  }
  // TODO: template-string like temporary file names, which is also awful

  public func write(_ buf: UnsafeRawBufferPointer) throws {
    // WTF, is this guaranteed to actually set errno?
    guard buf.count >= fwrite(buf.baseAddress, 1, buf.count, self.rawValue) else {
      throw errno
    }
  }

  public func read(into buf: UnsafeMutableRawBufferPointer) throws {
    guard buf.count >= fread(buf.baseAddress, 1, buf.count, self.rawValue) else {
      throw errno
    }
  }

  public func setBuffer(to buffer: UnsafeMutableRawBufferPointer) {
    let b = buffer.bindMemory(to: Int8.self)
    setbuffer(self.rawValue, b.baseAddress, Int32(b.count))
  }

  public func flush() throws {
    guard fflush(self.rawValue) != eof else { throw errno }
  }
}



