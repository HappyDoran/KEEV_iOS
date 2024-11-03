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
    // 회원가입 과정에서의 사용자 정보가 담기는 UserProfile 구조체입니다.
    @Published var userProfile: UserProfile = UserProfile()
}
