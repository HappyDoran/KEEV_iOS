//
//  ExpiringCache.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Foundation

fileprivate typealias EO = ExpirableObject /* ExpirableObject의 약자 */

public final class ExpiringCache<Key, Value> where Key: Hashable & AnyObject {
    private let cache: NSCache<Key, EO<Value>>
    private let expirationInterval: TimeInterval
    
    public init(configuartion: ExpiringCache.Configuration) {
        let cache = NSCache<Key, EO<Value>>()
        cache.countLimit = configuartion.countLimit
        cache.totalCostLimit = configuartion.memoryLimit
        
        self.cache = cache
        self.expirationInterval = configuartion.expirationInterval
    }
    
    deinit {
        cache.removeAllObjects()
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
        let expirableValue = EO(value: value, expiration: Date(timeIntervalSinceNow: expirationInterval))
        cache.setObject(expirableValue, forKey: key)
    }
    
    public func get(forKey key: Key) -> Value? {
        let expirableValue = cache.object(forKey: key)
        guard let expirableValue = expirableValue, !expirableValue.isExpired else {
            remove(forKey: key)
            return nil
        }
        return expirableValue.value
    }
    
    public func remove(forKey key: Key) {
        cache.removeObject(forKey: key)
    }
    
    public func removeAll() {
        cache.removeAllObjects()
    }
}
