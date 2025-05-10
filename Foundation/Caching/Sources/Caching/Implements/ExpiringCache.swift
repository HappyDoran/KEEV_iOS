//
//  ExpiringCache.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Foundation

fileprivate typealias KW = CacheKeyWrapper /* CacheKeyWrapper의 약자 */
fileprivate typealias EO = ExpirableObject /* ExpirableObject의 약자 */

/// 일정 시간이 지나면 자동으로 만료되는 캐시를 구현한 클래스입니다.
///
/// 내부적으로 `NSCache`를 사용하여 메모리 기반 캐시를 구현하며,
/// 각 항목은 `ExpirableObject`로 래핑되어 개별 만료 시간을 가질 수 있습니다.
/// 주기적으로 만료된 항목을 제거하는 백그라운드 태스크도 포함되어 있습니다.
///
/// - Note: `Key`는 `Hashable`을 준수해야 하며, 스레드 안전성을 위해 내부적으로 `NSLock`을 사용합니다.
public final class ExpiringCache<Key, Value>: @unchecked Sendable where Key: Hashable {
    /// 내부적으로 사용하는 NSCache 객체입니다.
    /// 키는 `CacheKeyWrapper`로 래핑되며, 값은 `ExpirableObject`로 래핑되어 저장됩니다.
    private let cache: NSCache<KW, EO<Value>>
    /// 다중 스레드 환경에서 캐시에 접근할 때 충돌을 방지하기 위한 락입니다.
    private let lock: NSLock
    /// 캐시에 저장되는 객체의 기본 만료 시간(초)입니다.
    /// `nil`이면 만료되지 않습니다.
    private let expirationInterval: TimeInterval?
    
    /// 현재 캐시에 저장된 키들의 집합입니다.
    /// 만료 체크 및 삭제를 위해 별도로 관리됩니다.
    private var keys: Set<KW>
    /// 주기적으로 만료된 항목을 제거하는 비동기 백그라운드 태스크입니다.
    private var cleanupTask: Task<Void, Never>?
    
    /// 캐시 구성 정보를 기반으로 ExpiringCache를 초기화합니다.
    ///
    /// - Parameter configuration: 메모리 제한, 만료 시간, 클린업 주기 등이 포함된 설정 값
    public init(configuration: ExpiringCache.Configuration) {
        let cache = NSCache<KW, EO<Value>>()
        cache.countLimit = configuration.countLimit
        cache.totalCostLimit = configuration.memoryLimit
        
        self.cache = cache
        self.lock = NSLock()
        self.expirationInterval = configuration.expirationInterval
        self.keys = []
        self.cleanupTask = nil
        
        if let cleanUpInterval = configuration.cleanUpInterval {
            let nanoTimeInterval = UInt64(cleanUpInterval * 1_000_000_000)
            self.cleanupTask = Task(priority: .background) { [weak self] in
                guard let self = self else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: nanoTimeInterval)
                    self.checkExpiration()
                }
            }
        }
    }
    
    /// 인스턴스가 해제될 때 실행됩니다.
    /// 백그라운드 태스크를 취소하고 캐시를 정리합니다.
    deinit {
        cleanupTask?.cancel()
        cleanupTask = nil
        cache.removeAllObjects()
    }
    
    /// 주어진 키에 해당하는 항목을 캐시에서 제거합니다.
    ///
    /// - Parameter key: 삭제할 항목의 키
    private func removeValue(forKey key: KW) {
        lock.lock()
        defer { lock.unlock() }
        
        cache.removeObject(forKey: key)
        keys.remove(key)
    }
    
    /// 현재 캐시에 저장된 항목들 중 만료된 항목을 찾아 제거합니다.
    /// 클린업 주기마다 백그라운드 태스크에 의해 호출됩니다.
    private func checkExpiration() {
        lock.lock()
        let atomicKeys = keys
        lock.unlock()
        
        for key in atomicKeys {
            guard let expirableValue = cache.object(forKey: key) else {
                lock.lock()
                keys.remove(key)
                lock.unlock()
                continue
            }
            if expirableValue.isExpired {
                removeValue(forKey: key)
            }
        }
    }
}

public extension ExpiringCache {
    /// `ExpiringCache`의 동작을 설정하기 위한 구성 구조체입니다.
    ///
    /// 캐시의 용량 제한, 만료 시간, 정리 주기 등을 지정하여
    /// 캐시 동작을 세밀하게 제어할 수 있습니다.
    /// 이 구성값은 `ExpiringCache` 생성 시 필수로 전달해야 합니다.
    struct Configuration {
        /// 캐시의 메모리 용량 제한 (바이트 단위)
        /// `NSCache.totalCostLimit`에 대응됩니다.
        let memoryLimit: Int
        /// 캐시에 저장할 수 있는 최대 객체 수
        /// `NSCache.countLimit`에 대응됩니다.
        let countLimit: Int
        /// 각 항목의 기본 만료 시간 (초 단위)
        /// `nil`일 경우, 저장된 항목은 만료되지 않습니다.
        let expirationInterval: TimeInterval?
        /// 만료된 항목을 정기적으로 정리할 주기 (초 단위)
        /// `nil`일 경우 정기 정리 작업은 수행되지 않습니다.
        let cleanUpInterval: TimeInterval?
    }
}

extension ExpiringCache: CacheStorage {
    public typealias Key = Key
    public typealias Value = Value
    
    /// 값을 캐시에 저장합니다. 저장 시 만료 시간도 함께 설정됩니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 해당 값을 식별할 키
    public func set(_ value: Value, forKey key: Key) {
        let wrapper = KW(key: key)
        let expirableValue: EO<Value>
        if let expirationInterval = expirationInterval {
            expirableValue = EO(value: value, expiration: Date(timeIntervalSinceNow: expirationInterval))
        } else {
            expirableValue = EO(value: value, expiration: nil)
        }
        
        
        lock.lock()
        defer { lock.unlock() }
        
        cache.setObject(expirableValue, forKey: wrapper)
        keys.insert(wrapper)
    }
    
    /// 캐시에서 값을 조회합니다.
    /// 만료된 값이거나 존재하지 않으면 `nil`을 반환하고 캐시에서 제거됩니다.
    ///
    /// - Parameter key: 조회할 키
    /// - Returns: 유효한 값이 존재하면 반환, 아니면 `nil`
    public func get(forKey key: Key) -> Value? {
        let wrapper = KW(key: key)
        let expirableValue = cache.object(forKey: wrapper)
        guard let expirableValue = expirableValue, !expirableValue.isExpired else {
            removeValue(forKey: wrapper)
            return nil
        }
        return expirableValue.value
    }
    
    /// 주어진 키에 해당하는 항목을 캐시에서 제거합니다.
    ///
    /// - Parameter key: 삭제할 항목의 키
    public func remove(forKey key: Key) {
        let wrapper = KW(key: key)
        removeValue(forKey: wrapper)
    }
    
    /// 캐시의 모든 항목을 제거합니다.
    /// 내부 캐시 객체와 키 추적용 집합을 모두 초기화합니다.
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        
        cache.removeAllObjects()
        keys.removeAll()
    }
}
