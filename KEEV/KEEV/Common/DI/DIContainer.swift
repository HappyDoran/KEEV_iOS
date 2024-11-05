//
//  DIContainer.swift
//  KEEV
//
//  Created by 김준성 on 11/5/24.
//

/// 의존성을 관리하는 객체.
///
/// 타입, 프로토콜에 대한 인스턴스를 저장하고 불러옵니다.
///
/// - Note: 해당 인스턴스들을 타입을 키 값으로 하여 딕셔너리로 관리하고 있습니다. 혹시나 의존성을 등록하는 과정에서 특정 프로퍼티에 DIContainer의 요소를 쓰고 있나 확인해주세요. `register`를 하는 순서에 따라 앱이 크러시가 날 수도 안 날 수도 있습니다.
/// - Author: newJunsung
final class DIContainer {
    private var container: [String: Any] = [:]
    
    /// 특정 타입 또는 프로토콜에 해당하는 인스턴스를 container에 등록합니다.
    ///
    /// - Parameters:
    ///   - instance: 뒤에 있는 파라미터 `type`에 해당하는 인스턴스
    ///   - type: 특정 프로토콜이나 타입의 메타타입
    ///
    /// - **특정 타입**에 대한 등록법은 다음과 같습니다:
    /// ```swift
    /// let container = DIContainer()
    /// let service = FooService()
    /// container.register(service, for: FooService.self)
    /// ```
    ///
    /// - **특정 프로토콜**에 대한 등록법은 다음과 같습니다:
    /// ```swift
    /// let container = DIContainer()
    /// let service: FooProtocol = FooService()
    /// container.register(service, (any FooProtocol).self)
    /// ```
    ///
    /// - Author: newJunsung
    func register<T>(_ instance: T, for type: T.Type) {
        container["\(type)"] = instance
    }
    
    /// 컨테이너에 저장된 특정 타입 또는 프로토콜에 해당한 인스턴스를 가져옵니다.
    ///
    /// - Parameters:
    ///   - type: container에 저장된 타입의 메타타입.
    ///
    /// - **특정 타입**에 대한 등록법은 다음과 같습니다:
    /// ```swift
    /// let container = DIContainer()
    /// let service = FooService()
    /// container.register(service, for: FooService.self)
    /// let resolvedService = container.resolve(for FooService.self)
    /// ```
    ///
    /// - **특정 프로토콜**에 대한 등록법은 다음과 같습니다:
    /// ```swift
    /// let container = DIContainer()
    /// let serviceToRegist: FooProtocol = FooService()
    /// container.register(serviceToRegist, for: (any FooProtocol).self)
    /// let resolvedService: any FooProtocol = container.resolve(for: (any FooProtocol).self)
    /// ```
    ///
    /// - Warning: container에 타입이 없거나, 타입 캐스팅이 실패하게 된다면 `fatalError`가 발생합니다.
    /// - Returns: 특정 타입 또는 프로토콜로 캐스팅된 타입
    /// - Author: newJunsung
    func resolve<T>(for type: T.Type) -> T {
        guard let instance = container["\(type)"] as? T else {
            fatalError("\(type)에 해당하는 인스턴스가 없습니다.")
        }
        return instance
    }
}
