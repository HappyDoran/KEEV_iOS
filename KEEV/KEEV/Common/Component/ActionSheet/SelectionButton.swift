//
//  SelectionButton.swift
//  KEEV
//
//  Created by Yune Cho on 10/29/24.
//

import SwiftUI

extension KEEVActionSheet {
    
    /// 액션 시트 버튼
    ///
    /// 액션 시트에 노출되는 버트입니다.
    ///
    /// 버튼에 표시할 정보들이 담긴 SelectionButtonContent 타입을 인자로 받아서 버튼을 표시합니다.
    ///
    /// 버튼 중 최상단이거나 최하단일 경우에는 cornerRadius가 적용되도록 했고 버튼 타입에 따라 색상이 다르게 노출되도록 구현했습니다.
    ///
    /// - Note: 액션 시트 닫기 버튼은 CloseButton에 별도로 만들었습니다.
    /// - Author: 라움
    struct SelectionButton: View {
        private let button: SelectionButtonContent
        private let isFirst: Bool
        private let isLast: Bool
        
        init(button: SelectionButtonContent, isFirst: Bool, isLast: Bool) {
            self.button = button
            self.isFirst = isFirst
            self.isLast = isLast
        }
        
        var body: some View {
            VStack(spacing: 0) {
                Button {
                    button.action()
                } label: {
                    UnevenRoundedRectangle(
                        topLeadingRadius: isFirst ? 16 : 0,
                        bottomLeadingRadius: isLast ? 16 : 0,
                        bottomTrailingRadius: isLast ? 16 : 0,
                        topTrailingRadius: isFirst ? 16 : 0
                    )
                    .frame(height: 56)
                    .foregroundStyle(.gray800)
                    .overlay(alignment: .leading) {
                        HStack(spacing: 8) {
                            button.type.image
                                .frame(width: 8, height: 24)
                                .padding(.horizontal, 8)
                            
                            Text(button.title)
                                .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .medium)))
                                .foregroundStyle(button.type == .modify || button.type == .share ? .gray50 : .red500)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                    }
                }
                
                if !isLast {
                    Divider()
                        .frame(height: 1)
                        .background(.gray700)
                }
            }
        }
    }
}
    
#Preview {
    KEEVActionSheet.SelectionButton(button: KEEVActionSheet.SelectionButtonContent(type: .share, title: "바이브 공유하기", action: {}), isFirst: true, isLast: true)
}
