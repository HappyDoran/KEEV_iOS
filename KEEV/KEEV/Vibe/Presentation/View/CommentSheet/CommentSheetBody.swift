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
    
    init(comment: Binding<String>, typedComment: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._comment = comment
        self._typedComment = typedComment
        self.isFocused = isFocused
    }
    
    var body: some View {
        
        // MARK: 코멘트 남기는 영역
        VStack(spacing : 0){
            TextEditor(text: $typedComment)
                .focused(isFocused)
                .accentColor(.brand500)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .foregroundColor(.gray50)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .frame(minHeight: minTextHeight())
                .frame(height: textHeight)
                .overlay(alignment: .topLeading) {
                    Text("공연의 감상을 자유롭게 작성해주세요.")
                        .foregroundStyle(typedComment.isEmpty ? .gray : .clear)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                        .padding(.top, 10)
                        .padding(.leading,3)
                }
                .onChange(of: typedComment) { _, _ in
                    updateTextHeight()
                }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .submitLabel(.return)
        .onAppear {
            updateTextHeight()
        }
    }
}

extension CommentSheetBody {
    private func updateTextHeight() {
        let textView = UITextView()
        textView.text = typedComment
        let fontStyle = PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular))
        textView.font = fontStyle.uiFont
        textView.frame.size.width = UIScreen.main.bounds.width - 90
        textView.sizeToFit()
        
        let lineHeight = fontStyle.lineHeight
        textHeight = textView.contentSize.height
    }
    
    private func minTextHeight() -> CGFloat {
        let fontStyle = PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular))
        let lineHeight = fontStyle.lineHeight
        
        return lineHeight
    }
}

#Preview {
    ZStack {
        Color.gray800
            .ignoresSafeArea(.all, edges: .all)
        CommentSheetBody(comment: .constant(""), typedComment: .constant(""), isFocused:  FocusState<Bool>().projectedValue)
    }
}
