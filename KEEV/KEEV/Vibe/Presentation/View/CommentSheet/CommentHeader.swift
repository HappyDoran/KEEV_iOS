//
//  CommentHeader.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct CommentHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Text("내 코멘트")
                .figmaFont(PretendardFont.title(style: .xs)).foregroundColor(.gray100)
            
            // MARK: 검색 시트 아래로 내리는 버튼
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                        .foregroundColor(.gray100)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("저장")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .regular)))
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
