//
//  ReplyListView.swift
//  KEEV
//
//  Created by 김준성 on 11/19/24.
//

import SwiftUI

struct ReplyListView: View {
    let userID: Int
    @Binding var replies: [ReplyUIO]
    private let userTapHandler: ((Int) -> Void)?
    private let moreTapHandler: ((Int, ReplyUIO) -> Void)?
    private let likeTapHandler: ((Int, ReplyUIO) -> Void)?
    
    init(
        userID: Int,
        replies: Binding<[ReplyUIO]>,
        userTapHandler: ((Int) -> Void)? = nil,
        moreTapHandler: ((Int, ReplyUIO) -> Void)? = nil,
        likeTapHandler: ((Int, ReplyUIO) -> Void)? = nil
    ) {
        self.userID = userID
        self._replies = replies
        self.userTapHandler = userTapHandler
        self.moreTapHandler = moreTapHandler
        self.likeTapHandler = likeTapHandler
    }
    
    
    var body: some View {
        LazyVStack {
            ForEach(0..<replies.count, id: \.self) { index in
                ReplyListCell(reply: replies[index]) {
                    userTapHandler?(replies[index].userID)
                } moreTapHandler: {
                    moreTapHandler?(index, replies[index])
                } likeTapHandler: {
                    likeTapHandler?(index, replies[index])
                }
                
                if index < replies.count - 1 {
                    Divider()
                        .padding(.vertical, 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.grayBG800)
    }
}

#Preview {
    ReplyListView(userID: 2, replies: .constant([
        .dummy0, .dummy1, .dummy2
    ]))
}
