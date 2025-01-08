//
//  MultiLineTextField.swift
//  KEEV
//
//  Created by Doran on 1/8/25.
//

import SwiftUI

/// 두줄 이상의 Text를 입력할 수 있는 TextEditor
///
/// 일정 크기만큼 늘어나면 frame의 height가 고정되며, scroll이 가능합니다.
///
/// - Author: Doran
struct MultiLineTextField: View {
    private let placeholder: String
    @Binding var text: String
    private let keyboardType: UIKeyboardType
    private let maxLength: Int?
    @Binding var errorMessage: String
    
    @State private var textHeight: CGFloat = 0
    private let customFont = PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium))
    private var isFocused: FocusState<Bool>.Binding
    
    init(placeholder: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = .default,
         maxLength: Int? = nil,
         errorMessage: Binding<String> = .constant(""),
         isFocused: FocusState<Bool>.Binding) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self._errorMessage = errorMessage
        self.isFocused = isFocused
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(isFocused.wrappedValue ? (errorMessage.isEmpty ? .gray300 : .red500) : .gray700)
                .frame(height: max(56, textHeight + 32))
                .overlay {
                    CustomTextEditor($textHeight, $text, textColor: .gray100, customFont: customFont.uiFont, scrollPossibleHeight: 118)
                        .focused(isFocused)
                        .tint(.brand500)
                        .keyboardType(keyboardType)
                        .frame(height: max(37, textHeight))
                        .overlay(alignment: .topLeading) {
                            Text(placeholder)
                                .foregroundStyle(text.isEmpty ? .gray700 : .clear)
                                .figmaFont(customFont)
                                .padding(.top, 7)
                                .padding(.leading, 5)
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
    
    MultiLineTextField(placeholder: "닉네임", text: $text, maxLength: 14, isFocused:  FocusState<Bool>().projectedValue)
}
