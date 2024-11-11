//
//  NoticeView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

/// 공지사항을 보여주는 뷰
///
/// KEEV의 공지사항들을 보여주는 뷰입니다.
///
/// - Author: 라움
struct NoticeView: View {
    private let settingService: SettingService
    
    init(settingService: SettingService) {
        self.settingService = settingService
    }
    
    var body: some View {
        ScrollView {
            ForEach(settingService.notices) { notice in
                NoticeCell(notice: notice)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("공지사항")
                    .figmaFont(PretendardFont.title(style: .xs))
                    .foregroundStyle(.gray100)
            }
        }
        .toolbarRole(.editor)
        .backgroundForKEEV()
    }
}

#Preview {
    NavigationStack {
        NoticeView(settingService: SettingService())
    }
}
