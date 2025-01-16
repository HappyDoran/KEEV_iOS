//
//  MemoryCacheStorage.swift
//  KEEV
//
//  Created by 김준성 on 10/28/24.
//

import Foundation

/// 메모리에서 캐싱하는 저장소
///
/// 메모리에서 캐싱하는 저장소입니다.
///
/// 이 클래스는 두 가지의 제네릭을 가지고 있는데, `Key`와 `Object`입니다.
/// - `Key` 타입의 경우 클래스이어야하며, Hashable 프로토콜을 채택해야 합니다.
/// - `Object` 타입의 경우 아무 타입이나 상관 없습니다.
///
/// - Author: newJunsung
final class MemoryCacheStorage<Key, Object>: @unchecked Sendable where Key: AnyObject & Hashable {
    // MARK: Private attributes
    
    private let storage: NSCache<Key, CachableObject>
    private let lock = NSLock()
    private var keys = Set<Key>()
    private var cleanTimer: Timer?
    
    // MARK: Initialization
    
    /// Configuration을 바탕으로 `MemoryCacheStorage`를 생성합니다.
    ///
    /// 요소로는 `countLimit`, `totalCostLimit`, `cleanTerm`이 있습니다.
    ///
    /// - `countLimit`: (키, 값)을 몇 개까지 저장할 것인지를 결정하는 요소, 0이면 무제한 입니다.
    /// - `totalCostLimit`: 저장소의 용량제한을 설정하는 요소, 0이면 무제한입니다.
    /// - `cleanTerm`: 어느 정도의 시간 간격을 두고 캐시를 정리할지 결정하는 요소, 0이면 캐시를 정리하지 않습니다.
    init(configuration: Configuration) {
        let storage = NSCache<Key, CachableObject>()
        storage.totalCostLimit = Int(configuration.totalCostLimit.toBytes)
        storage.countLimit = configuration.countLimit
        
        self.storage = storage
        
        let seconds = configuration.cleanTerm.toSeconds
        if seconds > TimeInterval.zero {
            cleanTimer = .scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] _ in
                self?.cleanExpiredObjects()
            }
        }
    }
    
    // MARK: Internal functions
    
    /// 캐싱된 값들의 유통기한을 확인하여, 유통기한이 지난 값들은 삭제합니다.
    func cleanExpiredObjects() {
        lock.lock()
        defer { lock.unlock() }
        
        for key in keys {
            guard let object = storage.object(forKey: key) else {
                keys.remove(key)
                continue
            }
            
            if object.isExpired {
                storage.removeObject(forKey: key)
                keys.remove(key)
            }
        }
    }
    
    /// 캐싱된 키와 값이 있는지 확인합니다.
    func contains(for key: Key) -> Bool {
        keys.contains(key)
    }
    
    /// 키와 값을 캐싱해두는 함수
    ///
    /// - Parameters:
    ///   - object: 캐싱할 값
    ///   - expiration: 유통기한, 기본값은 `nil`입니다.
    ///   - key: 키
    ///
    /// 값과 유통기한, 그리고 키를 저장합니다.
    ///
    /// `expiration`의 경우 `Optional<Date>`인데, 여기에 `nil`이 들어갈 경우, 유통기한이 없는 것입니다.
    ///
    /// - Author: newJunsung
    func store(_ object: Object, until expiration: TimeUnit? = nil, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        
        if let expiration {
            let expiration = Date().addingTimeInterval(expiration.toSeconds)
            storage.setObject(CachableObject(object, expiration: expiration), forKey: key)
        } else {
            storage.setObject(CachableObject(object, expiration: nil), forKey: key)
        }
        
        keys.insert(key)
    }
    
    /// 키와 관련된 캐시 값을 반환하는 함수
    ///
    /// - Parameters:
    ///   - key: 키
    ///
    /// 키와 관련된 값을 찾아서 반환합니다.
    ///
    /// 만약 키에 해당하는 값이 없다면 키를 삭제 후, `nil`을 반환합니다.
    /// - Important:만약 키에 해당하는 값이 있더라도 그 값의 유통기한이 지났다면, 키와 값을 삭제하고 `nil`을 반환합니다.
    ///
    /// - Returns: 값이 있으면 값, 없으면 `nil`을 반환합니다.
    /// - Author: newJunsung
    func fetch(for key: Key) -> Object? {
        guard let object = storage.object(forKey: key), !object.isExpired else {
            remove(for: key)
            return nil
        }
        
        return object.object
    }
    
    /// 캐싱된 키와 값을 삭제하는 함수.
    func remove(for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        
        storage.removeObject(forKey: key)
        keys.remove(key)
    }
    
    /// 캐싱된 키와 값 전부를 삭제합니다.
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        
        storage.removeAllObjects()
        keys.removeAll()
    }
}

extension MemoryCacheStorage {
    /// 메모리에 캐싱하는 저장소를 위한 환경설정
    ///
    /// 캐시 저장소에 대한 환경설정 요소들이 있습니다.
    ///
    /// 요소로는 `countLimit`, `totalCostLimit`, `cleanTerm`이 있습니다.
    ///
    /// - `countLimit`: (키, 값)을 몇 개까지 저장할 것인지를 결정하는 요소, 0이면 무제한 입니다.
    /// - `totalCostLimit`: 저장소의 용량제한을 설정하는 요소, 0보다 작으면 무제한입니다.
    /// - `cleanTerm`: 어느 정도의 시간 간격을 두고 캐시를 정리할지 결정하는 요소, 0보다 작으면 캐시를 정리하지 않습니다.
    ///
    /// - Important: 각 속성에 대해 0이 의미하는 바는 무제한이라는 뜻입니다.
    ///
    ///
    /// - Author: newJunsung
    struct Configuration {
        // MARK: Internal Attributes
        
        /// (키, 값)을 몇 개까지 저장할 것인지를 결정하는 요소, 0이면 무제한 입니다.
        let countLimit: Int
        
        /// 저장소의 용량제한을 설정하는 요소, 0보다 작으면 무제한입니다.
        let totalCostLimit: StorageUnit
        
        /// 어느 정도의 시간 간격을 두고 캐시를 정리할지 결정하는 요소, 0보다 작으면 캐시를 정리하지 않습니다.
        let cleanTerm: TimeUnit
    }
}

extension MemoryCacheStorage {
    private final class CachableObject {
        // MARK: Internal Attributes
        let object: Object
        let expiration: Date?
        
        var isExpired: Bool {
            guard let expiration = expiration else { return false }
            return expiration < .now
        }
        
        // MARK: Initialization
        
        init(_ object: Object, expiration: Date?) {
            self.object = object
            self.expiration = expiration
        }
    }
}
