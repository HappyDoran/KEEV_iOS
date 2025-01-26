//
//  ReplyCell.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyListCell: View {
    @Binding private var reply: ReplyUIO
    private let userTapHandler: () -> Void
    private let moreTapHandler: () -> Void
    private var likeTapHandler: () -> Void
    
    init(
        reply: Binding<ReplyUIO>,
        userTapHandler: @escaping () -> Void,
        moreTapHandler: @escaping () -> Void,
        likeTapHandler: @escaping () -> Void
    ) {
        self._reply = reply
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
            replyLikeArea
            
            Spacer()
            
            Text(reply.createdBefore)
                .figmaFont(PretendardFont.body(
                    style: .init(bodySize: .xsmall, bodyWeight: .medium)
                ))
                .foregroundStyle(.gray500)
        }
    }
    
    var replyLikeArea: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(reply.isLiked ? "Heart.fill.color" : "Heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12)
                
                Text("좋아요")
                    .foregroundStyle(reply.isLiked ? .brand500 : .gray500)
            }
            .onTapGesture(perform: likeTapHandler)
            
            Text("\(reply.likeCount)")
                .foregroundStyle(.gray500)
        }
        .figmaFont(PretendardFont.body(
            style: .init(bodySize: .xsmall, bodyWeight: .medium)
        ))
    }
}

#Preview {
    ReplyListCell(reply: .constant(.dummy0)) {
        
    } moreTapHandler: {
        
    } likeTapHandler: {
        
    }
}
