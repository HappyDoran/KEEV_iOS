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
    
    init(configuration: Configuration) {
        let storage = NSCache<Key, CachableObject>()
        storage.totalCostLimit = configuration.totalCostLimit
        storage.countLimit = configuration.countLimit
        
        self.storage = storage
        
        if configuration.cleanTerm != 0 {
            cleanTimer = .scheduledTimer(withTimeInterval: configuration.cleanTerm, repeats: true) { [weak self] _ in
                self?.cleanExpiredObjects()
            }
        }
    }
    
    // MARK: Private functions
    
    private func cleanExpiredObjects() {
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
    
    // MARK: Internal functions
    
    func contains(for key: Key) -> Bool {
        keys.contains(key)
    }
    
    func store(_ object: Object, until expiration: Date? = nil, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        
        storage.setObject(CachableObject(object, expiration: expiration), forKey: key)
        keys.insert(key)
    }
    
    func fetch(for key: Key) -> Object? {
        guard let object = storage.object(forKey: key) else { return nil }
        
        if object.isExpired {
            remove(for: key)
            return nil
        }
        
        return object.object
    }
    
    func remove(for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        
        storage.removeObject(forKey: key)
        keys.remove(key)
    }
    
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
    /// - `totalCostLimit`: 저장소의 용량제한을 설정하는 요소, 0이면 무제한입니다.
    /// - `cleanTerm`: 어느 정도의 시간 간격을 두고 캐시를 정리할지 결정하는 요소, 0이면 캐시를 정리하지 않습니다.
    ///
    /// - Important: 각 속성에 대해 0이 의미하는 바는 무제한이라는 뜻입니다.
    ///
    /// - ToDo: `totalCostLimit` 용량 단위(GB, MB, KB 등)별 열거형 만들기.
    /// `cleanTerm` 시간 단위(초, 분, 시간, 날)별 열거형 만들기
    ///
    /// - Author: newJunsung
    struct Configuration {
        // MARK: Internal Attributes
        
        /// (키, 값)을 몇 개까지 저장할 것인지를 결정하는 요소, 0이면 무제한 입니다.
        let countLimit: Int
        
        /// 저장소의 용량제한을 설정하는 요소, 0이면 무제한입니다.
        let totalCostLimit: Int
        
        /// 어느 정도의 시간 간격을 두고 캐시를 정리할지 결정하는 요소, 0이면 캐시를 정리하지 않습니다.
        let cleanTerm: TimeInterval
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
