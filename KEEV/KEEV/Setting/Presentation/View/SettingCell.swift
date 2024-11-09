//
//  SettingCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

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
