//
//  ExpiringCache.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Combine
import Foundation

fileprivate typealias KW = CacheKeyWrapper /* CacheKeyWrapper의 약자 */
fileprivate typealias EO = ExpirableObject /* ExpirableObject의 약자 */

public final class ExpiringCache<Key, Value> where Key: Hashable {
    private let cache: NSCache<KW, EO<Value>>
    private let expirationInterval: TimeInterval
    
    private var keys: Set<KW>
    private var cancellables: Set<AnyCancellable>
    
    public init(configuartion: ExpiringCache.Configuration) {
        let cache = NSCache<KW, EO<Value>>()
        cache.countLimit = configuartion.countLimit
        cache.totalCostLimit = configuartion.memoryLimit
        
        self.cache = cache
        self.expirationInterval = configuartion.expirationInterval
        self.keys = []
        self.cancellables = []
        
        Timer.publish(every: configuartion.expirationInterval, on: .current, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkExpiration()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cache.removeAllObjects()
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
    private func removeValue(forKey key: KW) {
        cache.removeObject(forKey: key)
        keys.remove(key)
    }
    
    private func checkExpiration() {
        for key in keys {
            guard let expirableValue = cache.object(forKey: key) else { continue }
            if expirableValue.isExpired {
                removeValue(forKey: key)
            }
        }
    }
}

public extension ExpiringCache {
    struct Configuration {
        let memoryLimit: Int
        let countLimit: Int
        let expirationInterval: TimeInterval
    }
}

extension ExpiringCache: CacheStorage {
    public typealias Key = Key
    public typealias Value = Value
    
    public func set(_ value: Value, forKey key: Key) {
        let wrapper = KW(key: key)
        let expirableValue = EO(value: value, expiration: Date(timeIntervalSinceNow: expirationInterval))
        cache.setObject(expirableValue, forKey: wrapper)
        keys.insert(wrapper)
    }
    
    public func get(forKey key: Key) -> Value? {
        let wrapper = KW(key: key)
        let expirableValue = cache.object(forKey: wrapper)
        guard let expirableValue = expirableValue, !expirableValue.isExpired else {
            removeValue(forKey: wrapper)
            return nil
        }
        return expirableValue.value
    }
    
    public func remove(forKey key: Key) {
        let wrapper = KW(key: key)
        removeValue(forKey: wrapper)
    }
    
    public func removeAll() {
        cache.removeAllObjects()
        keys.removeAll()
    }
}
