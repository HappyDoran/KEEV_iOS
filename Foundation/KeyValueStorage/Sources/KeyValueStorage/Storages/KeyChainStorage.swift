//
//  KeyChainStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation
import Security

public final class KeyChainStorage: KeyValueStorage {
    private let service: String
    
    init(service: String) {
        self.service = service
    }
    
    public func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) throws where T: Codable {
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
    
    public func load<T>(_ key: String, decoder: JSONDecoder) throws -> T? where T: Codable {
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
    
    public func remove(_ key: String) {
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
