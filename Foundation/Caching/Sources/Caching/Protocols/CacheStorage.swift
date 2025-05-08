//
//  CacheStorage.swift
//  Caching
//
//  Created by junsungkim on 5/8/25.
//

public protocol CacheStorage {
    associatedtype Key: Hashable
    associatedtype Value
    
    func set(_ value: Value, forKey key: Key)
    func get(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func removeAll()
}
