//
//  MockAccountService.swift
//  KEEV
//
//  Created by 김준성 on 11/27/24.
//

import Foundation
import UIKit

final class MockAccountService: AccountServiceProtocol {
    private var userInfo: DetailUserUIO? = nil
    private var email: String? = nil
    
    
    func autoSignIn() async throws -> DetailUserUIO {
        userInfo = .dummy4
        email = "test@test.com"
        return userInfo!
    }
    
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus {
        self.userInfo = .dummy4
        email = "test@test.com"
        return .ok(user: userInfo!)
    }
    
    func signUp(email: String, nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String?) async throws -> DetailUserUIO {
        self.email = email
        let dummy = DetailUserUIO.dummy4
        let id = dummy.id
        let profileImageURL = profileImage == nil ? nil : dummy.profileImageURL
        let backgroundImageURL = backgroundImage == nil ? nil : dummy.backgroundImageURL
        return .init(id: id, nickname: nickname, profileImageURL: profileImageURL, backgroundImageURL: backgroundImageURL, description: description)
    }
    
    func updateProfile(nickname: String, profileImage: UIImage?, backgroundImage: UIImage?, description: String?) async throws -> DetailUserUIO {
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
