//
//  KeyValueStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation

protocol KeyValueStorage {
    func load<T: Codable>(_ key: String) -> T?
    func loadOrThrow<T: Codable>(_ key: String) throws -> T
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func remove(_ key: String) throws
}
