//
//  SignUpProfileView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

/// 회원가입 프로필 정보 입력 뷰
///
/// 회원가입 단계 중 유저의 프로필 정보(닉네임, 프로필 이미지)를 입력받는 뷰입니다.
///
/// 닉네임에 특수문자가 포함되었는지 확인하는 과정을 거칩니다.
///
/// - Author: 라움
struct SignUpProfileView: View {
    @ObservedObject var accountService: AccountService
    @Binding var typedNickname: String
    @Binding var selectedProfileImage: UIImage?
    @Binding var showActionSheet: Bool
    
    @State private var isInvalidNickname = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("프로필을 설정해주세요")
                .figmaFont(PretendardFont.title(style: .lg))
                .foregroundStyle(.gray100)
                .padding(.bottom, 12)
            
            Text("닉네임과 프로필 이미지는 프로필탭에서 변경이 가능합니다")
                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                .foregroundStyle(.gray400)
            
            HStack {
                Spacer()
                
                ProfileImage(profileImage: selectedProfileImage, editable: true)
                    .onTapGesture {
                        showActionSheet = true
                    }
                
                Spacer()
            }
            .padding(.vertical, 48)
            
            SingleLineTextField(placeholder: "닉네임", text: $typedNickname, maxLength: 14)
                .submitLabel(.done)
                .onChange(of: typedNickname, {
                    if typedNickname.isValidNickname {
                        isInvalidNickname = false
                    } else {
                        isInvalidNickname = true
                    }
                })
                .padding(.bottom, 12)
            
            if !typedNickname.isEmpty && isInvalidNickname {
                Text("특수문자가 포함되어 있습니다.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SignUpProfileView(accountService: AccountService(), typedNickname: .constant(""), selectedProfileImage: .constant(nil), showActionSheet: .constant(false))
}
