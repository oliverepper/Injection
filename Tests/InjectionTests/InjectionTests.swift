import XCTest
@testable import Injection

final class InjectionTests: XCTestCase {

    struct MyService {
        func start() -> Bool { true }
        func stop() -> Bool { false }
    }

    struct OtherService {
        @Injected var myService: MyService

        func start() -> Bool {
            return myService.start()
        }
    }

    @Injected var myService: MyService
    @Injected var myClosure: Bool
    @Injected var myString: String

    func testRegisterMyService() {
        Injection.shared.register {
            Dependency { MyService() }
        }

        XCTAssert(myService.start() == true)
    }

    func testRegisterClosure() {
        Injection.shared.register {
            Dependency { false }
        }

        XCTAssert(myClosure == false)
    }

    func testRegisterMyServiceAndMyString() {
        Injection.shared.register {
            Dependency { MyService() }
            Dependency { "Swift rocks!" }
        }

        XCTAssert(myService.stop() == false)
        XCTAssert(myString == "Swift rocks!")
    }

    func testRegisterMultipleDependencies() {
        Injection.shared.register {
            Dependency { MyService() }
            Dependency { MyService() }
            Dependency { MyService() }
        }
    }

    func testWithoutInjectionReference() {
        let deps = Injection()
        deps.register {
            Dependency { MyService() }
        }

        let service: MyService = deps.resolve()

        XCTAssert(service.start() == true)
    }

    func testOtherDependsOnMyService() {
        Injection.shared.register {
            Dependency { MyService() }
            Dependency { OtherService() }
        }

        let otherService: OtherService = Injection.shared.resolve()
        XCTAssert(otherService.start() == true)
    }
}
