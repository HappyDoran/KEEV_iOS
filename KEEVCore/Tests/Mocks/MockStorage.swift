//
//  File.swift
//  KEEVCore
//
//  Created by junsungkim on 5/17/25.
//

import Foundation

import KeyValueStorage

actor MockStorage: KeyValueStorage {
    private var storage: [String: Data] = [:]
    
    func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) async throws where T : Decodable, T : Encodable, T : Sendable {
        let data = try encoder.encode(value)
        storage[key] = data;
    }
    
    
    func load<T>(_ key: String, decoder: JSONDecoder) async throws -> T? where T : Decodable, T : Encodable, T : Sendable {
        guard let data = storage[key] else { return nil }
        return try decoder.decode(T.self, from: data)
    }
    
    func remove(_ key: String) async {
        storage.removeValue(forKey: key)
    }
}
