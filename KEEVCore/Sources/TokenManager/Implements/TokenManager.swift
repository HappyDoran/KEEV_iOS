//
//  TokenManager.swift
//  KEEVCore
//
//  Created by junsungkim on 5/15/25.
//

import Foundation

import Network
import KeyValueStorage

extension TokenManager {
    public struct Configuration {
        let refreshInterval: TimeInterval
        let storage: KeyValueStorage
        let network: RemoteClientService
        
        public init(refreshInterval: TimeInterval, storage: KeyValueStorage, network: RemoteClientService) {
            self.refreshInterval = refreshInterval
            self.storage = storage
            self.network = network
        }
    }
}

public actor TokenManager {
    private static let refreshTokenKey = "keevRefreshToken"
    
    private let refreshInterval: TimeInterval
    private let storage: KeyValueStorage
    private let network: RemoteClientService
    
    public init(configuration: Configuration) {
        self.refreshInterval = configuration.refreshInterval
        self.storage = configuration.storage
        self.network = configuration.network
    }
    
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
