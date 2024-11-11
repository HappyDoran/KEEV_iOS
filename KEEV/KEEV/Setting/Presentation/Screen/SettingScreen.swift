//
//  SettingScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

/// 설정 화면
///
/// KEEV 앱의 설정 화면입니다.
///
/// 앱의 현재 버전 / 공지사항 / 서비스 이용약관 / 개인정보 처리방침 확인이 가능합니다.
///
/// 피드백 및 문의사항 전송을 위해 애플 기본 메일앱으로 연결됩니다.
///
/// 로그아웃 및 회원탈퇴를 해당 화면에서 할 수 있습니다.
///
/// - Todo: 로그아웃 및 회원탈퇴 기능이 구현되면 각 기능의 customAlert 내에 주석이 작성된 부분에 기능을 추가해야합니다.
/// - Author: 라움
struct SettingScreen: View {
    private let settingService = SettingService()
    
    @Environment(\.openURL) var openURL
    
    @State private var showTermsOfUse = false
    @State private var showPrivacyPolicy = false
    @State private var showLogoutAlert = false
    @State private var showWithdrawAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                SettingCell(title: "현재 버전 \(settingService.version)", titleColor: .gray500)
                
                NavigationLink {
                    NoticeView(settingService: settingService)
                } label: {
                    SettingCell(title: "공지사항")
                }
                
                Button {
                    settingService.send(openURL: openURL)
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
            DocumentView(title: "서비스 이용약관", text: settingService.termsOfUse)
        })
        .fullScreenCover(isPresented: $showPrivacyPolicy, content: {
            DocumentView(title: "개인정보 처리방침", text: settingService.privacyPolicy)
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

#Preview {
    NavigationStack {
        SettingScreen()
    }
}
