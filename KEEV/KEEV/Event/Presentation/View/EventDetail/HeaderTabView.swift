//
//  HeaderTabView.swift
//  KEEV
//
//  Created by Doran on 11/17/24.
//

import SwiftUI

/// 헤더 탭 뷰
///
///  "공연 상세"와 "바이브" 두 개의 탭을 제공하며, 현재 활성화된 탭에 따라 표시되는 바가 이동.
///
/// - Parameter activeSection: 현재 활성화된 섹션을 나타내는 바인딩 변수
///
/// - Author: Doran
struct HeaderTabView: View {
    
    @Binding var activeSection: EventDetailSection
    @State private var barX: CGFloat = 0
    private let barHeight: CGFloat = 4
    private let barWidth: CGFloat = 82
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 0) {
                    Text("공연 상세")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(activeSection == .detail ? .gray50 : .gray500)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            activeSection = .detail
                        }
                    
                    Text("바이브")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .semibold)))
                        .foregroundColor(activeSection == .vibe ? .gray50 : .gray500)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            activeSection = .vibe
                        }
                }
                .frame(height: 46)
                
                Rectangle()
                    .fill(Color.brand500)
                    .frame(width: barWidth, height: barHeight)
                    .offset(x: activeSection == .detail ? -((geometry.size.width / 4)) : (geometry.size.width / 4), y: 0)
                    .animation(.easeInOut, value: activeSection)
            }
            .background(Color.grayBG800)
        }
        .frame(height: 46)
    }
}

#Preview {
    HeaderTabView(activeSection: .constant(.detail))
}
