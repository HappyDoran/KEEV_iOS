//
//  Injected.swift
//  KEEV
//
//  Created by 김준성 on 11/5/24.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    
    init() {
        wrappedValue = AppEnvironment.diContainer.resolve(for: T.self)
    }
}
