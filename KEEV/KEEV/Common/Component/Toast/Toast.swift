//
//  Toast.swift
//  KEEV
//
//  Created by 김준성 on 11/1/24.
//

import SwiftUI

struct Toast: View {
    let content = "프로필이 변경되었습니다."
    
    var body: some View {
        contentView
            .padding(.horizontal, 8)
            .background {
                Capsule()
                    .foregroundStyle(.green500)
            }
            .frame(height: 40)
    }
    
    private var contentView: some View {
        HStack(spacing: 0) {
            CircleCheckIcon(checkColor: .green500)
                .frame(width: 32, height: 32)
            
            Text(content)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium))
                )
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
        }
    }
}

#Preview {
    Toast()
}
