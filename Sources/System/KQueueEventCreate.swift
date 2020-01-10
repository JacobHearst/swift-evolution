
extension KernelQueue.Event {
  public init(
    identifier: Identifier = Identifier(),
    filter: Filter,
    filterFlags: AllFilterSpecificFlags = AllFilterSpecificFlags(),
    filterData: FilterData = FilterData(),
    userData: UserData = nil,
    flags: Flags = Flags()
  ) {
    self.init(rawValue: CKEvent(
      ident: identifier,
      filter: filter.rawValue,
      flags: flags.rawValue,
      fflags: filterFlags.rawValue,
      data: filterData,
      udata: UnsafeMutablePointer(userData)))
  }

  public static func read() -> KernelQueue.Event {
    fatalError("TODO: arugmetns and implement")
  }
  // TODO: write, aio, vnode, proc, signal, timer, machPort, fileSystem

  public static func user(
    identifier: Identifier = Identifier(),
    filterFlags: UserFilterFlags, // TODO: Defaulted? "userFlags"?
    filterData: FilterData = FilterData(), // TODO: "userData?" contrast with below?
    userData: UserData = nil,
    flags: Flags = Flags()
  ) -> KernelQueue.Event {
    return KernelQueue.Event(
      identifier: identifier,
      filter: .user,
      filterFlags: AllFilterSpecificFlags(rawValue: filterFlags.rawValue),
      filterData: filterData,
      userData: userData,
      flags: flags)
  }

  // TODO: vm, except, others?
}


