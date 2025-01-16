//
//  MockAccountService.swift
//  KEEV
//
//  Created by 김준성 on 11/27/24.
//

import Foundation
import UIKit

final class MockAccountService: AccountServiceProtocol {
    static let layer: LayerType = .service(of: "MockAccountService")
    
    private var userInfo: DetailUserUIO? = nil
    private var email: String? = nil
    
    
    func autoSignIn() async -> SignInStatus {
//        .failed
        .ok(user: .dummy0)
    }
    
    func signInWithApple(email: String?, user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        let userInfo = """
        email: \(email!)\n--------\n
        user: \(user)\n--------\n
        token: \(String(data: identityToken, encoding: .utf8)!)\n--------\n
        code: \(String(data: authorizationCode, encoding: .utf8)!)\n--------\n
"""
        
        debugPrint(userInfo)
        UIPasteboard.general.string = userInfo
        
        return .created
    }
    
    func signUp(email: String?, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> SignInStatus {
        self.email = email
        let dummy = DetailUserUIO.dummy4
        let id = dummy.id
        let profileImageURL = profileImage == nil ? nil : dummy.profileImageURL
        let backgroundImageURL = backgroundImage == nil ? nil : dummy.backgroundImageURL
        return .ok(user: .init(id: id, nickname: nickname, profileImageURL: profileImageURL, backgroundImageURL: backgroundImageURL, description: description))
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String) async throws -> DetailUserUIO {
        let dummy = DetailUserUIO.dummy4
        let id = dummy.id
        let profileImageURL = profileImage == nil ? nil : dummy.profileImageURL
        let backgroundImageURL = backgroundImage == nil ? nil : dummy.backgroundImageURL
        return .init(id: id, nickname: nickname, profileImageURL: profileImageURL, backgroundImageURL: backgroundImageURL, description: description)
    }
    
    func signOut() async throws {
        guard email != nil, userInfo != nil else { throw AccountServiceError.unknownError(description: "이미 로그아웃 되었습니다.") }
        email = nil
        userInfo = nil
    }
    
    func deleteAccount() async throws {
        guard email != nil, userInfo != nil else { throw AccountServiceError.unknownError(description: "탈퇴할 계정이 없습니다.") }
        email = nil
        userInfo = nil
    }
}
