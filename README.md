# Injection

A micro dependency injection framework.
This is heavily based on the packacke [Injected](https://github.com/avdyushin/Injected.git) from Grigory Avdyushin. It's the simplest yet elegant solution I found for dependency injection in swift. It suits my needs :-D

## How to use
You can create and use a dependency container like this:

```swift
let myContainer = Injection()
myContainer.register {
   Dependency { AService() }
   Dependency { BService() }
}

let service: AService = Injection.resolve()
```

Where it get's even cooler is when you use the `@Injected` property wrapper. For this to work your dependency must be registered with the shared container `Injection.shared`:

```swift
Injection.shared.register {
   Dependency { AService }
}

struct MyApp {
   @Injected var service: AService
   
   func main() {
      service.start()
   }
}
```

You can even have a little fun with it:

```swift

Injection.shared.register {
   Dependency { "The Answer to the Ultimate Question of Life, The Universe, and Everything." }
   Dependency { 42 }
}

@Injected var question: String
@Injected var answer: Int
```

You can only have one dependency per type, though. It's 54 lines of code – what do you expect ;) Swift rocks!

