//
//  NSCacheManager.swift
//  KEEV
//
//  Created by 김준성 on 10/25/24.
//

import Foundation

/// `NSCache`를 통해서 데이터를 캐싱하는 객체
///
/// - Note: `NSCache`의 `Key`와 `Value`의 타입 모두 클래스여야 하기 때문에,
/// `String`을 `NSString`으로, `Data`를 `NSData`로 바꿔서 캐싱을 합니다.
/// - Author: newJunsung
final class NSCacheManager: CacheManagerProtocol {
    // MARK: Private attributes
    
    private let cache: NSCache<NSString, NSData>
    
    // MARK: Intitializations
    
    /// `NSCacheManager`의 기본 생성자
    ///
    /// - Parameters:
    ///   - cache: `NSCache<NSString, NSData>` 타입이 프로퍼티이며 `.init()`을 기본적으로 주입받습니다.
    ///
    /// - Author: newJunsung
    init(cache: NSCache<NSString, NSData> = .init()) {
        self.cache = cache
    }
    
    // MARK: Functions
    
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
