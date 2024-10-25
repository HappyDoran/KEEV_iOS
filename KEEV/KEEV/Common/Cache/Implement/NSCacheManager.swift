//
//  NSCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

actor NSCacheManager: CacheManagerProtocol {
    private let cache: NSCache<NSString, NSData>
    
    init(cache: NSCache<NSString, NSData>) {
        self.cache = cache
    }
    
    func storeInCache(_ value: Data, for key: String) async throws {
        cache.setObject(NSData(data: value), forKey: NSString(string: key))
    }
    
    func loadFromCache(for key: String) async throws -> Data {
        guard let nsData = cache.object(forKey: NSString(string: key)) else {
            throw CacheError.notFound
        }
        
        return Data(referencing: nsData)
    }
    
    func removeFromCache(for key: String) async throws {
        cache.removeObject(forKey: NSString(string: key))
    }
}

enum CacheError: Error {
    case notFound
}
