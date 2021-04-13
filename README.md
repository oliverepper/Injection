# Injection

A micro dependency injection framework.
This is heavily based on the packacke [Injected](https://github.com/avdyushin/Injected.git) from Grigory Avdyushin. It's the simplest yet elagant solution I found for dependency injection in swift. I suits my needs :-D

## How to use
You can create and use a dependency container like this:

```swift
let myContainer = Dependencies()
myContainer.register {
   Dependency { AService() }
   Dependency { BService() }
}

let service: AService = myContainer.resolve()
```

Where it get's even cooler is when you use the `@Injected` property wrapper. For this to work your dependency must be registered with the shared container `Injection.container`:

```swift
Injection.container.register {
   Dependency { AService }
}

struct MyApp {
   @Injected var service: AService
   
   func main() {
      service.start()
   }
}
```
