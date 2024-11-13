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
    @Injected private var settingService: any SettingServiceProtocol
    
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        ZStack {
            Image("LogoBackgroundImage")
                .resizable()
                .ignoresSafeArea()
            
            Image("LogoLargeImage")
                .resizable()
                .frame(width: 250, height: 103.5)
            
            VStack {
                Spacer()
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.white)
                        .frame(height: 54)
                        .overlay {
                            Label("Apple로 로그인", systemImage: "apple.logo")
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                                .foregroundStyle(.black)
                        }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                signInBottomText
            }
        }
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

extension SignInScreen {
    private var signInBottomText: some View {
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
    SignInScreen()
}
