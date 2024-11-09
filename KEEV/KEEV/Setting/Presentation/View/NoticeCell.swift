//
//  NoticeCell.swift
//  KEEV
//
//  Created by Yune Cho on 11/9/24.
//

import SwiftUI

struct NoticeCell: View {
    @Binding var expandCount: Int
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("공지사항 제목")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .medium, bodyWeight: .medium)))
                        .foregroundStyle(.gray100)
                    
                    Text("공지날짜")
                        .figmaFont(PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium)))
                        .foregroundStyle(.gray500)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.gray500)
            }
            .onTapGesture {
                if isExpanded {
                    expandCount -= 1
                } else {
                    expandCount += 1
                }
                isExpanded.toggle()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            
            if isExpanded {
                Text("공지사항 내용")
                    .figmaFont(PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .regular)))
                    .foregroundStyle(.gray300)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    .transition(.opacity)
            }
            
            Divider()
                .transition(.slide)
        }
        .animation(.bouncy, value: isExpanded)
    }
}

#Preview {
    NoticeCell(expandCount: .constant(0))
}
