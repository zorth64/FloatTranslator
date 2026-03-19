//
//  Dependencies.swift
//  Float Translator
//
//  Created by zorth64 on 06/03/26.
//

import SwiftUI
import Swinject

class Dependencies {
    static func setup() {
        let container = Container()
        container.registerSingleton(AppState.self) { _ in AppState() }
        Container.main = container.synchronize()
    }
}

extension Container {
    @discardableResult
    func registerSingleton<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
    ) -> ServiceEntry<Service> {
        _register(serviceType, factory: factory, name: name)
            .inObjectScope(.container)
    }
}

extension Container {
    static var main: Resolver!
}

@propertyWrapper
class Inject<Value> {
    private var storage: Value?
    
    init() {}
    
    var wrappedValue: Value {
        storage ?? {
            guard let resolver = Container.main else {
                fatalError("Missing call to `Dependencies.setup()`")
            }
            guard let value = resolver.resolve(Value.self) else {
                fatalError("Dependency `\(Value.self)` not found, register it in `Dependencies.setup()`.")
            }
            storage = value
            return value
        }()
    }
}

