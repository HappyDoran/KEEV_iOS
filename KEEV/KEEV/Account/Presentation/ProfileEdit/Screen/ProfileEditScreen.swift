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
    @Binding private var userProfile: DetailUserUIO
    @Binding private var profileEditedToast: Toast?
    
    init(userProfile: Binding<DetailUserUIO>, profileEditedToast: Binding<Toast?>) {
        self._userProfile = userProfile
        self._profileEditedToast = profileEditedToast
        self.nickname = userProfile.wrappedValue.nickname
        self.description = userProfile.wrappedValue.description ?? ""
    }
    
    @Injected private var service: any AccountServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var nickname: String
    @State private var description:String
    @State private var backgroundImage: UIImage?
    @State private var profileImage: UIImage?
    
    
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
                backgroundImage: backgroundImage,
                showBackgroundActionSheet: $showBackgroundActionSheet,
                isFocused: $isFocused
            )
            
            VStack {
                ProfileEditTopView(showCloseAlert: $showCloseAlert, isFocused: $isFocused)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 36)
                
                ProfileEditCenterView(
                    nickname: $nickname,
                    profileImage: $profileImage,
                    description: $description,
                    showProfileImageActionSheet: $showProfileImageActionSheet,
                    disableButton: $disableButton,
                    isFocused: $isFocused
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                CommonButton(
                    title: "수정 완료",
                    action: sendModifiedProfile,
                    style: .maxWidth,
                    disabled: disableButton
                )
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 42)
            }
            .ignoresSafeArea(.keyboard)
        }
        .task { // 추후에 Task가 병렬적으로 수행되도록 리팩토링이 필요함.
            if let userProfileURL = userProfile.profileImageURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: userProfileURL)
                    let image = UIImage(data: data)
                    profileImage = image
                } catch {
                    profileImage = nil
                }
            }
            
            if let backgroundImageURL = userProfile.backgroundImageURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: backgroundImageURL)
                    let image = UIImage(data: data)
                    backgroundImage = image
                } catch {
                    backgroundImage = nil
                }
            }
        }
        .backgroundForKEEV()
        .actionSheetForKEEV(
            isPresented: $showProfileImageActionSheet,
            defaults: .setProfileImage(
                modifyHandler: {
                    showProfileImageSelectSheet = true
                    showProfileImageActionSheet = false
                }, deleteHandler: {
                    profileImage = nil
                    showProfileImageActionSheet = false
                }))
        .fullScreenCover(isPresented: $showProfileImageSelectSheet) {
            ImageSelectView(image: $profileImage)
        }
        .actionSheetForKEEV(
            isPresented: $showBackgroundActionSheet,
            defaults: .setBackgroundImage(
                modifyHandler: {
                    showBackgroundImageSelectSheet = true
                    showBackgroundActionSheet = false
                }, deleteHandler: {
                    backgroundImage = nil
                    showBackgroundActionSheet = false
                }))
        .fullScreenCover(isPresented: $showBackgroundImageSelectSheet) {
            ImageSelectView(image: $backgroundImage)
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
            secondButtonAction: sendModifiedProfile
        )
    }
}

private extension ProfileEditScreen {
    func sendModifiedProfile() {
        Task {
            do {
                userProfile = try await service.updateProfile(
                    nickname: nickname,
                    profileImage: profileImage,
                    backgroundImage: backgroundImage,
                    description: description
                )
                profileEditedToast = Toast(title: "프로필이 변경되었습니다.", mainColor: .green500, subColor: .white)
                dismiss()
            } catch {
                print("ProfileEditScreen-sendModifiedProfile: \(error)")
            }
        }
    }
}

#Preview {
    ProfileEditScreen(userProfile: .constant(.dummy4), profileEditedToast: .constant(.init(title: "프로필이 변경되었습니다.", mainColor: .green500, subColor: .white)))
}
