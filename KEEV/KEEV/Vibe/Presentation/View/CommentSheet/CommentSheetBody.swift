//
//  CommentSheetBody.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct CommentSheetBody: View {
    @Binding private var comment: String
    private var isFocused: FocusState<Bool>.Binding
    
    init(comment: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._comment = comment
        self.isFocused = isFocused
    }
    
    var body: some View {
        TextEditor(text: $comment)
            .focused(isFocused)
            .scrollContentBackground(.hidden)
            .background(.clear)
            .foregroundColor(.gray50)
            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
            .frame(minHeight: 158)
            .overlay(alignment: .topLeading) {
                Text("공연의 감상을 자유롭게 작성해주세요.")
                    .foregroundStyle(comment.isEmpty ? .gray : .clear)
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .padding(.top, 10)
                    .padding(.leading,3)
            }
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
    }
}

#Preview {
    ZStack {
        Color.gray800
            .ignoresSafeArea(.all, edges: .all)
        CommentSheetBody(comment: .constant(""), isFocused:  FocusState<Bool>().projectedValue)
    }
}
