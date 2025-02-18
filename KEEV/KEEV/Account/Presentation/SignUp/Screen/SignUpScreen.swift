//
//  SignUpScreen.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

enum SignUpPage: Int {
    case profile = 1
    case complete = 2
}

/// 회원가입 화면
///
/// 회원가입 화면으로 최상단의 회원가입 인디케이터, 본문 뷰로 구성되어있습니다.
///
/// - Author: 라움
struct SignUpScreen: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @State var status: SignInStatus?
    
    @State private var result = SignInStatus.created
    @State private var nickname: String = ""
    @State private var profileImage: UIImage?
    @State private var currentPage: SignUpPage = .profile
    @State private var transitionDirection: Edge = .trailing
    @State private var showActionSheet = false
    @State private var showImageSelectSheet = false
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            SignUpIndicator(signInStatus: $status, currentPage: $currentPage, transitionDirection: $transitionDirection)
            
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
                    profileImage = nil
                    showActionSheet = false
                }))
        .fullScreenCover(isPresented: $showImageSelectSheet) {
            ImageSelectView(image: $profileImage)
        }
        .alertForError($error)
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
        case .profile:
            SignUpProfileView(
                result: $result,
                nickname: $nickname, profileImage: $profileImage,
                showActionSheet: $showActionSheet,
                currentPage: $currentPage,
                transitionDirection: $transitionDirection,
                error: $error
            )
        case .complete:
            SignUpCompleteView(
                nickname: nickname,
                profileImage: profileImage,
                currentPage: $currentPage
            ) {
                status = result
            }
        }
    }
}

#Preview {
    SignUpScreen(status: .created)
}
