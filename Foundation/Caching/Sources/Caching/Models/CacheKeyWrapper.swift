//
//  File.swift
//  Caching
//
//  Created by junsungkim on 5/9/25.
//

import Foundation

/// `NSCache`에서 사용할 수 있도록 `Hashable` 키를 래핑하는 클래스입니다.
///
/// `NSObject`를 상속하고 `hash` 및 `isEqual(_:)` 메서드를 오버라이드하여,
/// `AnyHashable` 타입의 키도 Objective-C 기반의 `NSCache`에서 문제없이 사용할 수 있도록 합니다.
/// 주로 제네릭 키를 `NSCache`에 활용할 때 필요합니다.
internal final class CacheKeyWrapper: NSObject {
    /// 캐시에 사용할 원래의 키입니다. `Hashable`을 준수해야 하며 `AnyHashable`로 래핑되어 저장됩니다.
    let key: AnyHashable
    
    /// 주어진 `Hashable` 키를 래핑하여 초기화합니다.
    ///
    /// - Parameter key: 캐시 키로 사용할 값입니다.
    init(key: some Hashable) {
        self.key = key
    }
    
    /// `NSCache`에서 사용하기 위한 해시 값입니다. 내부 `key`의 `hashValue`를 반환합니다.
    override var hash: Int { key.hashValue }
    
    /// 두 객체가 동일한 키를 가지는지 비교합니다.
    ///
    /// - Parameter object: 비교 대상 객체
    /// - Returns: 내부 키가 동일하면 `true`, 그렇지 않으면 `false`를 반환합니다.
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CacheKeyWrapper else {
            return false
        }
        return key == other.key
    }
}
