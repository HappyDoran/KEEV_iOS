//
//  SignUpEmailView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

/// 회원가입 이메일 입력 뷰
///
/// 회원가입 단계 중 유저의 이메일을 입력받는 뷰입니다.
///
/// 유저가 이메일을 입력하면 이메일 형식이 맞는지 확인하는 과정을 거칩니다.
///
/// - Author: 라움
struct SignUpEmailView: View {
    @ObservedObject var accountService: AccountService
    @Binding var userProfile: UserProfile
    @Binding var currentPage: SignUpPage
    @Binding var transitionDirection: Edge
    
    @State private var errorMessage = ""
    @State private var disableButton = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("반가워요!")
                    .figmaFont(PretendardFont.title(style: .lg))
                    .foregroundStyle(.brand500)
                
                Text("이메일을 알려주세요")
                    .figmaFont(PretendardFont.title(style: .lg))
                    .foregroundStyle(.gray100)
                
                SingleLineTextField(
                    placeholder: "keev@email.com",
                    text: $userProfile.email,
                    keyboardType: .emailAddress,
                    errorMessage: $errorMessage
                )
                .submitLabel(.done)
                .textInputAutocapitalization(.never)
                .onChange(of: userProfile.email, {
                    validityTest()
                })
                .padding(.top, 24)
                .padding(.bottom, 8)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            
            Spacer()
            
            CommonButton(
                title: "다음",
                action: {
                    transitionDirection = .trailing
                    currentPage = .profile
                },
                style: .maxWidth,
                disabled: disableButton
            )
            .sensoryFeedback(.impact, trigger: currentPage)
            .padding(.top, 12)
            .padding(.horizontal, 16)
            .padding(.bottom, 42)
        }
    }
}

extension SignUpEmailView {
    private func validityTest() {
        do {
            accountService.setUserProfile(userProfile)
            try accountService.checkEmailValidity()
            errorMessage = ""
            disableButton = false
        } catch let error as AccountError {
            errorMessage = error.rawValue
            disableButton = true
        } catch {
            errorMessage = error.localizedDescription
            disableButton = true
        }
    }
}

#Preview {
    SignUpEmailView(
        accountService: AccountService(),
        userProfile: .constant(UserProfile()),
        currentPage: .constant(.email),
        transitionDirection: .constant(.leading)
    )
}
