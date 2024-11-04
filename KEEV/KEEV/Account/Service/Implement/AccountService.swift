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
/// - Todo: 키체인을 활용한 토큰 저장 기능 추가해야합니다.
///
/// - Todo: 서버로부터 사용자 프로필을 받아오고, 사용자 프로필을 서버로 전송하는 함수를 추가해야합니다.
///
/// - Note: ObservableObject로 구현되어있으므로 회원가입에서 사용할 때 StateObject나 ObservedObject로 사용하면 됩니다.
/// - Author: 라움
class AccountService: AccountServiceProtocol {
    /// 회원가입 과정에서의 사용자 정보가 담기는 UserProfile 구조체입니다.
    private(set) var userProfile: UserProfile = UserProfile()
    
    /// 사용자의 프로필을 리턴하는 함수
    ///
    /// 사용자의 프로필을 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 프로필
    ///
    /// - Author: 라움
    func getUserProfile() -> UserProfile {
        return userProfile
    }
    
    /// 사용자의 프로필을 새로운 프로필로 업데이트하는 함수
    ///
    /// - Parameters:
    ///   - newUserProfile: 새로운 프로필
    ///
    /// 사용자의 프로필을 새로운 프로필로 업데이트하는 함수입니다.
    ///
    /// - Author: 라움
    func setUserProfile(newUserProfile: UserProfile) {
        userProfile = newUserProfile
    }
    
    /// 사용자의 이메일을 리턴하는 함수
    ///
    /// 사용자의 이메일을 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 이메일
    ///
    /// - Author: 라움
    func getEmail() -> String {
        return userProfile.email
    }
    
    /// 사용자의 닉네임을 리턴하는 함수
    ///
    /// 사용자의 닉네임을 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 닉네임
    ///
    /// - Author: 라움
    func getNickname() -> String {
        return userProfile.nickname
    }
    
    /// 사용자의 프로필 사진을 리턴하는 함수
    ///
    /// 사용자의 프로필 사진을 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 프로필 사진
    ///
    /// - Author: 라움
    func getProfileImage() -> UIImage? {
        return userProfile.profileImage
    }
    
    /// 사용자의 배경 이미지를 리턴하는 함수
    ///
    /// 사용자의 배경 이미지를 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 배경 이미지
    ///
    /// - Author: 라움
    func getBackgroundImage() -> UIImage? {
        return userProfile.backgroundImage
    }
    
    /// 사용자의 한 줄 소개를 리턴하는 함수
    ///
    /// 사용자의 한 줄 소개를 리턴하는 함수입니다.
    ///
    /// - Returns: 사용자의 한 줄 소개
    ///
    /// - Author: 라움
    func getDescription() -> String? {
        return userProfile.description
    }
}
