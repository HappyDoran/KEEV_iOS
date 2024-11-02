//
//  SignUpProfileView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

struct SignUpProfileView: View {
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    
    @State private var typedNickname = ""
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
                
                ProfileImageEdit(profileImage: $profileImage)
                
                Spacer()
            }
            .padding(.vertical, 48)
            
            SingleLineTextField(placeholder: "닉네임", text: $typedNickname, maxLength: 14)
                .submitLabel(.done)
                .onSubmit {
                    if typedNickname.isValidNickname {
                        nickname = typedNickname
                        isInvalidNickname = false
                    } else {
                        isInvalidNickname = true
                    }
                }
                .padding(.bottom, 12)
            
            if isInvalidNickname {
                Text("특수문자가 포함되어 있습니다.")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SignUpProfileView(nickname: .constant(""), profileImage: .constant(nil))
}
