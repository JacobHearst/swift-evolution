import XCTest
@testable import RawBuffer

final class RawBufferTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RawBuffer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
