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

struct SignUpScreen: View {
    @State private var currentPage: SignUpPage = .email
    @State private var progress = 1.0 / 3
    @State private var email = ""
    @State private var nickname = ""
    @State private var profileImage: UIImage?
    @State private var showActionSheet = false
    @State private var showProfileImageEditSheet = false
    
    @ViewBuilder
    private func signUpProcess() -> some View {
        switch currentPage {
        case .email:
            SignUpEmailView(email: $email)
        case .profile:
            SignUpProfileView(nickname: $nickname, profileImage: $profileImage, showActionSheet: $showActionSheet)
        case .complete:
            SignUpCompleteView(email: $email, nickname: $nickname, profileImage: $profileImage)
        }
    }
    
    @ViewBuilder
    private func signUpProcessButton() -> some View {
        switch currentPage {
        case .email:
            CommonButton(title: "다음", action: {
                currentPage = .profile
            }, style: .maxWidth, disabled: email.isEmpty)
            .sensoryFeedback(.impact, trigger: currentPage)
        case .profile:
            CommonButton(title: "다음", action: {
                currentPage = .complete
            }, style: .maxWidth, disabled: nickname.isEmpty || profileImage == nil)
            .sensoryFeedback(.impact, trigger: currentPage)
        case .complete:
            CommonButton(title: "시작하기", action: {
                // 시작하기 버튼을 탭했을 때 입력한 정보가 저장되도록 여기에 저장기능을 추가하면 됩니다.
                // navigationRouter로 메인화면으로 가면 됩니다.
            }, style: .maxWidth)
            .sensoryFeedback(.success, trigger: currentPage)
        }
    }
    
    var body: some View {
        VStack {
            SignUpIndicator(currentPage: $currentPage, progress: $progress)
            
            signUpProcess()
                .padding(.top, 40)
                .padding(.horizontal, 24)
            
            Spacer()
            
            signUpProcessButton()
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(isPresented: $showActionSheet, defaults: .setProfileImage(modifyHandler: {
            showProfileImageEditSheet = true
        }, deleteHandler: {
            profileImage = nil
            showActionSheet = false
        }))
        .fullScreenCover(isPresented: $showProfileImageEditSheet) {
            ProfileImageEdit(profileImage: $profileImage)
                .onDisappear {
                    showActionSheet = false
                }
        }
    }
}

#Preview {
    SignUpScreen()
}
