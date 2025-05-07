//
//  TokenUtility.swift
//  KEEV
//
//  Created by 김준성 on 12/29/24.
//

import Foundation
import KeyValueStorage

/// Token을 관리하는 유틸리티 액터
///
/// - Note: 액세스 토큰은 액터의 프로퍼티로 관리되고, 리프레시 토큰은 키체인에 저장되어 보안이 강화됩니다.
/// - Author: newJunsung
actor TokenUtility {
    /// TokenUtility의 싱글톤 인스턴스
    ///
    /// 이 싱글톤을 통해 `TokenUtility`에 대한 단일 진입점을 제공합니다.
    static let shared = TokenUtility()
    
    private let tokenStorage: some KeyValueStorage = KeyChainStorage(service: "hmhzKEEVService")
    private let network = NetworkUtility()
    private var accessToken: String?
    private var expirationDateForAccess: Date?
    
    /// 특정 유형의 토큰을 가져옵니다.
    ///
    /// - Parameters:
    ///   - type: 토큰의 유형을 지정합니다. `.access`와 `.refresh` 중 하나를 선택할 수 있습니다.
    ///
    /// - Returns: 요청한 유형의 토큰 문자열
    /// - Throws:
    ///   - `TokenError.tokenNotFound`: 토큰이 저장소에 존재하지 않는 경우
    ///   - `TokenError.decodeFail`: 토큰 디코딩 실패
    /// - Author: newJunsung
    func fetchToken(for type: TokenType) async throws -> String {
        switch type {
        case .access:
            return try await fetchAccessToken()
        case .refresh:
            return try await decodeRefreshToken()
        }
    }
    
    /// 액세스 토큰을 새로 고칩니다.
    ///
    /// - Returns: 새로 고쳐진 액세스 토큰 문자열
    /// - Throws: `TokenError.tokenNotFound`: 리프레시 토큰이 존재하지 않는 경우, `TokenError.tokenIsNil`: 서버로부터 액세스 토큰을 받을 수 없는 경우, `Other`: 네트워크 요청 또는 디코딩 실패 시 발생하는 오류
    /// - Author: newJunsung
    func refreshAccessToken() async throws -> String {
        let refreshToken = try await decodeRefreshToken()
        let router = AccountHTTPRequestRouter.refreshAccessToken(refreshToken: refreshToken)
        
        // 네트워크 통신
        let data = try await network.request(router: router)
        expirationDateForAccess = Date.now.addingTimeInterval(TimeUnit.hours(of: 1).toSeconds)
        
        // 서버 응답 디코딩
        let account = try JSONDecoder().decode(AccountDTO.self, from: data)
        
        guard let fetchedAccessToken = account.accessToken else {
            throw TokenError.tokenNotFound
        }
        
        accessToken = fetchedAccessToken
        return fetchedAccessToken
    }
    
    /// 특정 유형의 토큰을 저장합니다.
    ///
    /// - Parameters:
    ///   - token: 저장할 토큰 문자열
    ///   - type: 토큰의 유형 (`.access` 또는 `.refresh`)
    ///
    /// - Throws: `TokenError.keyChainWriteFail`: 키체인에 토큰 저장 실패 시 발생
    ///
    /// - Author: newJunsung
    func storeToken(_ token: String, for type: TokenType) async throws {
        switch type {
        case .access:
            accessToken = token
            expirationDateForAccess = Date.now.addingTimeInterval(TimeUnit.minutes(of: 55).toSeconds)
        case .refresh:
            try await storeRefreshToken(token)
        }
    }
    
    /// 나열한 토큰들을 모두 저장합니다.
    ///
    /// - Parameters:
    ///   - tokens: 딕셔너리 타입입니다. key에는 토큰의 종류가 들어가며, value에는 토큰의 값이 들어갑니다.
    ///
    /// - Throws: `TokenError.keyChainWriteFail`: 키체인에 토큰 저장 실패 시 발생
    /// - Author: newJunsung
    func storeTokens(_ tokens: [TokenType: String]) async throws {
        for (type, token) in tokens {
            try await storeToken(token, for: type)
        }
    }
    
    func deleteToken(for type: TokenType) async throws {
        switch type {
        case .access:
            accessToken = nil
            expirationDateForAccess = nil
        case .refresh:
            await tokenStorage.remove("keevRefreshToken")
        }
    }
    
    func deleteAllTokens() async throws {
        accessToken = nil
        expirationDateForAccess = nil
        await tokenStorage.remove("keevRefreshToken")
    }
    
    private func fetchAccessToken() async throws -> String {
        if let accessToken = accessToken,
           let expirationDateForAccess, expirationDateForAccess > Date.now {
            return accessToken
        }
        
        return try await refreshAccessToken()
    }
    
    /// 리프레시 토큰을 키체인에서 디코딩합니다.
    ///
    /// - Returns: 저장된 리프레시 토큰 문자열
    /// - Throws: `TokenError.tokenNotFound`: 키체인에 토큰이 존재하지 않는 경우. `TokenError.decodeFail`: 토큰 디코딩 실패
    /// - Author: newJunsung
    private nonisolated func decodeRefreshToken() async throws -> String {
        guard let data: String = try await tokenStorage.load("keevRefreshToken") else {
            throw TokenError.tokenNotFound
        }
        
        return data
    }
    
    /// 리프레시 토큰을 키체인에 저장합니다.
    ///
    /// - Parameter token: 저장할 리프레시 토큰 문자열
    /// - Throws: `TokenError.keyChainWriteFail`: 키체인 저장 실패
    /// - Author: newJunsung
    private func storeRefreshToken(_ token: String) async throws {
        try await tokenStorage.save(token, forKey: "keevRefreshToken")
    }
}

/// TokenUtility의 토큰 유형
extension TokenUtility {
    /// 토큰의 유형을 나타내는 열거형
    enum TokenType {
        /// 액세스 토큰
        case access
        /// 리프레시 토큰
        case refresh
    }
}
