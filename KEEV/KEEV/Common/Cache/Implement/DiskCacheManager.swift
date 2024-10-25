//
//  DiskCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

final class DiskCacheManager: CacheManagerProtocol {
    private let fileManager: FileManager
    private var cachedPath: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func storeInCache(_ value: Data, for key: String) async throws {
        guard let path = cachedPath?.appending(path: key) else {
            throw CacheError.notFound
        }
        
        do {
            try value.write(to: path)
        } catch {
            throw CacheError.notFound
        }
    }
    
    func loadFromCache(for key: String) async throws -> Data {
        guard let path = cachedPath?.appending(path: key) else {
            throw CacheError.notFound
        }
        
        do {
            return try Data(contentsOf: path)
        } catch {
            throw CacheError.notFound
        }
    }
    
    func removeFromCache(for key: String) async throws {
        guard let path = cachedPath?.appending(path: key) else {
            throw CacheError.notFound
        }
        
        do {
            try fileManager.removeItem(at: path)
        } catch {
            throw CacheError.notFound
        }
    }
}
