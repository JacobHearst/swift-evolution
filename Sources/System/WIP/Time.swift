
// TODO: This probably deserves more consideration and design...

/*public*/internal struct Time: RawRepresentable {
  /*public*/internal var rawValue: CTimeT
  /*public*/internal init(rawValue: CTimeT) { self.rawValue = rawValue }
}

// TODO: Is there a more useful structure we can cheaply unpack this into instead? Is there
//       a better interface to provide than what C provides?
/*public*/internal struct Timespec: RawRepresentable {
  /*public*/internal var rawValue: CTimespec
  /*public*/internal init(rawValue: CTimespec) { self.rawValue = rawValue }

  // TODO: Bleh, this is messy as C has them both type aliased to `long`...
  /*public*/internal var seconds: Time { Time(rawValue: self.rawValue.tv_sec) }

  /*public*/internal var nanoseconds: Int { self.rawValue.tv_nsec }
}
