//
//  FullScreenCoverTopView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

/// FullScreenCover로 나타나는 뷰의 상단 툴바
///
/// FullScreenCover로 나타나는 뷰의 상단 닫기 버튼과 타이틀을 표시하는 뷰입니다.
///
/// - Author: 라움
struct FullScreenCoverTopView: View {
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .font(.custom("SF Pro", size: 17))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray100)
                    
                    Spacer()
                }
                .frame(width: 58, height: 32)
            }
            
            Spacer()
            
            Text(title)
                .figmaFont(PretendardFont.title(style: .xs))
                .foregroundStyle(.gray100)
            
            Spacer()
            
            Rectangle()
                .frame(width: 58, height: 32)
                .foregroundStyle(.clear)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    FullScreenCoverTopView(title: "서비스 이용약관")
}
