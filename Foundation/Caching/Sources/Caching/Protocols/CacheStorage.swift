//
//  CacheStorage.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

/// 범용 캐시 저장소를 정의하는 프로토콜입니다.
///
/// `CacheStorage`는 키-값 기반의 데이터를 저장, 조회, 삭제하는 기본적인 기능을 제공합니다.
/// 메모리 캐시, 디스크 캐시, 만료 시간 기반 캐시 등 다양한 방식으로 구현할 수 있습니다.
///
/// - 참고: `Key`는 반드시 `Hashable`을 준수해야 하며, 내부적으로 딕셔너리처럼 활용될 수 있습니다.
public protocol CacheStorage {
    /// 캐시에 사용할 키 타입입니다. `Hashable`을 준수해야 합니다.
    associatedtype Key: Hashable

    /// 캐시에 저장할 값의 타입입니다.
    associatedtype Value

    /// 주어진 키에 해당하는 값을 캐시에 저장합니다.
    ///
    /// - parameters:
    ///   - value: 저장할 값
    ///   - key: 해당 값을 식별할 키
    func set(_ value: Value, forKey key: Key)

    /// 주어진 키에 해당하는 값을 캐시에서 조회합니다.
    ///
    /// - parameter key: 조회할 값의 키
    /// - returns: 해당 키에 저장된 값이 있다면 반환하고, 없다면 `nil`을 반환합니다.
    func get(forKey key: Key) -> Value?

    /// 주어진 키에 해당하는 값을 캐시에서 삭제합니다.
    ///
    /// - parameter key: 삭제할 값의 키
    func remove(forKey key: Key)

    /// 캐시에 저장된 모든 값을 삭제합니다.
    func removeAll()
}
