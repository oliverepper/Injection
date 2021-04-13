import XCTest
@testable import Injection

final class InjectionTests: XCTestCase {

    struct MyService {
        func start() -> Bool { true }
        func stop() -> Bool { false }
    }

    @Injected var myService: MyService
    @Injected var myClosure: Bool
    @Injected var myString: String

    func testRegisterMyService() {
        Injection.container.register {
            Dependency { MyService() }
        }

        XCTAssert(myService.start() == true)
    }

    func testRegisterClosure() {
        Injection.container.register {
            Dependency { false }
        }

        XCTAssert(myClosure == false)
    }

    func testRegisterMyServiceAndMyString() {
        Injection.container.register {
            Dependency { MyService() }
            Dependency { "Swift rocks!" }
        }

        XCTAssert(myService.stop() == false)
        XCTAssert(myString == "Swift rocks!")
    }

    func testRegisterMultipleDependencies() {
        Injection.container.register {
            Dependency { MyService() }
            Dependency { MyService() }
            Dependency { MyService() }
        }
    }

    func testWithoutInjectionReference() {
        var deps = Dependencies()
        deps.register {
            Dependency { MyService() }
        }

        let service: MyService = deps.resolve()

        XCTAssert(service.start() == true)
    }
}
