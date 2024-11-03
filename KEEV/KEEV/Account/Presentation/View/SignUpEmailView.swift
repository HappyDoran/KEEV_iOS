//
//  SignUpEmailView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

/// 회원가입 이메일 입력 뷰
///
/// 회원가입 단계 중 유저의 이메일을 입력받는 뷰입니다.
///
/// 유저가 이메일을 입력하면 이메일 형식이 맞는지 확인하는 과정을 거칩니다.
///
/// - Author: 라움
struct SignUpEmailView: View {
    @ObservedObject var accountService: AccountService
    @Binding var typedEmail: String
    
    @State private var isInvalidEmail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("반가워요!")
                .figmaFont(PretendardFont.title(style: .lg))
                .foregroundStyle(.brand500)
            
            Text("이메일을 알려주세요")
                .figmaFont(PretendardFont.title(style: .lg))
                .foregroundStyle(.gray100)
            
            SingleLineTextField(placeholder: "keev@email.com", text: $typedEmail, keyboardType: .emailAddress)
                .submitLabel(.done)
                .textInputAutocapitalization(.never)
                .onChange(of: typedEmail, {
                    if typedEmail.isValidEmail {
                        isInvalidEmail = false
                    } else {
                        isInvalidEmail = true
                    }
                })
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            if !typedEmail.isEmpty && isInvalidEmail {
                Text("이메일의 형식이 올바르지 않습니다!")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SignUpEmailView(accountService: AccountService(), typedEmail: .constant(""))
}
