//
//  KeyValueStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

protocol KeyValueStorage {
    func load<T: Codable>(_ key: String, decoder: JSONDecoder) throws -> T?
    func save<T: Codable>(_ value: T, forKey key: String, encoder: JSONEncoder) throws
    func remove(_ key: String)
}

extension KeyValueStorage {
    func save<T: Codable>(_ value: T, forKey key: String) throws {
        try save(value, forKey: key, encoder: JSONEncoder())
    }
    
    func load<T: Codable>(_ key: String) throws -> T? {
        try load(key, decoder: JSONDecoder())
    }
}
