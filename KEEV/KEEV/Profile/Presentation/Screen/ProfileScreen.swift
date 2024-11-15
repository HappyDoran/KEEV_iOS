//
//  ProfileScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

struct ProfileScreen: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @State private var showSetting = false
    @State private var showProfileEdit = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileTopView(userProfile: accountService.userProfile, showSetting: $showSetting)
                
                profileEditButton
            }
            .ignoresSafeArea(edges: .top)
            .backgroundForKEEV()
            .fullScreenCover(isPresented: $showProfileEdit) {
                ProfileEditScreen()
            }
        }
        .tint(.gray100)
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
