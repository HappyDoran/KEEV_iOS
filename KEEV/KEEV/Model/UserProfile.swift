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
    var description: String = ""
}
