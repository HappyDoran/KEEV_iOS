//
//  DIContainer.swift
//  KEEV
//
//  Created by 김준성 on 11/5/24.
//

final class DIContainer {
    private var container: [String: Any] = [:]
    
    func register<T>(_ instance: T) {
        container["\(T.self)"] = instance
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let instance = container["\(type)"] as? T else {
            fatalError("\(type)에 해당하는 인스턴스가 없습니다.")
        }
        return instance
    }
}

