//
//  SettingScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct SettingScreen: View {
    let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    @Environment(\.openURL) var openURL
    
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    @State private var showLogoutAlert = false
    @State private var showWithdrawAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                SettingCell(title: "현재 버전 \(version)", titleColor: .gray500)
                
                NavigationLink {
                    NoticeView()
                } label: {
                    SettingCell(title: "공지사항")
                }
                
                Button {
                    send(openURL: openURL)
                } label: {
                    SettingCell(title: "피드백 및 문의사항")
                }
                
                Button {
                    showTermsOfUse = true
                } label: {
                    SettingCell(title: "서비스 이용약관")
                }
                
                Button {
                    showPrivacyPolicy = true
                } label: {
                    SettingCell(title: "개인정보 처리방침")
                }
                
                Button {
                    showLogoutAlert = true
                } label: {
                    SettingCell(title: "로그아웃")
                }
                .padding(.top, 88)
                
                Button {
                    showWithdrawAlert = true
                } label: {
                    SettingCell(title: "회원탈퇴")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray100)
            }
        }
        .toolbarRole(.editor)
        .backgroundForKEEV()
        .fullScreenCover(isPresented: $showTermsOfUse, content: {
            TermsOfUseView()
        })
        .fullScreenCover(isPresented: $showPrivacyPolicy, content: {
            PrivacyPolicyView()
        })
        .customAlert(
            isPresented: $showLogoutAlert,
            title: "로그아웃하시겠습니까?",
            firstButtonText: "취소",
            firstButtonStyle: .normal,
            firstButtonAction: { },
            secondButtonText: "로그아웃",
            secondButtonStyle: .destructive,
            secondButtonAction: {
                // 로그아웃 기능 추가해야합니다.
            }
        )
        .customAlert(
            isPresented: $showWithdrawAlert,
            title: "회원탈퇴",
            message: "탈퇴 시 모든 데이터가 삭제되며\n복구가 불가능합니다.\n정말로 탈퇴하시겠습니까?",
            firstButtonText: "취소",
            firstButtonStyle: .active,
            firstButtonAction: { },
            secondButtonText: "회원탈퇴",
            secondButtonStyle: .normal,
            secondButtonAction: {
                // 회원탈퇴 기능 추가해야합니다.
            }
        )
    }
}

extension SettingScreen {
    private func send(openURL: OpenURLAction) {
        let email = "hmhz.studio@gmail.com"
        let subject = "제목을 입력해주세요."
        let body = "\n\n여러분의 피드백은 더 나은 KEEV 개발에 활용됩니다."
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingScreen()
    }
}
