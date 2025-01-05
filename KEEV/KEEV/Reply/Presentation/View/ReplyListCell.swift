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
            
            info
        }
        .background(.clear)
    }
}

private extension ReplyListCell {
    var content: some View {
        VStack(alignment: .leading) {
            replyHeader
            replyBody
        }
    }
    
    private var info: some View {
        VStack(alignment: .trailing) {
            Button(action: moreTapHandler) {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray50)
            }
            .frame(width: 15, height: 3)
            .padding(.vertical, 8.5)
            
            Spacer()
            Text(reply.createdBefore)
                .figmaFont(PretendardFont.body(
                    style: .init(bodySize: .xsmall, bodyWeight: .medium)
                ))
                .foregroundStyle(.gray500)
        }
    }
    
    var replyHeader: some View {
        userInfo
            .onTapGesture(perform: userTapHandler)
    }
    
    var userInfo: some View {
        HStack(spacing: 8) {
            Text(reply.userNickname)
                .lineLimit(1)
                .figmaFont(
                    PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .semibold))
                )
                .foregroundColor(.gray50)
            
            if reply.isMine {
                Text("작성자")
                    .figmaFont(
                        PretendardFont.body(style: .init(bodySize: .xsmall2, bodyWeight: .semibold))
                    )
                    .foregroundStyle(.gray500)
            }
            
            Spacer()
        }
    }
    
    var replyBody: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reply.text)
                .foregroundStyle(.gray300)
                .multilineTextAlignment(.leading)
                .figmaFont(
                    PretendardFont.body(
                        style: .init(bodySize: .base, bodyWeight: .regular)
                    )
                )
            
            HStack {
                Text("  ")
                    .figmaFont(
                        PretendardFont.body(style: .init(bodySize: .xsmall, bodyWeight: .medium))
                    )
                    .foregroundStyle(.gray700)
            }
        }
    }
}

#Preview {
    ReplyListCell(reply: .dummy0) {
        
    } moreTapHandler: {
        
    } likeTapHandler: {
        
    }
    
}
