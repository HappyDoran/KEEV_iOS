//
//  ProfileEditCenterView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

struct ProfileEditCenterView: View {
    @ObservedObject var accountService: AccountService
    @Binding var newProfile: UserProfile
    @Binding var showProfileImageActionSheet: Bool
    @Binding var disableButton: Bool
    
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                ProfileImage(profileImage: newProfile.profileImage, editable: true)
                    .onTapGesture {
                        showProfileImageActionSheet = true
                    }
                
                Spacer()
            }
            .padding(.bottom, 48)
            
            Text("닉네임")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.gray500)
                .padding(.bottom, 12)
            
            SingleLineTextField(placeholder: "닉네임", text: $newProfile.nickname, maxLength: 14)
                .submitLabel(.done)
                .onChange(of: newProfile.nickname, {
                    do {
                        accountService.setUserProfile(newProfile)
                        try accountService.checkNicknameValidity()
                        errorMessage = nil
                        disableButton = false
                    } catch let error as AccountError {
                        errorMessage = error.rawValue
                        disableButton = true
                    } catch {
                        errorMessage = error.localizedDescription
                        disableButton = true
                    }
                })
                .padding(.bottom, 48)
            
            if let errorMessage {
                Text(errorMessage)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
            }
            
            Text("한 줄 소개")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.gray500)
                .padding(.bottom, 12)
            
            SingleLineTextField(placeholder: "한 줄 소개를 입력해주세요.", text: $newProfile.description, maxLength: 20)
                .submitLabel(.done)
        }
    }
}

#Preview {
    ProfileEditCenterView(
        accountService: AccountService(),
        newProfile: .constant(UserProfile()),
        showProfileImageActionSheet: .constant(false),
        disableButton: .constant(false)
    )
}
