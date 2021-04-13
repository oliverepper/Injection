import XCTest

import InjectionTests

var tests = [XCTestCaseEntry]()
tests += InjectionTests.allTests()
XCTMain(tests)
