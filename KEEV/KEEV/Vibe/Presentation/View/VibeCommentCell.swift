//
//  VibeTextEditor.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 코멘트 텍스트 버튼
///
/// - Parameters:
///   - comment: CommentSheetView에서 입력 받은 Text를 표시해주는 필드
///   - showCancelAlert: 코멘트 작성 취소 선택 시 나오는 알럿 노출 여부
///
/// - Author: Doran
struct VibeCommentCell: View {
    @State private var isPresented = false
    @Binding private var comment: String
    @Binding private var showCancelAlert: Bool
    @State private var typedComment = ""
    
    init(comment: Binding<String>, showCancelAlert: Binding<Bool>) {
        self._comment = comment
        self._showCancelAlert = showCancelAlert
        self.typedComment = comment.wrappedValue
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            commentHeader.padding(.top, 16)
            Button(action: {
                typedComment = comment
                isPresented.toggle()
            }){
                // MARK: CommentSheetView를 띄우는 버튼 및 Comment가 표시되는 영역
                commentBody
                    .padding(.top, 12)
                    .frame(minHeight: 158)
            }
        }
        .sheet(isPresented: $isPresented){
            CommentSheetView(comment: $comment, typedComment: $typedComment, showCancleAlert: $showCancelAlert)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(comment != typedComment)
        }
    }
}

extension VibeCommentCell {
    private var commentHeader: some View {
        HStack(spacing: 0){
            Text("코멘트")
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundColor(.gray50)
            Spacer()
        }
    }
    
    private var commentBody: some View {
        Text(comment.isEmpty ? "공연의 감상을 자유롭게 작성해주세요." : comment)
            .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
            .foregroundColor(comment.isEmpty ? .gray500 : .gray50)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.gray800)
            }
    }
}

#Preview {
    VibeCommentCell(comment: .constant(""), showCancelAlert: .constant(false))
        .backgroundForKEEV()
}
