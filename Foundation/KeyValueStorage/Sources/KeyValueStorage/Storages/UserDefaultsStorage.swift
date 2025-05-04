//
//  UserDefaultsStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

/// UserDefaults를 이용한 KeyValueStorage 구현체입니다.
///
/// 간단한 설정 값, 최근 검색어 등 앱의 경량 데이터를 저장하는 데 적합합니다.
/// Codable을 기반으로 직렬화하여 데이터를 저장하고 불러옵니다.
public final class UserDefaultsStorage: KeyValueStorage, @unchecked Sendable {
    private let userDefaults: UserDefaults
    
    /// UserDefaults 인스턴스를 주입받아 초기화합니다.
    /// 기본값은 `.standard`입니다.
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// 지정된 키로 저장된 값을 불러옵니다.
    ///
    /// - Parameters:
    ///   - key: 불러올 값의 키
    ///   - decoder: 디코딩에 사용할 JSONDecoder (기본값 사용 가능)
    /// - Returns: 디코딩된 값 또는 nil
    /// - Throws: 디코딩 실패 시 `StorageError.decodingFailed`
    public func load<T>(_ key: String, decoder: JSONDecoder = JSONDecoder()) throws -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }
    
    /// 지정된 키에 값을 저장합니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 저장할 위치를 나타내는 키
    ///   - encoder: 인코딩에 사용할 JSONEncoder (기본값 사용 가능)
    /// - Throws: 인코딩 실패 시 `StorageError.encodingFailed`
    public func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder = JSONEncoder()) throws where T: Codable {
        do {
            userDefaults.set(try encoder.encode(value), forKey: key)
        } catch {
            throw StorageError.encodingFailed
        }
    }
    
    /// 지정된 키의 값을 삭제합니다.
    ///
    /// - Parameter key: 삭제할 키
    public func remove(_ key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
