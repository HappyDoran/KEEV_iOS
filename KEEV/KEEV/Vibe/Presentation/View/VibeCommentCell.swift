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
///
/// - Author: Doran
struct VibeCommentCell: View {
    @State private var isPresented = false
    @Binding private var comment: String
    
    init(comment: Binding<String>) {
        self._comment = comment
    }
    
    var body: some View {
        VStack(spacing: 0){
            // MARK: 헤더
            commentHeader.padding(.top, 16)
            Button(action: {
                isPresented.toggle()
            }){
                // MARK: CommentSheetView를 띄우는 버튼 및 Comment가 표시되는 영역
                commentBody
                    .padding(.top, 12)
                    .frame(minHeight: 158)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .sheet(isPresented: $isPresented){
            CommentSheetView(comment: $comment)
                .presentationDragIndicator(.visible)
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
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray800)
            
            Text(comment == "" ? "공연의 감상을 자유롭게 작성해주세요." : comment)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                .foregroundColor(comment == "" ? .gray500 : .gray50)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        }
    }
}

#Preview {
    VibeCommentCell(comment: .constant("")).backgroundForKEEV()
}
