//
//  ProfileEditScreen.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

/// 프로필 수정 화면
///
/// 프로필 화면에서 프로필 수정 버튼을 탭할 시에 fullScreenCover로 열리는 프로필 수정 화면입니다.
///
/// - ToDo: 닫기 버튼을 탭할 시에 나오는 커스텀 알럿 수정 후 해당하는 코드 부분을 수정해야합니다.
/// - Author: 라움
struct ProfileEditScreen: View {
    @Binding private var profileEditedToast: Toast?
    
    init(profileEditedToast: Binding<Toast?>) {
        self._profileEditedToast = profileEditedToast
    }
    
    @Injected private var accountService: any AccountServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var userProfile = UserProfile()
    @State private var showProfileImageActionSheet = false
    @State private var showProfileImageSelectSheet = false
    @State private var showBackgroundActionSheet = false
    @State private var showBackgroundImageSelectSheet = false
    @State private var showCloseAlert = false
    @State private var disableButton = true
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            ProfileEditBackgroundView(
                backgroundImage: userProfile.backgroundImage,
                showBackgroundActionSheet: $showBackgroundActionSheet,
                isFocused: $isFocused
            )
            
            VStack {
                ProfileEditTopView(showCloseAlert: $showCloseAlert, isFocused: $isFocused)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 36)
                
                ProfileEditCenterView(
                    userProfile: $userProfile,
                    showProfileImageActionSheet: $showProfileImageActionSheet,
                    disableButton: $disableButton,
                    isFocused: $isFocused
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(
                    title: "수정 완료",
                    action: {
                        accountService.setUserProfile(userProfile)
                        profileEditedToast = Toast(title: "프로필이 변경되었습니다.", mainColor: .green500, subColor: .white)
                        dismiss()
                    },
                    style: .maxWidth,
                    disabled: disableButton
                )
                .padding(.top, 12)
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            userProfile = accountService.userProfile
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(
            isPresented: $showProfileImageActionSheet,
            defaults: .setProfileImage(
                modifyHandler: {
                    showProfileImageSelectSheet = true
                    showProfileImageActionSheet = false
                }, deleteHandler: {
                    userProfile.profileImage = nil
                    showProfileImageActionSheet = false
                }))
        .fullScreenCover(isPresented: $showProfileImageSelectSheet) {
            ImageSelectView(image: $userProfile.profileImage)
        }
        .actionSheetForKEEV(
            isPresented: $showBackgroundActionSheet,
            defaults: .setBackgroundImage(
                modifyHandler: {
                    showBackgroundImageSelectSheet = true
                    showBackgroundActionSheet = false
                }, deleteHandler: {
                    userProfile.backgroundImage = nil
                    showBackgroundActionSheet = false
                }))
        .fullScreenCover(isPresented: $showBackgroundImageSelectSheet) {
            ImageSelectView(image: $userProfile.backgroundImage)
        }
        .customAlert(
            isPresented: $showCloseAlert,
            title: "변경된 정보를 저장하시겠습니까?",
            firstButtonText: "아니요",
            firstButtonStyle: .normal,
            firstButtonAction: {
                dismiss()
            },
            secondButtonText: "예",
            secondButtonStyle: .active,
            secondButtonAction: {
                accountService.setUserProfile(userProfile)
                profileEditedToast = Toast(title: "프로필이 변경되었습니다.", mainColor: .green500, subColor: .white)
                dismiss()
            }
        )
    }
}

#Preview {
    ProfileEditScreen(profileEditedToast: .constant(.init(title: "프로필이 변경되었습니다.", mainColor: .green500, subColor: .white)))
}
