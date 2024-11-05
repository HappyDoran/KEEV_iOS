//
//  SignUpScreen.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

enum SignUpPage: Int {
    case email = 1
    case profile = 2
    case complete = 3
}

/// 회원가입 화면
///
/// 회원가입 화면으로 최상단의 회원가입 인디케이터, 본문 뷰로 구성되어있습니다.
///
/// - Author: 라움
struct SignUpScreen: View {
    @StateObject private var accountService = AccountService()
    
    @State private var userProfile: UserProfile = UserProfile()
    @State private var currentPage: SignUpPage = .email
    @State private var transitionDirection: Edge = .trailing
    @State private var showActionSheet = false
    @State private var showImageSelectSheet = false
    
    var body: some View {
        VStack {
            SignUpIndicator(currentPage: $currentPage, transitionDirection: $transitionDirection)
            
            signUpProcess()
                .transition(.asymmetric(
                    insertion: .move(edge: transitionDirection),
                    removal: .opacity)
                )
                .animation(.easeInOut, value: currentPage)
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(
            isPresented: $showActionSheet,
            defaults: .setProfileImage(
                modifyHandler: {
                    showImageSelectSheet = true
                    showActionSheet = false
                }, deleteHandler: {
                    userProfile.profileImage = nil
                    showActionSheet = false
                }))
        .fullScreenCover(isPresented: $showImageSelectSheet) {
            ImageSelectView(image: $userProfile.profileImage)
        }
    }
}

extension SignUpScreen {
    /// 회원가입 단계의 본문을 보여주는 뷰빌더 함수
    ///
    /// 회원가입 각 단계에 맞는 본문 뷰를 리턴하는 함수입니다.
    ///
    /// - Returns: 현재의 진행단계에 해당하는 뷰
    ///
    /// - Author: 라움
    @ViewBuilder
    private func signUpProcess() -> some View {
        switch currentPage {
        case .email:
            SignUpEmailView(
                accountService: accountService,
                userProfile: $userProfile,
                currentPage: $currentPage,
                transitionDirection: $transitionDirection
            )
        case .profile:
            SignUpProfileView(
                accountService: accountService,
                userProfile: $userProfile,
                showActionSheet: $showActionSheet,
                currentPage: $currentPage,
                transitionDirection: $transitionDirection
            )
        case .complete:
            SignUpCompleteView(
                accountService: accountService,
                currentPage: $currentPage
            )
        }
    }
}

#Preview {
    SignUpScreen()
}
