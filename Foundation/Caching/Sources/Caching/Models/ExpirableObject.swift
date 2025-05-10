//
//  Expirable.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Foundation

/// 만료 시간을 가질 수 있는 객체를 래핑하는 제네릭 클래스입니다.
///
/// `ExpirableObject`는 내부에 값(`value`)과 선택적인 만료 시간(`expiration`)을 가지고 있으며,
/// 만료 여부를 확인할 수 있는 `isExpired` 속성을 제공합니다.
/// 캐시와 같이 일정 시간 이후 데이터를 무효화할 필요가 있는 경우에 유용하게 사용할 수 있습니다.
internal final class ExpirableObject<T> {
    /// 실제로 저장할 값입니다.
    let value: T
    /// 해당 값의 만료 시각입니다. 없을 경우 만료되지 않습니다.
    let expiration: Date?
    
    /// 현재 시간이 만료 시각을 지났는지 여부를 반환합니다.
    /// 만료 시각이 없는 경우에는 `false`를 반환합니다.
    var isExpired: Bool {
        guard let expiration = expiration else { return false }
        return .now > expiration
    }
    
    /// 주어진 값과 만료 시각을 사용하여 `ExpirableObject`를 초기화합니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - expiration: 선택적인 만료 시각
    init(value: T, expiration: Date?) {
        self.value = value
        self.expiration = expiration
    }
}
