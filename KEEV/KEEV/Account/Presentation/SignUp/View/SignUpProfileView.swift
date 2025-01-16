//
//  SignUpProfileView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

/// 회원가입 프로필 정보 입력 뷰
///
/// 회원가입 단계 중 유저의 프로필 정보(닉네임, 프로필 이미지)를 입력받는 뷰입니다.
///
/// 닉네임에 특수문자가 포함되었는지 확인하는 과정을 거칩니다.
///
/// - Author: 라움
struct SignUpProfileView: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @Binding var result: SignInStatus
    
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    @Binding var showActionSheet: Bool
    @Binding var currentPage: SignUpPage
    @Binding var transitionDirection: Edge
    @Binding var error: Error?
    
    @State private var errorMessage = ""
    @State private var disableButton = true
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("프로필을 설정해주세요")
                    .figmaFont(PretendardFont.title(style: .lg))
                    .foregroundStyle(.gray50)
                    .padding(.bottom, 12)
                
                Text("닉네임과 프로필 이미지는 프로필탭에서 변경이 가능합니다")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                    .foregroundStyle(.gray400)
                
                HStack {
                    Spacer()
                    
                    ProfileImage(profileImage: profileImage, size: 128, editable: true)
                        .onTapGesture {
                            isFocused = false
                            showActionSheet = true
                        }
                    
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.bottom, 24)
                
                SingleLineTextField(
                    placeholder: "닉네임",
                    text: $nickname,
                    maxLength: 14,
                    errorMessage: $errorMessage
                )
                .submitLabel(.done)
                .focused($isFocused)
                .onChange(of: nickname) {
                    validityTest(nickname)
                }
                .padding(.bottom, 8)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            
            Spacer()
            
            CommonButton(
                title: "다음",
                action: {
                    Task {
                        do {
                            result = try await accountService.signUp(
                                email: nil,
                                nickname: nickname,
                                profileImage: profileImage,
                                backgroundImage: nil,
                                description: ""
                            )
                            transitionDirection = .trailing
                            currentPage = .complete
                        } catch let failToSignUp {
                            error = failToSignUp
                        }
                    }
                },
                style: .maxWidth,
                disabled: disableButton
            )
            .sensoryFeedback(.impact, trigger: currentPage)
            .padding(.top, 12)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

extension SignUpProfileView {
    private func validityTest(_ nickname: String) {
        do {
            try accountService.isValidNickname(nickname)
            errorMessage = ""
            disableButton = false
        } catch {
            errorMessage = error.localizedDescription
            disableButton = true
        }
    }
}

#Preview {
    SignUpProfileView(
        result: .constant(.created),
        nickname: .constant("fefe"),
        profileImage: .constant(nil),
        showActionSheet: .constant(false),
        currentPage: .constant(.profile),
        transitionDirection: .constant(.leading), error: .constant(nil)
    )
}
