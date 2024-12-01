//
//  SignInScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/13/24.
//

import SwiftUI
import AuthenticationServices

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
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
            
            Spacer()
            
            signInWithAppleButton
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            
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
    }
}

private extension SignInScreen {
    var signInWithAppleButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
                .frame(height: 54)
                .overlay {
                    SignInWithAppleButton { _ in
                        
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            switch authorization.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let user = appleIDCredential.user
                                let token = appleIDCredential.identityToken!
                                let code = appleIDCredential.authorizationCode!
                                
                                Task {
                                    do {
                                        status = try await accountService.signInWithApple(user: user, identityToken: token, authorizationCode: code)
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            default: print("gggg");break
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .blendMode(.overlay)
                    .cornerRadius(14)
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 54)
                }
            
            Label("Apple로 로그인", systemImage: "apple.logo")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                .foregroundStyle(.black)
                .frame(height: 54)
        }
    }
    
    var signInBottomText: some View {
        HStack(spacing: 0) {
            Text("로그인(가입)시 ")
            
            Button {
                showTermsOfUse = true
            } label: {
                Text("이용약관")
                    .underline()
            }
            
            Text(" 및 ")
            
            Button {
                showPrivacyPolicy = true
            } label: {
                Text("개인정보 처리방침")
                    .underline()
            }
            
            Text("에 동의하게 됩니다.")
        }
        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall3, bodyWeight: .regular)))
        .foregroundStyle(.gray500)
    }
}

#Preview {
    SignInScreen(status: .constant(.failed))
}
