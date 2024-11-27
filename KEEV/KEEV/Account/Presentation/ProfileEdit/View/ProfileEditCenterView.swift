//
//  ProfileEditCenterView.swift
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
struct ProfileEditCenterView: View {
    @Injected private var service: any AccountServiceProtocol
    
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    @Binding var description: String
    
    @Binding var showProfileImageActionSheet: Bool
    @Binding var disableButton: Bool
    var isFocused: FocusState<Bool>.Binding
    
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                ProfileImage(profileImage: profileImage, size: 128, editable: true, strokeWidth: 4, strokeColor: .gray950)
                    .onTapGesture {
                        isFocused.wrappedValue = false
                        showProfileImageActionSheet = true
                    }
                
                Spacer()
            }
            
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
        }
    }
}

extension ProfileEditCenterView {
    private func validityTest(_ nickname: String) {
        do {
            try service.isValidNickname(nickname)
            errorMessage = ""
            disableButton = false
        } catch {
            errorMessage = error.localizedDescription
            disableButton = true
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    
    ProfileEditCenterView(
        nickname: .constant("dummy nicknameffff"),
        profileImage: .constant(nil),
        description: .constant("dummy descriptionfefefefefe"),
        showProfileImageActionSheet: .constant(false),
        disableButton: .constant(false),
        isFocused: $isFocused
    )
}
