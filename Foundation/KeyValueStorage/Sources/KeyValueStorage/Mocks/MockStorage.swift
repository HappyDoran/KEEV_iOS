//
//  MockStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

final class MockStorage: KeyValueStorage, @unchecked Sendable {
    private let storage: any KeyValueStorage
    private var keys = Set<String>()
    
    init(storage: any KeyValueStorage) {
        self.storage = storage
    }
    
    func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) async throws where T: Sendable & Codable {
        try await storage.save(value, forKey: key, encoder: encoder)
        keys.insert(key)
    }
    
    func load<T: Sendable>(_ key: String, decoder: JSONDecoder) async throws -> T? where T : Decodable, T : Encodable {
        try await storage.load(key, decoder: decoder)
    }
    
    func remove(_ key: String) async {
        await storage.remove(key)
        keys.remove(key)
    }
    
    func removeAll() async {
        await withTaskGroup { group in
            group.addTask { [self] in
                for key in keys {
                    await storage.remove(key)
                }
            }
        }
        keys.removeAll()
    }
}
