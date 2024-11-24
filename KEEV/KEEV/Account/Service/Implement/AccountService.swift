//
//  AccountService.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

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
    private var keychainUtility = TokenKeyChainUtility()
    
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


extension AccountService {
    
    // 자동 로그인을 하는 함수
    func autoSignIn() async throws{
        // 키체인에서 리프레시 토큰을 가져온다.
        let refreshToken = try await getRefreshToken()
        
        
        // 이거를 서버로 보내서 검사를 받는다.(refreshAccessToken)
        // TODO: 서버 호출 코드
        
        // 그렇다면 자동 로그인을 할 때는, accessToken이 Keychain에 있으면 된다?
        
        // 성공하면 account에 값을 할당한다.
        // 실패하면 로그인 뷰로 넘어가게 안내해주기만 하면 됨.
    }
    
    // 애플로 로그인 하고 Identity Token, Authorization Code, user을 보내고 서버한테 detailUser를 받아오는 함수
    func signIn(identityToken: String, authorizationCode: String, user: String) async throws  {
        // Apple 인증에 성공하면 Identity Token, Authorization Code, user를 받아온다. 이걸 가지고 서버에 요청한다.
        // TODO: 서버 호출 코드
        
        // 서버가 200을 반환하면:
        let detailUser =  DetailUserUIO(detailuserDTO:
                                            UserDTO(id: Int.random(in: 1...100),
                                                    nickname: userProfile.nickname,
                                                    profileImageURL: nil,
                                                    backgroundImageURL: nil,
                                                    description: nil,
                                                    signupDate: Date()
                                                   )) // 목업 데이터
        let email = "user@example.com" // 목업 데이터
        let accessToken = "mockAccessToken" // 목업 데이터
        let refreshToken = "mockRefreshToken" // 목업 데이터
        
        // Access Token, Refresh Token, email을 KeyChain에 저장한다.
        try await saveAccessToken(accessToken)
        try await saveRefreshToken(refreshToken)
        
        // user는 detailUser에 넣어준다.
        // NotificationCenter를 활용해 User값이 바뀌었음을 전역적으로 알린다.
    }
    
    // Profile을 서버에 보내는 함수
    func signUp(userProfile: UserProfile) async throws {
        // 서버가 201을 반환하면, 사용자는 Email과 Nickname을 입력한다.
        // TODO: 서버 호출 코드
        
        // 서버가 성공적으로 회원 가입을 처리하면:
        let email = "newuser@example.com" // 목업 데이터
        let accessToken = "mockAccessToken" // 목업 데이터
        let refreshToken = "mockRefreshToken" // 목업 데이터
        
        // Access Token, Refresh Token, email을 KeyChain에 저장한다.
        try await saveAccessToken(accessToken)
        try await saveRefreshToken(refreshToken)
        
        // user는 detailUser에 넣어준다.
        // NotificationCenter를 활용해 User값이 바뀌었음을 전역적으로 알린다.
        // 완료되면 EntityView로 Navigation 이동한다.
    }
    
    // Access Token 갱신 요청 함수
    func refreshAccessToken() async throws {
        // refreshAccessToken을 통해 Access Token을 가져온다.
        // TODO: 서버 호출 코드
        
        // 만약 Unauthorized 응답이 반환되면:
        // Access Token이 만료된 경우: Refresh Token을 서버에 보내어 새로운 Access Token을 요청한다.
        let newAccessToken = "newMockAccessToken" // 목업 데이터
        
        // 받은 Access Token을 Keychain에 저장한다.
        try await saveAccessToken(newAccessToken)
    }
    
    // 로그아웃 함수
    func signOut() async throws {
        // 키체인의 Access Token, Refresh Token, email을 지운다.
        // TODO: 키체인 삭제 코드
        
        // 서버에 헤더로 Access Token을 보내면 서버에서의 Access Token과 Refresh Token을 삭제한다.
        // TODO: 서버 호출 코드
    }
    
    // 회원탈퇴 함수
    func goodBye() async throws {
        // 키체인의 Access Token, Refresh Token, email을 지운다.
        // TODO: 키체인 삭제 코드
        
        // 서버에 헤더로 Access Token을 보내면 서버에서의 연관 테이블을 삭제 한다.
        // TODO: 서버 호출 코드
    }
    
    //키체인에서 엑세스 토큰 가져오는 함수
    private func getAccessToken() async throws -> String {
        guard let accessTokenData = keychainUtility.read(tokenTag: "accessToken"),
              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
            print("Access token not found.")
            throw TokenKeyChainError.NotFound
        }
        
        return accessToken
    }
    
    //키체인에서 리프레시 토큰 가져오는 함수
    private func getRefreshToken() async throws -> String {
        guard let refreshTokenData = keychainUtility.read(tokenTag: "refreshToken"),
              let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
            print("Refresh token not found.")
            throw TokenKeyChainError.NotFound
        }
        
        return refreshToken
    }
    
    // 키체인에 액세스 토큰 저장하는 함수
    private func saveAccessToken(_ accessToken: String) async throws {
        try keychainUtility.create("accessToken", tokenTag: accessToken)
    }
    
    // 키체인에 리프레시 토큰 저장하는 함수
    private func saveRefreshToken(_ refreshToken: String) async throws {
        try keychainUtility.create("refreshToken", tokenTag: refreshToken)
    }
    
}
