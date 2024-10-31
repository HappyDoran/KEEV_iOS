//
//  KEEVActionSheet.swift
//  KEEV
//
//  Created by 김준성 on 10/31/24.
//

import SwiftUI

struct KEEVActionSheet: View {
    @Binding var isPresented: Bool
    let buttons: [SelectionButtonContent]
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            VStack(spacing: 0) {
                ForEach(Array(buttons.enumerated()), id: \.element.id) { index, button in
                    if index == 0 && index == buttons.count - 1 {
                        SelectionButton(button: button, isFirst: true, isLast: true)
                    } else if index == 0 {
                        SelectionButton(button: button, isFirst: true, isLast: false)
                    } else if index == buttons.count - 1 {
                        SelectionButton(button: button, isFirst: false, isLast: true)
                    } else {
                        SelectionButton(button: button, isFirst: false, isLast: false)
                    }
                }
            }
            
            CloseButton(isPresented: $isPresented)
        }
    }
}

extension KEEVActionSheet {
    /// 액션 시트 닫기 버튼
    ///
    /// 앱션 시트 최하단에 노출되는 액션 시트 닫기 버튼입니다.
    ///
    /// - Author: 라움
    private struct CloseButton: View {
        @Binding var isPresented: Bool
        
        var body: some View {
            Button {
                isPresented = false
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 56)
                    .foregroundStyle(.gray800)
                    .overlay {
                        Text("닫기")
                            .figmaFont(PretendardFont.body(style: .init(bodySize: .large, bodyWeight: .semibold)))
                            .foregroundStyle(.gray100)
                    }
            }
        }
    }
}
