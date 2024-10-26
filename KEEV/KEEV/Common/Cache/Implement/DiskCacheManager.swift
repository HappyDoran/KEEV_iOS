//
//  DiskCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

/// 디스크에 데이터를 캐싱하기 위한 객체
///
/// `FileManager`를 사용하여 데이터를 캐싱합니다.
/// 이 때 데이터는 `cachesDirectory`에 저장이 됩니다.
///
/// - Warning: `cachesDirectory`에 데이터를 저장하고 있기 때문에, 기한이 만료되거나 저장 공간이 부족할 경우, 저장한 데이터들이 임의로 삭제될 수 있습니다.
///
/// - SeeAlso: `CacheManagerProtocol`
///
/// - Author: newJunsung
final class DiskCacheManager: CacheManagerProtocol {
    // MARK: Private attributes
    private let fileManager: FileManager
    private var cachedPath: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    // MARK: Intitializations
    
    /// `DiskCacheManager`의 기본 생성자
    ///
    /// - Parameters:
    ///   - fileManager: `FileManger` 타입이 프로퍼티이며 `FileManager.default`을 기본적으로 주입받습니다.
    ///
    /// - Author: newJunsung
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    // MARK: Functions
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
