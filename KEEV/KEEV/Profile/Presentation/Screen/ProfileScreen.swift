//
//  ProfileScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/15/24.
//

import SwiftUI

/// 프로필 화면
///
/// 프로필 메인 화면입니다.
///
/// 사용자의 프로필 정보를 보여주는 ProfileTopView와 바이브 목록을 보여주는 ProfileVibeView로 구성되어있습니다.
///
/// - Author: 라움
struct ProfileScreen: View {
    @Injected private var accountService: any AccountServiceProtocol
    
    @Binding private var showActionSheet: Bool
    
    init(showActionSheet: Binding<Bool>) {
        self._showActionSheet = showActionSheet
    }
    
    @State private var userProfile = UserProfile()
    @State private var isMyProfile = true
    @State private var showProfileEdit = false
    @State private var profileEditedToast: Toast? = nil
    @State private var selectedVibeViewType: VibeViewType = .list
    
    var body: some View {
        ScrollView {
            ProfileTopView(userProfile: userProfile, isMyProfile: isMyProfile, showActionSheet: $showActionSheet)
                
            
            if isMyProfile {
                profileEditButton
            }
            
            ProfileVibeView(isMyProfile: isMyProfile, selectedVibeViewType: $selectedVibeViewType)
        }
        .backgroundForKEEV()
        .ignoresSafeArea(edges: .top)
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
    }
}

extension ProfileScreen {
    private var profileEditButton: some View {
        Button {
            showProfileEdit = true
        } label: {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 84, height: 25)
                .foregroundStyle(.grayBG700)
                .overlay {
                    Text("프로필 수정")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundStyle(.gray300)
                }
        }
        .padding(.top, 16)
    }
}

/// 바이브 보기 방식에 대한 열거형
///
/// 바이브 보기 방식에 대한 열거형으로 리스트 방식과 테이블 방식이 있습니다.
///
/// - Author: 라움
enum VibeViewType {
    case list
    case table
}

#Preview {
    ProfileScreen(showActionSheet: .constant(false))
}
