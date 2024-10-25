//
//  SingleLineTextField.swift
//  KEEV
//
//  Created by Yune Cho on 10/25/24.
//

import SwiftUI

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
            
            HStack {
                Spacer()
                
                if let maxLength = maxLength {
                    Text("\(text.count) / \(maxLength)")
                        .frame(width: 33, height: 17)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .regular)))
                        .foregroundStyle(.gray700)
                }
            }
            .frame(width: 305)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    
    SingleLineTextField(placeholder: "keev@email.com", text: $text, maxLength: 10)
}
