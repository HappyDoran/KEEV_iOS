import Foundation
import UIKit

final class AccountService: AccountServiceProtocol {
    private static let refreshTokenTag = "keevRefreshToken"
    
    private let keychain = TokenKeyChainUtility()
    private let network = NetworkUtility()
    
    private let multipartBuilder = MultipartFormBuilder()
    private let decoder = JSONDecoder()
    
    private var account: AccountDTO?
    
    func autoSignIn() async -> SignInStatus {
        if let account = account {
            return isRegistered(from: account) ? .ok(user: .init(account: account)) : .created
        }
        
        guard let tokenData = keychain.read(tokenTag: "keevRefreshToken") else {
            debugPrint("AccountService->autoSignIn: nono token")
            return .failed
        }
        
        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
            debugPrint("AccountService->autoSignIn: token to String failed")
            try? keychain.delete(tokenTag: "keevRefreshToken")
            return .failed
        }
        
        do {
            let fetchedAccount = try await getAccountDTO(from: .refreshAccessToken(refreshToken: tokenString))
            return isRegistered(from: fetchedAccount) ? .ok(user: .init(account: fetchedAccount)) : .created
        } catch {
            debugPrint("AccountService->autoSignIn: \(error)")
            return .failed
        }
    }
    
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        let fetchedAccount = try await getAccountDTO(from: .signInWithApple(code: authorizationCode))
        
        if isRegistered(from: fetchedAccount) {
            return .created
        }
        
        do {
            try store(fetchedAccount.keevRefreshToken)
            debugPrint("Successfully stored refresh token!!!")
        } catch {
            debugPrint(error)
        }
        
        let user = DetailUserUIO(account: fetchedAccount)
        
        return isRegistered(from: fetchedAccount) ? .ok(user: user) : .created
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String?) async throws -> SignInStatus {
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
        
        if let profileJpeg {
            builder.append(
                name: "backgroundImage",
                fileName: "user\(account.id)-backgroundImage.jpeg",
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
        
        let router = AccountHTTPRequestRouter.signUp(
            accessToken: account.accessToken,
            boundary: boundary,
            multipartData: data
        )
        
        let fetchedAccount = try await getAccountDTO(from: router)
        return isRegistered(from: fetchedAccount) ? .ok(user: .init(account: fetchedAccount)) : .failed
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String?) async throws -> DetailUserUIO {
        .dummy0
    }
    
    func signOut() async throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
    private func getAccountDTO(from router: AccountHTTPRequestRouter) async throws -> AccountDTO {
        let data = try await network.request(router: router)
        let fetchedAccount = try decoder.decode(AccountDTO.self, from: data)
        account = fetchedAccount
        return fetchedAccount
    }
    
    private func store(_ token: String?) throws {
        if let token {
            try keychain.create(token, tokenTag: Self.refreshTokenTag)
        }
    }
    
    private func isRegistered(from account: AccountDTO) -> Bool {
        account.email != nil
    }
}
