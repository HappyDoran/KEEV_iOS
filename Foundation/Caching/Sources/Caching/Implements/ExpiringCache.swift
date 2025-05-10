//
//  ExpiringCache.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

import Foundation

fileprivate typealias KW = CacheKeyWrapper /* CacheKeyWrapper의 약자 */
fileprivate typealias EO = ExpirableObject /* ExpirableObject의 약자 */

public final class ExpiringCache<Key, Value>: @unchecked Sendable where Key: Hashable {
    private let cache: NSCache<KW, EO<Value>>
    private let lock: NSLock
    private let expirationInterval: TimeInterval?
    
    private var keys: Set<KW>
    private var cleanupTask: Task<Void, Never>?
    
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
    
    deinit {
        cleanupTask?.cancel()
        cleanupTask = nil
        cache.removeAllObjects()
    }
    
    private func removeValue(forKey key: KW) {
        lock.lock()
        defer { lock.unlock() }
        
        cache.removeObject(forKey: key)
        keys.remove(key)
    }
    
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
    struct Configuration {
        let memoryLimit: Int
        let countLimit: Int
        let expirationInterval: TimeInterval?
        let cleanUpInterval: TimeInterval?
    }
}

extension ExpiringCache: CacheStorage {
    public typealias Key = Key
    public typealias Value = Value
    
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
        lock.lock()
        defer { lock.unlock() }
        
        cache.removeAllObjects()
        keys.removeAll()
    }
}
