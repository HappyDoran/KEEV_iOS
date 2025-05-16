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
        let network: APIClient
        
        public init(refreshInterval: TimeInterval, storage: KeyValueStorage, network: APIClient) {
            self.refreshInterval = refreshInterval
            self.storage = storage
            self.network = network
        }
    }
}

public actor TokenManager {
    private static let refreshTokenKey = "keevRefreshToken"
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(dateformatter)
        return decoder
    }()
    
    private let refreshInterval: TimeInterval
    private let storage: KeyValueStorage
    private let network: APIClient
    
    private var accessTokenDate: Date?
    private var accessToken: String?
    private var refreshToken: String?
    
    public init(configuration: Configuration) {
        self.refreshInterval = configuration.refreshInterval
        self.storage = configuration.storage
        self.network = configuration.network
    }
    
    public func fetch(_ type: TokenType) async throws -> String? {
        switch type {
        case .accessToken:
            if let token = try fetchAccessToken() { return token }
            return try await refreshAccessToken()
        case .refreshToken:
            return try await fetchRefreshToken()
        }
    }
    
    public func remove(_ type: TokenType) {
        switch type {
        case .accessToken:
            accessToken = nil
            accessTokenDate = nil
        case .refreshToken:
            refreshToken = nil
            Task(priority: .background) {
                await storage.remove(TokenManager.refreshTokenKey)
            }
        }
    }
    
    public func removeAll() {
        accessToken = nil
        accessTokenDate = nil
        refreshToken = nil
        Task(priority: .background) {
            await storage.remove(TokenManager.refreshTokenKey)
        }
    }
    
    public func refreshAccessToken() async throws -> String {
        accessToken = nil
        accessTokenDate = nil
        
        guard let refreshToken = try await fetchRefreshToken() else {
            throw TokenError.tokenNotFound
        }
        
        let router = TokenRouter(refreshToken: refreshToken)
        let token = try await network.request(by: router, for: TokenResponseDTO.self, decoder: Self.decoder)
        
        self.accessToken = token.accessToken
        self.accessTokenDate = token.createdDate
        
        if let refreshToken = token.refreshToken {
            store([.refreshToken: refreshToken])
        }
        
        return token.accessToken
    }
    
    public func store(_ tokens: [TokenType: String]) {
        for (type, token) in tokens {
            switch type {
            case .accessToken:
                accessToken = token
                accessTokenDate = .now
            case .refreshToken:
                refreshToken = token
                Task(priority: .background) {
                    try await storage.save(token, forKey: TokenManager.refreshTokenKey)
                }
            }
        }
    }
    
    private func fetchAccessToken() throws -> String? {
        guard let accessToken = accessToken, let accessTokenDate = accessTokenDate else { return nil }
        guard Date.now < accessTokenDate.addingTimeInterval(refreshInterval) else { throw TokenError.expiredToken }
        return accessToken
    }
    
    private func fetchRefreshToken() async throws -> String? {
        if let token = self.refreshToken {
            return token
        }
        
        self.refreshToken = try await storage.load(TokenManager.refreshTokenKey)
        return self.refreshToken
    }
}
