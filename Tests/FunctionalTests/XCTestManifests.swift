#if !os(macOS)
import XCTest

extension FunctionalTests {
    // DO NOT MODIFY: This is autogenerated, use: 
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionalTests = [
        ("testAll", testAll),
        ("testDelete", testDelete),
        ("testFormEncoded", testFormEncoded),
        ("testGet", testGet),
        ("testHead", testHead),
        ("testJson", testJson),
        ("testOptions", testOptions),
        ("testPost", testPost),
        ("testPut", testPut),
        ("testRequest", testRequest),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FunctionalTests.__allTests__FunctionalTests),
    ]
}
#endif
