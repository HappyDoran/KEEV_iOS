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
/// - Todo: 회원가입 과정 마지막에서 회원정보를 저장하는 함수를 추가해야합니다.
///
/// - Note: ObservableObject로 구현되어있으므로 회원가입에서 사용할 때 StateObject나 ObservedObject로 사용하면 됩니다.
/// - Author: 라움
protocol AccountServiceProtocol: ObservableObject {
    var userProfile: UserProfile { get }
    
    func getEmail() -> String
    func setEmail(_ email: String)
    func checkEmailValidity(checkEmpty: Bool) -> Bool
    
    func getNickname() -> String
    func setNickname(_ nickname: String)
    func checkNicknameValidity(checkEmpty: Bool) -> Bool
    
    func getProfileImage() -> UIImage?
    func setProfileImage(_ image: UIImage?)
    
    func getBackgroundImage() -> UIImage?
    func setBackgroundImage(_ image: UIImage?)
    
    func getDescription() -> String?
    func setDescription(_ description: String?)
}
