//
//  AccountService.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

/// 회원가입 과정에서 사용자 정보를 처리하는 Service
///
/// 회원가입 과정에서의 사용자 정보를 처리하는 Service입니다.
///
/// - Todo: 키체인을 활용한 토큰 저장 기능 추가해야합니다.
///
/// - Todo: 서버로부터 사용자 프로필을 받아오고, 사용자 프로필을 서버로 전송하는 함수를 추가해야합니다.
///
/// - Note: ObservableObject로 구현되어있으므로 회원가입에서 사용할 때 StateObject나 ObservedObject로 사용하면 됩니다.
/// - Author: 라움
class AccountService: AccountServiceProtocol {
    /// 회원가입 과정에서의 사용자 정보가 담기는 UserProfile 구조체입니다.
    private(set) var userProfile: UserProfile = UserProfile()
    
    /// 사용자 이메일을 리턴하는 연산 프로퍼티
    ///
    /// 사용자 이메일을 리턴하는 연산 프로퍼티입니다.
    /// - Author: 라움
    var email: String {
        return userProfile.email
    }
    
    /// 사용자 닉네임을 리턴하는 연산 프로퍼티
    ///
    /// 사용자 닉네임을 리턴하는 연산 프로퍼티입니다.
    /// - Author: 라움
    var nickname: String {
        return userProfile.nickname
    }
    
    /// 사용자 프로필 사진을 리턴하는 연산 프로퍼티
    ///
    /// 사용자 프로필 사진을 리턴하는 연산 프로퍼티입니다.
    /// - Author: 라움
    var profileImage: UIImage? {
        return userProfile.profileImage
    }
    
    /// 사용자 배경 이미지를 리턴하는 연산 프로퍼티
    ///
    /// 사용자 배경 이미지를 리턴하는 연산 프로퍼티입니다.
    /// - Author: 라움
    var backgroundImage: UIImage? {
        return userProfile.backgroundImage
    }
    
    /// 사용자 한 줄 소개를 리턴하는 연산 프로퍼티
    ///
    /// 사용자 한 줄 소개를 리턴하는 연산 프로퍼티입니다.
    /// - Author: 라움
    var description: String {
        return userProfile.description
    }
    
    /// Apple ID에 대한 인증 요청을 하는 함수
    ///
    /// - Parameters:
    ///   - request: 애플 로그인
    ///
    /// Apple ID에 대한 인증 요청을 하는 함수입니다.
    ///
    /// - Author: 라움
    func signInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = []
    }
    
    /// 로그인 성공 시 호출되는 handler
    ///
    /// - Parameters:
    ///   - result: 애플 로그인 결과
    ///
    /// 로그인 성공 시 호출되는 handler입니다.
    ///
    /// - Author: 라움
    func signInHandler(result: Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            
            print("User: \(credential.user)")
            if let authCode = String(data: credential.authorizationCode!, encoding: .utf8) {
                print("Authorization code: \(authCode)")
            }
            if let identityToken = String(data: credential.identityToken!, encoding: .utf8) {
                print("Identity token: \(identityToken)")
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    /// 사용자의 프로필을 새로운 프로필로 업데이트하는 함수
    ///
    /// - Parameters:
    ///   - newUserProfile: 새로운 프로필
    ///
    /// 사용자의 프로필을 새로운 프로필로 업데이트하는 함수입니다.
    ///
    /// - Author: 라움
    func setUserProfile(_ newUserProfile: UserProfile) {
        userProfile = newUserProfile
    }
    
    /// 이메일 형식을 확인하는 static 함수
    ///
    /// - Parameters:
    ///   - email: 형식을 확인할 이메일
    ///
    /// 정규표현식과 비교하여 입력한 이메일이 이메일 형식과 맞는지 유효성을 확인합니다.
    ///
    /// - Returns: 이메일 형식이 맞으면 true, 아니면 false 값을 리턴합니다.
    ///
    /// - Author: 라움
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// 입력된 이메일의 형식이 타당한지 확인하는 함수
    ///
    /// - Parameters:
    ///   - email: 형식을 확인할 이메일
    ///
    /// 입력된 이메일의 형식이 타당한지 확인하는 함수입니다.
    ///
    /// - Throws: 이메일 형식이 타당하지 않을 경우 에러를 throw
    ///
    /// - Author: 라움
    func checkEmailValidity(_ email: String) throws {
        if email.isEmpty {
            throw AccountError.empty
        } else if !isValidEmail(email) {
            throw AccountError.inValidEmail
        }
    }
        
    /// 닉네임에 특수문자가 포함되어있는지 확인하는 프로퍼티
    ///
    /// - Parameters:
    ///   - nickname: 특수문자가 포함되어있는지 확인할 닉네임
    ///
    /// 정규표현식과 비교하여 입력한 닉네임에 특수문자가 포함되어있는지 유효성을 확인합니다.
    ///
    /// - Returns: 특수문자가 포함되어있지 않으면 true, 포함되어 있으면 false를 리턴합니다.
    ///
    /// - Author: 라움
    func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ가-힣A-Za-z0-9]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: nickname)
    }
    
    /// 입력된 닉네임이 타당한지 확인하는 함수
    ///
    /// - Parameters:
    ///   - nickname: 특수문자가 포함되어있는지 확인할 닉네임
    ///
    /// 입력된 닉네임이 타당한지 확인하는 함수입니다.
    ///
    /// - Throws: 닉네임 형식이 타당하지 않을 경우 에러를 throw
    ///
    /// - Author: 라움
    func checkNicknameValidity(_ nickname: String) throws {
        if nickname.isEmpty {
            throw AccountError.empty
        } else if !isValidNickname(nickname) {
            throw AccountError.inValidNickname
        }
    }
}

enum AccountError: String, Error {
    case empty
    case inValidEmail
    case inValidNickname
}

extension AccountError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return ""
        case .inValidEmail:
            return "이메일의 형식이 올바르지 않습니다."
        case .inValidNickname:
            return "특수문자가 포함되어 있습니다."
        }
    }
}
