//
//  MemoryCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

actor MemoryCacheManager: CacheManagerProtocol {
    private var cache: [String: Data] = [:]
    
    func storeInCache(_ value: Data, for key: String) async throws {
        cache[key] = value
    }
    
    func loadFromCache(for key: String) async throws -> Data {
        guard let data = cache[key] else {
            throw CacheError.notFound
        }
        return data
    }
    
    func removeFromCache(for key: String) async throws {
        cache.removeValue(forKey: key)
    }
}
