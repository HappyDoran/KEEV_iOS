//
//  CommentSheetView.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// VibeCreateScreen의 코멘트 창을 클릭했을 때 올라오는 시트 뷰
///
/// - Parameters:
///   - textEditorFocus: 텍스트 에디터 포커싱 여부
///   - comment: 유저가 남긴 코멘트
///   - typedComment: TextEditor에 입력된 텍스트
///   - showCancelAlert: 코멘트 작성 취소 선택 시 나오는 알럿 노출 여부
///
/// - Note: FocusState를 사용하여 텍스트 에디터 영역이 아닌 다른 시트의 영역을 터치해도 입력이 가능하게 하였습니다.
/// - Author: Doran
struct CommentSheetView: View {
    @FocusState private var textEditorFocus: Bool
    @Binding private var comment: String
    @Binding private var typedComment: String
    @Binding private var showCancelAlert: Bool
    init(comment: Binding<String>, typedComment: Binding<String>, showCancleAlert: Binding<Bool>) {
        self._comment = comment
        self._typedComment = typedComment
        self._showCancelAlert = showCancleAlert
    }
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color.grayBG700
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0){
                // MARK: 헤더
                CommentHeader(comment: $comment, typedComment: $typedComment, showCancleAlert: $showCancelAlert)
                    .padding(.top, 12)
//                ScrollView {
//                    // MARK: 코멘트 남기는 영역. 터치시, 텍스트 에디터에 포커싱
//                    CommentSheetBody(comment: $comment, typedComment: $typedComment, isFocused: $textEditorFocus)
//                }
                CommentSheetBody(comment: $comment, typedComment: $typedComment, isFocused: $textEditorFocus)
                .onTapGesture {
                    textEditorFocus.toggle()
                }
            }
        }
        .onChange(of: showCancelAlert, {
            textEditorFocus = false
        })
        .customAlert(
            isPresented: $showCancelAlert,
            title: "작성중인 글을 저장할까요?",
            message: "취소 선택 시 작성된 글은 저장되지 않습니다.",
            firstButtonText: "취소",
            firstButtonStyle: .normal,
            firstButtonAction: {
                typedComment = ""
                dismiss()
            },
            secondButtonText: "저장",
            secondButtonStyle: .active,
            secondButtonAction: {
                comment = typedComment.trimmingCharacters(in: .whitespacesAndNewlines)
                typedComment = ""
                dismiss()
            }
        )
    }
}

#Preview {
    CommentSheetView(comment: .constant(""), typedComment: .constant(""), showCancleAlert: .constant(false))
        .backgroundForKEEV()
}
