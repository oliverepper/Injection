public struct Dependency {
    var id: ObjectIdentifier
    var wrappedValue: Any

    public init<T>(_ block: @escaping () -> T) {
        id = ObjectIdentifier(T.self)
        wrappedValue = block()
    }
}

public struct Dependencies {
    private var dependencies: [Dependency] = .init()

    @_functionBuilder
    public struct DependencyBuilder {
        public static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
        public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    public mutating func register(@DependencyBuilder _ builder: () -> Dependency) {
        _register(builder())
    }

    public mutating func register(@DependencyBuilder _ builder: () -> [Dependency]) {
        builder().forEach { _register($0) }
    }

    public func resolve<T>() -> T {
        guard let dependency = dependencies.first(where: { $0.wrappedValue is T } )?.wrappedValue as? T else {
            fatalError(#"Dependency "\#(T.self)" cannot be resolved."#)
        }
        return dependency
    }

    private mutating func _register(_ dependency: Dependency) {
        guard dependencies.filter({ $0.id == dependency.id }).count == 0 else {
            return
        }
        dependencies.append(dependency)
    }
}

public final class Injection {
    public static var container = Dependencies()
}

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T {
        Injection.container.resolve()
    }

    public init() {}
}
