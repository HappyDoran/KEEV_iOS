//
//  ProfileEditBodyView.swift
//  KEEV
//
//  Created by Yune Cho on 11/5/24.
//

import SwiftUI

/// 프로필 사진, 닉네임, 한 줄 소개를 수정할 수 있는 뷰
///
/// 프로필 내용 중 프로필 사진, 닉네임, 한 줄 소개를 수정할 수 있는 뷰입니다.
///
/// 프로필 사진을 탭할 시 프로필 사진 수정에 대한 액션시트가 열립니다.
///
/// - Note: 액션시트에 대한 modifier는 ProfileEditScreen에 추가되어있습니다.
/// - Author: 라움
struct ProfileEditBodyView: View {
    @Injected private var service: any AccountServiceProtocol
    
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    @Binding var backgroundImage: UIImage?
    @Binding var description: String
    
    @Binding var showProfileImageActionSheet: Bool
    @Binding var showBackgroundActionSheet: Bool
    @Binding var profileModified: Bool
    @Binding var buttonDisabled: Bool
    var isFocused: FocusState<Bool>.Binding
    
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottom) {
                backgroundArea
                    .frame(height: 266)
                
                ProfileImage(profileImage: profileImage, size: 128, editable: true, strokeWidth: 4, strokeColor: .gray950)
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showProfileImageActionSheet = true
                    }
            }
            
            textArea
        }
    }
}

private extension ProfileEditBodyView {
    var backgroundArea: some View {
        VStack {
            if let backgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 202)
                    .clipped()
                    .overlay(content: {
                        Color.black
                            .opacity(0.2)
                    })
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showBackgroundActionSheet = true
                    }
            } else {
                Color.gray800
                    .frame(height: 202)
                    .overlay(content: {
                        Color.black
                            .opacity(0.2)
                    })
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showBackgroundActionSheet = true
                    }
            }
            
            Spacer()
        }
    }
    
    var textArea: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.gray300)
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            SingleLineTextField(
                placeholder: "닉네임",
                text: $nickname,
                maxLength: 14,
                errorMessage: $errorMessage
            )
            .submitLabel(.done)
            .focused(isFocused)
            .onChange(of: nickname) {
                validityTest(nickname)
                profileModified = true
            }
            
            Text("한 줄 소개")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .semibold)))
                .foregroundStyle(.gray300)
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            SingleLineTextField(
                placeholder: "한 줄 소개를 입력해주세요.",
                text: $description,
                maxLength: 20
            )
            .submitLabel(.done)
            .focused(isFocused)
            .onChange(of: description) {
                profileModified = true
            }
        }
        .padding(.horizontal, 24)
    }
}

private extension ProfileEditBodyView {
    func validityTest(_ nickname: String) {
        do {
            try service.isValidNickname(nickname)
            errorMessage = ""
            buttonDisabled = false
        } catch {
            errorMessage = error.localizedDescription
            buttonDisabled = true
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    
    ProfileEditBodyView(
        nickname: .constant("dummy nicknameffff"),
        profileImage: .constant(nil),
        backgroundImage: .constant(nil),
        description: .constant("dummy descriptionfefefefefe"),
        showProfileImageActionSheet: .constant(false),
        showBackgroundActionSheet: .constant(false),
        profileModified: .constant(false),
        buttonDisabled: .constant(false),
        isFocused: $isFocused
    )
}
