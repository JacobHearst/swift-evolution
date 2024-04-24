# Safe Access to Contiguous UTF-8 Storage

* Proposal: [SE-NNNN](nnnn-utf8-span.md)
* Authors: [Michael Ilseman](https://github.com/milseman), [Guillaume Lessard](https://github.com/glessard)
* Review Manager: TBD
* Status: **Awaiting implementation**
* Bug: rdar://48132971, rdar://96837923
* Implementation: (pending)
* Upcoming Feature Flag: (pending)
* Review: ([pitch 1](https://forums.swift.org/t/pitch-utf-8-processing-over-unsafe-contiguous-bytes/69715))

## Introduction

We introduce `UTF8Span` for efficient and safe Unicode processing over contiguous storage.

Native `String`s are stored as validly-encoded UTF-8 bytes in a contiguous memory buffer. The standard library implements `String` functionality on top of this buffer, taking advantage of the validly-encoded invariant and specialized Unicode knowledge. We propose exposing this functionality as API for more advanced libraries and developers.

## Motivation

**TODO**

### UTF-8 validity and efficiency

UTF-8 validation is particularly common concern and the subject of a fair amount of [research](https://lemire.me/blog/2020/10/20/ridiculously-fast-unicode-utf-8-validation/). Once an input is known to be validly encoded UTF-8, subsequent operations such as decoding, grapheme breaking, comparison, etc., can be implemented much more efficiently under this assumption of validity. Swift's `String` type's native storage is guaranteed-valid-UTF8 for this reason.

Failure to guarantee UTF-8 encoding validity creates security and safety concerns. With invalidly-encoded contents, memory safety would become more nuanced. An ill-formed leading byte can dictate a scalar length that is longer than the memory buffer. The buffer may have bounds associated with it, which differs from the bounds dictated by its contents.

Additionally, a particular scalar value in valid UTF-8 has only one encoding, but invalid UTF-8 could have the same value encoded as an [overlong encoding](https://en.wikipedia.org/wiki/UTF-8#Overlong_encodings), which would compromise code that checks for the presence of a scalar value by looking at the encoded bytes (or that does a byte-wise comparison).




## Proposed solution

We propose a non-escapable `UTF8Span` which exposes a similar API surface as `String` for validly-encoded UTF-8 code units in contiguous memory.


## Detailed design

...

```swift
@frozen
public struct UTF8Span: Copyable, ~Escapable {
  @usableFromInline
  internal var _start: RawSpan.Index

  /*
   A bit-packed count and flags (such as isASCII)

   ┌───────┬──────────┬───────┐
   │ b63   │ b62:56   │ b56:0 │
   ├───────┼──────────┼───────┤
   │ ASCII │ reserved │ count │
   └───────┴──────────┴───────┘

   Future bits could be used for all <0x300 scalar (aka <0xC0 byte)
   flag which denotes the quickest NFC check, a quickCheck NFC
   flag (using Unicode data tables), a full-check NFC flag,
   single-scalar-grapheme-clusters flag, etc.

   */
  @usableFromInline
  internal var _countAndFlags: UInt64
}
```

### Creation and validation

...

```swift
extension Unicode.UTF8 {
  @frozen
  public struct EncodingErrorKind: Error, Sendable, Hashable, Codable {
    public var rawValue: UInt8

    @inlinable
    public init(rawValue: UInt8)

    @inlinable
    public static var unexpectedContinuationByte: Self { get }

    @inlinable
    public static var overlongEncoding: Self { get }

    // TODO: ...
  }
}

```

...

```swift
extension UTF8Span {
  @frozen
  public struct EncodingError: Error, Sendable, Hashable, Codable {
    public var kind: Unicode.UTF8.EncodingErrorKind
    public var range: Range<Int>
  }

  public init(
    validating codeUnits: Span<UInt8>
  ) throws(EncodingError) -> dependsOn(codeUnits) Self

  public init<Owner: ~Copyable & ~Escapable>(
    nulTerminatedCString: UnsafeRawPointer,
    owner: borrowing Owner
  ) throws(DecodingError) -> dependsOn(owner) Self

  public init<Owner: ~Copyable & ~Escapable>(
    nulTerminatedCString: UnsafePointer<CChar>,
    owner: borrowing Owner
  ) throws(DecodingError) -> dependsOn(owner) Self
}
```

...

```swift
extension UTF8Span {
  /// Returns whether the validated contents were all-ASCII. This is checked at
  /// initialization time and remembered.
  @inlinable
  public var isASCII: Bool { get }
}
```
...

```swift
extension UTF8Span {
  public typealias CodeUnits = Span<UInt8>

  @inlinable
  public var codeUnits: CodeUnits { get }
}
```
...

```swift
extension UTF8Span {
  @frozen
  public struct UnicodeScalarView: ~Escapable {
    public let span: UTF8Span

    @inlinable
    public init(_ span: UTF8Span)
  }

  @inlinable
  public var unicodeScalars: UnicodeScalarView { _read }

  @frozen
  public struct CharacterView: ~Escapable {
    public let span: UTF8Span

    @inlinable
    public init(_ span: UTF8Span)
  }

  @inlinable
  public var characters: CharacterView { _read }

  @frozen
  public struct UTF16View: ~Escapable {
    public let span: UTF8Span

    @inlinable
    public init(_ span: UTF8Span)
  }

  @inlinable
  public var utf16: UTF16View { _read }
}
```
...

```swift
extension UTF8Span.UnicodeScalarView {
  @frozen
  public struct Index: Comparable, Hashable {
    public var position: RawSpan.Index

    @inlinable
    public init(_ position: RawSpan.Index)

    @inlinable
    public static func < (
      lhs: UTF8Span.UnicodeScalarView.Index,
      rhs: UTF8Span.UnicodeScalarView.Index
    ) -> Bool
  }

  public typealias Element = Unicode.Scalar

  @frozen
  public struct Iterator: ~Escapable {
    public typealias Element = Unicode.Scalar

    public let span: UTF8Span

    public var position: RawSpan.Index

    @inlinable
    init(_ span: UTF8Span)

    @inlinable
    public mutating func next() -> Unicode.Scalar?
  }

  @inlinable
  public borrowing func makeIterator() -> Iterator

  @inlinable
  public var startIndex: Index { get }

  @inlinable
  public var endIndex: Index { get }

  @inlinable
  public var count: Int { get }

  @inlinable
  public var isEmpty: Bool { get }

  @inlinable
  public var indices: Range<Index> { get }

  @inlinable
  public func index(after i: Index) -> Index

  @inlinable
  public func index(before i: Index) -> Index

  @inlinable
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index?

  @inlinable
  public func formIndex(after i: inout Index)

  @inlinable
  public func formIndex(before i: inout Index)

  @inlinable
  public func index(_ i: Index, offsetBy distance: Int) -> Index

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy distance: Int)

  @inlinable
  public func formIndex(
    _ i: inout Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Bool

  @inlinable
  public subscript(position: Index) -> Element { borrowing _read }

  @inlinable
  public subscript(unchecked position: Index) -> Element { 
    borrowing _read
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> Self { get }

  @inlinable
  public subscript(unchecked bounds: Range<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(bounds: some RangeExpression<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(
    unchecked bounds: some RangeExpression<Index>
  ) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(x: UnboundedRange) -> Self {
    borrowing get
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int

  @inlinable
  public func elementsEqual(_ other: Self) -> Bool

  @inlinable
  public func elementsEqual(_ other: some Sequence<Element>) -> Bool
}

extension UTF8Span.CharacterView {
  @frozen
  public struct Index: Comparable, Hashable {
    public var position: RawSpan.Index

    @inlinable
    public init(_ position: RawSpan.Index)

    @inlinable
    public static func < (
      lhs: UTF8Span.CharacterView.Index,
      rhs: UTF8Span.CharacterView.Index
    ) -> Bool
  }

  public typealias Element = Character

  @frozen
  public struct Iterator: ~Escapable {
    public typealias Element = Character

    public let span: UTF8Span

    public var position: RawSpan.Index

    @inlinable
    init(_ span: UTF8Span)

    @inlinable
    public mutating func next() -> Character?
  }

  @inlinable
  public borrowing func makeIterator() -> Iterator

  @inlinable
  public var startIndex: Index { get }

  @inlinable
  public var endIndex: Index { get }

  @inlinable
  public var count: Int { get }

  @inlinable
  public var isEmpty: Bool { get }

  @inlinable
  public var indices: Range<Index> { get }

  @inlinable
  public func index(after i: Index) -> Index

  @inlinable
  public func index(before i: Index) -> Index

  @inlinable
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index?

  @inlinable
  public func formIndex(after i: inout Index)

  @inlinable
  public func formIndex(before i: inout Index)

  @inlinable
  public func index(_ i: Index, offsetBy distance: Int) -> Index

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy distance: Int)

  @inlinable
  public func formIndex(
    _ i: inout Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Bool

  @inlinable
  public subscript(position: Index) -> Element { borrowing _read }

  @inlinable
  public subscript(unchecked position: Index) -> Element { 
    borrowing _read
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> Self { get }

  @inlinable
  public subscript(unchecked bounds: Range<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(bounds: some RangeExpression<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(
    unchecked bounds: some RangeExpression<Index>
  ) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(x: UnboundedRange) -> Self {
    borrowing get
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int

  @inlinable
  public func elementsEqual(_ other: Self) -> Bool

  @inlinable
  public func elementsEqual(_ other: some Sequence<Element>) -> Bool
}

extension UTF8Span.UTF16View {
  @frozen
  public struct Index: Comparable, Hashable {
    @usableFromInline
    internal var _rawValue: UInt64

    @inlinable
    public var position: RawSpan.Index { get }

    /// Whether this index is referring to the second code unit of a non-BMP
    /// Unicode Scalar value.
    @inlinable
    public var secondCodeUnit: Bool { get }

    @inlinable
    public init(_ position: RawSpan.Index, secondCodeUnit: Bool)

    @inlinable
    public static func < (
      lhs: UTF8Span.UTF16View.Index,
      rhs: UTF8Span.UTF16View.Index
    ) -> Bool
  }

  public typealias Element = UInt16

  @frozen
  public struct Iterator: ~Escapable {
    public typealias Element = UInt16

    public let span: UTF8Span

    public var index: UTF8Span.UTF16View.Index

    @inlinable
    init(_ span: UTF8Span)

    @inlinable
    public mutating func next() -> UInt16?
  }

  @inlinable
  public borrowing func makeIterator() -> Iterator

  @inlinable
  public var startIndex: Index { get }

  @inlinable
  public var endIndex: Index { get }

  @inlinable
  public var count: Int { get }

  @inlinable
  public var isEmpty: Bool { get }

  @inlinable
  public var indices: Range<Index> { get }

  @inlinable
  public func index(after i: Index) -> Index

  @inlinable
  public func index(before i: Index) -> Index

  @inlinable
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index?

  @inlinable
  public func formIndex(after i: inout Index)

  @inlinable
  public func formIndex(before i: inout Index)

  @inlinable
  public func index(_ i: Index, offsetBy distance: Int) -> Index

  @inlinable
  public func formIndex(_ i: inout Index, offsetBy distance: Int)

  @inlinable
  public func formIndex(
    _ i: inout Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Bool

  @inlinable
  public subscript(position: Index) -> Element { borrowing _read }

  @inlinable
  public subscript(unchecked position: Index) -> Element { 
    borrowing _read
  }

  @inlinable
  public subscript(bounds: Range<Index>) -> Self { get }

  @inlinable
  public subscript(unchecked bounds: Range<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(bounds: some RangeExpression<Index>) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(
    unchecked bounds: some RangeExpression<Index>
  ) -> Self {
    borrowing get
  }

  @_alwaysEmitIntoClient
  public subscript(x: UnboundedRange) -> Self {
    borrowing get
  }

  @inlinable
  public func distance(from start: Index, to end: Index) -> Int

  @inlinable
  public func elementsEqual(_ other: Self) -> Bool

  // NOTE: No Collection overload, since it's the same code as
  // the sequence one.

  @inlinable
  public func elementsEqual(_ other: some Sequence<Element>) -> Bool
}

```
...

```swift
extension UTF8Span {
  @inlinable
  public func isScalarAligned(
    _ i: RawSpan.Index
  ) -> Bool

  @inlinable
  public func isCharacterAligned(
    _ i: RawSpan.Index
  ) -> Bool
}
```

...

```swift
extension UTF8Span {
  /// Whether `self` is equivalent to `other` under Unicode Canonical Equivalance
  public func isCanonicallyEquivalent(
    to other: UTF8Span
  ) -> Bool

  /// Whether `self` orders less than `other` under Unicode Canonical Equivalance
  /// using normalized code-unit order
  public func isCanonicallyLessThan(
    _ other: UTF8Span
  ) -> Bool
}
```

...

```swift
extension String {
  public var utf8Span: UTF8Span {
    // TODO: how to do this well...
  }
}
```

...

```swift
extension RawSpan {
  public func parseUTF8(length: Int) throws -> UTF8Span

  public func parseNullTermiantedUTF8() throws -> UTF8Span
}

extension RawSpan.Cursor {
  public mutating func parseUTF8(length: Int) throws -> UTF8Span

  public mutating func parseNullTermiantedUTF8() throws -> UTF8Span
}
```

## Source compatibility

This proposal is additive and source-compatible with existing code.

## ABI compatibility

This proposal is additive and ABI-compatible with existing code.

## Implications on adoption

The additions described in this proposal require a new version of the standard library and runtime.

## Future directions


### More alignments

... word alignment, line alignment


### Normalization

... mutating normalize, `isNormal(quickCheck: Bool)`, ...

### Transcoded views, normalized views, case-folded views, etc

We could provide lazily transcoded, normalized, case-folded, etc., views. If we do any of these for `UTF8Span`, we should consider adding equivalents on `String`, `Substring`, etc.

For example, transcoded views can be generalized:

```swift
extension UTF8Span {
  /// A view off the span's contents as a bidirectional collection of 
  /// transcoded `Encoding.CodeUnit`s.
  @frozen
  public struct TranscodedView<Encoding: _UnicodeEncoding> {
    public var span: UTF8Span

    @inlinable
    public init(_ span: UTF8Span)

    ...
  }
}
```

Note that since UTF-16 has such historical significance that even with a fully-generic transcoded view, we'd likely want a dedicated, specialized type for UTF-16.

We could similarly provide lazily-normalized views of code units or scalars under NFC or NFD (which the stdlib already distributes data tables for), possibly generic via a protocol for 3rd party normal forms.

Finally, case-folded functionality can be accessed in today's Swift via [scalar properties](https://developer.apple.com/documentation/swift/unicode/scalar/properties-swift.struct), but we could provide convenience collections ourselves as well.


### Regex or regex-like support

Future API additions would be to support `Regex`es on such spans. 

Another future direction could be to add many routines corresponding to the underlying operations performed by the regex engine, such as:

```swift
extension UTF8Span.CharacterView {
  func matchCharacterClass(
    _: CharacterClass,
    startingAt: Index,
    limitedBy: Index    
  ) throws -> Index?

  func matchQuantifiedCharacterClass(
    _: CharacterClass,
    _: QuantificationDescription,
    startingAt: Index,
    limitedBy: Index    
  ) throws -> Index?
}
```

which would be useful for parser-combinator libraries who wish to expose `String`'s model of Unicode by using the stdlib's accelerated implementation.


### Index rounding operations

Unlike String, `UTF8Span`'s view's `Index` types are distinct, which avoids a [mess of problems](https://forums.swift.org/t/string-index-unification-vs-bidirectionalcollection-requirements/55946). Interesting additions to both `UTF8Span` and `String` would be explicit index-rounding for a desired behavior.

### Canonical Spaceships

Should a `ComparisonResult` (or [spaceship](https://forums.swift.org/t/pitch-comparison-reform/5662)) be added to Swift, we could support that operation under canonical equivalence in a single pass rather than subsequent calls to `isCanonicallyEquivalent(to:)` and `isCanonicallyLessThan(_:)`.

### Other Unicode functionality

For the purposes of this pitch, we're not looking to expand the scope of functionality beyond what the stdlib already does in support of `String`'s API. Other functionality can be considered future work.


## Alternatives considered

...

## Acknowledgments

Karoy Lorentey, Karl, Geordie_J, and fclout, contributed to this proposal with their clarifying questions and discussions.

