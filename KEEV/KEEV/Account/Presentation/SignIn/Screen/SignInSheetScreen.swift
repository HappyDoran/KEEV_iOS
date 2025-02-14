//
//  SignInSheetScreen.swift
//  KEEV
//
//  Created by 김준성 on 2/14/25.
//

import SwiftUI
import AuthenticationServices

struct SignInSheetScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var accountService: any AccountServiceProtocol
    @Injected private var settingService: any SettingServiceProtocol
    
    @State var status: SignInStatus?
    @State private var error: Error? = nil
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Label("닫기", systemImage: "xmark")
                }
                .font(.system(size: 22, weight: .medium))
                .tint(Color.gray100)
                .labelStyle(.iconOnly)

                Spacer()
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
            
            Spacer()
            
            signInWithAppleButton
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

private extension SignInSheetScreen {
    var signInWithAppleButton: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let email = appleIDCredential.email
                    let user = appleIDCredential.user
                    let token = appleIDCredential.identityToken!
                    let code = appleIDCredential.authorizationCode!
                    
                    Task {
                        do {
                            status = try await accountService.signInWithApple(email: email, user: user, identityToken: token, authorizationCode: code)
                        } catch let failToSignIn {
                            error = failToSignIn
                        }
                    }
                    
                default: break
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
        .figmaFont(
            PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold))
        )
        .frame(height: 54)
        .signInWithAppleButtonStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
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
    SignInSheetScreen()
}
