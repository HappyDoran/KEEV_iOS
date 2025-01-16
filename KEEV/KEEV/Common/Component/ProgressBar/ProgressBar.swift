//
//  ProgressBar.swift
//  KEEV
//
//  Created by 김준성 on 11/21/24.
//

import SwiftUI

/// KEEV에서 쓰이는 ProgressView의 Bar 버전
///
/// ProgressView와 방법이 유사합니다.
///
/// value에는 현재 값을, total에는 전체 값을 넣어주면, 뷰 자신의 너비를 계산하여 표시해줍니다.
///
/// - Author: newJunsung
struct ProgressBar: View {
    let value: Double
    let total: Double
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .foregroundStyle(.grayBG700)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.brand500)
                        .frame(width: proxy.size.width * value / total)
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 3)
    }
}

#Preview {
    ProgressBar(value: 50, total: 100)
}
