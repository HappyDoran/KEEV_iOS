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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Text("내 코멘트")
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼들
            HStack {
                Button(action: {
                    
                }) {
                    Text("취소")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                        .foregroundColor(.gray100)
                }
                
                Spacer()
                
                Button(action: {
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
        CommentHeader()
    }
}
