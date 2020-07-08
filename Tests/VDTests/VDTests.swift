import XCTest
@testable import VDKit

final class VDTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VD().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
