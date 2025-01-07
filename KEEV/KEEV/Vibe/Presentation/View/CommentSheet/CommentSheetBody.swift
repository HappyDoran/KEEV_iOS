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
            view.textColor = .gray50
            view.text = text
            view.delegate = context.coordinator
            view.becomeFirstResponder()
            
            view.showsVerticalScrollIndicator = false
            
            view.isEditable = true
            view.isUserInteractionEnabled = true
            view.isScrollEnabled = true
            
            return view
        }
        
        func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CommentTextEditor>) {
            uiView.text = text
            uiView.textColor = UIColor.white
            uiView.isScrollEnabled = true
            
            DispatchQueue.main.async {
                let calculatedHeight = uiView.contentSize.height
    
                if calculatedHeight > 410 {
                    height = 410
                } else {
                    height = calculatedHeight
                }
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
                textView.textColor = UIColor.white
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let calculatedHeight = textView.contentSize.height
                
                if calculatedHeight > 410 {
                    self.parent.height = 410
                } else {
                    self.parent.height = calculatedHeight
                }
                
                self.parent.text = textView.text
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
