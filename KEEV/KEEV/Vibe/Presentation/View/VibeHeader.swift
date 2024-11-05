//
//  VibeHeader.swift
//  KEEV
//
//  Created by Doran on 11/6/24.
//

import SwiftUI

struct VibeHeader: View {
    
    var body: some View {
        ZStack {
            Text("글쓰기")
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
            }
            .padding(.leading, 16)
            .frame(height: 48)
        }
    }
}

#Preview {
    VibeHeader()
        .backgroundForKEEV()
}

