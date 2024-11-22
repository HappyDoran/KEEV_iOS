//
//  AccountServiceProtocol.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

/// AccountService를 구현하기 위한 프로토콜
///
/// AccountService를 구현하기 위한 프로토콜입니다.
///
/// - Todo: 키체인을 활용한 토큰 저장 기능 추가해야합니다.
///
/// - Todo: 서버로부터 사용자 프로필을 받아오고, 사용자 프로필을 서버로 전송하는 함수를 추가해야합니다.
///
/// - Note: ObservableObject로 구현되어있으므로 회원가입에서 사용할 때 StateObject나 ObservedObject로 사용하면 됩니다.
/// - Author: 라움
protocol AccountServiceProtocol: ObservableObject {
    var userProfile: UserProfile { get }
    var email: String { get }
    var nickname: String { get }
    var profileImage: UIImage? { get }
    var backgroundImage: UIImage? { get }
    var description: String { get }
    
    func setUserProfile(_ newUserProfile: UserProfile)
    
    func isValidEmail(_ email: String) -> Bool
    func checkEmailValidity(_ email: String) throws
    func isValidNickname(_ nickname: String) -> Bool
    func checkNicknameValidity(_ nickname: String) throws
    
    func autoLogin() -> Void
    func login(identityToken: String, authorizationCode: String, user: String) -> Void
    func sendProfile(userProfile: UserProfile) -> Void
    func refreshAccessToken() -> Void
    func logout() -> Void
    func goodBye() -> Void
}
