import Foundation
import UIKit

final class AccountService: AccountServiceProtocol {
    private static let refreshTokenTag = "keevRefreshToken"
    
    private let networkUtility = NetworkUtility()
    private let tokenUtility = TokenUtility.shared
    private let decoder = JSONDecoder()
    
    private var account: AccountDTO?
    
    // MARK: Default Functions
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
            let (code, fetchedAccount) = try await fetchAccountDTO(from: .refreshAccessToken(refreshToken: tokenString))
            try await storeToken(fetchedAccount.accessToken, for: .access)
            return determineStatus(from: fetchedAccount, with: code)
        } catch {
            debugPrint("AccountService->autoSignIn: \(error)")
            return .failed
        }
    }
    
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        let (code, fetchedAccount) = try await fetchAccountDTO(from: .signInWithApple(code: authorizationCode))
        
        do {
            try await storeToken(fetchedAccount.accessToken, for: .access)
            try await storeToken(fetchedAccount.keevRefreshToken, for: .refresh)
            debugPrint("Successfully stored refresh token!!!")
        } catch {
            debugPrint("AccountService->signInWithApple Error: \(error)")
        }
        
        return determineStatus(from: fetchedAccount, with: code)
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        guard let account else {
            debugPrint("nono account")
            return .failed
        }
        
        let json = try buildUserDataJSON(email: email, nickname: nickname)
        let (profileJPEG, backgroundJPEG) = convertToJPEG(profileImage: profileImage, backgroundImage: backgroundImage)
        
        guard let (boundary, data) = buildMultipartFormData(
            id: account.id,
            userJSON: json,
            profileJPEG: profileJPEG,
            backgroundJPEG: backgroundJPEG
        ) else {
            debugPrint("AccountService->signUp: fail to build multipartFormData")
            return .failed
        }
        
        let accessToken = try await tokenUtility.fetchToken(for: .access)
        
        let router = AccountHTTPRequestRouter.modifyAccount(
            accessToken: accessToken,
            boundary: boundary,
            multipartData: data
        )
        
        let (code, fetchedAccount) = try await fetchAccountDTO(from: router)
        return determineStatus(from: fetchedAccount, with: code)
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        guard let account, let email = account.email else {
            throw AccountServiceError.unknownError(description: "이메일이 없습니다.")
        }
        
        let result = try await signUp(
            email: email,
            nickname: nickname,
            profileImage: profileImage,
            backgroundImage: backgroundImage,
            description: description
        )
        
        if case .ok(let user) = result {
            return user
        } else {
            throw AccountServiceError.unknownError(description: "알 수 없는 에러가 발생했습니다.")
        }
    }
    
    func signOut() async throws {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = AccountHTTPRequestRouter.signOut(accessToken: token)
        let _ = try await networkUtility.request(router: router)
        try await deleteAllTokens()
        resetStatus()
    }
    
    func deleteAccount() async throws {
        let token = try await tokenUtility.fetchToken(for: .access)
        let router = AccountHTTPRequestRouter.deleteAccount(accessToken: token)
        let _ = try await networkUtility.request(router: router)
        try await deleteAllTokens()
        resetStatus()
    }
    
    // MARK: Private Functions
    private func determineStatus(from account: AccountDTO, with code: Int) -> SignInStatus {
        if code == 200 {
            if account.email == nil || account.nickname == nil {
                return .created
            }
            
            let user = DetailUserUIO(account: account)
            updateStatus(with: user)
            return .ok(user: user)
        } else if code == 201 {
            return .created
        } else {
            return .failed
        }
    }
    
    private func fetchAccountDTO(from router: AccountHTTPRequestRouter) async throws -> (Int, AccountDTO) {
        let (code, data) = try await networkUtility.requestWithStatusCode(router: router)
        debugPrint("code: \(code)")
        debugPrint("Fetched account: \(String(data: data, encoding: .utf8)!)")
        
        do {
            let fetchedAccount = try decoder.decode(AccountDTO.self, from: data)
            account = fetchedAccount
            if code == 200 {
                NotificationCenter.default.post(name: .updateUserInfo, object: DetailUserUIO(account: fetchedAccount))
            }
            return (code, fetchedAccount)
        } catch {
            throw NetworkDecodeError(data: data)
        }
    }
    
    private func isRegistered(from account: AccountDTO) -> Bool {
        account.email != nil
    }
    
    private func storeToken(_ token: String?, for type: TokenUtility.TokenType) async throws {
        if let token {
            try await tokenUtility.storeToken(token, for: type)
        }
    }
    
    private func buildUserDataJSON(email: String, nickname: String) throws -> Data {
        try JSONSerialization.data(withJSONObject: [
            "email": email,
            "nickname": nickname,
        ])
    }
    
    private func buildMultipartFormData(id: Int, userJSON: Data, profileJPEG: Data?, backgroundJPEG: Data?) -> (String, Data)? {
        var builder = MultipartFormBuilder()
        
        builder.append(name: "userData", content: .json(data: userJSON))
        
        if let profileJPEG {
            builder.append(
                name: "profileImage",
                fileName: "user\(id)-\(UUID().uuidString)-profileImage.jpeg",
                content: .jpeg(data: profileJPEG)
            )
        }
        
        if let backgroundJPEG {
            builder.append(
                name: "backgroundImage",
                fileName: "user\(id)-\(UUID().uuidString)-backgroundImage.jpeg",
                content: .jpeg(data: backgroundJPEG)
            )
        }
        
        return builder.build()
    }
    
    private func convertToJPEG(profileImage: UIImage?, backgroundImage: UIImage?) -> (Data?, Data?) {
        let profileJPEG = profileImage?.jpegData(compressionQuality: 0.3)
        let backgroundJPEG = backgroundImage?.jpegData(compressionQuality: 0.5)
        
        return (profileJPEG, backgroundJPEG)
    }
    
    private func deleteAllTokens() async throws {
        try await tokenUtility.deleteToken(for: .access)
        try await tokenUtility.deleteToken(for: .refresh)
    }
    
    private func resetStatus() {
        NotificationCenter.default.post(name: .updateUserInfo, object: nil)
        NotificationCenter.default.post(name: .updateSignInStatus, object: SignInStatus.failed)
    }
    
    private func updateStatus(with user: DetailUserUIO) {
        NotificationCenter.default.post(name: .updateUserInfo, object: user)
    }
}

private struct NetworkDecodeError: Error, LocalizedError {
    let dataString: String?
    
    init(data: Data) {
        self.dataString = String(data: data, encoding: .utf8)
    }
    
    var errorDescription: String? {
        dataString
    }
}
