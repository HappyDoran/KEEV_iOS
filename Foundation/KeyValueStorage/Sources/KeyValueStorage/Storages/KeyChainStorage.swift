//
//  KeyChainStorage.swift
//  KeyValueStorage
//
//  Created by junsungkim on 5/1/25.
//

import Foundation
import Security

public final class KeyChainStorage: KeyValueStorage {
    public func save<T>(_ value: T, forKey key: String, encoder: JSONEncoder) throws where T : Decodable, T : Encodable {
        
    }
    
    public func load<T>(_ key: String, decoder: JSONDecoder) throws -> T? where T : Decodable, T : Encodable {
        nil
    }
    
    public func remove(_ key: String) {
        
    }
    
    private let service: String
    
    init(service: String) {
        self.service = service
    }
}
