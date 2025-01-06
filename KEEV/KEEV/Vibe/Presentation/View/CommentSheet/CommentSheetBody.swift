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
    init(comment: Binding<String>, typedComment: Binding<String>, isFocused: FocusState<Bool>.Binding) {
        self._comment = comment
        self._typedComment = typedComment
        self.isFocused = isFocused
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                // MARK: 코멘트 남기는 영역
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
                            .padding(.top, 8)
                            .padding(.leading,5)
                    }
                    .onChange(of: typedComment) { _,_ in
                        updateTextHeight(screenWidth: geometry.size.width)
                    }
                    .border(.red)
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    .submitLabel(.return)
                Spacer()
            }
            .onAppear{
                updateTextHeight(screenWidth: geometry.size.width)
            }
        }
    }
}

extension CommentSheetBody {
    private func updateTextHeight(screenWidth: CGFloat) {
        let textView = UITextView()
        textView.text = typedComment
        textView.font = customFont.uiFont
        textView.frame.size.width = screenWidth - 90
        textView.sizeToFit()
        
        let lineHeight = customFont.uiFont.lineHeight
        textHeight = textView.contentSize.height + lineHeight
    }
    
    private func minTextHeight() -> CGFloat {
        let lineHeight = customFont.uiFont.lineHeight
        return lineHeight
    }
}

#Preview {
    ZStack {
        Color.gray800
            .ignoresSafeArea(.all, edges: .all)
        CommentSheetBody(comment: .constant(""), typedComment: .constant("TextEditor가 스크롤되는 이유는 기본적으로 TextEditor가 내부적으로 스크롤 가능한 뷰로 구현되어 있기 때문입니다. 사용자가 입력한 텍스트가 TextEditor의 높이를 초과하면 자동으로 스크롤이 발생합니다."), isFocused:  FocusState<Bool>().projectedValue)
    }
}
