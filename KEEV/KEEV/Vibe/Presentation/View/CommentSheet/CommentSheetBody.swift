//
//  CommentSheetBody.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 코멘트 시트 바디 뷰
///
/// - Parameters:
///   - comment: 코멘트 텍스트
///   - isFocused: 텍스트 에디터 포커싱 여부
///
/// - Author: Doran
struct CommentSheetBody: View {
    @Binding private var comment: String
    private var isFocused: FocusState<Bool>.Binding
    
    init(comment: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._comment = comment
        self.isFocused = isFocused
    }
    
    var body: some View {
        
        // MARK: 코멘트 남기는 영역
        TextEditor(text: $comment)
            .focused(isFocused)
            .accentColor(.brand500)
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
