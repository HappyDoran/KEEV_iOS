//
//  CommentSheetBody.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct CommentSheetBody: View {
    @Binding private var comment: String
    
    init(comment: Binding<String>) {
        self._comment = comment
    }
    
    var body: some View {
        TextEditor(text: $comment)
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
        CommentSheetBody(comment: .constant(""))
    }
}
