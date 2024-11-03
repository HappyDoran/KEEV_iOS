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
    
    @State private var typedEmail = ""
    @State private var typedNickname = ""
    @State private var selectedProfileImage: UIImage? = nil
    @State private var currentPage: SignUpPage = .email
    @State private var transitionDirection: Edge = .trailing
    @State private var showActionSheet = false
    @State private var showProfileImageEditSheet = false
    
    var body: some View {
        VStack {
            SignUpIndicator(currentPage: $currentPage, transitionDirection: $transitionDirection)
            
            signUpProcess()
                .transition(.asymmetric(insertion: .move(edge: transitionDirection), removal: .opacity))
                .animation(.easeInOut, value: currentPage)
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(isPresented: $showActionSheet, defaults: .setProfileImage(modifyHandler: {
            showProfileImageEditSheet = true
            showActionSheet = false
        }, deleteHandler: {
            selectedProfileImage = nil
            showActionSheet = false
        }))
        .fullScreenCover(isPresented: $showProfileImageEditSheet) {
            ProfileImageEdit(profileImage: $selectedProfileImage)
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
            VStack {
                SignUpEmailView(accountService: accountService, typedEmail: $typedEmail)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(title: "다음", action: {
                    accountService.setEmail(typedEmail)
                    transitionDirection = .trailing
                    currentPage = .profile
                }, style: .maxWidth, disabled: typedEmail.isEmpty || !typedEmail.isValidEmail)
                .sensoryFeedback(.impact, trigger: currentPage)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
            }
        case .profile:
            VStack {
                SignUpProfileView(accountService: accountService, typedNickname: $typedNickname, selectedProfileImage: $selectedProfileImage, showActionSheet: $showActionSheet)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(title: "다음", action: {
                    accountService.setProfileImage(selectedProfileImage)
                    accountService.setNickname(typedNickname)
                    transitionDirection = .trailing
                    currentPage = .complete
                }, style: .maxWidth, disabled: typedNickname.isEmpty || !typedNickname.isValidNickname)
                .sensoryFeedback(.impact, trigger: currentPage)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
            }
        case .complete:
            VStack {
                SignUpCompleteView(accountService: accountService)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(title: "시작하기", action: {
                    // 시작하기 버튼을 탭했을 때 입력한 정보가 저장되도록 여기에 저장기능을 추가하면 됩니다.
                    // navigationRouter로 메인화면으로 가면 됩니다.
                }, style: .maxWidth)
                .sensoryFeedback(.success, trigger: currentPage)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
            }
        }
    }
}

#Preview {
    SignUpScreen()
}
