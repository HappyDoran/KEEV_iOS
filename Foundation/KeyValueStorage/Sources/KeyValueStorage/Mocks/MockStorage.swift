//
//  MockStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

final class MockStorage: KeyValueStorage {
    private let storage: any KeyValueStorage
    private var keys = Set<String>()
    
    init(storage: any KeyValueStorage) {
        self.storage = storage
    }
    
    deinit {
        removeAll()
    }
    
    func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) throws where T : Decodable, T : Encodable {
        try storage.save(value, forKey: key, encoder: encoder)
        keys.insert(key)
    }
    
    func load<T>(_ key: String, decoder: JSONDecoder) throws -> T? where T : Decodable, T : Encodable {
        try storage.load(key, decoder: decoder)
    }
    
    func remove(_ key: String) {
        storage.remove(key)
        keys.remove(key)
    }
    
    func removeAll() {
        for key in keys {
            storage.remove(key)
        }
    }
}
