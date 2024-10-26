//
//  MemoryCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

/// 딕셔너리를 통해서 데이터를 캐싱하는 객체
///
/// - Author: newJunsung
final class MemoryCacheManager: CacheManagerProtocol {
    // MARK: Private attributes
    
    private var cache: [String: Data] = [:]
    
    // MARK: Functions
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
