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
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 345, height: 56)
                .foregroundStyle(.gray900)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray700))
                .frame(width: 305, height: 24)
                .foregroundStyle(.gray100)
                .keyboardType(keyboardType)
        }
    }
}

#Preview {
    SingleLineTextField(placeholder: "keev@email.com", text: .constant(""))
}
