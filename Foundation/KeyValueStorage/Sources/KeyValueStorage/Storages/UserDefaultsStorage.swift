//
//  UserDefaultsStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

public final class UserDefaultsStorage: KeyValueStorage {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func load<T>(_ key: String, decoder: JSONDecoder = JSONDecoder()) throws -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }
    
    func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder = JSONEncoder()) throws where T: Codable {
        do {
            userDefaults.set(try encoder.encode(value), forKey: key)
        } catch {
            throw StorageError.encodingFailed
        }
    }
    
    func remove(_ key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
