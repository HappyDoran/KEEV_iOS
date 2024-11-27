//
//  AccountServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import UIKit


/// AccountService를 구현하기 위한 프로토콜
///
/// AccountService를 구현하기 위한 프로토콜입니다.
///
/// - Note: AnyObject를 상속 받아, 참조 타입으로만 만들어야 합니다.
/// - Author: 뉴준성
protocol AccountServiceProtocol: AnyObject {
    /// 자동 로그인을 하는 함수.
    ///
    /// 토큰를 서버에 보내, 자동로그인을 시도합니다.
    ///
    /// - Throws: JWT가 만료되었거나 서버와의 통신이 불안정할 경우 에러를 던집니다.
    /// - Returns: JWT를 통하여 로그인에 성공하면 `DetailUserUIO`을 반환합니다.
    /// - Author: newJunsung
    func autoSignIn() async throws -> DetailUserUIO
    
    /// 애플 로그인을 위한 함수.
    ///
    /// - Parameters:
    ///   - user: 사용자의 고유 ID입니다.
    ///   - identityToken: 토큰입니다.
    ///   - authorizationCode: 코드입니다.
    ///
    /// 애플 로그인을 하기 위한 정보를 서버로 넘깁니다.
    /// 각 파라미터의 이름과 타입은 `ASAuthorizationAppleIDCredential`의 프로퍼티와 동일합니다.
    ///
    /// - Throws: 서버와 통신을 실패했을 때, 에러를 리턴합니다.
    /// - Returns: 회원가입이 된 상태라면 `.ok`와 함께 `DetailUserUIO`를, 회원가입이 되지 않은 상태라면 `.created`를 반환합니다.
    /// - Author: newJunsung
    func signInWithApple(user: String, identityToken: Data, authorizationCode: Data) async throws -> SignInStatus
    
    /// 회원가입 정보를 넣는 함수.
    ///
    /// - Parameters:
    ///   - email: 유저가 쓸 이메일 입니다.
    ///   - nickname: 유저가 쓸 닉네임 입니다.
    ///   - profileImage: 프로필 사진이며 사용자가 사진을 넣지 않았을 경우, `nil`을 넣으면 됩니다..
    ///   - backgroundImage: 프로필의 배경화면이며 사용자가 배경화면을 넣지 않았을 경우, `nil`을 넣으면 됩니다.
    ///   - description: 한 줄 소개이며, 빈 값일 경우 `nil`을 넣으면 됩니다.
    ///
    /// 회원 정보를 서버로 넘겨 회원가입을 진행합니다.
    ///
    /// - Throws: 이메일과 닉네임이 정해진 형식을 지키지 않았거나 서버에 중복된 이메일 또는 닉네임이 있을 때, 그리고 서버와 통신을 실패했을 때 에러를 던집니다.
    /// - Returns: 회원정보가 서버에 등록이 된다면 그 값을 `DetailUserUIO`로 다시 리턴받습니다.
    /// - Author: newJunsung
    func signUp(
        email: String,
        nickname: String,
        profileImage: UIImage?,
        backgroundImage: UIImage?,
        description: String?
    ) async throws -> DetailUserUIO
    
    /// 회원가입 정보를 넣는 함수.
    ///
    /// - Parameters:
    ///   - nickname: 유저가 쓸 닉네임 입니다.
    ///   - profileImage: 프로필 사진이며 사용자가 사진을 넣지 않았을 경우, `nil`을 넣으면 됩니다..
    ///   - backgroundImage: 프로필의 배경화면이며 사용자가 배경화면을 넣지 않았을 경우, `nil`을 넣으면 됩니다.
    ///   - description: 한 줄 소개이며, 빈 값일 경우 `nil`을 넣으면 됩니다.
    ///
    /// 회원 정보를 서버로 넘겨 회원가입을 진행합니다.
    ///
    /// - Throws: 닉네임이 정해진 형식을 지키지 않았거나 서버에 중복된 이메일 또는 닉네임이 있을 때, 그리고 서버와 통신을 실패했을 때 에러를 던집니다.
    /// - Returns: 회원정보가 서버에서 변경이 된다면 그 값을 `DetailUserUIO`로 다시 리턴받습니다.
    /// - Author: newJunsung
    func updateProfile(
        nickname: String,
        profileImage: UIImage?,
        backgroundImage: UIImage?,
        description: String?
    ) async throws -> DetailUserUIO
    
    /// 이메일이 형식에 맞는지 검사하는 함수
    func isValidEmail(_ email: String) throws
    
    /// 닉네임이 형식에 맞는지 검사하는 함수
    func isValidNickname(_ nickname: String) throws
    
    /// 로그아웃을 시도합니다.
    func signOut() async throws
    
    /// 서버로부터 계정 탈퇴를 시도합니다.
    func deleteAccount() async throws
}

extension AccountServiceProtocol {
    func isValidEmail(_ email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            throw AccountServiceError.invalidEmail
        }
    }

    func isValidNickname(_ nickname: String) throws {
        let nicknameRegex = "^[ㄱ-ㅎ가-힣A-Za-z0-9]{1,}$"
        if !NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: nickname) {
            throw AccountServiceError.invalidNickname
        }
    }
}

/// 로그인을 시도하고 난 뒤, 받는 결과 값입니다.
///
/// ok의 경우, 서버에 회원정보가 있어 로그인이 성공했을 때이며,
///
/// created의 경우, 서버에 회원정보가 없어 회원가입이 필요한 경우 입니다.
///
/// - Author: newJunsung
enum SignInStatus: Hashable {
    static func == (lhs: SignInStatus, rhs: SignInStatus) -> Bool {
        if case .ok(let l) = lhs, case .ok(let r) = rhs { return l.id == r.id }
        if case .created = lhs, case .created = rhs { return true }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .created: hasher.combine(self)
        case .ok(_): hasher.combine(self)
        }
    }
    
    case ok(user: DetailUserUIO)
    case created
}

/// AccountService에서 발생할 수 있는 에러
enum AccountServiceError: Error {
    /// 토큰이 만료되었을 때.
    case expiredToken
    
    /// 이메일 형식이 옳지 않을 때
    case invalidEmail
    
    /// 닉네임 형식이 올바르지 않을 때
    case invalidNickname
    
    /// 이메일이 이미 존재할 때
    case alreadyExsistEmail
    
    /// 닉네임이 이미 존재할 때
    case alreadyExsistNickname
    
    /// 이외의 모든 에러
    case unknownError(description: String)
}

extension AccountServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .expiredToken: return "Token 만료"
        case .invalidEmail: return "이메일 형식이 올바르지 않습니다."
        case .invalidNickname: return "닉네임 형식이 올바르지 않습니다."
        case .alreadyExsistEmail: return "이미 존재하는 이메일입니다."
        case .alreadyExsistNickname: return "이미 존재하는 닉네임입니다."
        case .unknownError(_): return "알 수 없는 에러가 발생했습니다."
        }
    }
}
