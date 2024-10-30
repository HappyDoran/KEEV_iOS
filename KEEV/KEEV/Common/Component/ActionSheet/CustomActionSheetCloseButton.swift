//
//  CustomActionSheetCloseButton.swift
//  KEEV
//
//  Created by Yune Cho on 10/29/24.
//

import SwiftUI

/// 액션 시트 닫기 버튼
///
/// 앱션 시트 최하단에 노출되는 액션 시트 닫기 버튼입니다.
///
/// - Author: 라움
struct CustomActionSheetCloseButton: View {
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

#Preview {
    CustomActionSheetCloseButton(isPresented: .constant(true))
}
