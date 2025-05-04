//
//  KeyChainStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation
import Security

/// Keychain을 이용한 KeyValueStorage 구현체입니다.
///
/// 보안이 중요한 데이터(JWT 토큰, 비밀번호 등)를 안전하게 저장할 수 있습니다.
/// iOS의 Security 프레임워크 기반으로 동작하며, 저장된 항목은 시스템에 의해 암호화됩니다.
public actor KeyChainStorage: KeyValueStorage {
    private let service: String
    
    /// Keychain 항목을 식별하기 위한 서비스 이름을 지정하여 초기화합니다.
    /// - Parameter service: Keychain에서 사용할 서비스 식별자
    public init(service: String) {
        self.service = service
    }
    
    /// 값을 Keychain에 저장합니다.
    ///
    /// 기존에 동일한 키로 저장된 값이 있다면 먼저 삭제한 후 새로 저장합니다.
    ///
    /// - Parameters:
    ///   - value: 저장할 값 (Codable & Sendable)
    ///   - key: 저장할 항목의 키
    ///   - encoder: JSONEncoder 인스턴스
    /// - Throws: 인코딩 실패 또는 Keychain 저장 오류 발생 시 에러를 던집니다.
    public func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) async throws where T: Codable, T: Sendable {
        let data = try encode(value, encoder: encoder)
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
        ]
        
        SecItemDelete(query as CFDictionary)
        
        var attributes: [CFString: Any] = query
        attributes[kSecValueData] = data
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.keychainError(status: status)
        }
    }
    
    /// Keychain에서 값을 불러옵니다.
    ///
    /// - Parameters:
    ///   - key: 조회할 키
    ///   - decoder: JSONDecoder 인스턴스
    /// - Returns: 복호화된 값 또는 항목이 없으면 nil
    /// - Throws: Keychain 오류 또는 디코딩 실패 시 에러를 던집니다.
    public func load<T>(_ key: String, decoder: JSONDecoder) async throws -> T? where T: Codable, T: Sendable {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecItemNotFound { return nil }
        
        guard status == errSecSuccess else {
            throw StorageError.keychainError(status: status)
        }
        
        guard let data = item as? Data else {
            throw StorageError.unexpectedData
        }
        
        return try decode(data, decoder: decoder)
    }
    
    /// 지정된 키의 값을 Keychain에서 삭제합니다.
    ///
    /// - Parameter key: 삭제할 항목의 키
    public func remove(_ key: String) async {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrService: service,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    private func encode(_ value: some Encodable, encoder: JSONEncoder) throws -> Data {
        do {
            return try encoder.encode(value)
        } catch {
            throw StorageError.encodingFailed
        }
    }
    
    private func decode<T>(_ data: Data, decoder: JSONDecoder) throws -> T where T: Decodable {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }
}
