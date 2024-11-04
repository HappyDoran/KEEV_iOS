//
//  SearchField.swift
//  KEEV
//
//  Created by Doran on 11/2/24.
//

import SwiftUI

struct SearchField: View {
    @Binding private var text: String
    private let onSubmit: () -> Void
    
    init(text: Binding<String>, onSubmit: @escaping () -> Void) {
        self._text = text
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        Rectangle()
            .frame(height: 56)
            .foregroundStyle(.gray900)
            .overlay {
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 16)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(.gray300)
                        .padding(.leading, 6)
                    
                    TextField("", text: $text, prompt: Text("공연 이름 검색하기").foregroundStyle(.gray700))
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                        .accentColor(.brand500)
                        .foregroundStyle(.gray100)
                        .keyboardType(.default)
                        .padding(.leading, 14)
                        .onSubmit {
                            onSubmit()
                        }
                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                            
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17.14, height: 17.14)
                                .foregroundColor(.gray700)
                                .padding(.trailing, 3.43)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
    }
}

#Preview {
    SearchField(text: .constant(""), onSubmit: {})
        .backgroundForKEEV()
}
