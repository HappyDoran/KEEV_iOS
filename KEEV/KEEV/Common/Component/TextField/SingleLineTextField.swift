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
/// 사용 예시는 아래와 같습니다.
/// ```swift
/// SingleLineTextField(placeholder: "텍스트", text: $text)
/// SingleLineTextField(placeholder: "이메일", text: $email, keyboardType: .emailAddress)
/// SingleLineTextField(placeholder: "이름", text: $name, maxLength: 3)
/// ```
///
/// - Author: 라움
struct SingleLineTextField: View {
    private let placeholder: String
    @Binding var text: String
    private let keyboardType: UIKeyboardType
    private let maxLength: Int?
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, maxLength: Int? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.maxLength = maxLength
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 345, height: 56)
                .foregroundStyle(.gray900)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray700))
                .frame(width: 305, height: 24)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                .foregroundStyle(.gray100)
                .keyboardType(keyboardType)
                .onChange(of: text, {
                    if let maxLength = maxLength {
                        text = String(text.prefix(maxLength))
                    }
                })
            
            if let maxLength = maxLength {
                HStack {
                    Spacer()
                    
                    Text("\(text.count) / \(maxLength)")
                        .frame(width: 33, height: 17)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                        .foregroundStyle(.gray700)
                }
                .frame(width: 305)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    
    SingleLineTextField(placeholder: "닉네임", text: $text, maxLength: 14)
}
