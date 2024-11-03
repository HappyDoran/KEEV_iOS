//
//  AccountService.swift
//  KEEV
//
//  Created by Yune Cho on 11/2/24.
//

import Foundation
import SwiftUI

/// 회원가입 과정에서 사용자 정보를 처리하는 Service
///
/// 회원가입 과정에서의 사용자 정보를 처리하는 Service입니다.
///
/// - Note: ObservableObject로 구현되어있으므로 회원가입에서 사용할 때 StateObject나 ObservedObject로 사용하면 됩니다.
/// - Author: 라움
class AccountService: AccountServiceProtocol {
    /// 회원가입 과정에서의 사용자 정보가 담기는 UserProfile 구조체입니다.
    @Published private(set) var userProfile: UserProfile = UserProfile()
    
    /// 사용자의 이메일을 리턴하는 함수입니다.
    func getEmail() -> String {
        return userProfile.email
    }
    
    /// 입력된 이메일을 인자로 받아서 사용자의 이메일을 설정하는 함수입니다.
    func setEmail(_ typedEmail: String) {
        userProfile.email = typedEmail
    }
    
    /// 사용자의 닉네임을 리턴하는 함수입니다.
    func getNickname() -> String {
        return userProfile.nickname
    }
    
    /// 입력된 닉네임을 인자로 받아서 사용자의 닉네임을 설정하는 함수입니다.
    func setNickname(_ typedNickname: String) {
        userProfile.nickname = typedNickname
    }
    
    /// 사용자의 프로필 사진을 리턴하는 함수입니다.
    func getProfileImage() -> UIImage? {
        return userProfile.profileImage
    }
    
    /// 선택된 프로필 사진을 인자로 받아서 사용자의 프로필 사진을 설정하는 함수입니다.
    func setProfileImage(_ selectedImage: UIImage?) {
        userProfile.profileImage = selectedImage
    }
    
    /// 사용자의 배경 이미지를 리턴하는 함수입니다.
    func getBackgroundImage() -> UIImage? {
        return userProfile.backgroundImage
    }
    
    /// 선택된 배경 이미지를 인자로 받아서 사용자의 배경 이미지를 설정하는 함수입니다.
    func setBackgroundImage(_ selectedImage: UIImage?) {
        userProfile.backgroundImage = selectedImage
    }
    
    /// 사용자의 한 줄 소개를 리턴하는 함수입니다.
    func getDescription() -> String? {
        return userProfile.description
    }
    
    /// 입력된 한 줄 소개를 인자로 받아서 사용자의 한 줄 소개를 설정하는 함수입니다.
    func setDescription(_ typedDescription: String?) {
        userProfile.description = typedDescription
    }
}
