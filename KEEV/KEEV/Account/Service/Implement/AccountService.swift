import Foundation
import UIKit

final class AccountService: AccountServiceProtocol, KEEVErrorHandler {
    typealias Layer = AccountService
    
    static var layer: LayerType = .service(of: "AccountService")
    
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
            return .failed
        }
        
        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
            try? KeyChain.delete(tag: Self.refreshTokenTag)
            return .failed
        }
        
        do {
            let (code, fetchedAccount) = try await fetchAccountDTO(from: .refreshAccessToken(refreshToken: tokenString))
            try await doAsyncWithException(caller: "autoSignIn") {
                try await storeToken(fetchedAccount.accessToken, for: .access)
            }
            return determineStatus(from: fetchedAccount, with: code)
        } catch {
            return .failed
        }
    }
    
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        try await doAsyncWithException(caller: "signInWithApple") {
            let (code, fetchedAccount) = try await fetchAccountDTO(from: .signInWithApple(code: authorizationCode))
        
            try await storeToken(fetchedAccount.accessToken, for: .access)
            try await storeToken(fetchedAccount.keevRefreshToken, for: .refresh)
            
            return determineStatus(from: fetchedAccount, with: code)
        }
        
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        guard let account else {
            return .failed
        }
        
        return try await doAsyncWithException(
            caller: "signUp"
        ) {
            let json = try buildUserDataJSON(email: email, nickname: nickname, description: description)
            let (profileJPEG, backgroundJPEG) = convertToJPEG(profileImage: profileImage, backgroundImage: backgroundImage)
            
            guard let (boundary, data) = buildMultipartFormData(
                id: account.id,
                userJSON: json,
                profileJPEG: profileJPEG,
                backgroundJPEG: backgroundJPEG
            ) else {
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
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        guard let account, let email = account.email else {
            NotificationCenter.default.post(name: .updateUserInfo, object: nil)
            NotificationCenter.default.post(name: .updateSignInStatus, object: SignInStatus.failed)
            throw KEEVError(
                layer: Self.layer,
                caller: "updateProfile",
                occurPoint: .local(description: "NO ACCOUNT"),
                previousError: nil
            )
        }
        
        let result = try await doAsyncWithException(
            caller: "updateProfile"
        ) {
            try await signUp(
                email: email,
                nickname: nickname,
                profileImage: profileImage,
                backgroundImage: backgroundImage,
                description: description
            )
        }
        
        if case .ok(let user) = result {
            return user
        } else {
            throw KEEVError(
                layer: Self.layer,
                caller: "updateProfile",
                occurPoint: .local(description: "FAILED TO UPDATE PROFILE"),
                previousError: nil
            )
        }
    }
    
    func signOut() async throws {
        try await doAsyncWithException(caller: "signOut()") {
            let token = try await tokenUtility.fetchToken(for: .access)
            let router = AccountHTTPRequestRouter.signOut(accessToken: token)
            let _ = try await networkUtility.request(router: router)
            try await deleteAllTokens()
            resetStatus()
        }
    }
    
    func deleteAccount() async throws {
        try await doAsyncWithException(caller: "deleteAccount()") {
            let token = try await tokenUtility.fetchToken(for: .access)
            let router = AccountHTTPRequestRouter.deleteAccount(accessToken: token)
            let _ = try await networkUtility.request(router: router)
            try await deleteAllTokens()
            resetStatus()
        }
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
        
        guard (200..<300).contains(code) else {
            let error = try decoder.decode(ErrorMessageDTO.self, from: data)
            throw KEEVError(
                layer: Self.layer,
                caller: "fetchAccountDTO(from router: AccountHTTPRequestRouter)",
                occurPoint: .remote(code: code, message: error.message),
                previousError: nil
            )
        }
        
        let fetchedAccount = try decoder.decode(AccountDTO.self, from: data)
        account = fetchedAccount
        
        if code == 200 {
            NotificationCenter.default.post(name: .updateUserInfo, object: DetailUserUIO(account: fetchedAccount))
        }
        
        
        return (code, fetchedAccount)
    }
    
    private func isRegistered(from account: AccountDTO) -> Bool {
        account.email != nil
    }
    
    private func storeToken(_ token: String?, for type: TokenUtility.TokenType) async throws {
        if let token {
            try await tokenUtility.storeToken(token, for: type)
        }
    }
    
    private func buildUserDataJSON(email: String, nickname: String, description: String) throws -> Data {
        if !description.isEmpty {
            return try JSONSerialization.data(withJSONObject: [
                "email": email,
                "nickname": nickname,
                "description": description
            ])
        } else {
            return try JSONSerialization.data(withJSONObject: [
                "email": email,
                "nickname": nickname,
            ])
        }
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
