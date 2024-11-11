//
//  NoticeView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct NoticeView: View {
    var body: some View {
        ScrollView {
            ForEach(notices) { notice in
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

extension NoticeView {
    private var notices: [Notice] {
        return [
            Notice(
                title: "KEEV 앱스토어 오픈!",
                date: .now,
                content: "앱스토어에 KEEV가 출시되었습니다!"
            ),
            Notice(
                title: "KEEV 앱스토어 오픈! 그런데 이제 제목이 매우 매우 매우 매우 매우 매우 매우 길어질 경우",
                date: .now,
                content: "앱스토어에 KEEV가 출시되었습니다!"
            ),
            Notice(
                title: "KEEV 앱스토어 오픈!",
                date: .now,
                content: "앱스토어에 KEEV가 출시되었습니다! 그런데 이제 본문이 매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우 길어질 경우"
            )]
    }
}

#Preview {
    NavigationStack {
        NoticeView()
    }
}
