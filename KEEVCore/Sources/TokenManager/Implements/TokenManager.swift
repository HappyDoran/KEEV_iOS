//
//  TokenManager.swift
//  KEEVCore
//
//  Created by junsungkim on 5/15/25.
//

import Network
import KeyValueStorage

public actor TokenManager {
    nonisolated public func fetch(_ type: TokenType) throws -> String? {
        nil
    }
    
    public func remove(_ type: TokenType) {
        
    }
    
    public func removeAll() {
        
    }
    
    public func refreshAccessToken() throws -> String {
        ""
    }
    
    public func store(_ tokens: [TokenType: String]) {
        
    }
}
