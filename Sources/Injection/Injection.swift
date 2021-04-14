public struct Dependency {
    var objectIdentifier: ObjectIdentifier
    var wrappedValue: Any

    public init<T>(_ block: @escaping () -> T) {
        objectIdentifier = ObjectIdentifier(T.self)
        wrappedValue = block()
    }
}

public class Injection {
    public static let shared = Injection()

    private var dependencies: [Dependency] = .init()

    @_functionBuilder
    public struct DependencyBuilder {
        public static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
        public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    public func register(@DependencyBuilder _ builder: () -> Dependency) {
        _register(builder())
    }

    public func register(@DependencyBuilder _ builder: () -> [Dependency]) {
        builder().forEach { _register($0) }
    }

    public func resolve<T>() -> T {
        guard let dependency = dependencies.first(where: { $0.wrappedValue is T })?.wrappedValue as? T else {
            fatalError(#"Dependency "\#(T.self)" cannot be resolved."#)
        }
        return dependency
    }

    private func _register(_ dependency: Dependency) {
        guard dependencies.filter({ $0.objectIdentifier == dependency.objectIdentifier }).count == 0 else {
            return
        }
        dependencies.append(dependency)
    }
}

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T {
        Injection.shared.resolve()
    }

    public init() {}
}
