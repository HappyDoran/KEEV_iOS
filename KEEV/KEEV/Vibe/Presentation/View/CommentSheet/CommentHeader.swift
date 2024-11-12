//
//  CommentHeader.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

/// 코멘트 시트 헤더 뷰
///
/// - Note: 버튼의 액션 (취소 버튼의 액션)이 아직 구현되지 않았습니다. Alert 수정 후 반영하여 구현할 예정입니다.
/// - Author: Doran
struct CommentHeader: View {
    @Binding private var comment: String
    @Binding private var typedComment: String
    @Binding private var showCancleAlert: Bool
    
    init(comment: Binding<String>, typedComment: Binding<String>, showCancleAlert: Binding<Bool>) {
        self._comment = comment
        self._typedComment = typedComment
        self._showCancleAlert = showCancleAlert
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Text("내 코멘트")
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼들
            HStack {
                Button(action: {
                    if comment == typedComment {
                        dismiss()
                    } else {
                        showCancleAlert = true
                    }
                }) {
                    Text("취소")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                        .foregroundColor(.gray100)
                }
                
                Spacer()
                
                Button(action: {
                    comment = typedComment.trimmingCharacters(in: .whitespacesAndNewlines)
                    dismiss()
                }) {
                    Text("저장")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                        .foregroundColor(.brand500)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
        }
    }
}

#Preview {
    ZStack {
        Color.gray800
            .ignoresSafeArea(.all, edges: .all)
        CommentHeader(comment: .constant(""), typedComment: .constant(""), showCancleAlert: .constant(false))
    }
}
