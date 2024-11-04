//
//  UserProfile.swift
//  KEEV
//
//  Created by Yune Cho on 11/3/24.
//

import Foundation
import SwiftUI

/// 사용자의 정보를 관리하는 모델
///
/// 사용자의 정보를 관리하는 모델(구조체)입니다.
///
/// 사용자의 이메일, 닉네임, 프로필 사진, 배경 이미지, 한 줄 소개로 구성되어 있습니다.
///
/// - Author: 라움
struct UserProfile {
    /// 사용자 이메일
    var email: String = ""
    /// 사용자 닉네임
    var nickname: String = ""
    /// 사용자 프로필 사진
    var profileImage: UIImage?
    /// 사용자 배경 이미지
    var backgroundImage: UIImage?
    /// 사용자 한 줄 소개
    var description: String?
}

extension UserProfile {
    /// 입력된 이메일의 형식이 타당한지 확인하는 함수
    ///
    /// - Parameters:
    ///   - checkEmpty: 공백 확인 여부
    ///
    /// 입력된 이메일의 형식이 타당한지 확인하는 함수입니다.
    ///
    /// - Returns: 이메일 형식이 타당할 경우 true, 아닐 경우 false를 리턴
    ///
    /// - Author: 라움
    func checkEmailValidity(checkEmpty: Bool) -> Bool {
        switch checkEmpty {
        case true:
            if !self.email.isEmpty && self.email.isValidEmail  {
                return true
            } else {
                return false
            }
        case false:
            if self.email.isEmpty {
                return true
            } else {
                if self.email.isValidEmail  {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    /// 입력된 닉네임이 타당한지 확인하는 함수
    ///
    /// - Parameters:
    ///   - checkEmpty: 공백 확인 여부
    ///
    /// 입력된 닉네임이 타당한지 확인하는 함수입니다.
    ///
    /// - Returns: 닉네임이 타당할 경우 true, 아닐 경우 false를 리턴
    ///
    /// - Author: 라움
    func checkNicknameValidity(checkEmpty: Bool) -> Bool {
        switch checkEmpty {
        case true:
            if !self.nickname.isEmpty && self.nickname.isValidNickname {
                return true
            } else {
                return false
            }
        case false:
            if self.nickname.isEmpty {
                return true
            } else {
                if self.nickname.isValidNickname {
                    return true
                } else {
                    return false
                }
            }
        }
    }
}
