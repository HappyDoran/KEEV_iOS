//
//  ReplyCell.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyListCell: View {
    private let userID: Int?
    private let reply: ReplyUIO
    private let moreTabHandler: () -> Void
    
    init(userID: Int?, reply: ReplyUIO, moreTabHandler: @escaping () -> Void) {
        self.userID = userID
        self.reply = reply
        self.moreTabHandler = moreTabHandler
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            URLCircleImage(url: reply.userProfileImageURL)
                .frame(width: 40, height: 40)
            
            content
        }
        .background(.clear)
    }
}

private extension ReplyListCell {
    var content: some View {
        VStack(alignment: .leading) {
            replyHeader
            replyBody
            replyFooter
        }
    }
    
    var replyHeader: some View {
        HStack(alignment: .top) {
            userInfo
            
            Spacer()
            
            Button(action: moreTabHandler) {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray50)
            }
            .frame(width: 15, height: 3)
            .padding(.horizontal, 10.5)
            .padding(.vertical, 8.5)
        }
    }
    
    var userInfo: some View {
        HStack(spacing: 8) {
            Text(reply.userNickname)
                .lineLimit(1)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold))
                )
                .foregroundColor(.gray50)
            
            if userID == reply.userID {
                Text("작성자")
                    .figmaFont(
                        PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold))
                    )
                    .foregroundStyle(.gray500)
            }
        }
    }
    
    var replyBody: some View {
        Text(reply.text)
            .multilineTextAlignment(.leading)
            .figmaFont(
                PretendardFont.body(
                    style: .init(bodySize: .base, bodyWeight: .regular)
                )
            )
    }
    var replyFooter: some View {
        let font = PretendardFont.body(
            style: .init(bodySize: .xsmall, bodyWeight: .medium)
        )
        
        return HStack {
            // 좋아요 추후 추가 예정
            Spacer()
            Text("\(reply.createdBefore)일 전")
                .figmaFont(font)
                .foregroundStyle(.gray500)
        }
    }
}

#Preview {
    ReplyListCell(userID: 1, reply: .dummy2) { }
}
