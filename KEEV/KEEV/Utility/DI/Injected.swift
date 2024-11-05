//
//  Injected.swift
//  KEEV
//
//  Created by 김준성 on 11/5/24.
//

/// 쉽게 앱 내의 전역 인스턴스에 접근하기 위한 프로퍼티 래퍼
///
/// `AppEnviroment` 내의 `diContainer`에 접근할 수 있습니다.
/// 사용법은 아래와 같습니다.
/// ```swift
/// import SwiftUI
/// struct DummyScreen: View {
///     @Injected private var eventService: any EventServiceProtocol
///
///     var body: some View {
///         Text("Hello, World!")
///             .onAppear {
///                 print(userService)
///             }
///     }
/// }
/// ```
///
/// - Note: 특정 타입 또는 프로토콜을 `@Injected`를 통해 호출했는데, fatalError가 일어날 수도 있습니다. 그럴 때는 당황하지 말고, `AppEnviroment`의 `setupDependency()`에서 인스턴스를 등록해주세요!
/// - Author: newJunsung
@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    
    init() {
        wrappedValue = AppEnvironment.diContainer.resolve(for: T.self)
    }
}
