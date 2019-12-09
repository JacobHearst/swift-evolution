
// TODO: This probably deserves more consideration and design...

public struct Time: RawRepresentable {
  public var rawValue: CTimeT
  public init(rawValue: CTimeT) { self.rawValue = rawValue }
}

// TODO: Is there a more useful structure we can cheaply unpack this into instead? Is there
//       a better interface to provide than what C provides?
public struct Timespec: RawRepresentable {
  public var rawValue: CTimespec
  public init(rawValue: CTimespec) { self.rawValue = rawValue }

  // TODO: Bleh, this is messy as C has them both type aliased to `long`...
  public var seconds: Time { Time(rawValue: self.rawValue.tv_sec) }

  public var nanoseconds: Int { self.rawValue.tv_nsec }
}
