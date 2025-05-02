//
//  KeyValueStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

public protocol KeyValueStorage: Sendable {
    func load<T: Codable & Sendable>(_ key: String, decoder: JSONDecoder) async throws -> T?
    func load<T: Codable & Sendable>(_ key: String) async throws -> T?
    func save<T: Codable & Sendable>(_ value: T, forKey key: String, encoder: JSONEncoder) async throws
    func save<T: Codable & Sendable>(_ value: T, forKey key: String) async throws
    func remove(_ key: String) async
}

public extension KeyValueStorage {
    func save<T: Codable & Sendable>(_ value: T, forKey key: String) async throws {
        try await save(value, forKey: key, encoder: JSONEncoder())
    }
    
    func load<T: Codable & Sendable>(_ key: String) async throws -> T? {
        try await load(key, decoder: JSONDecoder())
    }
}
