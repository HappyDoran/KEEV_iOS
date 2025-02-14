//
//  SignInScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/13/24.
//

import SwiftUI

/// 로그인 화면
///
/// KEEV 로그인 화면입니다.
///
/// - Note: 현재 애플 로그인 버튼은 임시 버튼입니다.
/// - Todo: 로그인 기능이 추가되면 애플 로그인 버튼 수정해야합니다.
/// - Author: 라움
struct SignInScreen: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @Binding var status: SignInStatus?
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
            
            Spacer()
            
            VStack(spacing: 16) {
                signInWithAppleButton
                lookAroundButton
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
            TermAndCondition()
        }
        .backgroundForKEEV()
        .alertForError($error)
    }
}

private extension SignInScreen {
    var signInWithAppleButton: some View {
        AppleLoginButton { (email, user, token, code) in
            Task {
                do {
                    status = try await accountService.signInWithApple(email: email, user: user, identityToken: token, authorizationCode: code)
                } catch let failToSignIn {
                    error = failToSignIn
                }
            }
        }
    }
    
    var lookAroundButton: some View {
        Button("로그인 없이 둘러보기") {
            status = .lookAround
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .figmaFont(
            PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold))
        )
        .foregroundStyle(Color.grayBG300)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayBG700)
        )
    }
}

#Preview {
    KEEVPreview {
        SignInScreen(status: .constant(.failed))
    }
}
