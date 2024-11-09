//
//  NoticeView.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct NoticeView: View {
    @State private var expandCount = 0
    
    var body: some View {
        ScrollView {
            NoticeCell(expandCount: $expandCount)
            
            NoticeCell(expandCount: $expandCount)
            
            NoticeCell(expandCount: $expandCount)
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
        .animation(.easeInOut, value: expandCount)
    }
}

#Preview {
    NoticeView()
}
