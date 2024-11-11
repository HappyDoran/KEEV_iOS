//
//  SettingCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

/// 설정 화면 내 리스트의 각 셀
///
/// 설정 화면의 메뉴에 나타나는 각 셀에 대한 구현입니다.
///
/// - Note: 현재 앱 버전에 대한 셀을 표시할 때 텍스트 색이 다르기 때문에 titleColor를 받고 있고, 기본값으로는 gray100이 적용됩니다.
/// - Author: 라움
struct SettingCell: View {
    private let title: String
    private let titleColor: Color
    
    init(title: String, titleColor: Color = .gray100) {
        self.title = title
        self.titleColor = titleColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                .foregroundStyle(titleColor)
                .padding(.vertical, 16)
            
            Divider()
        }
    }
}

#Preview {
    SettingCell(title: "공지사항")
}
