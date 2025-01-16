//
//  ReplyCell.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyListCell: View {
    private let reply: ReplyUIO
    private let userTapHandler: () -> Void
    private let moreTapHandler: () -> Void
    private let likeTapHandler: () -> Void
    
    init(
        reply: ReplyUIO,
        userTapHandler: @escaping () -> Void,
        moreTapHandler: @escaping () -> Void,
        likeTapHandler: @escaping () -> Void
    ) {
        self.reply = reply
        self.userTapHandler = userTapHandler
        self.moreTapHandler = moreTapHandler
        self.likeTapHandler = likeTapHandler
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
        HStack {
            userInfo
                .onTapGesture(perform: userTapHandler)
            
            Spacer()
            
            Button(action: moreTapHandler) {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray50)
            }
            .frame(width: 15, height: 3)
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
            
            Spacer()
        }
    }
    
    var replyBody: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reply.text.splitWords())
                .foregroundStyle(.gray300)
                .multilineTextAlignment(.leading)
                .figmaFont(
                    PretendardFont.body(
                        style: .init(bodySize: .base, bodyWeight: .regular)
                    )
                )
        }
    }
    
    var replyFooter: some View {
        HStack {
            //댓글 좋아요 여기에 추가 해주시면 됩니다.
            
            Spacer()
            
            Text(reply.createdBefore)
                .figmaFont(PretendardFont.body(
                    style: .init(bodySize: .xsmall, bodyWeight: .medium)
                ))
                .foregroundStyle(.gray500)
        }
    }
}

#Preview {
    ReplyListCell(reply: .dummy0) {
        
    } moreTapHandler: {
        
    } likeTapHandler: {
        
    }
}
