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
    @Injected private var settingService: any SettingServiceProtocol
    
    @Binding var status: SignInStatus?
    @State private var error: Error? = nil
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    
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
            
            signInBottomText
        }
        .backgroundForKEEV()
        .sheet(isPresented: $showTermsOfUse, content: {
            DocumentView(title: "서비스 이용약관", text: settingService.termsOfUse())
                .presentationDragIndicator(.visible)
                .padding(.top, 16)
                .backgroundForKEEV()
        })
        .sheet(isPresented: $showPrivacyPolicy, content: {
            DocumentView(title: "개인정보 처리방침", text: settingService.privacyPolicy())
                .presentationDragIndicator(.visible)
                .padding(.top, 16)
                .backgroundForKEEV()
        })
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
    
    var signInBottomText: some View {
        HStack(spacing: 0) {
            Text("로그인(가입)시 ")
            
            Button {
                showTermsOfUse = true
            } label: {
                Text("이용약관")
                    .underline()
                    .baselineOffset(4)
                    .offset(y: 2)
            }
            
            Text(" 및 ")
            
            Button {
                showPrivacyPolicy = true
            } label: {
                Text("개인정보 처리방침")
                    .underline()
                    .baselineOffset(4)
                    .offset(y: 2)
            }
            
            Text("에 동의하게 됩니다.")
        }
        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall3, bodyWeight: .regular)))
        .foregroundStyle(.gray500)
    }
}

#Preview {
    KEEVPreview {
        SignInScreen(status: .constant(.failed))
    }
}
