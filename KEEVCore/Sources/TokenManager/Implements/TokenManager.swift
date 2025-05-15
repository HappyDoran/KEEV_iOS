//
//  TokenManager.swift
//  KEEVCore
//
//  Created by junsungkim on 5/15/25.
//

import Network
import KeyValueStorage

public actor TokenManager {
    public func fetch(_ type: TokenType) -> TokenState? {
        nil
    }
    
    @discardableResult
    public func remove(_ type: TokenType) -> TokenState? {
        nil
    }
    
    public func removeAll() {
        
    }
    
    public func refreshAccessToken() throws -> TokenState {
        .expired
    }
    
    public func store(_ tokens: [TokenType: TokenState]) {
        
    }
}
