import Foundation
import UIKit

final class AccountService: AccountServiceProtocol {
    private static let refreshTokenTag = "keevRefreshToken"
    
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    
    private let multipartBuilder = MultipartFormBuilder()
    private let decoder = JSONDecoder()
    
    private var account: AccountDTO?
    
    func autoSignIn() async -> SignInStatus {
        if let account = account {
            return isRegistered(from: account) ? .ok(user: .init(account: account)) : .created
        }
        
        guard let tokenData = KeyChain.read(tag: Self.refreshTokenTag) else {
            debugPrint("AccountService->autoSignIn: nono token")
            return .failed
        }
        
        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
            debugPrint("AccountService->autoSignIn: token to String failed")
            try? KeyChain.delete(tag: Self.refreshTokenTag)
            return .failed
        }
        
        do {
            let fetchedAccount = try await fetchAccountDTO(from: .refreshAccessToken(refreshToken: tokenString))
            try await storeToken(fetchedAccount.accessToken, for: .access)
            return isRegistered(from: fetchedAccount) ? .ok(user: .init(account: fetchedAccount)) : .created
        } catch {
            debugPrint("AccountService->autoSignIn: \(error)")
            return .failed
        }
    }
    
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        let fetchedAccount = try await fetchAccountDTO(from: .signInWithApple(code: authorizationCode))
        
        if isRegistered(from: fetchedAccount) {
            return .created
        }
        
        do {
            try await storeToken(fetchedAccount.accessToken, for: .access)
            try await storeToken(fetchedAccount.keevRefreshToken, for: .refresh)
            debugPrint("Successfully stored refresh token!!!")
        } catch {
            debugPrint("AccountService->signInWithApple Error: \(error)")
        }
        
        let user = DetailUserUIO(account: fetchedAccount)
        
        return isRegistered(from: fetchedAccount) ? .ok(user: user) : .created
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        guard let account else {
            debugPrint("nono account")
            return .failed
        }
        
        let json = try JSONSerialization.data(withJSONObject: [
            "email": email,
            "nickName": nickname,
        ])
        
        let profileJpeg = profileImage?.jpegData(compressionQuality: 0.3)
        let backgroundJpeg = backgroundImage?.jpegData(compressionQuality: 0.5)
        
        var builder = MultipartFormBuilder()
        
        builder.append(name: "userData", content: .json(data: json))
        
        if let profileJpeg {
            builder.append(
                name: "profileImage",
                fileName: "user\(account.id)-profileImage.jpeg",
                content: .jpeg(data: profileJpeg)
            )
        }
        
        if let backgroundJpeg {
            builder.append(
                name: "backgroundImage",
                fileName: "user\(account.id)-backgroundImage.jpeg",
                content: .jpeg(data: backgroundJpeg)
            )
        }
        
        guard let (boundary, data) = builder.build() else {
            debugPrint("AccountService->signUp: fail to build multipart")
            return .failed
        }
        
        guard let accessToken = account.accessToken else {
            debugPrint("AccountService->signUp: fail to get accessToken")
            return .failed
        }
        
        let router = AccountHTTPRequestRouter.signUp(
            accessToken: accessToken,
            boundary: boundary,
            multipartData: data
        )
        
        let fetchedAccount = try await fetchAccountDTO(from: router)
        return isRegistered(from: fetchedAccount) ? .ok(user: .init(account: fetchedAccount)) : .failed
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        .dummy0
    }
    
    func signOut() async throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
    private func fetchAccountDTO(from router: AccountHTTPRequestRouter) async throws -> AccountDTO {
        let data = try await networkUtility.request(router: router)
        let fetchedAccount = try decoder.decode(AccountDTO.self, from: data)
        account = fetchedAccount
        return fetchedAccount
    }
    
    private func isRegistered(from account: AccountDTO) -> Bool {
        account.email != nil
    }
    
    private func storeToken(_ token: String?, for type: TokenUtility.TokenType) async throws {
        if let token {
            try await tokenUtility.storeToken(token, for: type)
        }
    }
}
