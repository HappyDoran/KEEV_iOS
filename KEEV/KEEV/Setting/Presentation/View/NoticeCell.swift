//
//  NoticeCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct NoticeCell: View {
    private let notice: Notice
    
    init(notice: Notice) {
        self.notice = notice
    }
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            DisclosureGroup(isExpanded: $isExpanded) {
                HStack {
                    Text(notice.content)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                        .foregroundStyle(.gray300)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(notice.title)
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                        .foregroundStyle(.gray100)
                        .lineLimit(isExpanded ? 2 : 1)
                        .multilineTextAlignment(.leading)
                    
                    Text(notice.date.toString(format: "yy.MM.dd"))
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundStyle(.gray500)
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .tint(.gray500)
            
            Divider()
        }
    }
}

#Preview {
    NoticeCell(notice: Notice(title: "KEEV 앱스토어 오픈!", date: .now, content: "앱스토어에 KEEV가 출시되었습니다!"))
}
