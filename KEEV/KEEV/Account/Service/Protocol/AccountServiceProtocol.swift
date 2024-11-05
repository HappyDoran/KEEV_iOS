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
    var isValidEmail: Bool { get }
    var nickname: String { get }
    var isValidNickname: Bool { get }
    var profileImage: UIImage? { get }
    var backgroundImage: UIImage? { get }
    var description: String? { get }
    
    func setUserProfile(_ newUserProfile: UserProfile)
    func checkEmailValidity() throws
    func checkNicknameValidity() throws
}
