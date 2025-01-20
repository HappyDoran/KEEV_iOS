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
///   - typedComment: TextEditor에 입력된 텍스트
///   - isFocused: 텍스트 에디터 포커싱 여부
///
/// - Author: Doran
struct CommentSheetBody: View {
    @Binding private var comment: String
    @Binding private var typedComment: String
    @State private var textHeight: CGFloat = 0
    private var isFocused: FocusState<Bool>.Binding
    private let customFont = PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular))

    init(comment: Binding<String>,
         typedComment: Binding<String>,
         isFocused: FocusState<Bool>.Binding) {
        self._comment = comment
        self._typedComment = typedComment
        self.isFocused = isFocused
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                // MARK: 코멘트 남기는 영역
                CustomTextEditor($textHeight, $typedComment, textColor: .gray50, customFont: customFont.uiFont, scrollPossibleHeight: 410)
                    .focused(isFocused)
                    .tint(.brand500)
                    .frame(height: isFocused.wrappedValue ? textHeight : geometry.size.height)
                    .overlay(alignment: .topLeading) {
                        Text("공연의 감상을 자유롭게 작성해주세요.")
                            .foregroundStyle(typedComment.isEmpty ? .gray : .clear)
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                            .padding(.top, 7)
                            .padding(.leading, 5)
                    }
                    .border(.red)
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    .animation(.default, value: isFocused.wrappedValue)
                Spacer()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray800
            .ignoresSafeArea(.all, edges: .all)
        CommentSheetBody(comment: .constant(""), typedComment: .constant(""), isFocused:  FocusState<Bool>().projectedValue)
    }
}
