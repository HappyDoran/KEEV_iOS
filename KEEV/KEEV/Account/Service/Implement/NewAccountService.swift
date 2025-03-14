//
//  NewAccountService.swift
//  KEEV
//
//  Created by 김준성 on 3/13/25.
//

import Foundation
import UIKit

final class NewAccountService {
    private static let refreshTokenTag = "keevRefreshToken"
    
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let jsonDecoder = {
        let jsonDecoder = JSONDecoder()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        jsonDecoder.dateDecodingStrategy = .formatted(dateformatter)
        return jsonDecoder
    }()
    
    private var identityToken: String?
    private var account: AccountDTO? {
        didSet {
            updateAccount(account)
        }
    }
    
    private func storeTokens(from account: AccountDTO?) async throws {
        var tokens = [TokenUtility.TokenType: String]()
        if let accessToken = account?.accessToken {
            tokens[.access] = accessToken
        }
        
        if let refreshToken = account?.keevRefreshToken {
            tokens[.refresh] = refreshToken
        }
        
        try await tokenUtility.storeTokens(tokens)
    }
    
    private func updateAccount(_ account: AccountDTO?) {
        guard let account else {
            NotificationCenter.default.post(name: .updateUserInfo, object: nil)
            return
        }
        
        let user = DetailUserUIO(account: account)
        NotificationCenter.default.post(name: .updateUserInfo, object: user)
    }
    
    private func updateSignInStatus(_ status: SignInStatus) {
        NotificationCenter.default.post(name: .updateSignInStatus, object: status)
    }
    
    private func resetAllStatus() {
        account = nil
        updateSignInStatus(.failed)
    }
}

extension NewAccountService: AccountServiceProtocol {
    static let layer: LayerType = .service(of: "NewAccountService")
    
    func autoSignIn() async -> SignInStatus {
        if let account = account {
            return .ok(user: .init(account: account))
        }
        
        guard let refreshToken = try? await tokenUtility.fetchToken(for: .refresh) else {
            updateSignInStatus(.failed)
            return .failed
        }
        
        let router = NewAccountHTTPRequestRouter.refreshAccessToken(refreshToken: refreshToken)
        let data = try! await networkUtility.request(router: router)
        guard let fetchedAccount = try? jsonDecoder.decode(AccountDTO.self, from: data) else {
            updateSignInStatus(.failed)
            return .failed
        }
        
        _ = try? await storeTokens(from: fetchedAccount)
        account = fetchedAccount
        updateSignInStatus(.ok(user: .init(account: fetchedAccount)))
        return .ok(user: .init(account: fetchedAccount))
    }
    
    func signInWithApple(email: String?, user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        self.identityToken = String(data: identityToken, encoding: .utf8)!
        let router = NewAccountHTTPRequestRouter.signInWithApple(identityToken: identityToken)
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        
        if code == 404 {
            updateSignInStatus(.created)
            return .created
        }
        
        let fetchedAccount = try jsonDecoder.decode(AccountDTO.self, from: data)
        try await storeTokens(from: fetchedAccount)
        account = fetchedAccount
        let ok = SignInStatus.ok(user: .init(account: fetchedAccount))
        updateSignInStatus(ok)
        return ok
    }
    
    func signUp(email: String?, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        guard let identityToken else {
            account = nil
            try await tokenUtility.deleteAllTokens()
            return .failed
        }
        
        let signUpInfo = try JSONEncoder().encode(SignUpInfo(idToken: identityToken, nickname: nickname))
        
        
        var builder = MultipartFormBuilder()
        builder.append(name: "signUpInfo", content: .json(data: signUpInfo))
        
        if let profileImage,
           let jpeg = profileImage.jpegData(compressionQuality: 0.5) {
            builder.append(name: "profileImage", fileName: UUID().uuidString, content: .jpeg(data: jpeg))
        }
        
        guard let (boundary, multipartData) = builder.build() else {
            return .failed
        }
        
        let router = NewAccountHTTPRequestRouter.signUp(boundary: boundary, multipartData: multipartData)
        let data = try await networkUtility.request(router: router)
        let fetchedAccount = try jsonDecoder.decode(AccountDTO.self, from: data)
        try await storeTokens(from: fetchedAccount)
        account = fetchedAccount
        updateSignInStatus(.ok(user: .init(account: fetchedAccount)))
        return .ok(user: .init(account: fetchedAccount))
        
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        let accessToken = try await tokenUtility.fetchToken(for: .access)
        let userJSON = try JSONEncoder().encode(EditInfo(nickname: nickname, description: description))
        
        var builder = MultipartFormBuilder()
        builder.append(name: "editInfo", content: .json(data: userJSON))
        
        if let profileImage,
           let profileJPEG = profileImage.jpegData(compressionQuality: 0.5) {
            builder.append(name: "profileImage", fileName: UUID().uuidString, content: .jpeg(data: profileJPEG))
        }
        
        if let backgroundImage,
           let backgroundJPEG = backgroundImage.jpegData(compressionQuality: 0.7) {
            builder.append(name: "backgroundImage", fileName: UUID().uuidString, content: .jpeg(data: backgroundJPEG))
        }
        
        let (boundary, multipartData) = builder.build()!
        
        let router = NewAccountHTTPRequestRouter.modifyAccount(
            accessToken: accessToken,
            boundary: boundary,
            multipartData: multipartData
        )
        
        let data = try await networkUtility.request(router: router)
        let fetchedUser = try jsonDecoder.decode(DetailUserDTO.self, from: data)
        let uio = DetailUserUIO(detailuserDTO: fetchedUser)
        NotificationCenter.default.post(name: .updateUserInfo, object: uio)
        return uio
    }
    
    func signOut() async throws {
        try await tokenUtility.deleteAllTokens()
        resetAllStatus()
    }
    
    func deleteAccount() async throws {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = NewAccountHTTPRequestRouter.deleteAccount(accessToken: token)
        let _ = try await networkUtility.requestWithStatusCode(router: router)
        try await tokenUtility.deleteAllTokens()
        resetAllStatus()
    }
    
    func lookAround() -> SignInStatus {
        updateSignInStatus(.lookAround)
        return .lookAround
    }
}

private extension NewAccountService {
    struct SignUpInfo: Encodable {
        let idToken: String
        let nickname: String
    }
    
    struct EditInfo: Encodable {
        let nickname: String
        let description: String
    }
}
