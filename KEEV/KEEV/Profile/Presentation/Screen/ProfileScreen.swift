//
//  ProfileScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

struct ProfileScreen: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @State private var userProfile = UserProfile()
    @State private var isMyProfile = true
    @State private var showActionSheet = false
    @State private var navigateToReport = false
    @State private var showProfileEdit = false
    @State private var profileEditedToast: Toast? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileTopView(userProfile: userProfile, isMyProfile: $isMyProfile, showActionSheet: $showActionSheet)
                    .navigationDestination(isPresented: $navigateToReport) {
                        ReportScreen(reportType: .user)
                    }
                
                if isMyProfile {
                    profileEditButton
                }
            }
            .ignoresSafeArea(edges: .top)
            .backgroundForKEEV()
            .onAppear(perform: {
                userProfile = accountService.userProfile
            })
            .onChange(of: showProfileEdit, {
                userProfile = accountService.userProfile
            })
            .fullScreenCover(isPresented: $showProfileEdit) {
                ProfileEditScreen(profileEditedToast: $profileEditedToast)
            }
            .toast(with: $profileEditedToast, for: .seconds(of: 2))
            .actionSheetForKEEV(
                isPresented: $showActionSheet,
                defaults: .othersProfile(
                    shareHandler: {
                        //프로필 공유하기 코드 추가해야합니다.
                        showActionSheet = false
                    },
                    reportHandler: {
                        navigateToReport = true
                        showActionSheet = false
                    })
            )
        }
    }
}

extension ProfileScreen {
    private var profileEditButton: some View {
        Button {
            showProfileEdit = true
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 84, height: 25)
                .foregroundStyle(.gray700)
                .overlay {
                    Text("프로필 수정")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundStyle(.gray300)
                }
        }
        .padding(.top, 16)
    }
}

#Preview {
    ProfileScreen()
}
