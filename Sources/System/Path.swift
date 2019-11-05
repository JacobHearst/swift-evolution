public struct Path {
  public var rawValue: String
}
extension Path: ExpressibleByStringLiteral {
  public init(stringLiteral: String) {
    self.rawValue = stringLiteral
  }
}
