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
                CommentTextEditor($textHeight, $typedComment, customFont: customFont.uiFont)
                    .frame(height: textHeight)
                    .overlay(alignment: .topLeading) {
                        Text("공연의 감상을 자유롭게 작성해주세요.")
                            .foregroundStyle(typedComment.isEmpty ? .gray : .clear)
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                            .padding(.top, 7)
                            .padding(.leading, 5)
                    }

                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                Spacer()
            }
        }
    }
}

extension CommentSheetBody {
    private struct CommentTextEditor: UIViewRepresentable{
        typealias UIViewType = UITextView
        
        @Binding var height: CGFloat
        @Binding var text: String
        private var customFont: UIFont
        
        init(_ height: Binding<CGFloat>,
             _ text: Binding<String>,
             customFont: UIFont) {
            self._height = height
            self._text = text
            self.customFont = customFont
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }
        
        func makeUIView(context: UIViewRepresentableContext<CommentTextEditor>) -> UITextView {
            let view = UITextView()
            
            view.font = customFont
            view.backgroundColor = .clear
            view.textColor = UIColor.white
            view.delegate = context.coordinator
            
            view.text = text
            
            view.isEditable = true
            view.isUserInteractionEnabled = true
            view.isScrollEnabled = false
            
            return view
        }
        
        func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CommentTextEditor>) {
            // 텍스트 업데이트 및 높이 조정
            uiView.text = text // typedComment 값 동기화
            uiView.textColor = UIColor.white // 텍스트 색상 유지 (흰색)
            
            DispatchQueue.main.async {
                height = uiView.contentSize.height // 높이 업데이트
            }
        }
    }
}

extension CommentSheetBody {
    private class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: CommentTextEditor
        
        init(_ parent: CommentTextEditor) { self.parent = parent }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.white {
                // 텍스트 색상 유지 (흰색)
                textView.textColor = UIColor.white
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.parent.height = textView.contentSize.height // 높이 업데이트
                self.parent.text = textView.text                 // 텍스트 업데이트 (typedComment와 동기화)
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
