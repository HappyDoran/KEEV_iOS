//
//  SignUpEmailView.swift
//  KEEV
//
//  Created by Yune Cho on 10/31/24.
//

import SwiftUI

struct SignUpEmailView: View {
    @Binding var email: String
    
    @State private var typedEmail = ""
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
                .onSubmit {
                    if typedEmail.isValidEmail {
                        email = typedEmail
                        isInvalidEmail = false
                    } else {
                        isInvalidEmail = true
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            if isInvalidEmail {
                Text("이메일의 형식이 올바르지 않습니다!")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SignUpEmailView(email: .constant(""))
}
