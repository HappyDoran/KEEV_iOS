//
//  ProfileEditScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

struct ProfileEditScreen: View {
    @StateObject private var accountService = AccountService()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var originalProfile = UserProfile()
    @State private var newProfile = UserProfile()
    @State private var showProfileImageActionSheet = false
    @State private var showProfileImageEditSheet = false
    @State private var showBackgroundActionSheet = false
    @State private var showBackgroundEditSheet = false
    @State private var showCloseAlert = false
    @State private var disableButton = true
    
    var body: some View {
        ZStack {
            ProfileEditBackgroundView(
                newProfile: $newProfile,
                showBackgroundActionSheet: $showBackgroundActionSheet
            )
            
            VStack {
                ProfileEditTopView(showCloseAlert: $showCloseAlert)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                Spacer()
                
                ProfileEditCenterView(
                    accountService: accountService,
                    newProfile: $newProfile,
                    showProfileImageActionSheet: $showProfileImageActionSheet,
                    disableButton: $disableButton)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(
                    title: "수정 완료",
                    action: {
                        accountService.setUserProfile(newProfile)
                    },
                    style: .maxWidth,
                    disabled: disableButton
                )
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
            }
        }
        .onAppear {
            originalProfile = accountService.userProfile
            newProfile = originalProfile
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(
            isPresented: $showProfileImageActionSheet,
            defaults: .setProfileImage(
                modifyHandler: {
                    showProfileImageEditSheet = true
                    showProfileImageActionSheet = false
                }, deleteHandler: {
                    newProfile.profileImage = nil
                    showProfileImageActionSheet = false
                }))
        .fullScreenCover(isPresented: $showProfileImageEditSheet) {
            ProfileImageEdit(profileImage: $newProfile.profileImage)
        }
        .actionSheetForKEEV(
            isPresented: $showBackgroundActionSheet,
            defaults: .setBackgroundImage(
                modifyHandler: {
                    showBackgroundEditSheet = true
                    showBackgroundActionSheet = false
                }, deleteHandler: {
                    newProfile.backgroundImage = nil
                    showBackgroundActionSheet = false
                }))
        .fullScreenCover(isPresented: $showBackgroundEditSheet) {
            ProfileImageEdit(profileImage: $newProfile.backgroundImage)
        }
        .customAlert(
            isPresented: $showCloseAlert,
            title: "변경된 정보를 저장하시겠습니까?",
            message: "",
            closeText: "아니요",
            closeAction: {
                dismiss()
            },
            someText: "예",
            someAction: {
                accountService.setUserProfile(newProfile)
                dismiss()
            }
        )
    }
}

#Preview {
    ProfileEditScreen()
}
