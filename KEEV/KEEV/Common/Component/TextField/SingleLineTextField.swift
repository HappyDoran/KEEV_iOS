//
//  SingleLineTextField.swift
//  KEEV
//
//  Created by Yune Cho on 10/25/24.
//

import SwiftUI

/// 한줄짜리 입력을 받는 텍스트필드
///
/// 필수 인자로 placeholder, text를 받습니다.
///
/// 텍스트를 입력받을 때의 키보드 타입을 변경해야할 경우 keyboardType을 인자로 받아서 키보드 타입을 변경할 수 있습니다.
///
/// 입력 받는 글자수에 제한을 두고자 할때는 maxLength를 인자로 받을 수 있습니다.
///
/// 입력 받는 글자에 제약사항이 있고 에러 메시지가 있을 경우 errorMessage를 바인딩 인자로 받아서 에러가 발생할 때 오류 문구가 나오고 색상이 빨간색으로 바뀌도록 할 수  있습니다.
///
/// 사용 예시는 아래와 같습니다.
/// ```swift
/// SingleLineTextField(placeholder: "텍스트", text: $text)
/// SingleLineTextField(placeholder: "이메일", text: $email, keyboardType: .emailAddress)
/// SingleLineTextField(placeholder: "이름", text: $name, maxLength: 3)
/// SingleLineTextField(placeholder: "닉네임", text: $nickname, maxLength: 8, errorMessage: $errorMessage)
/// ```
///
/// - Author: 라움
struct SingleLineTextField: View {
    private let placeholder: String
    @Binding var text: String
    private let keyboardType: UIKeyboardType
    private let maxLength: Int?
    @Binding var errorMessage: String
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, maxLength: Int? = nil, errorMessage: Binding<String> = .constant("")) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self._errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1.5)
                .foregroundStyle(errorMessage.isEmpty ? .gray100 : .red500)
                .frame(height: 56)
                .overlay {
                    HStack(spacing: 8) {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray700))
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                            .foregroundStyle(.gray100)
                            .tint(.brand500)
                            .keyboardType(keyboardType)
                            .onChange(of: text, {
                                if let maxLength = maxLength {
                                    text = String(text.prefix(maxLength))
                                }
                            })
                        
                        if let maxLength = maxLength {
                            Text("\(text.count) / \(maxLength)")
                                .frame(height: 17)
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                                .foregroundStyle(.gray700)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .medium)))
                    .foregroundStyle(.red500)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    
    SingleLineTextField(placeholder: "닉네임", text: $text, maxLength: 14)
}
